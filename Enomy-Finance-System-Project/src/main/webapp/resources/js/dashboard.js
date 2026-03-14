document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("appSidebar");
    const sidebarToggle = document.getElementById("sidebarToggle");
    const dashboardMain = document.getElementById("dashboardMain");

    if (!sidebar || !sidebarToggle || !dashboardMain) {
        return;
    }

    sidebarToggle.addEventListener("click", function () {
        if (window.innerWidth <= 991.98) {
            sidebar.classList.toggle("mobile-open");
        } else {
            sidebar.classList.toggle("collapsed");
            dashboardMain.classList.toggle("expanded");
        }
    });
});