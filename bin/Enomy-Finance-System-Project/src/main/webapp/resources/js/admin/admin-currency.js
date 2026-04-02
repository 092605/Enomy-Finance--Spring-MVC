/* =========================================================
   ADMIN CURRENCY MODULE JS
   ---------------------------------------------------------
   This file handles:
   1. section switching inside the admin currency page
   2. active rule loading and rendering
   3. creating new conversion rule sets
   4. filtering currency rates
   5. filtering saved transactions
   6. loading rule history and activating old rule sets
   ========================================================= */

/* global bootstrap, window, document, fetch */

/* =========================================================
   PAGE STARTUP
   ---------------------------------------------------------
   Runs once the HTML is fully loaded.
   Initializes all UI behaviors and loads initial backend data.
   ========================================================= */
document.addEventListener("DOMContentLoaded", function () {
    initSectionSwitching();
    initBracketBuilder();
    initRatesFilter();
    initTransactionsFilter();
    loadActiveRule();
    loadHistory();
});

/* =========================================================
   GLOBAL STATE
   ---------------------------------------------------------
   Stores the currently selected rule set ID from history modal,
   so that the Activate button knows which rule to activate.
   ========================================================= */
let currentHistoryRuleId = null;

/* =========================================================
   API URL HELPER
   ---------------------------------------------------------
   Builds the full backend API URL using the base path provided
   by the JSP page.
   Example result:
   /Enomy-Finance-System-Project/admin/api/currency/active-rule
   ========================================================= */
function apiUrl(path) {
    return `${window.currencyAdminApiBase}${path}`;
}

/* =========================================================
   ALERT HELPERS
   ---------------------------------------------------------
   Shows success or error messages at the top of the page.
   ========================================================= */
function showAlert(message, type = "success") {
    const wrap = document.getElementById("currencyAdminAlerts");
    if (!wrap) return;

    wrap.innerHTML = `
        <div class="alert alert-${type === "success" ? "success currency-admin-alert-success" : "danger currency-admin-alert-error"} mb-4">
            ${escapeHtml(message)}
        </div>
    `;
}

function clearAlert() {
    const wrap = document.getElementById("currencyAdminAlerts");
    if (wrap) wrap.innerHTML = "";
}

/* =========================================================
   SECTION SWITCHING
   ---------------------------------------------------------
   Handles clicking the right-side module navigation buttons.
   It shows the selected section and hides the others.
   It also updates active highlight styles on nav items.
   ========================================================= */
function initSectionSwitching() {
    const navLinks = document.querySelectorAll("[data-section-target]");
    const sections = document.querySelectorAll(".currency-admin-section");

    navLinks.forEach((link) => {
        link.addEventListener("click", function () {
            const targetId = link.getAttribute("data-section-target");
            if (!targetId) return;

            sections.forEach((section) => section.classList.remove("active"));

            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                targetSection.classList.add("active");
            }

            document.querySelectorAll(".currency-admin-module-nav-link, .currency-admin-module-logo-link")
                .forEach((item) => item.classList.remove("active"));

            document.querySelectorAll(`[data-section-target="${targetId}"]`)
                .forEach((item) => item.classList.add("active"));
        });
    });
}

/* =========================================================
   GENERIC JSON FETCH HELPER
   ---------------------------------------------------------
   Sends requests to backend APIs and safely parses JSON.
   This version is safer than direct response.json()
   because if the backend accidentally returns HTML (404 page,
   login page, server error page), it throws a useful message
   instead of crashing with:
   Unexpected token '<'
   ========================================================= */
   async function fetchJson(url, options = {}) {
       const response = await fetch(url, {
           method: options.method || "GET",
           credentials: "same-origin", // 🔥 send session cookie
           headers: {
               "Content-Type": "application/json",
               "X-Requested-With": "XMLHttpRequest", // 🔥 VERY IMPORTANT
               ...options.headers
           },
           body: options.body
       });

       // 🔥 Detect redirect to login
       if (response.redirected) {
           throw new Error("Session expired. Please login again.");
       }

       const rawText = await response.text();

       let data;
       try {
           data = rawText ? JSON.parse(rawText) : {};
       } catch (error) {
           throw new Error(`Expected JSON response but received something else. URL: ${url}`);
       }

       if (!response.ok || data.success === false) {
           throw new Error(data.message || "Request failed.");
       }

       return data;
   }

