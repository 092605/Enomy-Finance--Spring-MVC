document.addEventListener("DOMContentLoaded", function () {
    const dropdown = document.getElementById("investmentPlanDropdown");
    if (!dropdown) return;

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

        titleEl.textContent = plan.title;
        maxInvestmentEl.textContent = plan.maximumInvestmentPerYear;
        minMonthlyEl.textContent = plan.minimumMonthlyInvestment;
        minLumpSumEl.textContent = plan.minimumInitialInvestmentLumpSum;
        returnsEl.textContent = plan.predictedReturnsPerYear;
        taxEl.textContent = plan.estimatedTax;
        feesEl.textContent = plan.groupFeesPerMonth;
    }

    toggle.addEventListener("click", function () {
        menu.classList.toggle("show");
    });

    items.forEach(item => {
        item.addEventListener("click", function () {
            const selectedPlan = item.getAttribute("data-value");

            items.forEach(i => i.classList.remove("active"));
            item.classList.add("active");

            selectedValue.textContent = item.textContent.trim();
            hiddenInput.value = selectedPlan;

            updatePlanDetails(selectedPlan);

            menu.classList.remove("show");
        });
    });

    document.addEventListener("click", function (e) {
        if (!dropdown.contains(e.target)) {
            menu.classList.remove("show");
        }
    });

    if (hiddenInput.value) {
        updatePlanDetails(hiddenInput.value);
    }
	

});



/* ================================================= */
/* Investment Calculator Error message timeout       */
/* ================================================= */

setTimeout(() => {
    const alert = document.querySelector(".alert");
    if (alert) {
        alert.classList.remove("show");
        alert.classList.add("fade");

        setTimeout(() => alert.remove(), 300); // remove after animation
    }
}, 5000);



/* ================================================= */
/* Switch for 1yr | 5yrs | 10yrs                     */
/* ================================================= */

    function formatMoney(value) {
        return "£" + Number(value).toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

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

        document.getElementById("resultPlanTitle").textContent =
            getResultPlanDisplayName(planType);

        document.getElementById("resultInitialLumpSum").textContent =
            formatMoney(store.dataset[prefix + "Initial"]);

        document.getElementById("resultMonthlyInvestment").textContent =
            formatMoney(store.dataset[prefix + "Monthly"]);

        document.getElementById("resultTotalInvested").textContent =
            formatMoney(store.dataset[prefix + "Total"]);

        document.getElementById("resultMinReturn").textContent =
            formatMoney(store.dataset[prefix + "MinReturn"]);

        document.getElementById("resultMaxReturn").textContent =
            formatMoney(store.dataset[prefix + "MaxReturn"]);

        document.getElementById("resultMinProfit").textContent =
            formatMoney(store.dataset[prefix + "MinProfit"]);

        document.getElementById("resultMaxProfit").textContent =
            formatMoney(store.dataset[prefix + "MaxProfit"]);

        document.getElementById("resultMinTax").textContent =
            formatMoney(store.dataset[prefix + "MinTax"]);

        document.getElementById("resultMaxTax").textContent =
            formatMoney(store.dataset[prefix + "MaxTax"]);

        document.getElementById("resultMonthlyFee").textContent =
            formatMoney(store.dataset[prefix + "MonthlyFee"]);

        document.getElementById("resultTotalFee").textContent =
            formatMoney(store.dataset[prefix + "TotalFee"]);
    }

    document.addEventListener("DOMContentLoaded", function () {
        const tabButtons = document.querySelectorAll(".result-tab-btn");

        tabButtons.forEach(button => {
            button.addEventListener("click", function () {
                tabButtons.forEach(btn => btn.classList.remove("active"));
                this.classList.add("active");

                const yearKey = this.getAttribute("data-year");
                updateResultCard(yearKey);
            });
        });

        updateResultCard("oneYear");
    });

	
	