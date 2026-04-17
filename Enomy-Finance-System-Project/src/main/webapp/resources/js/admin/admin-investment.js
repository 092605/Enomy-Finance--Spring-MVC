/* =========================
   PAGE BOOTSTRAP
========================= */

// This waits until the page is fully ready before binding behaviors.
document.addEventListener("DOMContentLoaded", function () {
    initTabbedPanels();

    initWizardFlow();
    initTaxModeCards();
    restoreWizardStepFromConfig();

    initActiveTaxSettingsSwitcher();
    initHistoryTaxSettingsSwitcher();

    initTaxHistoryModal();
    initPlanHistoryModal();
    initActivateConfirmFlow();
});


/* =========================
   SHARED FORMATTERS & HELPERS
========================= */

// This formats numbers into currency-style text when needed.
function formatMoney(value) {
    if (value === null || value === undefined || value === "" || value === "null") {
        return "-";
    }

    const num = Number(value);
    if (Number.isNaN(num)) {
        return value;
    }

    return "£" + num.toLocaleString(undefined, {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

// This formats percentage values for display in cards and modals.
function formatPercent(value) {
    if (value === null || value === undefined || value === "" || value === "null") {
        return "-";
    }

    const num = Number(value);
    if (Number.isNaN(num)) {
        return value;
    }

    return num.toLocaleString(undefined, {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }) + "%";
}

// This formats values that may be unlimited depending on the field.
function formatYearlyLimit(value) {
    if (value === null || value === undefined || value === "" || value === "null") {
        return "Unlimited";
    }

    const num = Number(value);
    if (Number.isNaN(num)) {
        return value;
    }

    return formatMoney(num);
}

// This safely sets text content on a target element by ID.
function setText(id, value) {
    const el = document.getElementById(id);
    if (el) {
        el.textContent = value;
    }
}

// This shows a temporary inline error at the top if the page already has no server error.
function showInlinePageError(message) {
    let existing = document.querySelector(".investment-inline-temp-error");

    if (!existing) {
        existing = document.createElement("div");
        existing.className = "alert alert-danger investment-inline-temp-error mb-4";

        const pageHeader = document.querySelector(".investment-page-header");
        if (pageHeader && pageHeader.parentNode) {
            pageHeader.parentNode.insertBefore(existing, pageHeader.nextSibling);
        } else {
            const content = document.querySelector(".investment-page");
            if (content) {
                content.prepend(existing);
            }
        }
    }

    existing.textContent = message;

    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });
}

// This gets the app context path from the current URL structure.
function getContextPath() {
    const path = window.location.pathname;
    const parts = path.split("/").filter(Boolean);

    if (parts.length === 0) return "";
    return "/" + parts[0];
}


/* =========================
   SHARED TAB BEHAVIOR
========================= */

// This handles all tab groups like Active Plan tabs and modal tabs.
function initTabbedPanels() {
    const tabButtons = document.querySelectorAll(".investment-tab-btn");

    tabButtons.forEach((button) => {
        button.addEventListener("click", function () {
            const tabGroup = button.closest(".investment-plan-tabs");
            if (!tabGroup) return;

            const allButtons = tabGroup.querySelectorAll(".investment-tab-btn");
            allButtons.forEach((btn) => btn.classList.remove("active"));
            button.classList.add("active");

            const parentCard = tabGroup.parentElement;
            if (!parentCard) return;

            const allPanels = parentCard.querySelectorAll(".investment-tab-panel");
            allPanels.forEach((panel) => panel.classList.remove("active"));

            const targetId = button.getAttribute("data-tab-target");
            if (!targetId) return;

            const targetPanel = parentCard.querySelector("#" + CSS.escape(targetId));
            if (targetPanel) {
                targetPanel.classList.add("active");
            }
        });
    });
}


/* =========================
   PLAN RULE WIZARD
========================= */

// This restores the wizard step when the controller sends a saved state.
function restoreWizardStepFromConfig() {
    if (!window.investmentPageConfig) return;

    const activeSection = window.investmentPageConfig.activeSection;
    const planRuleStep = window.investmentPageConfig.planRuleStep;
    const embeddedTaxSaved = window.investmentPageConfig.embeddedTaxSaved;
    const selectedTaxMode = window.investmentPageConfig.selectedTaxMode;

    if (activeSection !== "plan-rules") return;

    if (selectedTaxMode) {
        setSelectedTaxMode(selectedTaxMode);
    }

    if (embeddedTaxSaved === "true") {
        showEmbeddedTaxSavedState();
    } else {
        hideEmbeddedTaxSavedState();
    }

    if (planRuleStep) {
        showWizardStep(planRuleStep);
    } else {
        showWizardStep("basic");
    }

    updateTaxSelectionPrimaryButton();
}

// This wires all Plan Rule wizard next/back/save/create actions.
function initWizardFlow() {
    const wizardForm = document.getElementById("planRuleWizardForm");
    if (!wizardForm) return;

    const nextButtons = document.querySelectorAll(".wizard-next");
    const prevButtons = document.querySelectorAll(".wizard-prev");
    const saveEmbeddedTaxBtn = document.getElementById("saveEmbeddedTaxBtn");
    const taxSelectionPrimaryBtn = document.getElementById("taxSelectionPrimaryBtn");
    const editEmbeddedTaxBtn = document.getElementById("editEmbeddedTaxBtn");
    const finalCreateActivateBtn = document.getElementById("finalCreateActivateBtn");

    nextButtons.forEach((button) => {
        button.addEventListener("click", function () {
            const nextStep = button.getAttribute("data-next-step");
            if (!nextStep) return;
            showWizardStep(nextStep);
        });
    });

    prevButtons.forEach((button) => {
        button.addEventListener("click", function () {
            const prevStep = button.getAttribute("data-prev-step");
            if (!prevStep) return;
            showWizardStep(prevStep);
        });
    });

    if (taxSelectionPrimaryBtn) {
        taxSelectionPrimaryBtn.addEventListener("click", function () {
            const selectedTaxMode = getSelectedTaxMode();
            const embeddedTaxSaved = getEmbeddedTaxSavedFlag();

            if (selectedTaxMode === "NEW") {
                if (embeddedTaxSaved) {
                    submitPlanRuleFormWithNewTax();
                } else {
                    showWizardStep("tax-form");
                }
                return;
            }

            submitPlanRuleFormUsingActiveTax();
        });
    }

    if (saveEmbeddedTaxBtn) {
        saveEmbeddedTaxBtn.addEventListener("click", function () {
            if (!validateEmbeddedTaxForm()) {
                showInlinePageError("Please complete all required tax settings fields before saving.");
                return;
            }

            setEmbeddedTaxSavedFlag(true);
            showEmbeddedTaxSavedState();
            showWizardStep("tax-selection");
            updateTaxSelectionPrimaryButton();
        });
    }

    if (editEmbeddedTaxBtn) {
        editEmbeddedTaxBtn.addEventListener("click", function () {
            showWizardStep("tax-form");
        });
    }

    if (finalCreateActivateBtn) {
        finalCreateActivateBtn.addEventListener("click", function () {
            submitPlanRuleFormWithNewTax();
        });
    }
}

// This switches the visible wizard step and updates the progress chips.
function showWizardStep(stepName) {
    const steps = document.querySelectorAll(".investment-wizard-step");
    const chips = document.querySelectorAll(".investment-step-chip");
    const currentWizardStepInput = document.getElementById("currentWizardStep");

    steps.forEach((step) => {
        step.classList.remove("active");
        if (step.getAttribute("data-step") === stepName) {
            step.classList.add("active");
        }
    });

    chips.forEach((chip) => {
        chip.classList.remove("active");
        if (chip.getAttribute("data-step-chip") === stepName) {
            chip.classList.add("active");
        }
    });

    if (currentWizardStepInput) {
        currentWizardStepInput.value = stepName;
    }
}


/* =========================
   PLAN RULE WIZARD - TAX MODE
========================= */

// This binds tax mode cards so the UI matches the radio selection.
function initTaxModeCards() {
    const taxModeCards = document.querySelectorAll(".investment-radio-card");
    if (!taxModeCards.length) return;

    taxModeCards.forEach((card) => {
        card.addEventListener("click", function () {
            const mode = card.getAttribute("data-tax-mode");
            if (!mode) return;

            setSelectedTaxMode(mode);

            if (mode === "ACTIVE") {
                hideEmbeddedTaxSavedState();
            }

            updateTaxSelectionPrimaryButton();
        });
    });
}

// This sets ACTIVE or NEW mode in both radio and hidden input.
function setSelectedTaxMode(mode) {
    const hidden = document.getElementById("selectedTaxMode");
    const cards = document.querySelectorAll(".investment-radio-card");
    const radios = document.querySelectorAll('input[name="taxModeChoice"]');

    if (hidden) {
        hidden.value = mode;
    }

    cards.forEach((card) => {
        if (card.getAttribute("data-tax-mode") === mode) {
            card.classList.add("active");
        } else {
            card.classList.remove("active");
        }
    });

    radios.forEach((radio) => {
        radio.checked = radio.value === mode;
    });
}

// This reads the currently selected tax mode.
function getSelectedTaxMode() {
    const hidden = document.getElementById("selectedTaxMode");
    return hidden ? hidden.value : "ACTIVE";
}

// This updates the main button text on Tax Selection based on the chosen mode.
function updateTaxSelectionPrimaryButton() {
    const primaryBtn = document.getElementById("taxSelectionPrimaryBtn");
    if (!primaryBtn) return;

    const mode = getSelectedTaxMode();
    const embeddedTaxSaved = getEmbeddedTaxSavedFlag();

    if (mode === "NEW" && !embeddedTaxSaved) {
        primaryBtn.textContent = "Continue";
    } else if (mode === "NEW" && embeddedTaxSaved) {
        primaryBtn.textContent = "Continue";
    } else {
        primaryBtn.textContent = "Create and Activate";
    }
}

// This marks whether embedded tax has already been saved in this flow.
function setEmbeddedTaxSavedFlag(value) {
    const hidden = document.getElementById("embeddedTaxSaved");
    if (hidden) {
        hidden.value = value ? "true" : "false";
    }
}

// This reads the embedded tax saved flag.
function getEmbeddedTaxSavedFlag() {
    const hidden = document.getElementById("embeddedTaxSaved");
    return hidden && hidden.value === "true";
}

// This shows the saved-state banner and the secondary action buttons.
function showEmbeddedTaxSavedState() {
    const banner = document.getElementById("embeddedTaxSavedBanner");
    const secondaryActions = document.getElementById("taxSelectionSecondaryActions");

    if (banner) {
        banner.classList.remove("d-none");
    }

    if (secondaryActions) {
        secondaryActions.classList.remove("d-none");
    }
}

// This hides the saved-state banner and the secondary action buttons.
function hideEmbeddedTaxSavedState() {
    const banner = document.getElementById("embeddedTaxSavedBanner");
    const secondaryActions = document.getElementById("taxSelectionSecondaryActions");

    if (banner) {
        banner.classList.add("d-none");
    }

    if (secondaryActions) {
        secondaryActions.classList.add("d-none");
    }
}

// This validates the embedded grouped tax form before allowing Save.
function validateEmbeddedTaxForm() {
    const requiredFields = [
        'input[name="embeddedNoneTaxFreeAllowance"]',
        'input[name="embeddedFlatTaxFreeAllowance"]',
        'input[name="embeddedFlatTaxRate"]',
        'input[name="embeddedProgTaxFreeAllowance"]',
        'input[name="embeddedProgLowerRate"]',
        'input[name="embeddedProgUpperRate"]'
    ];

    for (const selector of requiredFields) {
        const el = document.querySelector(selector);
        if (!el) continue;
        if (el.value === null || el.value === undefined || String(el.value).trim() === "") {
            return false;
        }
    }

    return true;
}

// This submits the wizard form using the active tax settings route.
function submitPlanRuleFormUsingActiveTax() {
    const form = document.getElementById("planRuleWizardForm");
    if (!form) return;

    form.action = getContextPath() + "/admin/investment/plan-rules/create/using-active-tax";
    form.submit();
}

// This submits the wizard form using the new embedded tax route.
function submitPlanRuleFormWithNewTax() {
    const form = document.getElementById("planRuleWizardForm");
    if (!form) return;

    form.action = getContextPath() + "/admin/investment/plan-rules/create/with-new-tax";
    form.submit();
}


/* =========================
   TAX SETTINGS SECTION - ACTIVE SWITCHER
========================= */

// This wires the Active Tax Settings selector to switch visible grouped tax panels.
function initActiveTaxSettingsSwitcher() {
    const select = document.getElementById("activeTaxTypeSelect");
    if (!select) return;

    const applySelection = () => {
        const panelId = select.value;
        showActiveTaxPanel(panelId);
        updateActiveTaxQuickRate(panelId);
    };

    select.addEventListener("change", applySelection);
    applySelection();
}

// This shows only the selected active tax panel.
function showActiveTaxPanel(panelId) {
    const container = document.getElementById("activeTaxTypeDropdown")?.closest(".investment-card-inner");
    if (!container) return;

    const panels = container.querySelectorAll(".investment-tax-view-panel");
    panels.forEach((panel) => panel.classList.remove("active"));

    const target = container.querySelector("#" + CSS.escape(panelId));
    if (target) {
        target.classList.add("active");
    }
}

// This updates the quick rate text beside the active tax selector.
function updateActiveTaxQuickRate(panelId) {
    const quickRate = document.getElementById("activeTaxQuickRate");
    if (!quickRate) return;

    const rateMap = {
        "active-tax-none": "0%",
        "active-tax-flat": getRateTextFromPanel("active-tax-flat", "activeTaxTypeDropdown"),
        "active-tax-progressive": getRateTextFromPanel("active-tax-progressive", "activeTaxTypeDropdown")
    };

    quickRate.textContent = rateMap[panelId] || "0%";
}

// This reads the first available tax rate text from a selected panel within a given container.
function getRateTextFromPanel(panelId, dropdownId) {
    const dropdown = document.getElementById(dropdownId);
    if (!dropdown) return "0%";

    const container = dropdown.closest(".investment-card-inner");
    if (!container) return "0%";

    const panel = container.querySelector("#" + CSS.escape(panelId));
    if (!panel) return "0%";

    const strongs = panel.querySelectorAll(".investment-tax-input-display strong");
    if (!strongs.length) return "0%";

    if (panelId === "active-tax-progressive") {
        const lowerRate = strongs[0] ? strongs[0].textContent.trim() : "0.00%";
        const upperRate = strongs[2] ? strongs[2].textContent.trim() : "0.00%";
        return `${lowerRate} - ${upperRate}`;
    }

    const text = strongs[0] ? strongs[0].textContent.trim() : "";
    return text || "0%";
}


/* =========================
   HISTORY MODAL - TAX SWITCHER
========================= */

// This wires the Tax History modal selector to switch visible grouped tax panels.
function initHistoryTaxSettingsSwitcher() {
    const select = document.getElementById("historyTaxTypeSelect");
    if (!select) return;

    const applySelection = () => {
        const panelId = select.value;
        const modal = document.getElementById("taxHistoryDetailsModal");
        if (!modal) return;

        modal.querySelectorAll(".investment-tax-view-panel").forEach(panel => {
            panel.classList.remove("active");
        });

        const target = modal.querySelector("#" + CSS.escape(panelId));
        if (target) {
            target.classList.add("active");
        }

        const quickRate = document.getElementById("historyTaxQuickRate");
        const activeItem = document.querySelector(
            `#historyTaxTypeDropdown .custom-dropdown-item[data-value="${panelId}"]`
        );

        if (quickRate && activeItem) {
            quickRate.textContent = activeItem.getAttribute("data-rate") || "0%";
        }
    };

    select.addEventListener("change", applySelection);
    applySelection();
}


/* =========================
   HISTORY MODALS - TAX
========================= */

// This fills the Tax History modal using the clicked row's data attributes.
function initTaxHistoryModal() {
    const taxButtons = document.querySelectorAll(".view-tax-history-btn");
    if (!taxButtons.length) return;

    taxButtons.forEach((button) => {
        button.addEventListener("click", function () {

            const taxSetId = button.getAttribute("data-tax-set-id") || "";

            // =========================
            // NONE
            // =========================
            const none = {
                allowance: button.getAttribute("data-none-tax-free-allowance"),
                lowerRate: button.getAttribute("data-none-lower-tax-rate"),
                lowerThreshold: button.getAttribute("data-none-lower-tax-threshold"),
                upperRate: button.getAttribute("data-none-upper-tax-rate"),
                upperThreshold: button.getAttribute("data-none-upper-tax-threshold")
            };

            // =========================
            // FLAT
            // =========================
            const flat = {
                allowance: button.getAttribute("data-flat-tax-free-allowance"),
                lowerRate: button.getAttribute("data-flat-lower-tax-rate"),
                lowerThreshold: button.getAttribute("data-flat-lower-tax-threshold"),
                upperRate: button.getAttribute("data-flat-upper-tax-rate"),
                upperThreshold: button.getAttribute("data-flat-upper-tax-threshold")
            };

            // =========================
            // PROGRESSIVE
            // =========================
            const progressive = {
                allowance: button.getAttribute("data-progressive-tax-free-allowance"),
                lowerRate: button.getAttribute("data-progressive-lower-tax-rate"),
                lowerThreshold: button.getAttribute("data-progressive-lower-tax-threshold"),
                upperRate: button.getAttribute("data-progressive-upper-tax-rate"),
                upperThreshold: button.getAttribute("data-progressive-upper-tax-threshold")
            };

            // =========================
            // VERSION BADGE
            // =========================
            const versionBadge = document.getElementById("history-tax-version-badge");
            if (versionBadge) {
                versionBadge.textContent = taxSetId ? `Version ${taxSetId}` : "Version -";
            }

            // =========================
            // DEFAULT VIEW = NONE
            // =========================
            const hiddenSelect = document.getElementById("historyTaxTypeSelect");
            if (hiddenSelect) {
                hiddenSelect.value = "history-tax-none";
                hiddenSelect.dispatchEvent(new Event("change", { bubbles: true }));
            }

            // =========================
            // UPDATE DROPDOWN RATE LABELS
            // =========================
            const flatItem = document.querySelector('[data-value="history-tax-flat"]');
            const progItem = document.querySelector('[data-value="history-tax-progressive"]');

            if (flatItem) {
                flatItem.setAttribute("data-rate", formatPercent(flat.lowerRate));
            }

            if (progItem) {
                progItem.setAttribute(
                    "data-rate",
                    `${formatPercent(progressive.lowerRate)} - ${formatPercent(progressive.upperRate)}`
                );
            }

            // =========================
            // FILL NONE PANEL
            // =========================
            setText("history-none-tax-free-allowance", formatMoney(none.allowance));
            setText("history-none-lower-tax-rate", formatPercent(none.lowerRate));
            setText("history-none-lower-tax-threshold", formatMoney(none.lowerThreshold));
            setText("history-none-upper-tax-rate", formatPercent(none.upperRate));
            setText("history-none-upper-tax-threshold", formatMoney(none.upperThreshold));

            // =========================
            // FILL FLAT PANEL
            // =========================
            setText("history-flat-tax-free-allowance", formatMoney(flat.allowance));
            setText("history-flat-lower-tax-rate", formatPercent(flat.lowerRate));
            setText("history-flat-lower-tax-threshold", formatMoney(flat.lowerThreshold));
            setText("history-flat-upper-tax-rate", formatPercent(flat.upperRate));
            setText("history-flat-upper-tax-threshold", formatMoney(flat.upperThreshold));

            // =========================
            // FILL PROGRESSIVE PANEL
            // =========================
            setText("history-progressive-tax-free-allowance", formatMoney(progressive.allowance));
            setText("history-progressive-lower-tax-rate", formatPercent(progressive.lowerRate));
            setText("history-progressive-lower-tax-threshold", formatMoney(progressive.lowerThreshold));
            setText("history-progressive-upper-tax-rate", formatPercent(progressive.upperRate));
            setText("history-progressive-upper-tax-threshold", formatMoney(progressive.upperThreshold));

            // =========================
            // ACTIVATE BUTTON
            // =========================
            const hiddenSetId = document.getElementById("activateTaxSetId");
            if (hiddenSetId) {
                hiddenSetId.value = taxSetId;
            }

            const activateBtn = document.getElementById("openActivateConfirmBtn");
            if (activateBtn) {
                const isActive = button.getAttribute("data-is-active") === "true";
                activateBtn.disabled = isActive;
                activateBtn.textContent = isActive ? "Already Active" : "Activate Tax Settings";
            }
        });
    });
}


/* =========================
   HISTORY MODALS - PLAN
========================= */

// This fills the Plan Rule History modal using the preloaded plan history map.
function initPlanHistoryModal() {
    const planButtons = document.querySelectorAll(".view-plan-history-btn");
    if (!planButtons.length) return;

    planButtons.forEach((button) => {
        button.addEventListener("click", function () {
            const planSetId = button.getAttribute("data-plan-set-id");
            if (!planSetId || !window.planHistoryDetails) return;

			const basic = window.planHistoryDetails[planSetId + "_BASIC_SAVINGS"];
			const plus = window.planHistoryDetails[planSetId + "_SAVINGS_PLUS"];
			const managed = window.planHistoryDetails[planSetId + "_MANAGED_STOCKS"];

            fillPlanModalSection("basic", basic);
            fillPlanModalSection("plus", plus);
            fillPlanModalSection("managed", managed);

            resetPlanModalTabs();
        });
    });
}

// This writes one plan type's values into the Plan History modal.
function fillPlanModalSection(prefix, data) {
    if (!data) {
        setText(`modal-${prefix}-yearly-limit`, "-");
        setText(`modal-${prefix}-monthly`, "-");
        setText(`modal-${prefix}-initial`, "-");
        setText(`modal-${prefix}-min-return`, "-");
        setText(`modal-${prefix}-max-return`, "-");
        setText(`modal-${prefix}-fee`, "-");
        return;
    }

    setText(`modal-${prefix}-yearly-limit`, formatYearlyLimit(data.yearlyInvestmentLimit));
    setText(`modal-${prefix}-monthly`, formatMoney(data.minMonthlyRequired));
    setText(`modal-${prefix}-initial`, formatMoney(data.minInitialRequired));
    setText(`modal-${prefix}-min-return`, formatPercent(data.minReturnRate));
    setText(`modal-${prefix}-max-return`, formatPercent(data.maxReturnRate));
    setText(`modal-${prefix}-fee`, formatPercent(data.monthlyFeeRate));
}

// This resets the Plan History modal tabs so it always starts from Basic.
function resetPlanModalTabs() {
    const modal = document.getElementById("planHistoryDetailsModal");
    if (!modal) return;

    const buttons = modal.querySelectorAll(".investment-tab-btn");
    const panels = modal.querySelectorAll(".investment-tab-panel");

    buttons.forEach((btn) => btn.classList.remove("active"));
    panels.forEach((panel) => panel.classList.remove("active"));

    const basicBtn = modal.querySelector('.investment-tab-btn[data-tab-target="modal-plan-basic"]');
    const basicPanel = modal.querySelector("#modal-plan-basic");

    if (basicBtn) basicBtn.classList.add("active");
    if (basicPanel) basicPanel.classList.add("active");
}


/* =========================
   CONFIRMATION MODAL BEHAVIOR
========================= */

// This opens the confirm modal and submits the activation form only after Yes.
function initActivateConfirmFlow() {
    const openConfirmBtn = document.getElementById("openActivateConfirmBtn");
    const confirmBtn = document.getElementById("confirmActivateTaxBtn");
    const activateForm = document.getElementById("activateTaxSettingsForm");

    if (openConfirmBtn) {
        openConfirmBtn.addEventListener("click", function () {
            if (openConfirmBtn.disabled) return;

            const confirmModalEl = document.getElementById("activateConfirmModal");
            if (!confirmModalEl) return;

            const confirmModal = bootstrap.Modal.getOrCreateInstance(confirmModalEl);
            confirmModal.show();
        });
    }

    if (confirmBtn && activateForm) {
        confirmBtn.addEventListener("click", function () {
            activateForm.submit();
        });
    }
}

/*
 =========================
   Dropdown showing quick rate
========================= 

document.addEventListener("DOMContentLoaded", function () {
    const activeTaxDropdown = document.getElementById("activeTaxTypeDropdown");
    const activeTaxPanels = document.querySelectorAll(".investment-tax-view-panel");
    const quickRate = document.getElementById("activeTaxQuickRate");

    if (!activeTaxDropdown) return;

    const items = activeTaxDropdown.querySelectorAll(".custom-dropdown-item");
    const hiddenInput = activeTaxDropdown.querySelector("input[type='hidden']");

    function applyActiveTaxPanel(panelId, rateText) {
        activeTaxPanels.forEach(panel => {
            panel.classList.toggle("active", panel.id === panelId);
        });

        if (quickRate) {
            quickRate.textContent = rateText || "0%";
        }

        if (hiddenInput) {
            hiddenInput.value = panelId;
        }
    }

    items.forEach(item => {
        item.addEventListener("click", function () {
            const panelId = this.getAttribute("data-value");
            const rateText = this.getAttribute("data-rate");
            applyActiveTaxPanel(panelId, rateText);
        });
    });

    const activeItem = activeTaxDropdown.querySelector(".custom-dropdown-item.active");
    if (activeItem) {
        applyActiveTaxPanel(
            activeItem.getAttribute("data-value"),
            activeItem.getAttribute("data-rate")
        );
    }
});*/