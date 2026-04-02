console.log("currency-converter.js loaded");

document.addEventListener("DOMContentLoaded", function () {
    setupCheckRateMessageTimer();
    setupTransactionTypeNavSync();
    setupCheckRateAjax();
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




//CHECK RATE BUTTON- Wlcm


document.addEventListener("DOMContentLoaded", function () {
    const checkRateBtn = document.getElementById("checkRateBtn");
    const baseCurrencyInput = document.getElementById("checkRateBaseCurrency");
    const targetCurrencyInput = document.getElementById("checkRateTargetCurrency");
    const resultValue = document.getElementById("checkRateResultValue");
    const rateDateEl = document.getElementById("checkRateRateDate");
    const fetchedAtEl = document.getElementById("checkRateFetchedAt");

    if (!checkRateBtn || !baseCurrencyInput || !targetCurrencyInput || !resultValue || !rateDateEl || !fetchedAtEl) {
        return;
    }

    checkRateBtn.addEventListener("click", function () {
        const baseCurrency = baseCurrencyInput.value;
        const targetCurrency = targetCurrencyInput.value;

        if (!baseCurrency || !targetCurrency) {
            resultValue.textContent = "Please select both currencies.";
            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            return;
        }

        if (baseCurrency === targetCurrency) {
            resultValue.innerHTML = "1 " + baseCurrency + " = <strong>1.00</strong> " + targetCurrency;
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
            body: "baseCurrency=" + encodeURIComponent(baseCurrency) +
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
            console.error(error);
        });
    });
});