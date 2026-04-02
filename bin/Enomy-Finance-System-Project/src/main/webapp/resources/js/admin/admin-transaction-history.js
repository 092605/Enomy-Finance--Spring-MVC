document.addEventListener("DOMContentLoaded", function () {
    // =========================================================
    // 1. SECTION NAVIGATION
    // What this block is for:
    // - switches right sidebar sections
    // - shows only one main section at a time
    // =========================================================
    const sectionLinks = document.querySelectorAll("[data-section-target]");
    const sections = document.querySelectorAll(".transaction-admin-section");

	function activateSection(targetId) {
	    sections.forEach(section => {
	        section.classList.toggle("active", section.id === targetId);
	    });

	    sectionLinks.forEach(link => {
	        link.classList.toggle("active", link.dataset.sectionTarget === targetId);
	    });

	    // ✅ ADD THIS PART
	    if (targetId === "section-currency-transactions") {
	        fetchCurrencyTransactions();
	    }

	    if (targetId === "section-investment-quotes") {
	        fetchInvestmentQuotes();
	    }
	}

    sectionLinks.forEach(link => {
        link.addEventListener("click", function () {
            const targetId = this.dataset.sectionTarget;
            if (!targetId) return;
            activateSection(targetId);
        });
    });

    // =========================================================
    // 2. API BASE
    // What this block is for:
    // - keeps endpoint paths in one place
    // =========================================================
    const apiBase = window.transactionHistoryApiBase || "/admin/api/transaction-history";

    // =========================================================
    // 3. FORM / FIELD REFERENCES
    // What this block is for:
    // - currency filter references
    // - investment filter references
    // =========================================================

    // ---------- Currency ----------
    const currencyForm = document.getElementById("currencyTransactionFilterForm");
    const currencyDateFrom = document.getElementById("currencyDateFrom");
    const currencyDateTo = document.getElementById("currencyDateTo");
    const currencyBaseCurrency = document.getElementById("currencyBaseCurrency");
    const currencyTargetCurrency = document.getElementById("currencyTargetCurrency");
    const currencyTransactionType = document.getElementById("currencyTransactionType");
    const currencySearch = document.getElementById("currencySearch");
    const resetCurrencyBtn = document.getElementById("resetCurrencyTransactionFiltersBtn");

    const currencyResultsWrap = document.getElementById("currencyTransactionsResultsWrap");
    const currencyTableWrap = document.getElementById("currencyTransactionsTableWrap");
    const currencyTableBody = document.getElementById("currencyTransactionsTableBody");
    const currencyResultsCountBadge = document.getElementById("currencyResultsCountBadge");

    // ---------- Investment ----------
    const investmentForm = document.getElementById("investmentQuoteFilterForm");
    const investmentDateFrom = document.getElementById("investmentDateFrom");
    const investmentDateTo = document.getElementById("investmentDateTo");
    const investmentPlanType = document.getElementById("investmentPlanType");
    const investmentSearch = document.getElementById("investmentSearch");
    const resetInvestmentBtn = document.getElementById("resetInvestmentQuoteFiltersBtn");

    const investmentResultsWrap = document.getElementById("investmentQuotesResultsWrap");
    const investmentTableWrap = document.getElementById("investmentQuotesTableWrap");
    const investmentTableBody = document.getElementById("investmentQuotesTableBody");
    const investmentResultsCountBadge = document.getElementById("investmentResultsCountBadge");

    // =========================================================
    // 4. ALERT HELPER
    // What this block is for:
    // - shows success/error/info alerts above the page
    // =========================================================
    const alertsWrap = document.getElementById("transactionAdminAlerts");

    function showAlert(message, type = "error") {
        if (!alertsWrap) return;

        let alertClass = "alert-danger";
        if (type === "success") alertClass = "alert-success";
        if (type === "info") alertClass = "alert-info";

        alertsWrap.innerHTML = `
            <div class="alert ${alertClass} mb-4" role="alert">
                ${escapeHtml(message)}
            </div>
        `;

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function clearAlert() {
        if (alertsWrap) {
            alertsWrap.innerHTML = "";
        }
    }

    // =========================================================
    // 5. GENERIC HELPERS
    // What this block is for:
    // - safe fetch
    // - debounce for live search
    // - formatting helpers
    // =========================================================
    function debounce(fn, delay = 350) {
        let timeoutId;
        return function (...args) {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => fn.apply(this, args), delay);
        };
    }

    async function postJson(url, payload) {
        const headers = {
            "Content-Type": "application/json"
        };

        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute("content");
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute("content");

        if (csrfToken && csrfHeader) {
            headers[csrfHeader] = csrfToken;
        }

        const response = await fetch(url, {
            method: "POST",
            headers,
            body: JSON.stringify(payload)
        });

        const data = await response.json().catch(() => ({}));

        if (!response.ok || data.success === false) {
            throw new Error(data.message || "Request failed.");
        }

        return data;
    }

    function formatMoney(value) {
        if (value === null || value === undefined || value === "") return "-";
        const number = Number(value);
        if (Number.isNaN(number)) return "-";
        return number.toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function formatDate(value) {
        if (!value) return "-";

        const date = new Date(value);
        if (Number.isNaN(date.getTime())) return value;

        return date.toLocaleString();
    }

    function escapeHtml(value) {
        if (value === null || value === undefined) return "";
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // =========================================================
    // 6. EMPTY / LOADING STATE HELPERS
    // What this block is for:
    // - builds placeholder state
    // - shows loading and empty messages without removing table DOM
    // =========================================================
    function buildEmptyStateHtml(messageTitle, messageText) {
        return `
            <div class="transaction-admin-empty-state">
                <h4>${escapeHtml(messageTitle)}</h4>
                <p>${escapeHtml(messageText)}</p>
            </div>
        `;
    }

    function renderEmptyState(container, messageTitle, messageText) {
        let tableWrap = null;

        if (container.id === "currencyTransactionsResultsWrap") {
            tableWrap = document.getElementById("currencyTransactionsTableWrap");
        }

        if (container.id === "investmentQuotesResultsWrap") {
            tableWrap = document.getElementById("investmentQuotesTableWrap");
        }

        const existingEmptyState = container.querySelector(".transaction-admin-empty-state");

        if (tableWrap) {
            tableWrap.classList.add("d-none");
        }

        if (existingEmptyState) {
            existingEmptyState.outerHTML = buildEmptyStateHtml(messageTitle, messageText);
        } else {
            container.insertAdjacentHTML("afterbegin", buildEmptyStateHtml(messageTitle, messageText));
        }
    }

    function removeEmptyState(container) {
        const emptyState = container.querySelector(".transaction-admin-empty-state");
        if (emptyState) {
            emptyState.remove();
        }
    }

    // =========================================================
    // 7. CURRENCY TRANSACTION TABLE RENDERING
    // What this block is for:
    // - maps backend rows into currency table
    // =========================================================
    function renderCurrencyTransactions(rows) {
        if (!currencyTableBody || !currencyTableWrap || !currencyResultsWrap || !currencyResultsCountBadge) return;

        currencyResultsCountBadge.textContent = `${rows.length} Result${rows.length === 1 ? "" : "s"}`;

        if (!rows.length) {
            currencyTableBody.innerHTML = "";
            currencyTableWrap.classList.add("d-none");
            renderEmptyState(
                currencyResultsWrap,
                "No currency transactions found",
                "Try adjusting the filters or search keyword."
            );
            return;
        }

        removeEmptyState(currencyResultsWrap);
        currencyTableWrap.classList.remove("d-none");

        currencyTableBody.innerHTML = rows.map(row => `
            <tr>
                <td>${escapeHtml(row.transactionNumber || "-")}</td>
                <td>${escapeHtml(row.userId ?? "-")}</td>
                <td>${escapeHtml(row.userName || "-")}</td>
                <td>${escapeHtml(row.transactionType || "-")}</td>
                <td>${escapeHtml(row.baseCurrency || "-")}</td>
                <td>${escapeHtml(row.targetCurrency || "-")}</td>
                <td>${formatMoney(row.inputAmount)}</td>
                <td>${formatMoney(row.finalAmount)}</td>
                <td>${escapeHtml(row.status || "-")}</td>
                <td>${escapeHtml(formatDate(row.createdAt))}</td>
            </tr>
        `).join("");
    }

    // =========================================================
    // 8. INVESTMENT QUOTE TABLE RENDERING
    // What this block is for:
    // - maps backend rows into investment table
    // =========================================================
    function renderInvestmentQuotes(rows) {
        if (!investmentTableBody || !investmentTableWrap || !investmentResultsWrap || !investmentResultsCountBadge) return;

        investmentResultsCountBadge.textContent = `${rows.length} Result${rows.length === 1 ? "" : "s"}`;

        if (!rows.length) {
            investmentTableBody.innerHTML = "";
            investmentTableWrap.classList.add("d-none");
            renderEmptyState(
                investmentResultsWrap,
                "No investment quotes found",
                "Try adjusting the filters or search keyword."
            );
            return;
        }

        removeEmptyState(investmentResultsWrap);
        investmentTableWrap.classList.remove("d-none");

        investmentTableBody.innerHTML = rows.map(row => `
            <tr>
                <td>${escapeHtml(row.quoteId ?? "-")}</td>
                <td>${escapeHtml(row.userId ?? "-")}</td>
                <td>${escapeHtml(row.userName || "-")}</td>
                <td>${escapeHtml(row.planType || "-")}</td>
                <td>${formatMoney(row.initialLumpSum)}</td>
                <td>${formatMoney(row.monthlyInvestment)}</td>
                <td>${escapeHtml(row.planRuleId ?? "-")}</td>
                <td>${escapeHtml(formatDate(row.createdAt))}</td>
            </tr>
        `).join("");
    }

    // =========================================================
    // 9. CURRENCY FILTER SUBMIT
    // What this block is for:
    // - sends currency filter request to backend
    // - supports button submit and live search
    // =========================================================
    async function fetchCurrencyTransactions() {
        if (!currencyResultsWrap || !currencyTableWrap) return;

        clearAlert();
        currencyTableWrap.classList.add("d-none");
        renderEmptyState(
            currencyResultsWrap,
            "Loading currency transactions...",
            "Please wait while the system retrieves the filtered records."
        );

        const payload = {
            baseCurrency: currencyBaseCurrency?.value || "",
            targetCurrency: currencyTargetCurrency?.value || "",
            transactionType: currencyTransactionType?.value || "",
            dateFrom: currencyDateFrom?.value || "",
            dateTo: currencyDateTo?.value || "",
            search: currencySearch?.value || ""
        };

        try {
            const data = await postJson(`${apiBase}/currency/filter`, payload);
            renderCurrencyTransactions(data.currencyTransactions || []);
        } catch (error) {
            currencyResultsCountBadge.textContent = "0 Results";
            currencyTableWrap.classList.add("d-none");
            renderEmptyState(
                currencyResultsWrap,
                "Unable to load currency transactions",
                error.message || "Something went wrong while retrieving the records."
            );
            showAlert(error.message || "Unable to load currency transactions.");
        }
    }

    // =========================================================
    // 10. INVESTMENT FILTER SUBMIT
    // What this block is for:
    // - sends investment filter request to backend
    // - supports button submit and live search
    // =========================================================
    async function fetchInvestmentQuotes() {
        if (!investmentResultsWrap || !investmentTableWrap) return;

        clearAlert();
        investmentTableWrap.classList.add("d-none");
        renderEmptyState(
            investmentResultsWrap,
            "Loading investment quotes...",
            "Please wait while the system retrieves the filtered records."
        );

        const payload = {
            planType: investmentPlanType?.value || "",
            dateFrom: investmentDateFrom?.value || "",
            dateTo: investmentDateTo?.value || "",
            search: investmentSearch?.value || ""
        };

        try {
            const data = await postJson(`${apiBase}/investment/filter`, payload);
            renderInvestmentQuotes(data.investmentQuotes || []);
        } catch (error) {
            investmentResultsCountBadge.textContent = "0 Results";
            investmentTableWrap.classList.add("d-none");
            renderEmptyState(
                investmentResultsWrap,
                "Unable to load investment quotes",
                error.message || "Something went wrong while retrieving the records."
            );
            showAlert(error.message || "Unable to load investment quotes.");
        }
    }

    // =========================================================
    // 11. RESET BUTTONS
    // What this block is for:
    // - resets all filter inputs
    // - restores custom dropdown display text
    // - reloads filtered results with defaults
    // =========================================================
    function resetCustomDropdown(dropdownId, displayText = "All") {
        const dropdown = document.getElementById(dropdownId);
        if (!dropdown) return;

        const hiddenInput = dropdown.querySelector("input[type='hidden']");
        const selectedValue = dropdown.querySelector(".selected-value");
        const items = dropdown.querySelectorAll(".custom-dropdown-item");

        if (hiddenInput) hiddenInput.value = "";
        if (selectedValue) selectedValue.textContent = displayText;

        items.forEach((item, index) => {
            item.classList.toggle("active", index === 0);
        });
    }

    if (resetCurrencyBtn) {
        resetCurrencyBtn.addEventListener("click", function () {
            if (currencyDateFrom) currencyDateFrom.value = "";
            if (currencyDateTo) currencyDateTo.value = "";
            if (currencySearch) currencySearch.value = "";

            resetCustomDropdown("currencyBaseCurrencyDropdown", "All");
            resetCustomDropdown("currencyTargetCurrencyDropdown", "All");
            resetCustomDropdown("currencyTransactionTypeDropdown", "All");

            fetchCurrencyTransactions();
        });
    }

    if (resetInvestmentBtn) {
        resetInvestmentBtn.addEventListener("click", function () {
            if (investmentDateFrom) investmentDateFrom.value = "";
            if (investmentDateTo) investmentDateTo.value = "";
            if (investmentSearch) investmentSearch.value = "";

            resetCustomDropdown("investmentPlanTypeDropdown", "All");

            fetchInvestmentQuotes();
        });
    }

    // =========================================================
    // 12. FORM SUBMIT EVENTS
    // What this block is for:
    // - prevents page reload
    // - submits filters through fetch
    // =========================================================
    if (currencyForm) {
        currencyForm.addEventListener("submit", function (e) {
            e.preventDefault();
            fetchCurrencyTransactions();
        });
    }

    if (investmentForm) {
        investmentForm.addEventListener("submit", function (e) {
            e.preventDefault();
            fetchInvestmentQuotes();
        });
    }

    // =========================================================
    // 13. LIVE SEARCH
    // What this block is for:
    // - updates table while user types
    // - debounced to avoid too many requests
    // =========================================================
    const debouncedCurrencySearch = debounce(fetchCurrencyTransactions, 350);
    const debouncedInvestmentSearch = debounce(fetchInvestmentQuotes, 350);

    if (currencySearch) {
        currencySearch.addEventListener("input", debouncedCurrencySearch);
    }

    if (investmentSearch) {
        investmentSearch.addEventListener("input", debouncedInvestmentSearch);
    }

    // =========================================================
    // 14. DATE FILTER AUTO-REFRESH
    // What this block is for:
    // - date input changes auto-refresh results
    // =========================================================
    [currencyDateFrom, currencyDateTo]
        .filter(Boolean)
        .forEach(element => {
            element.addEventListener("change", fetchCurrencyTransactions);
        });

    [investmentDateFrom, investmentDateTo]
        .filter(Boolean)
        .forEach(element => {
            element.addEventListener("change", fetchInvestmentQuotes);
        });

    // =========================================================
    // 15. CUSTOM DROPDOWN HOOK
    // What this block is for:
    // - ensures auto-refresh works after custom dropdown selection
    // - relies on your reusable dropdown behavior script
    // =========================================================
    document.addEventListener("click", function (event) {
        const dropdownItem = event.target.closest(".custom-dropdown-item");
        if (!dropdownItem) return;

        const dropdown = dropdownItem.closest(".custom-dropdown");
        if (!dropdown) return;

        setTimeout(() => {
            if (
                dropdown.id === "currencyBaseCurrencyDropdown" ||
                dropdown.id === "currencyTargetCurrencyDropdown" ||
                dropdown.id === "currencyTransactionTypeDropdown"
            ) {
                fetchCurrencyTransactions();
            }

            if (dropdown.id === "investmentPlanTypeDropdown") {
                fetchInvestmentQuotes();
            }
        }, 0);
    });

    // =========================================================
    // 16. INITIAL LOAD
    // What this block is for:
    // - loads default section data on page open
    // =========================================================
    fetchCurrencyTransactions();
});