/* =========================================================
   LOAD ACTIVE RULE
   ---------------------------------------------------------
   Gets the current active conversion rule set from backend.
   Also fills the form preview using the active rule values.
   Endpoint: GET /active-rule
   ========================================================= */
async function loadActiveRule() {
    try {
        const data = await fetchJson(apiUrl("/active-rule"));
        renderActiveRule(data);
        prefillRuleForm(data);
        clearAlert();
    } catch (e) {
        showAlert(e.message || "Unable to load active rule.", "error");
    }
}

/* =========================================================
   RENDER ACTIVE RULE CARD
   ---------------------------------------------------------
   Displays the active rule set information and fee brackets
   on the page.
   ========================================================= */
function renderActiveRule(data) {
    const badge = document.getElementById("activeRuleSetBadge");
    const wrap = document.getElementById("activeRuleCardContent");
    if (!wrap) return;

    const ruleSet = data.activeRuleSet;
    const rules = data.activeFeeRules || [];

    if (!ruleSet) {
        wrap.innerHTML = `
            <div class="currency-admin-empty-state">
                <h4>No active conversion rule found</h4>
                <p>Create your first conversion rule set to begin.</p>
            </div>
        `;
        if (badge) badge.textContent = "Set ID -";
        return;
    }

    if (badge) badge.textContent = `Set ID ${ruleSet.id}`;

    wrap.innerHTML = `
        <div class="currency-admin-info-grid compact">
            <div>
                <span>Rule Name</span>
                <strong>${escapeHtml(ruleSet.ruleName || "No Rule Name")}</strong>
            </div>
            <div>
                <span>Description</span>
                <strong>${escapeHtml(ruleSet.description || "No Description")}</strong>
            </div>
            <div>
                <span>Minimum Amount</span>
                <strong>${formatNumber(data.activeMinAmount)}</strong>
            </div>
            <div>
                <span>Maximum Amount</span>
                <strong>${formatNumber(data.activeMaxAmount)}</strong>
            </div>
        </div>

        <div class="currency-admin-bracket-card mt-3">
            <div class="currency-admin-bracket-head">
                <h4>Fee Brackets</h4>
            </div>
            <div class="table-responsive">
                <table class="table currency-admin-bracket-table">
                    <thead>
                        <tr>
                            <th>Min</th>
                            <th>Max</th>
                            <th>Fee Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rules.map(rule => `
                            <tr>
                                <td>${formatNumber(rule.minAmount)}</td>
                                <td>${formatNumber(rule.maxAmount)}</td>
                                <td>${formatNumber(rule.feeRate)}%</td>
                            </tr>
                        `).join("")}
                    </tbody>
                </table>
            </div>
        </div>
    `;
}

/* =========================================================
   PREFILL FORM
   ---------------------------------------------------------
   Uses the currently active rule set to prefill the create
   new rule form and update the min/max preview labels.
   ========================================================= */
function prefillRuleForm(data) {
    const previewRuleSetId = document.getElementById("previewRuleSetId");
    const previewMinAmount = document.getElementById("previewMinAmount");
    const previewMaxAmount = document.getElementById("previewMaxAmount");
    const wrap = document.getElementById("bracketRowsWrap");

    if (previewRuleSetId) previewRuleSetId.textContent = data.nextRuleSetIdPreview ?? "-";
    if (previewMinAmount) previewMinAmount.textContent = formatNumber(data.activeMinAmount);
    if (previewMaxAmount) previewMaxAmount.textContent = formatNumber(data.activeMaxAmount);

    if (!wrap) return;

    wrap.innerHTML = "";

    const rules = data.activeFeeRules || [];
    if (!rules.length) {
        wrap.insertAdjacentHTML("beforeend", buildBracketRowHtml());
    } else {
        rules.forEach(rule => {
            wrap.insertAdjacentHTML(
                "beforeend",
                buildBracketRowHtml(rule.minAmount, rule.maxAmount, rule.feeRate)
            );
        });
    }

    rebindBracketUi();
}

