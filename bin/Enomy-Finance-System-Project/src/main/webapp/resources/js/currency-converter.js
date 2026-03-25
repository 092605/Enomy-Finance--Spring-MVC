document.addEventListener("DOMContentLoaded", function () {
    setupCheckRateMessageTimer();
    setupTransactionTypeNavSync();
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