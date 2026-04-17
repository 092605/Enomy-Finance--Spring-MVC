/* ================================================= */
/* Dropdown Behaviour                                */
/* Related purpose:                                  */
/* - Used by dashboard dropdowns                     */
/* - Updated to work properly for dashboard cards    */
/*   with hidden inputs                              */
/* ================================================= */

function initComponents() {
    setupCustomDropdowns();
}

document.addEventListener("DOMContentLoaded", initComponents);

function setupCustomDropdowns() {
    const dropdowns = document.querySelectorAll(".custom-dropdown");

    if (!dropdowns.length) return;

    dropdowns.forEach(dropdown => {

        // ✅ prevent duplicate binding
        if (dropdown.dataset.initialized === "true") return;
        dropdown.dataset.initialized = "true";

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
                    hiddenInput.value = rawValue !== null
                        ? rawValue
                        : (itemText.toLowerCase() === "all" ? "" : itemText);

                    hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
                }

                dropdown.classList.remove("active");
            });
        });

        // restore state
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

    // ✅ global click (already safe)
    if (!window._customDropdownGlobalListener) {
        document.addEventListener("click", function () {
            document.querySelectorAll(".custom-dropdown").forEach(dropdown => {
                dropdown.classList.remove("active");
            });
        });

        window._customDropdownGlobalListener = true;
    }
}