/* =========================================================
   BRACKET BUILDER INITIALIZATION
   ---------------------------------------------------------
   Handles:
   1. adding new fee bracket rows
   2. submitting the new rule set form
   Endpoint: POST /rules
   ========================================================= */
function initBracketBuilder() {
    const addBtn = document.getElementById("addBracketRowBtn");
    const form = document.getElementById("currencyRuleForm");

    if (addBtn) {
        addBtn.addEventListener("click", function () {
            const wrap = document.getElementById("bracketRowsWrap");
            if (!wrap) return;

            wrap.insertAdjacentHTML("beforeend", buildBracketRowHtml());
            rebindBracketUi();
            updatePreviewMinMax();
        });
    }

    if (form) {
        form.addEventListener("submit", async function (e) {
            e.preventDefault();

            const payload = {
                ruleName: document.getElementById("ruleNameInput")?.value.trim() || "",
                description: document.getElementById("ruleDescriptionInput")?.value.trim() || "",
                minAmounts: Array.from(document.querySelectorAll(".bracket-min-input")).map(i => toNullableNumber(i.value)),
                maxAmounts: Array.from(document.querySelectorAll(".bracket-max-input")).map(i => toNullableNumber(i.value)),
                feeRates: Array.from(document.querySelectorAll(".bracket-fee-input")).map(i => toNullableNumber(i.value))
            };

            try {
                const data = await fetchJson(apiUrl("/rules"), {
                    method: "POST",
                    body: JSON.stringify(payload)
                });

                renderActiveRule(data);
                prefillRuleForm(data);
                await loadHistory();

                const ruleNameInput = document.getElementById("ruleNameInput");
                const ruleDescriptionInput = document.getElementById("ruleDescriptionInput");

                if (ruleNameInput) ruleNameInput.value = "";
                if (ruleDescriptionInput) ruleDescriptionInput.value = "";

                showAlert(data.message || "New conversion rule set created and activated successfully.", "success");
            } catch (e) {
                showAlert(e.message || "Unable to create conversion rule set.", "error");
            }
        });
    }
}

/* =========================================================
   BUILD ONE BRACKET ROW HTML
   ---------------------------------------------------------
   Creates one editable fee bracket row for the form.
   ========================================================= */
function buildBracketRowHtml(min = "", max = "", fee = "") {
    return `
        <div class="currency-admin-bracket-row">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="currency-admin-label">Minimum</label>
                    <input type="number" step="0.01" class="currency-admin-input bracket-min-input" value="${min}">
                </div>
                <div class="col-md-4">
                    <label class="currency-admin-label">Maximum</label>
                    <input type="number" step="0.01" class="currency-admin-input bracket-max-input" value="${max}">
                </div>
                <div class="col-md-3">
                    <label class="currency-admin-label">Fee Rate (%)</label>
                    <input type="number" step="0.01" class="currency-admin-input bracket-fee-input" value="${fee}">
                </div>
                <div class="col-md-1">
                    <button type="button" class="currency-admin-row-remove-btn remove-bracket-row-btn" title="Remove Row">×</button>
                </div>
            </div>
        </div>
    `;
}

/* =========================================================
   REBIND BRACKET UI
   ---------------------------------------------------------
   Reattaches remove button click events and input listeners
   whenever new bracket rows are added dynamically.
   ========================================================= */
function rebindBracketUi() {
    document.querySelectorAll(".remove-bracket-row-btn").forEach((button) => {
        button.onclick = function () {
            const rows = document.querySelectorAll(".currency-admin-bracket-row");
            if (rows.length <= 1) return;

            const row = button.closest(".currency-admin-bracket-row");
            if (row) {
                row.remove();
                updatePreviewMinMax();
            }
        };
    });

    document.querySelectorAll(".bracket-min-input, .bracket-max-input").forEach((input) => {
        input.oninput = updatePreviewMinMax;
    });
}

