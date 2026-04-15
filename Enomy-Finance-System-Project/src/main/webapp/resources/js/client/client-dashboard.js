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
/* - Updated to work properly for dashboard cards    */
/*   with hidden inputs                              */
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

                    hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
                }

                dropdown.classList.remove("active");
            });
        });

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

    if (!planTabs.length || !planTitle || !usePlanBtn ||
        !detailFields.maxInvestment || !detailFields.minMonthly ||
        !detailFields.minLumpSum || !detailFields.returns ||
        !detailFields.tax || !detailFields.fees) {
        return;
    }

    const plans = window.dashboardPlanDetails || {};

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
        detailFields.tax.innerHTML = selectedPlan.tax;
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
        const selectedPlan = plans[selectedPlanId];
        const planType = selectedPlan ? selectedPlan.planType : "BASIC_SAVINGS";
        window.location.href = window.CONTEXT_PATH + "/client/investment?planType=" + encodeURIComponent(planType);
    });

    updatePlan("1");
});


/* ================================================= */
/* Dashboard Currency Converter - Calculate Logic    */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    setupDashboardConverterCard();
});

let convertErrorTimer;
let convertSuccessTimer;

function setupDashboardConverterCard() {
    const convertBtn = document.getElementById("convertBtn");
    const baseCurrencyInput = document.getElementById("convertBaseCurrency");
    const targetCurrencyInput = document.getElementById("convertTargetCurrency");
    const amountInput = document.getElementById("convertAmountInput");
    const resultBox = document.getElementById("convertResultBox");
    const errorBox = document.getElementById("convertError");
    const successBox = document.getElementById("convertSuccess");

    if (!convertBtn || !baseCurrencyInput || !targetCurrencyInput || !amountInput || !resultBox) {
        return;
    }

    convertBtn.addEventListener("click", function () {
        const baseCurrency = (baseCurrencyInput.value || "").trim();
        const targetCurrency = (targetCurrencyInput.value || "").trim();
        const amountRaw = (amountInput.value || "").trim();
        const amount = parseFloat(amountRaw);

        clearDashboardConvertError(errorBox);
        clearDashboardConvertSuccess(successBox);

        if (!baseCurrency || !targetCurrency) {
            resultBox.textContent = "Please select both currencies.";
            showDashboardConvertError(errorBox, "Please select both base and target currencies.");
            return;
        }

        if (!amountRaw || isNaN(amount) || amount <= 0) {
            resultBox.textContent = "Please enter a valid amount.";
            showDashboardConvertError(errorBox, "Please enter a valid amount.");
            return;
        }

        if (baseCurrency === targetCurrency) {
            resultBox.textContent = "Invalid currency selection.";
            showDashboardConvertError(errorBox, "Base and target currency must not be the same.");
            return;
        }

        resultBox.textContent = "Calculating...";

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
                throw new Error("Failed to retrieve conversion rate.");
            }
            return response.json();
        })
        .then(data => {
            const rate = Number(data.convertedAmount);

            if (isNaN(rate) || rate <= 0) {
                resultBox.textContent = "Unable to calculate conversion.";
                showDashboardConvertError(errorBox, "Unable to calculate conversion. Please try again.");
                return;
            }

            const convertedAmount = amount * rate;

            resultBox.innerHTML =
                Number(amount).toFixed(2) + " " + data.baseCurrency +
                " = <strong>" + convertedAmount.toFixed(2) +
                "</strong> " + data.targetCurrency;

            showDashboardConvertSuccess(successBox, "Conversion successful.");
        })
        .catch(error => {
            resultBox.textContent = "Conversion failed. Please try again.";
            showDashboardConvertError(errorBox, "Conversion failed. Please try again.");
            console.error("Dashboard converter error:", error);
        });
    });
}

function showDashboardConvertError(errorBox, message) {
    if (!errorBox) return;

    errorBox.textContent = message;
    errorBox.classList.add("show");

    clearTimeout(convertErrorTimer);

    convertErrorTimer = setTimeout(() => {
        clearDashboardConvertError(errorBox);
    }, 3000);
}

function clearDashboardConvertError(errorBox) {
    if (!errorBox) return;

    errorBox.textContent = "";
    errorBox.classList.remove("show");
}

function showDashboardConvertSuccess(successBox, message) {
    if (!successBox) return;

    successBox.textContent = message;
    successBox.classList.add("show");

    clearTimeout(convertSuccessTimer);

    convertSuccessTimer = setTimeout(() => {
        clearDashboardConvertSuccess(successBox);
    }, 3000);
}

function clearDashboardConvertSuccess(successBox) {
    if (!successBox) return;

    successBox.textContent = "";
    successBox.classList.remove("show");
}


/* ================================================= */
/* Dashboard Currency Rates - Check Rate Logic       */
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {
    setupDashboardCheckRateCard();
});

let checkRateErrorTimer;

function setupDashboardCheckRateCard() {
    const checkRateBtn = document.getElementById("checkRateBtn");
    const baseCurrencyInput = document.getElementById("checkRateBaseCurrency");
    const targetCurrencyInput = document.getElementById("checkRateTargetCurrency");
    const resultValue = document.getElementById("checkRateResultValue");
    const rateDateEl = document.getElementById("checkRateRateDate");
    const fetchedAtEl = document.getElementById("checkRateFetchedAt");
    const errorBox = document.getElementById("checkRateError");

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
            resultValue.textContent = "Invalid currency selection.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            showDashboardCheckRateError(errorBox, "Base and target currency must not be the same.");
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
    errorBox.classList.add("show");

    clearTimeout(checkRateErrorTimer);

    checkRateErrorTimer = setTimeout(() => {
        clearDashboardCheckRateError(errorBox);
    }, 3000);
}

function clearDashboardCheckRateError(errorBox) {
    if (!errorBox) return;

    errorBox.textContent = "";
    errorBox.classList.remove("show");
}