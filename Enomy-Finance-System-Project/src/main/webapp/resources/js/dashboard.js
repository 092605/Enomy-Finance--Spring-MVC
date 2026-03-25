document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("appSidebar");
    const sidebarToggle = document.getElementById("sidebarToggle");
    const mobileMenuToggle = document.getElementById("mobileMenuToggle");
    const dashboardMain = document.getElementById("dashboardMain");

	if (!sidebar || !dashboardMain) {
	    return;
	}

    // Edge arrow toggle (desktop + mobile)
    sidebarToggle.addEventListener("click", function () {
        if (window.innerWidth <= 991.98) {
            sidebar.classList.toggle("mobile-open");
        } else {
            sidebar.classList.toggle("collapsed");
            dashboardMain.classList.toggle("expanded");
        }
    });

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
/* ================================================= */

document.addEventListener("DOMContentLoaded", function () {

    const dropdowns = document.querySelectorAll(".custom-dropdown");

    dropdowns.forEach(dropdown => {
        const toggle = dropdown.querySelector(".custom-dropdown-toggle");
        const selectedValue = dropdown.querySelector(".selected-value");
        const items = dropdown.querySelectorAll(".custom-dropdown-item");
        const hiddenInput = dropdown.querySelector("input[type='hidden']");

        toggle.addEventListener("click", function (e) {
            e.stopPropagation();

            // close others
            dropdowns.forEach(d => {
                if (d !== dropdown) {
                    d.classList.remove("active");
                }
            });

            dropdown.classList.toggle("active");
        });

        items.forEach(item => {
            item.addEventListener("click", function () {
                items.forEach(i => i.classList.remove("active"));
                this.classList.add("active");

                selectedValue.textContent = this.textContent;

                if (hiddenInput) {
                    hiddenInput.value = this.getAttribute("data-value") || this.textContent.trim();
                }

                dropdown.classList.remove("active");
            });
        });
    });

    document.addEventListener("click", function () {
        dropdowns.forEach(d => d.classList.remove("active"));
    });

});



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
        document.querySelector('.plan-tab[data-plan-id="' + planId + '"]').classList.add("active");
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