/* =========================================================
   UPDATE PREVIEW MIN / MAX
   ---------------------------------------------------------
   Updates the summary preview values based on the first min
   and last max of the current bracket rows.
   ========================================================= */
function updatePreviewMinMax() {
    const minInputs = document.querySelectorAll(".bracket-min-input");
    const maxInputs = document.querySelectorAll(".bracket-max-input");

    const previewMin = document.getElementById("previewMinAmount");
    const previewMax = document.getElementById("previewMaxAmount");

    if (!previewMin || !previewMax || !minInputs.length || !maxInputs.length) return;

    const firstMin = minInputs[0].value;
    const lastMax = maxInputs[maxInputs.length - 1].value;

    if (firstMin !== "") previewMin.textContent = formatNumber(firstMin);
    if (lastMax !== "") previewMax.textContent = formatNumber(lastMax);
}

/* =========================================================
   RATES FILTER INITIALIZATION
   ---------------------------------------------------------
   What this block is for:
   - resets the rates form
   - shows loading state before API call
   - renders empty or loaded results after response
   ========================================================= */
function initRatesFilter() {
    const form = document.getElementById("ratesFilterForm");
    const resetBtn = document.getElementById("resetRatesBtn");

    if (resetBtn && form) {
        resetBtn.addEventListener("click", function () {
            form.reset();
            renderEmptyState(
                "ratesResultsWrap",
                "No rate results yet",
                "Use the filter above to load rate results."
            );
        });
    }

    if (form) {
        form.addEventListener("submit", async function (e) {
            e.preventDefault();

            const payload = {
                baseCurrency: document.getElementById("rateBaseCurrency")?.value.trim() || "",
                targetCurrency: document.getElementById("rateTargetCurrency")?.value.trim() || "",
                dateFrom: document.getElementById("rateDateFrom")?.value || "",
                dateTo: document.getElementById("rateDateTo")?.value || ""
            };

            renderLoadingState(
                "ratesResultsWrap",
                "Loading rate results...",
                "Please wait while the system retrieves exchange rates."
            );

            try {
                const data = await fetchJson(apiUrl("/rates/filter"), {
                    method: "POST",
                    body: JSON.stringify(payload)
                });

                renderRatesResults(data.rateResults || []);
                clearAlert();
            } catch (e) {
                renderEmptyState(
                    "ratesResultsWrap",
                    "Unable to load rate results",
                    "Please try again."
                );
                showAlert(e.message || "Unable to retrieve currency rates.", "error");
            }
        });
    }
}

/* =========================================================
   RENDER RATE RESULTS
   ---------------------------------------------------------
   What this block is for:
   - shows empty state when there are no rows
   - shows a scrollable table when results exist
   ========================================================= */
function renderRatesResults(results) {
    const wrap = document.getElementById("ratesResultsWrap");
    if (!wrap) return;

    if (!results.length) {
        renderEmptyState(
            "ratesResultsWrap",
            "No rate results found",
            "Try another currency pair or date range."
        );
        return;
    }

    wrap.innerHTML = `
        <div class="table-responsive">
            <table class="table currency-admin-history-table">
                <thead>
                    <tr>
                        <th>Base</th>
                        <th>Target</th>
                        <th>Exchange Rate</th>
                        <th>Rate Date</th>
                        <th>Retrieved At</th>
                    </tr>
                </thead>
                <tbody>
                    ${results.map(rate => `
                        <tr>
                            <td>${escapeHtml(rate.baseCurrency)}</td>
                            <td>${escapeHtml(rate.targetCurrency)}</td>
                            <td>${formatRate(rate.exchangeRate)}</td>
                            <td>${escapeHtml(rate.rateDate || "-")}</td>
                            <td>${formatDateTime(rate.retrievedAt)}</td>
                        </tr>
                    `).join("")}
                </tbody>
            </table>
        </div>
    `;
}

