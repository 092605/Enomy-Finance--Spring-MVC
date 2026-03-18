
    document.addEventListener("DOMContentLoaded", function () {
        const dropdown = document.getElementById("investmentPlanDropdown");
        if (!dropdown) return;

        const toggle = dropdown.querySelector(".custom-dropdown-toggle");
        const menu = dropdown.querySelector(".custom-dropdown-menu");
        const selectedValue = dropdown.querySelector(".selected-value");
        const hiddenInput = document.getElementById("investmentPlanValue");
        const items = dropdown.querySelectorAll(".custom-dropdown-item");

        toggle.addEventListener("click", function () {
            menu.classList.toggle("show");
        });

        items.forEach(item => {
            item.addEventListener("click", function () {
                items.forEach(i => i.classList.remove("active"));
                item.classList.add("active");

                selectedValue.textContent = item.textContent;
                hiddenInput.value = item.getAttribute("data-value");

                menu.classList.remove("show");
            });
        });

        document.addEventListener("click", function (e) {
            if (!dropdown.contains(e.target)) {
                menu.classList.remove("show");
            }
        });
    });
