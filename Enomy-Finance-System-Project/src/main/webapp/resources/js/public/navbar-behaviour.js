let lastScroll = 0;

document.addEventListener("DOMContentLoaded", function () {
    setupNavbarHideOnScroll();
    setupAccountDropdownArrowBehaviour();
});

function setupNavbarHideOnScroll() {
    const navbar = document.querySelector(".navbar");
    if (!navbar) return;

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
}

function setupAccountDropdownArrowBehaviour() {
    const accountDropdown = document.querySelector(".account-dropdown");
    const accountBtn = document.querySelector(".account-dropdown-toggle, .logged-user-trigger");
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
}