/* =========================================================
   TRANSACTIONS FILTER INITIALIZATION
   ---------------------------------------------------------
   What this block is for:
   - resets the transactions form
   - shows loading state before API call
   - renders empty or loaded results after response
   ========================================================= */
function initTransactionsFilter() {
    const form = document.getElementById("transactionsFilterForm");
    const resetBtn = document.getElementById("resetTransactionsBtn");

    if (resetBtn && form) {
        resetBtn.addEventListener("click", function () {
            form.reset();
            renderEmptyState(
                "transactionsResultsWrap",
                "No transaction results yet",
                "Use the filter above to load saved transactions."
            );
        });
    }

    if (form) {
        form.addEventListener("submit", async function (e) {
            e.preventDefault();

            const payload = {
                baseCurrency: document.getElementById("txnBaseCurrency")?.value.trim() || "",
                targetCurrency: document.getElementById("txnTargetCurrency")?.value.trim() || "",
                dateFrom: document.getElementById("txnDateFrom")?.value || "",
                dateTo: document.getElementById("txnDateTo")?.value || "",
                search: document.getElementById("txnSearch")?.value.trim() || ""
            };

            renderLoadingState(
                "transactionsResultsWrap",
                "Loading transactions...",
                "Please wait while the system retrieves saved transactions."
            );

            try {
                const data = await fetchJson(apiUrl("/transactions/filter"), {
                    method: "POST",
                    body: JSON.stringify(payload)
                });

                renderTransactionsResults(data.transactionHistory || []);
                clearAlert();
            } catch (e) {
                renderEmptyState(
                    "transactionsResultsWrap",
                    "Unable to load transactions",
                    "Please try again."
                );
                showAlert(e.message || "Unable to retrieve transactions.", "error");
            }
        });
    }
}


/* =========================================================
   RENDER TRANSACTION RESULTS
   ---------------------------------------------------------
   What this block is for:
   - shows empty state when there are no rows
   - shows a scrollable table when results exist
   ========================================================= */
function renderTransactionsResults(results) {
    const wrap = document.getElementById("transactionsResultsWrap");
    if (!wrap) return;

    if (!results.length) {
        renderEmptyState(
            "transactionsResultsWrap",
            "No transactions found",
            "Try another filter combination."
        );
        return;
    }

    wrap.innerHTML = `
        <div class="table-responsive">
            <table class="table currency-admin-history-table">
                <thead>
                    <tr>
                        <th>Transaction No.</th>
                        <th>User ID</th>
                        <th>Type</th>
                        <th>Base</th>
                        <th>Target</th>
                        <th>Input Amount</th>
                        <th>Fee</th>
                        <th>Final</th>
                        <th>Status</th>
                        <th>Created At</th>
                    </tr>
                </thead>
                <tbody>
                    ${results.map(item => `
                        <tr>
                            <td>${escapeHtml(item.transactionNumber || "-")}</td>
                            <td>${escapeHtml(String(item.userId ?? "-"))}</td>
                            <td>${escapeHtml(item.transactionType || "-")}</td>
                            <td>${escapeHtml(item.baseCurrency || "-")}</td>
                            <td>${escapeHtml(item.targetCurrency || "-")}</td>
                            <td>${formatNumber(item.inputAmount)}</td>
                            <td>${formatNumber(item.feeValue)}</td>
                            <td>${formatNumber(item.finalAmount)}</td>
                            <td>
                                <span class="currency-admin-status-badge ${(item.status === "COMPLETED") ? "active" : "inactive"}">
                                    ${escapeHtml(item.status || "-")}
                                </span>
                            </td>
                            <td>${formatDateTime(item.createdAt)}</td>
                        </tr>
                    `).join("")}
                </tbody>
            </table>
        </div>
    `;
}

/* =========================================================
   LOAD RULE HISTORY
   ---------------------------------------------------------
   What this block is for:
   - shows loading state while history is fetched
   - renders empty or loaded history results
   ========================================================= */
