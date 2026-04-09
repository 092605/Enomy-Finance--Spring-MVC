document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("appSidebar");
    const sidebarToggle = document.getElementById("sidebarToggle");
    const mobileMenuToggle = document.getElementById("mobileMenuToggle");
    const dashboardMain = document.getElementById("dashboardMain");

    if (!sidebar || !dashboardMain) {
        return;
    }

    // Edge arrow toggle (desktop + mobile)
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", function () {
            if (window.innerWidth <= 991.98) {
                sidebar.classList.toggle("mobile-open");
            } else {
                sidebar.classList.toggle("collapsed");
                dashboardMain.classList.toggle("expanded");
            }
        });
    }

    // Topbar mobile menu button
    if (mobileMenuToggle) {
        mobileMenuToggle.addEventListener("click", function () {
            if (window.innerWidth <= 991.98) {
                sidebar.classList.toggle("mobile-open");
            }
        });
    }
});


/* ================================================= */
/* Dropdown Behaviour                                */
/* Related purpose:                                  */
/* - Used by dashboard dropdowns                     */
/* - Updated to work properly for Currency Rates     */
/*   check card hidden inputs                        */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    setupCustomDropdowns();
});

function setupCustomDropdowns() {
    const dropdowns = document.querySelectorAll(".custom-dropdown");

    if (!dropdowns.length) return;

    dropdowns.forEach(dropdown => {
        const toggle = dropdown.querySelector(".custom-dropdown-toggle");
        const selectedValue = dropdown.querySelector(".selected-value");
        const items = dropdown.querySelectorAll(".custom-dropdown-item");
        const hiddenInput = dropdown.querySelector("input[type='hidden']");

        if (!toggle || !selectedValue || !items.length) return;

        // Open / close current dropdown
        toggle.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            dropdowns.forEach(otherDropdown => {
                if (otherDropdown !== dropdown) {
                    otherDropdown.classList.remove("active");
                }
            });

            dropdown.classList.toggle("active");
        });

        // Select item
        items.forEach(item => {
            item.addEventListener("click", function (e) {
                e.preventDefault();
                e.stopPropagation();

                const itemText = this.textContent.trim();
                const rawValue = this.getAttribute("data-value");

                items.forEach(i => i.classList.remove("active"));
                this.classList.add("active");

                selectedValue.textContent = itemText;

                if (hiddenInput) {
                    if (rawValue !== null) {
                        hiddenInput.value = rawValue;
                    } else {
                        hiddenInput.value = itemText.toLowerCase() === "all" ? "" : itemText;
                    }

                    // Related purpose:
                    // trigger change so dashboard currency-rate logic can react if needed later
                    hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
                }

                dropdown.classList.remove("active");
            });
        });

        // Related purpose:
        // if hidden input already has value from server/rendering,
        // sync selected text on load
        if (hiddenInput && hiddenInput.value) {
            const matchedItem = Array.from(items).find(item => {
                return item.getAttribute("data-value") === hiddenInput.value;
            });

            if (matchedItem) {
                items.forEach(i => i.classList.remove("active"));
                matchedItem.classList.add("active");
                selectedValue.textContent = matchedItem.textContent.trim();
            }
        }
    });

    // Close all dropdowns when clicking outside
    document.addEventListener("click", function () {
        document.querySelectorAll(".custom-dropdown").forEach(dropdown => {
            dropdown.classList.remove("active");
        });
    });
}


