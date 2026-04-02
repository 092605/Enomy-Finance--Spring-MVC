let lastScroll = 0;
const navbar = document.querySelector(".navbar");

window.addEventListener("scroll", () => {

    const currentScroll = window.pageYOffset;

    if (currentScroll <= 0) {
        navbar.classList.remove("navbar-hide");
        return;
    }

    if (currentScroll > lastScroll) {
        navbar.classList.add("navbar-hide");
    } else {
        navbar.classList.remove("navbar-hide");
    }

    lastScroll = currentScroll;

});




/* ===================================== */
/* ACCOUNT DROPDOWN ARROW BEHAVIOUR      */
/* ===================================== */

document.addEventListener("DOMContentLoaded", function () {

    const accountDropdown = document.querySelector(".account-dropdown");
    const accountBtn = document.querySelector(".account-dropdown-toggle");
    const accountMenu = document.querySelector(".account-menu");

    if (!accountDropdown || !accountBtn || !accountMenu) return;

    accountDropdown.addEventListener("show.bs.dropdown", function () {
        accountBtn.classList.add("arrow-up");

        accountMenu.classList.remove("dropdown-animate-out");

        requestAnimationFrame(() => {
            accountMenu.classList.add("dropdown-animate-in");
        });
    });

    accountDropdown.addEventListener("hide.bs.dropdown", function () {
        accountBtn.classList.remove("arrow-up");

        accountMenu.classList.remove("dropdown-animate-in");
        accountMenu.classList.add("dropdown-animate-out");
    });

});