async function loadHistory() {
    renderLoadingState(
        "historyResultsWrap",
        "Loading conversion rule history...",
        "Please wait while the system retrieves saved rule versions."
    );

    try {
        const data = await fetchJson(apiUrl("/rules/history"));
        renderHistoryResults(data.conversionRuleHistory || []);
        clearAlert();
    } catch (e) {
        renderEmptyState(
            "historyResultsWrap",
            "Unable to load history",
            "Please try again."
        );
        showAlert(e.message || "Unable to load conversion rule history.", "error");
    }
}

/* =========================================================
   RENDER HISTORY RESULTS
   ---------------------------------------------------------
   What this block is for:
   - shows empty state when there are no rows
   - shows a scrollable table when results exist
   - binds View buttons after rendering
   ========================================================= */
function renderHistoryResults(results) {
    const wrap = document.getElementById("historyResultsWrap");
    if (!wrap) return;

    if (!results.length) {
        renderEmptyState(
            "historyResultsWrap",
            "No conversion rule history yet",
            "Saved conversion rule versions will appear here."
        );
        return;
    }

    wrap.innerHTML = `
        <div class="table-responsive">
            <table class="table currency-admin-history-table">
                <thead>
                    <tr>
                        <th>Set ID</th>
                        <th>Rule Name</th>
                        <th>Description</th>
                        <th>Date Created</th>
                        <th>Status</th>
                        <th>View</th>
                    </tr>
                </thead>
                <tbody>
                    ${results.map(item => `
                        <tr>
                            <td>${item.id}</td>
                            <td>${escapeHtml(item.ruleName || "-")}</td>
                            <td>${escapeHtml(item.description || "-")}</td>
                            <td>${formatDateTime(item.createdAt)}</td>
                            <td>
                                <span class="currency-admin-status-badge ${item.active ? "active" : "inactive"}">
                                    ${item.active ? "Active" : "Inactive"}
                                </span>
                            </td>
                            <td>
                                <button type="button"
                                        class="btn-glow-outline btn-sm view-rule-history-btn"
                                        data-rule-set-id="${item.id}">
                                    View
                                </button>
                            </td>
                        </tr>
                    `).join("")}
                </tbody>
            </table>
        </div>
    `;

    bindHistoryViewButtons();
}


/* =========================================================
   BIND HISTORY VIEW BUTTONS
   ---------------------------------------------------------
   When the user clicks View, this loads detailed fee bracket
   information for that specific rule set.
   Endpoint: GET /rules/{ruleSetId}
   ========================================================= */
function bindHistoryViewButtons() {
    document.querySelectorAll(".view-rule-history-btn").forEach((button) => {
        button.onclick = async function () {
            const ruleSetId = button.getAttribute("data-rule-set-id");
            if (!ruleSetId) return;

            try {
                const data = await fetchJson(apiUrl(`/rules/${ruleSetId}`));
                openHistoryModal(data);
            } catch (e) {
                showAlert(e.message || "Unable to load rule details.", "error");
            }
        };
    });
}

/* =========================================================
   OPEN HISTORY MODAL
   ---------------------------------------------------------
   Fills the Bootstrap modal with selected rule set details
   and prepares the activate button.
   ========================================================= */
   function openHistoryModal(data) {
       const ruleSet = data.ruleSet;
       const feeRules = data.feeRules || [];

       currentHistoryRuleId = ruleSet.id;

       document.getElementById("historyRuleSetId").textContent = ruleSet.id ?? "-";
       document.getElementById("historyRuleName").textContent = ruleSet.ruleName || "-";
       document.getElementById("historyRuleDescription").textContent = ruleSet.description || "No description available.";
       document.getElementById("historyRuleMin").textContent = formatNumber(data.minAmount);
       document.getElementById("historyRuleMax").textContent = formatNumber(data.maxAmount);

       const statusBadge = document.getElementById("historyRuleStatusBadge");
       if (statusBadge) {
           const isActive = !!ruleSet.active;
           statusBadge.textContent = isActive ? "Active" : "Inactive";
           statusBadge.classList.remove("active", "inactive");
           statusBadge.classList.add(isActive ? "active" : "inactive");
       }

       const tbody = document.getElementById("historyRuleBracketTableBody");
       if (tbody) {
           tbody.innerHTML = feeRules.length
               ? feeRules.map(rule => `
                   <tr>
                       <td>
                           ${formatNumber(rule.minAmount)} - ${formatNumber(rule.maxAmount)}
                       </td>
                       <td>${formatNumber(rule.feeRate)}%</td>
                   </tr>
               `).join("")
               : `<tr><td colspan="2">No rule details found.</td></tr>`;
       }

       const activateBtn = document.getElementById("activateRuleSetBtn");
       if (activateBtn) {
           activateBtn.disabled = !!ruleSet.active;
           activateBtn.textContent = ruleSet.active ? "Already Active" : "Activate Conversion Rule";
           activateBtn.onclick = activateHistoryRule;
       }

       const modalEl = document.getElementById("ruleHistoryDetailsModal");
       if (!modalEl) return;

       const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
       modal.show();
   }
