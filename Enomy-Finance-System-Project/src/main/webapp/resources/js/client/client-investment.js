/* ================================================= */
/* CLIENT INVESTMENT PAGE SCRIPT                     */
/* Note: This version keeps your investment page behavior and adds AJAX calculation, AJAX save, and result-card reset after successful save. */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    /* ============================================= */
    /* SHARED INLINE MESSAGE AUTO-HIDE               */
    /* Note: This block keeps support for any server-rendered success or error messages that still use the shared inline message system. */
    /* ============================================= */
    initializeInlineMessagesAutoHide();

    /* ============================================= */
    /* INVESTMENT PLAN DROPDOWN + PLAN DETAILS       */
    /* Note: This block keeps the custom dropdown behavior and updates the plan details card when the selected plan changes. */
    /* ============================================= */
    const dropdown = document.getElementById("investmentPlanDropdown");

    if (dropdown) {
        const toggle = dropdown.querySelector(".custom-dropdown-toggle");
        const menu = dropdown.querySelector(".custom-dropdown-menu");
        const selectedValue = dropdown.querySelector(".selected-value");
        const hiddenInput = document.getElementById("investmentPlanValue");
        const items = dropdown.querySelectorAll(".custom-dropdown-item");

        const titleEl = document.getElementById("planDetailsTitle");
        const maxInvestmentEl = document.getElementById("planMaxInvestment");
        const minMonthlyEl = document.getElementById("planMinMonthly");
        const minLumpSumEl = document.getElementById("planMinLumpSum");
        const returnsEl = document.getElementById("planReturns");
        const taxEl = document.getElementById("planTax");
        const feesEl = document.getElementById("planFees");

        function updatePlanDetails(planType) {
            const plan = window.planDetailsData ? window.planDetailsData[planType] : null;
            if (!plan) return;

            if (titleEl) titleEl.textContent = plan.title;
            if (maxInvestmentEl) maxInvestmentEl.textContent = plan.maximumInvestmentPerYear;
            if (minMonthlyEl) minMonthlyEl.textContent = plan.minimumMonthlyInvestment;
            if (minLumpSumEl) minLumpSumEl.textContent = plan.minimumInitialInvestmentLumpSum;
            if (returnsEl) returnsEl.textContent = plan.predictedReturnsPerYear;
            if (taxEl) taxEl.innerHTML = plan.estimatedTax;
            if (feesEl) feesEl.textContent = plan.groupFeesPerMonth;
        }

        if (toggle && menu) {
            toggle.addEventListener("click", function () {
                menu.classList.toggle("show");
            });
        }

        items.forEach(item => {
            item.addEventListener("click", function () {
                const selectedPlan = item.getAttribute("data-value");

                items.forEach(i => i.classList.remove("active"));
                item.classList.add("active");

                if (selectedValue) {
                    selectedValue.textContent = item.textContent.trim();
                }

                if (hiddenInput) {
                    hiddenInput.value = selectedPlan;
                }

                updatePlanDetails(selectedPlan);

                if (menu) {
                    menu.classList.remove("show");
                }
            });
        });

        document.addEventListener("click", function (e) {
            if (!dropdown.contains(e.target) && menu) {
                menu.classList.remove("show");
            }
        });

        if (hiddenInput && hiddenInput.value) {
            updatePlanDetails(hiddenInput.value);
        }
    }

    /* ============================================= */
    /* SHARED MONEY FORMATTER                        */
    /* Note: This helper keeps all investment amounts displayed consistently in pound format. */
    /* ============================================= */
    function formatMoney(value) {
        return "£" + Number(value || 0).toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    /* ============================================= */
    /* RESULT CARD HELPERS                           */
    /* Note: These helpers control the main result card values and tab switching for 1, 5, and 10 year results. */
    /* ============================================= */
    function getResultPlanDisplayName(planType) {
        if (planType === "BASIC_SAVINGS") return "Basic Savings Plan";
        if (planType === "SAVINGS_PLUS") return "Savings Plan Plus";
        if (planType === "MANAGED_STOCKS") return "Managed Stock Investments";
        return "Investment Result";
    }

    function getYearPrefix(yearKey) {
        if (yearKey === "oneYear") return "one";
        if (yearKey === "fiveYears") return "five";
        if (yearKey === "tenYears") return "ten";
        return "one";
    }

    function updateResultCard(yearKey) {
        const store = document.getElementById("resultDataStore");
        if (!store) return;

        const prefix = getYearPrefix(yearKey);
        const planType = store.dataset.planType || "";

        const resultPlanTitle = document.getElementById("resultPlanTitle");
        const resultInitialLumpSum = document.getElementById("resultInitialLumpSum");
        const resultMonthlyInvestment = document.getElementById("resultMonthlyInvestment");
        const resultTotalInvested = document.getElementById("resultTotalInvested");
        const resultMinReturn = document.getElementById("resultMinReturn");
        const resultMaxReturn = document.getElementById("resultMaxReturn");
        const resultMinProfit = document.getElementById("resultMinProfit");
        const resultMaxProfit = document.getElementById("resultMaxProfit");
        const resultMinTax = document.getElementById("resultMinTax");
        const resultMaxTax = document.getElementById("resultMaxTax");
        const resultMonthlyFee = document.getElementById("resultMonthlyFee");
        const resultTotalFee = document.getElementById("resultTotalFee");

        if (resultPlanTitle) resultPlanTitle.textContent = getResultPlanDisplayName(planType);
        if (resultInitialLumpSum) resultInitialLumpSum.textContent = formatMoney(store.dataset[prefix + "Initial"]);
        if (resultMonthlyInvestment) resultMonthlyInvestment.textContent = formatMoney(store.dataset[prefix + "Monthly"]);
        if (resultTotalInvested) resultTotalInvested.textContent = formatMoney(store.dataset[prefix + "Total"]);
        if (resultMinReturn) resultMinReturn.textContent = formatMoney(store.dataset[prefix + "MinReturn"]);
        if (resultMaxReturn) resultMaxReturn.textContent = formatMoney(store.dataset[prefix + "MaxReturn"]);
        if (resultMinProfit) resultMinProfit.textContent = formatMoney(store.dataset[prefix + "MinProfit"]);
        if (resultMaxProfit) resultMaxProfit.textContent = formatMoney(store.dataset[prefix + "MaxProfit"]);
        if (resultMinTax) resultMinTax.textContent = formatMoney(store.dataset[prefix + "MinTax"]);
        if (resultMaxTax) resultMaxTax.textContent = formatMoney(store.dataset[prefix + "MaxTax"]);
        if (resultMonthlyFee) resultMonthlyFee.textContent = formatMoney(store.dataset[prefix + "MonthlyFee"]);
        if (resultTotalFee) resultTotalFee.textContent = formatMoney(store.dataset[prefix + "TotalFee"]);
    }

    function updateResultDataStoreFromAjax(response) {
        const store = document.getElementById("resultDataStore");
        if (!store) return;

        const one = response.oneYear || {};
        const five = response.fiveYears || {};
        const ten = response.tenYears || {};

        store.dataset.planType = response.planType || "";

        store.dataset.oneInitial = one.initialLumpSum ?? 0;
        store.dataset.oneMonthly = one.monthlyInvestment ?? 0;
        store.dataset.oneTotal = one.totalInvested ?? 0;
        store.dataset.oneMinReturn = one.minReturn ?? 0;
        store.dataset.oneMaxReturn = one.maxReturn ?? 0;
        store.dataset.oneMinProfit = one.minProfit ?? 0;
        store.dataset.oneMaxProfit = one.maxProfit ?? 0;
        store.dataset.oneMinTax = one.minTax ?? 0;
        store.dataset.oneMaxTax = one.maxTax ?? 0;
        store.dataset.oneMonthlyFee = one.monthlyFee ?? 0;
        store.dataset.oneTotalFee = one.totalFee ?? 0;

        store.dataset.fiveInitial = five.initialLumpSum ?? 0;
        store.dataset.fiveMonthly = five.monthlyInvestment ?? 0;
        store.dataset.fiveTotal = five.totalInvested ?? 0;
        store.dataset.fiveMinReturn = five.minReturn ?? 0;
        store.dataset.fiveMaxReturn = five.maxReturn ?? 0;
        store.dataset.fiveMinProfit = five.minProfit ?? 0;
        store.dataset.fiveMaxProfit = five.maxProfit ?? 0;
        store.dataset.fiveMinTax = five.minTax ?? 0;
        store.dataset.fiveMaxTax = five.maxTax ?? 0;
        store.dataset.fiveMonthlyFee = five.monthlyFee ?? 0;
        store.dataset.fiveTotalFee = five.totalFee ?? 0;

        store.dataset.tenInitial = ten.initialLumpSum ?? 0;
        store.dataset.tenMonthly = ten.monthlyInvestment ?? 0;
        store.dataset.tenTotal = ten.totalInvested ?? 0;
        store.dataset.tenMinReturn = ten.minReturn ?? 0;
        store.dataset.tenMaxReturn = ten.maxReturn ?? 0;
        store.dataset.tenMinProfit = ten.minProfit ?? 0;
        store.dataset.tenMaxProfit = ten.maxProfit ?? 0;
        store.dataset.tenMinTax = ten.minTax ?? 0;
        store.dataset.tenMaxTax = ten.maxTax ?? 0;
        store.dataset.tenMonthlyFee = ten.monthlyFee ?? 0;
        store.dataset.tenTotalFee = ten.totalFee ?? 0;
    }

    function showResultActions() {
        const resultActions = document.querySelector(".result-actions");
        if (resultActions) {
            resultActions.classList.remove("d-none");
        }
    }

    function hideResultActions() {
        const resultActions = document.querySelector(".result-actions");
        if (resultActions) {
            resultActions.classList.add("d-none");
        }
    }

    function activateMainResultTab(yearKey) {
        const tabButtons = document.querySelectorAll(".result-tab-btn:not(.modal-result-tab-btn)");
        tabButtons.forEach(btn => btn.classList.remove("active"));

        const targetButton = document.querySelector(`.result-tab-btn:not(.modal-result-tab-btn)[data-year="${yearKey}"]`);
        if (targetButton) {
            targetButton.classList.add("active");
        }
    }

	function resetResultCardToDefault() {
	    const store = document.getElementById("resultDataStore");
	    if (store) {
	        store.dataset.planType = "";

	        store.dataset.oneInitial = 0;
	        store.dataset.oneMonthly = 0;
	        store.dataset.oneTotal = 0;
	        store.dataset.oneMinReturn = 0;
	        store.dataset.oneMaxReturn = 0;
	        store.dataset.oneMinProfit = 0;
	        store.dataset.oneMaxProfit = 0;
	        store.dataset.oneMinTax = 0;
	        store.dataset.oneMaxTax = 0;
	        store.dataset.oneMonthlyFee = 0;
	        store.dataset.oneTotalFee = 0;

	        store.dataset.fiveInitial = 0;
	        store.dataset.fiveMonthly = 0;
	        store.dataset.fiveTotal = 0;
	        store.dataset.fiveMinReturn = 0;
	        store.dataset.fiveMaxReturn = 0;
	        store.dataset.fiveMinProfit = 0;
	        store.dataset.fiveMaxProfit = 0;
	        store.dataset.fiveMinTax = 0;
	        store.dataset.fiveMaxTax = 0;
	        store.dataset.fiveMonthlyFee = 0;
	        store.dataset.fiveTotalFee = 0;

	        store.dataset.tenInitial = 0;
	        store.dataset.tenMonthly = 0;
	        store.dataset.tenTotal = 0;
	        store.dataset.tenMinReturn = 0;
	        store.dataset.tenMaxReturn = 0;
	        store.dataset.tenMinProfit = 0;
	        store.dataset.tenMaxProfit = 0;
	        store.dataset.tenMinTax = 0;
	        store.dataset.tenMaxTax = 0;
	        store.dataset.tenMonthlyFee = 0;
	        store.dataset.tenTotalFee = 0;
	    }

	    const resultPlanTitle = document.getElementById("resultPlanTitle");
	    if (resultPlanTitle) {
	        resultPlanTitle.textContent = "Investment Result";
	    }

	    activateMainResultTab("oneYear");
	    updateResultCard("oneYear");
	    hideResultActions();

	    const savePlanType = document.getElementById("saveQuotePlanType");
	    const saveInitialLumpSum = document.getElementById("saveQuoteInitialLumpSum");
	    const saveMonthlyInvestment = document.getElementById("saveQuoteMonthlyInvestment");

	    if (savePlanType) savePlanType.value = "";
	    if (saveInitialLumpSum) saveInitialLumpSum.value = "0";
	    if (saveMonthlyInvestment) saveMonthlyInvestment.value = "0";

	    const initialInvestmentInput = document.getElementById("initialInvestment");
	    const monthlyContributionInput = document.getElementById("monthlyContribution");
	    const investmentPlanValue = document.getElementById("investmentPlanValue");
	    const investmentPlanDropdown = document.getElementById("investmentPlanDropdown");
	    const selectedValue = investmentPlanDropdown
	        ? investmentPlanDropdown.querySelector(".selected-value")
	        : null;
	    const dropdownItems = investmentPlanDropdown
	        ? investmentPlanDropdown.querySelectorAll(".custom-dropdown-item")
	        : [];

	    if (initialInvestmentInput) initialInvestmentInput.value = "0";
	    if (monthlyContributionInput) monthlyContributionInput.value = "0";
	    if (investmentPlanValue) investmentPlanValue.value = "BASIC_SAVINGS";

	    if (selectedValue) {
	        selectedValue.textContent = "Basic Savings Plan";
	    }

	    dropdownItems.forEach(item => {
	        item.classList.remove("active");
	        if (item.getAttribute("data-value") === "BASIC_SAVINGS") {
	            item.classList.add("active");
	        }
	    });

	    if (typeof window.planDetailsData !== "undefined") {
	        const basicPlan = window.planDetailsData["BASIC_SAVINGS"];

	        if (basicPlan) {
	            const titleEl = document.getElementById("planDetailsTitle");
	            const maxInvestmentEl = document.getElementById("planMaxInvestment");
	            const minMonthlyEl = document.getElementById("planMinMonthly");
	            const minLumpSumEl = document.getElementById("planMinLumpSum");
	            const returnsEl = document.getElementById("planReturns");
	            const taxEl = document.getElementById("planTax");
	            const feesEl = document.getElementById("planFees");

	            if (titleEl) titleEl.textContent = basicPlan.title;
	            if (maxInvestmentEl) maxInvestmentEl.textContent = basicPlan.maximumInvestmentPerYear;
	            if (minMonthlyEl) minMonthlyEl.textContent = basicPlan.minimumMonthlyInvestment;
	            if (minLumpSumEl) minLumpSumEl.textContent = basicPlan.minimumInitialInvestmentLumpSum;
	            if (returnsEl) returnsEl.textContent = basicPlan.predictedReturnsPerYear;
	            if (taxEl) taxEl.innerHTML = basicPlan.estimatedTax;
	            if (feesEl) feesEl.textContent = basicPlan.groupFeesPerMonth;
	        }
	    }
	}

    const tabButtons = document.querySelectorAll(".result-tab-btn:not(.modal-result-tab-btn)");
    tabButtons.forEach(button => {
        button.addEventListener("click", function () {
            tabButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            const yearKey = this.getAttribute("data-year");
            updateResultCard(yearKey);
        });
    });

    updateResultCard("oneYear");

    /* ============================================= */
    /* AJAX CALCULATOR SUBMIT                        */
    /* Note: This block converts the calculator to AJAX so errors and success messages can animate like the currency check-rate card. */
    /* ============================================= */
    function setupInvestmentCalculatorAjax() {
        const form = document.querySelector('form[action*="/client/investment/calculate"]');
        const errorEl = document.getElementById("investmentCalcError");
        const successEl = document.getElementById("investmentCalcSuccess");

        if (!form || !errorEl || !successEl) {
            return;
        }

        form.addEventListener("submit", function (event) {
            event.preventDefault();

            if (typeof clearInlineMessage === "function") {
                clearInlineMessage(errorEl);
                clearInlineMessage(successEl);
            }

            const submitBtn = form.querySelector('button[type="submit"]');
            const originalBtnText = submitBtn ? submitBtn.textContent : "";

            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = "Calculating...";
            }

            const payload = {
                planType: document.getElementById("investmentPlanValue")?.value || "",
                initialLumpSum: parseFloat(document.getElementById("initialInvestment")?.value || "0"),
                monthlyInvestment: parseFloat(document.getElementById("monthlyContribution")?.value || "0")
            };

            fetch(form.action + "-ajax", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify(payload)
            })
            .then(async response => {
                const data = await response.json().catch(() => null);

                if (!response.ok || !data) {
                    throw new Error((data && data.message) || "Unable to calculate projection.");
                }

                return data;
            })
            .then(data => {
                if (!data.success) {
                    if (typeof showInlineError === "function") {
                        showInlineError(errorEl, data.message || "Unable to calculate projection.");
                    }
                    return;
                }

                updateResultDataStoreFromAjax(data);
                syncSaveQuoteFormValues(payload);
                activateMainResultTab("oneYear");
                updateResultCard("oneYear");
                showResultActions();

                if (typeof showInlineSuccess === "function") {
                    showInlineSuccess(successEl, data.message || "Calculation successful.");
                }
            })
            .catch(error => {
                if (typeof showInlineError === "function") {
                    showInlineError(errorEl, error.message || "Something went wrong. Please try again.");
                }
            })
            .finally(() => {
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.textContent = originalBtnText || "Calculate Projection";
                }
            });
        });
    }

    /* ============================================= */
    /* AJAX SAVE QUOTE                               */
    /* Note: This block saves the current calculated quote without page reload, updates the saved quote count, and resets the result card after success. */
    /* ============================================= */
    function setupSaveQuoteAjax() {
        const saveForm = document.getElementById("saveQuoteForm");
        const saveBtn = document.getElementById("saveQuoteBtn");
        const errorEl = document.getElementById("investmentResultError");
        const successEl = document.getElementById("investmentResultSuccess");
        const savedQuoteCountEl = document.querySelector(".SumCount");

        if (!saveForm || !saveBtn || !errorEl || !successEl) {
            return;
        }

        saveForm.addEventListener("submit", function (event) {
            event.preventDefault();

            if (typeof clearInlineMessage === "function") {
                clearInlineMessage(errorEl);
                clearInlineMessage(successEl);
            }

            const payload = {
                planType: document.getElementById("saveQuotePlanType")?.value || "",
                initialLumpSum: parseFloat(document.getElementById("saveQuoteInitialLumpSum")?.value || "0"),
                monthlyInvestment: parseFloat(document.getElementById("saveQuoteMonthlyInvestment")?.value || "0")
            };

            const originalText = saveBtn.textContent;
            saveBtn.disabled = true;
            saveBtn.textContent = "Saving...";

            fetch(saveForm.action + "-ajax", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify(payload)
            })
            .then(async response => {
                const data = await response.json().catch(() => null);

                if (!response.ok || !data) {
                    throw new Error((data && data.message) || "Unable to save quote.");
                }

                return data;
            })
            .then(data => {
                if (!data.success) {
                    if (typeof showInlineError === "function") {
                        showInlineError(errorEl, data.message || "Unable to save quote.");
                    }
                    return;
                }

                if (savedQuoteCountEl && typeof data.savedQuoteCount !== "undefined") {
                    savedQuoteCountEl.textContent = data.savedQuoteCount;
                }

                resetResultCardToDefault();

                if (typeof showInlineSuccess === "function") {
                    showInlineSuccess(successEl, data.message || "Investment quote has been successfully saved.");
                }
            })
            .catch(error => {
                if (typeof showInlineError === "function") {
                    showInlineError(errorEl, error.message || "Something went wrong while saving.");
                }
            })
            .finally(() => {
                saveBtn.disabled = false;
                saveBtn.textContent = originalText;
            });
        });
    }

    setupInvestmentCalculatorAjax();
    setupSaveQuoteAjax();

    /* ============================================= */
    /* SAME-PAGE SECTION SWITCHING                   */
    /* Note: This block keeps the main calculator view and saved quotes view switching on the same page. */
    /* ============================================= */
    const investmentMainSection = document.getElementById("investmentMainSection");
    const investmentQuotesSection = document.getElementById("investmentQuotesSection");
    const showSavedQuotesBtn = document.getElementById("showSavedQuotesBtn");
    const backToCalculatorBtn = document.getElementById("backToCalculatorBtn");
    const backToCalculatorBtnEmpty = document.getElementById("backToCalculatorBtnEmpty");

    function showQuotesSection() {
        if (investmentMainSection) {
            investmentMainSection.classList.add("d-none");
        }
        if (investmentQuotesSection) {
            investmentQuotesSection.classList.remove("d-none");
        }

        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }

    function showMainSection() {
        if (investmentQuotesSection) {
            investmentQuotesSection.classList.add("d-none");
        }
        if (investmentMainSection) {
            investmentMainSection.classList.remove("d-none");
        }

        closeQuoteModal();

        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }

    if (showSavedQuotesBtn) {
        showSavedQuotesBtn.addEventListener("click", function () {
            showQuotesSection();
        });
    }

    if (backToCalculatorBtn) {
        backToCalculatorBtn.addEventListener("click", function () {
            showMainSection();
        });
    }

    if (backToCalculatorBtnEmpty) {
        backToCalculatorBtnEmpty.addEventListener("click", function () {
            showMainSection();
        });
    }

    /* ============================================= */
    /* MODAL RESULT CARD DATA + SWITCHING            */
    /* Note: This block keeps the saved-quote result modal working with the existing quote-details AJAX endpoint. */
    /* ============================================= */
    let modalQuoteData = null;

    const modalResultPlanTitle = document.getElementById("modalResultPlanTitle");
    const modalQuoteId = document.getElementById("modalQuoteId");
    const modalQuoteCreated = document.getElementById("modalQuoteCreated");

    const modalResultInitialLumpSum = document.getElementById("modalResultInitialLumpSum");
    const modalResultMonthlyInvestment = document.getElementById("modalResultMonthlyInvestment");
    const modalResultTotalInvested = document.getElementById("modalResultTotalInvested");
    const modalResultMinReturn = document.getElementById("modalResultMinReturn");
    const modalResultMaxReturn = document.getElementById("modalResultMaxReturn");
    const modalResultMinProfit = document.getElementById("modalResultMinProfit");
    const modalResultMaxProfit = document.getElementById("modalResultMaxProfit");
    const modalResultMinTax = document.getElementById("modalResultMinTax");
    const modalResultMaxTax = document.getElementById("modalResultMaxTax");
    const modalResultMonthlyFee = document.getElementById("modalResultMonthlyFee");
    const modalResultTotalFee = document.getElementById("modalResultTotalFee");

    function updateModalResultCard(yearKey) {
        if (!modalQuoteData) return;

        const yearData = modalQuoteData[yearKey];
        if (!yearData) return;

        if (modalResultPlanTitle) modalResultPlanTitle.textContent = modalQuoteData.planLabel || "Investment Result";
        if (modalQuoteId) modalQuoteId.textContent = "#" + (modalQuoteData.quoteId || "-");
        if (modalQuoteCreated) modalQuoteCreated.textContent = modalQuoteData.createdAt || "-";

        if (modalResultInitialLumpSum) modalResultInitialLumpSum.textContent = formatMoney(yearData.initialLumpSum);
        if (modalResultMonthlyInvestment) modalResultMonthlyInvestment.textContent = formatMoney(yearData.monthlyInvestment);
        if (modalResultTotalInvested) modalResultTotalInvested.textContent = formatMoney(yearData.totalInvested);
        if (modalResultMinReturn) modalResultMinReturn.textContent = formatMoney(yearData.minReturn);
        if (modalResultMaxReturn) modalResultMaxReturn.textContent = formatMoney(yearData.maxReturn);
        if (modalResultMinProfit) modalResultMinProfit.textContent = formatMoney(yearData.minProfit);
        if (modalResultMaxProfit) modalResultMaxProfit.textContent = formatMoney(yearData.maxProfit);
        if (modalResultMinTax) modalResultMinTax.textContent = formatMoney(yearData.minTax);
        if (modalResultMaxTax) modalResultMaxTax.textContent = formatMoney(yearData.maxTax);
        if (modalResultMonthlyFee) modalResultMonthlyFee.textContent = formatMoney(yearData.monthlyFee);
        if (modalResultTotalFee) modalResultTotalFee.textContent = formatMoney(yearData.totalFee);
    }

    const modalTabButtons = document.querySelectorAll(".modal-result-tab-btn");
    modalTabButtons.forEach(button => {
        button.addEventListener("click", function () {
            modalTabButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            const yearKey = this.getAttribute("data-modal-year");
            updateModalResultCard(yearKey);
        });
    });

    function resetModalTabsToDefault() {
        modalTabButtons.forEach(btn => btn.classList.remove("active"));

        const defaultTab = document.querySelector('.modal-result-tab-btn[data-modal-year="oneYear"]');
        if (defaultTab) {
            defaultTab.classList.add("active");
        }
    }

    /* ============================================= */
    /* SAVED QUOTE MODAL CARD                        */
    /* Note: This block keeps the saved quote modal opening, closing, and loading quote data asynchronously. */
    /* ============================================= */
    const quoteModalOverlay = document.getElementById("investmentQuoteModalOverlay");
    const closeQuoteModalBtn = document.getElementById("closeQuoteModalBtn");
    const closeQuoteModalFooterBtn = document.getElementById("closeQuoteModalFooterBtn");
    const quoteViewButtons = document.querySelectorAll(".investment-quote-view-btn");

    function openQuoteModal() {
        if (!quoteModalOverlay) return;
        quoteModalOverlay.classList.remove("d-none");
        document.body.classList.add("quote-modal-open");
    }

    function closeQuoteModal() {
        if (!quoteModalOverlay) return;
        quoteModalOverlay.classList.add("d-none");
        document.body.classList.remove("quote-modal-open");
    }

    async function fetchSavedQuoteDetails(quoteId) {
        const contextPath = window.location.pathname.split("/client/")[0] || "";
        const url = `${contextPath}/client/investment/quotes/${quoteId}/details`;

        const response = await fetch(url, {
            method: "GET",
            headers: {
                "X-Requested-With": "XMLHttpRequest",
                "Accept": "application/json"
            }
        });

        const rawText = await response.text();

        let data;
        try {
            data = JSON.parse(rawText);
        } catch (e) {
            throw new Error("Server did not return JSON. Response starts with: " + rawText.substring(0, 120));
        }

        if (!response.ok || !data.success) {
            throw new Error(data.message || "Unable to load saved quote details.");
        }

        return data;
    }

    quoteViewButtons.forEach(button => {
        button.addEventListener("click", async function () {
            const quoteId = this.getAttribute("data-quote-id");
            if (!quoteId) return;

            try {
                this.disabled = true;
                this.textContent = "Loading...";

                const data = await fetchSavedQuoteDetails(quoteId);
                modalQuoteData = data;

                resetModalTabsToDefault();
                updateModalResultCard("oneYear");
                openQuoteModal();

            } catch (error) {
                alert(error.message || "Unable to load saved quote details.");
            } finally {
                this.disabled = false;
                this.textContent = "View";
            }
        });
    });

    if (closeQuoteModalBtn) {
        closeQuoteModalBtn.addEventListener("click", function () {
            closeQuoteModal();
        });
    }

    if (closeQuoteModalFooterBtn) {
        closeQuoteModalFooterBtn.addEventListener("click", function () {
            closeQuoteModal();
        });
    }

    if (quoteModalOverlay) {
        quoteModalOverlay.addEventListener("click", function (event) {
            if (event.target === quoteModalOverlay) {
                closeQuoteModal();
            }
        });
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeQuoteModal();
        }
    });
});

/* ============================================= */
/* SAVE QUOTE FORM SYNC                          */
/* Note: This function keeps the Save Quote hidden inputs synced with the latest AJAX calculation request values. */
/* ============================================= */
function syncSaveQuoteFormValues(payload) {
    const savePlanType = document.getElementById("saveQuotePlanType");
    const saveInitialLumpSum = document.getElementById("saveQuoteInitialLumpSum");
    const saveMonthlyInvestment = document.getElementById("saveQuoteMonthlyInvestment");

    if (savePlanType) {
        savePlanType.value = payload.planType || "";
    }

    if (saveInitialLumpSum) {
        saveInitialLumpSum.value = payload.initialLumpSum ?? 0;
    }

    if (saveMonthlyInvestment) {
        saveMonthlyInvestment.value = payload.monthlyInvestment ?? 0;
    }
}

/* ============================================= */
/* INLINE MESSAGE INITIALIZER                    */
/* Note: This function keeps support for any JSP-rendered shared messages that still need auto-hide behavior. */
/* ============================================= */
function initializeInlineMessagesAutoHide() {
    if (typeof autoHideRenderedInlineMessages === "function") {
        autoHideRenderedInlineMessages(3000);
    }
}