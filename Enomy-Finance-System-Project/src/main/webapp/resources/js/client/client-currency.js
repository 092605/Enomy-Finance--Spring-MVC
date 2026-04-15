console.log("currency-converter.js loaded");

document.addEventListener("DOMContentLoaded", function () {
    setupCheckRateMessageTimer();
    setupTransactionTypeNavSync();
    setupCheckRateAjax();
    setupConfirmButtonLoadingState();
});

function setupCheckRateMessageTimer() {
    const messageBox = document.getElementById("checkRateMessage");
    const timestampLabel = document.getElementById("checkRateTimestamp");

    if (messageBox) {
        if (timestampLabel) {
            const now = new Date();
            timestampLabel.textContent = now.toLocaleString();
        }

        setTimeout(() => {
            messageBox.style.transition = "opacity 0.5s ease";
            messageBox.style.opacity = "0";

            setTimeout(() => {
                messageBox.style.display = "none";
            }, 500);
        }, 5000);
    }
}

function setupTransactionTypeNavSync() {
    const transactionTypeSelect = document.getElementById("transactionTypeSelect");
    if (!transactionTypeSelect) return;

    transactionTypeSelect.addEventListener("change", function () {
        const value = this.value;

        if (value === "BUY") {
            highlightModuleNav("buy");
        } else if (value === "SELL") {
            highlightModuleNav("sell");
        }
    });
}

function highlightModuleNav(type) {
    const navLinks = document.querySelectorAll(".currency-module-nav-link");
    navLinks.forEach(link => link.classList.remove("active"));

    navLinks.forEach(link => {
        const text = link.textContent.trim().toLowerCase();
        if (type === "buy" && text.includes("buy")) {
            link.classList.add("active");
        }
        if (type === "sell" && text.includes("sell")) {
            link.classList.add("active");
        }
    });
}


/* ================================================= */
/* CHECK RATE AJAX - WELCOME CARD                    */
/* ================================================= */

let checkRateErrorTimer;
let checkRateHideTimer;

function setupCheckRateAjax() {
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

        clearCheckRateError(errorBox);

        if (!baseCurrency || !targetCurrency) {
            resultValue.textContent = "Please select both currencies.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            showCheckRateError(errorBox, "Please select both base and target currencies.");
            return;
        }

        if (baseCurrency === targetCurrency) {
            resultValue.textContent = "Invalid currency selection.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            showCheckRateError(errorBox, "Base and target currency must not be the same.");
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
            clearCheckRateError(errorBox);

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
            showCheckRateError(errorBox, "Unable to retrieve rate. Please try again.");
            console.error(error);
        });
    });
}

function showCheckRateError(errorBox, message) {
    if (!errorBox) return;

    clearTimeout(checkRateErrorTimer);
    clearTimeout(checkRateHideTimer);

    errorBox.textContent = message;
    errorBox.classList.remove("hide");
    errorBox.classList.add("show");

    checkRateErrorTimer = setTimeout(() => {
        clearCheckRateError(errorBox);
    }, 3000);
}

function clearCheckRateError(errorBox) {
    if (!errorBox) return;

    clearTimeout(checkRateHideTimer);

    errorBox.classList.remove("show");
    errorBox.classList.add("hide");

    checkRateHideTimer = setTimeout(() => {
        errorBox.textContent = "";
        errorBox.classList.remove("hide");
    }, 280);
}


/* ================================================= */
/* BUY NOW / SELL NOW BUTTON LOADING STATE           */
/* ================================================= */

function setupConfirmButtonLoadingState() {
    const confirmForms = document.querySelectorAll('form[action*="/client/currency-converter/confirm"]');

    if (!confirmForms.length) {
        return;
    }

    confirmForms.forEach(form => {
        form.addEventListener("submit", function () {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (!submitBtn) return;

            submitBtn.disabled = true;

            const currentText = submitBtn.textContent.trim().toLowerCase();

            if (currentText.includes("buy")) {
                submitBtn.textContent = "Processing Buy...";
            } else if (currentText.includes("sell")) {
                submitBtn.textContent = "Processing Sell...";
            } else {
                submitBtn.textContent = "Processing...";
            }
        });
    });
}