/* =========================================================
   ACTIVATE OLD RULE SET
   ---------------------------------------------------------
   Sends request to activate the selected history rule set.
   Endpoint: POST /rules/{ruleSetId}/activate
   Then refreshes active rule and history list.
   ========================================================= */
async function activateHistoryRule() {
    if (!currentHistoryRuleId) return;

    try {
        const data = await fetchJson(apiUrl(`/rules/${currentHistoryRuleId}/activate`), {
            method: "POST",
            body: JSON.stringify({})
        });

        showAlert(data.message || "Conversion rule set activated successfully.", "success");

        const modalEl = document.getElementById("ruleHistoryDetailsModal");
        const modal = modalEl ? bootstrap.Modal.getInstance(modalEl) : null;
        if (modal) modal.hide();

        await loadActiveRule();
        await loadHistory();
    } catch (e) {
        showAlert(e.message || "Unable to activate conversion rule set.", "error");
    }
}


/* =========================================================
   RESULTS STATE HELPERS
   ---------------------------------------------------------
   What this block is for:
   - shows loading state while request is running
   - shows no-data state when no results are found
   - keeps the UI consistent across rates, transactions, history
   ========================================================= */
function renderLoadingState(containerId, title, message) {
    const wrap = document.getElementById(containerId);
    if (!wrap) return;

    wrap.innerHTML = `
        <div class="currency-admin-empty-state">
            <h4>${escapeHtml(title || "Loading...")}</h4>
            <p>${escapeHtml(message || "Please wait while the system retrieves data.")}</p>
        </div>
    `;
}

function renderEmptyState(containerId, title, message) {
    const wrap = document.getElementById(containerId);
    if (!wrap) return;

    wrap.innerHTML = `
        <div class="currency-admin-empty-state">
            <h4>${escapeHtml(title || "No results found")}</h4>
            <p>${escapeHtml(message || "Try another filter combination.")}</p>
        </div>
    `;
}

/* =========================================================
   FORMAT HELPERS
   ---------------------------------------------------------
   Utility functions for formatting numbers, rates, dates,
   and safely converting empty inputs.
   ========================================================= */
function formatNumber(value) {
    const num = Number(value);
    if (value === null || value === undefined || value === "" || Number.isNaN(num)) return "-";
    return num.toLocaleString(undefined, {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function formatRate(value) {
    const num = Number(value);
    if (value === null || value === undefined || value === "" || Number.isNaN(num)) return "-";
    return num.toLocaleString(undefined, {
        minimumFractionDigits: 4,
        maximumFractionDigits: 6
    });
}

function formatDateTime(value) {
    if (!value) return "-";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleString();
}

function toNullableNumber(value) {
    if (value === null || value === undefined || value === "") return null;
    const num = Number(value);
    return Number.isNaN(num) ? null : num;
}

/* =========================================================
   ESCAPE HTML
   ---------------------------------------------------------
   Prevents unsafe HTML injection when printing values into
   the page using template strings.
   ========================================================= */
function escapeHtml(value) {
    if (value === null || value === undefined) return "";
    return String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}