/* ================================================= */
/* Investment Plan Widget                            */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    const planTabs = document.querySelectorAll(".plan-tab");
    const planTitle = document.querySelector(".plan-title");
    const usePlanBtn = document.querySelector(".use-plan-btn");

    const detailFields = {
        maxInvestment: document.querySelector('[data-field="maxInvestment"]'),
        minMonthly: document.querySelector('[data-field="minMonthly"]'),
        minLumpSum: document.querySelector('[data-field="minLumpSum"]'),
        returns: document.querySelector('[data-field="returns"]'),
        tax: document.querySelector('[data-field="tax"]'),
        fees: document.querySelector('[data-field="fees"]')
    };

    // Exit safely if investment widget is not present
    if (!planTabs.length || !planTitle || !usePlanBtn ||
        !detailFields.maxInvestment || !detailFields.minMonthly ||
        !detailFields.minLumpSum || !detailFields.returns ||
        !detailFields.tax || !detailFields.fees) {
        return;
    }

    const plans = {
        1: {
            title: "Option 1 – Basic Savings Plan",
            maxInvestment: "£20 000",
            minMonthly: "£50",
            minLumpSum: "N/A",
            returns: "1.2% to 2.4%",
            tax: "0%",
            fees: "0.25%"
        },
        2: {
            title: "Option 2 – Savings Plan Plus",
            maxInvestment: "£30 000",
            minMonthly: "£50",
            minLumpSum: "£300",
            returns: "3% to 5.5%",
            tax: "10% on profits above £12 000",
            fees: "0.3%"
        },
        3: {
            title: "Option 3 – Managed Stock Investments",
            maxInvestment: "Unlimited",
            minMonthly: "£150",
            minLumpSum: "£1000",
            returns: "4% to 23%",
            tax: "10% on profits above £12 000; 20% on profits above £40 000",
            fees: "1.3%"
        }
    };

    let selectedPlanId = "1";

    function updatePlan(planId) {
        const selectedPlan = plans[planId];
        if (!selectedPlan) return;

        selectedPlanId = planId;

        planTitle.textContent = selectedPlan.title;
        detailFields.maxInvestment.textContent = selectedPlan.maxInvestment;
        detailFields.minMonthly.textContent = selectedPlan.minMonthly;
        detailFields.minLumpSum.textContent = selectedPlan.minLumpSum;
        detailFields.returns.textContent = selectedPlan.returns;
        detailFields.tax.textContent = selectedPlan.tax;
        detailFields.fees.textContent = selectedPlan.fees;

        planTabs.forEach(tab => tab.classList.remove("active"));

        const activeTab = document.querySelector('.plan-tab[data-plan-id="' + planId + '"]');
        if (activeTab) {
            activeTab.classList.add("active");
        }
    }

    planTabs.forEach(tab => {
        tab.addEventListener("click", function () {
            const planId = this.getAttribute("data-plan-id");
            updatePlan(planId);
        });
    });

    usePlanBtn.addEventListener("click", function () {
        // temporary UI-only behavior
        // later replace this with your real investment page route
        window.location.href = "/Enomy-Finance-System-Project/client/investment?planId=" + selectedPlanId;
    });

    updatePlan("1");
});


/* ================================================= */
/* Dashboard Currency Rates - Check Rate Logic       */
/* Related purpose:                                  */
/* - Reuse the dashboard Currency Rates card         */
/* - Keep client-currency.js unchanged               */
/* - Works only for dashboard card elements          */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    setupDashboardCheckRateCard();
});

function setupDashboardCheckRateCard() {
    const checkRateBtn = document.getElementById("checkRateBtn");
    const baseCurrencyInput = document.getElementById("checkRateBaseCurrency");
    const targetCurrencyInput = document.getElementById("checkRateTargetCurrency");
    const resultValue = document.getElementById("checkRateResultValue");
    const rateDateEl = document.getElementById("checkRateRateDate");
    const fetchedAtEl = document.getElementById("checkRateFetchedAt");
    const errorBox = document.getElementById("checkRateError");

    // Exit safely if dashboard card is not present
    if (!checkRateBtn || !baseCurrencyInput || !targetCurrencyInput || !resultValue || !rateDateEl || !fetchedAtEl) {
        return;
    }

    checkRateBtn.addEventListener("click", function () {
        const baseCurrency = (baseCurrencyInput.value || "").trim();
        const targetCurrency = (targetCurrencyInput.value || "").trim();

        clearDashboardCheckRateError(errorBox);

        if (!baseCurrency || !targetCurrency) {
            resultValue.textContent = "Please select both currencies.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            showDashboardCheckRateError(errorBox, "Please select both base and target currencies.");
            return;
        }

        if (baseCurrency === targetCurrency) {
            resultValue.innerHTML = "1 " + baseCurrency + " = <strong>1.0000</strong> " + targetCurrency;
            rateDateEl.textContent = "Today";
            fetchedAtEl.textContent = new Date().toLocaleString();
            return;
        }

        resultValue.textContent = "Checking latest rate...";
        rateDateEl.textContent = "Loading...";
        fetchedAtEl.textContent = "Loading...";

        fetch(window.CONTEXT_PATH + "/client/currency-converter/check-rate-ajax", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body:
                "baseCurrency=" + encodeURIComponent(baseCurrency) +
                "&targetCurrency=" + encodeURIComponent(targetCurrency)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Failed to retrieve rate.");
            }
            return response.json();
        })
        .then(data => {
            resultValue.innerHTML =
                "1 " + data.baseCurrency + " = <strong>" +
                Number(data.convertedAmount).toFixed(4) +
                "</strong> " + data.targetCurrency;

            rateDateEl.textContent = data.rateDate ? data.rateDate : "Not available";
            fetchedAtEl.textContent = new Date().toLocaleString();
        })
        .catch(error => {
            resultValue.textContent = "Unable to retrieve rate.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            showDashboardCheckRateError(errorBox, "Unable to retrieve rate. Please try again.");
            console.error("Dashboard check-rate error:", error);
        });
    });
}

function showDashboardCheckRateError(errorBox, message) {
    if (!errorBox) return;
    errorBox.textContent = message;
    errorBox.style.display = "block";
}

function clearDashboardCheckRateError(errorBox) {
    if (!errorBox) return;
    errorBox.textContent = "";
    errorBox.style.display = "none";
}