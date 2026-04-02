/* ================================================= */
/* CLIENT INVESTMENT PAGE SCRIPT                     */
/* Note:
   - Existing dropdown/result hooks are preserved
   - Added:
   - same-page section switching
   - AJAX saved quote modal result card
   - modal 1yr / 5yrs / 10yrs tab switching
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    /* ============================================= */
    /* INVESTMENT PLAN DROPDOWN + PLAN DETAILS       */
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
    /* AUTO HIDE ALERTS                              */
    /* ============================================= */
    setTimeout(() => {
        const alerts = document.querySelectorAll(".alert");
        alerts.forEach(alert => {
            alert.classList.remove("show");
            alert.classList.add("fade");

            setTimeout(() => {
                if (alert && alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        });
    }, 5000);

    /* ============================================= */
    /* SHARED MONEY FORMATTER                        */
    /* ============================================= */
    function formatMoney(value) {
        return "£" + Number(value || 0).toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    /* ============================================= */
    /* MAIN RESULT CARD TAB SWITCHING                */
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
    /* SAME-PAGE SECTION SWITCHING                   */
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