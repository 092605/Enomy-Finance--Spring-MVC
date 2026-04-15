console.log("landing-converter.js loaded");

document.addEventListener("DOMContentLoaded", function () {
    setupPublicCheckRateAjax();
});

function setupPublicCheckRateAjax() {
    const checkRateBtn = document.getElementById("checkRateBtn");
    const baseCurrencyInput = document.getElementById("checkRateBaseCurrency");
    const targetCurrencyInput = document.getElementById("checkRateTargetCurrency");
    const resultValue = document.getElementById("checkRateResultValue");
    const rateDateEl = document.getElementById("checkRateRateDate");
    const fetchedAtEl = document.getElementById("checkRateFetchedAt");
    const previewBox = document.querySelector(".currency-checkrate-preview-box");

    if (!checkRateBtn || !baseCurrencyInput || !targetCurrencyInput || !resultValue || !rateDateEl || !fetchedAtEl || !previewBox) {
        return;
    }

    checkRateBtn.addEventListener("click", function () {
        const baseCurrency = baseCurrencyInput.value.trim();
        const targetCurrency = targetCurrencyInput.value.trim();

        // Reset UI state
        resultValue.classList.remove("check-rate-error");
        previewBox.classList.remove("error");

        // Validation: empty
        if (!baseCurrency || !targetCurrency) {
            resultValue.textContent = "Please select both currencies.";
            resultValue.classList.add("check-rate-error");
            previewBox.classList.add("error");

            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            return;
        }

        // Validation: same currency
        if (baseCurrency === targetCurrency) {
            resultValue.innerHTML = "⚠ Base currency and target currency must be different.";
            resultValue.classList.add("check-rate-error");
            previewBox.classList.add("error");

            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";
            return;
        }

        // Loading state
        resultValue.innerHTML = `
            <span class="spinner-border spinner-border-sm"></span>
            Checking latest rate...
        `;
        rateDateEl.textContent = "Loading...";
        fetchedAtEl.textContent = "Loading...";

        fetch(window.CONTEXT_PATH + "/public/check-rate-ajax", {
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
            const convertedAmount = Number(data.convertedAmount);

            if (isNaN(convertedAmount)) {
                throw new Error("Invalid rate data received.");
            }

            resultValue.innerHTML =
                "1 " + data.baseCurrency + " = <strong>" +
                convertedAmount.toFixed(4) +
                "</strong> " + data.targetCurrency;

            rateDateEl.textContent = data.rateDate ? data.rateDate : "Not available";
            fetchedAtEl.textContent = new Date().toLocaleString();
        })
        .catch(error => {
            resultValue.textContent = "Unable to retrieve the latest rate right now.";
            resultValue.classList.add("check-rate-error");
            previewBox.classList.add("error");

            rateDateEl.textContent = "Not available";
            fetchedAtEl.textContent = "Not available";

            console.error("Public check rate error:", error);
        });
    });
}