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