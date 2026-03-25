<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="app-sidebar" id="appSidebar">

    <div class="sidebar-header">
        <a href="#" class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/resources/images/Enomy Finance Logo.png"
                 class="brand-logo"
                 alt="Enomy Finance Logo">

            <span class="brand-text">Enomy Finance</span>
        </a>
    </div>

    <button class="sidebar-edge-toggle" id="sidebarToggle">
        <span id="sidebarArrow">></span>
    </button>

    <nav class="sidebar-nav">
        <ul class="sidebar-menu">

            <li class="sidebar-item ${activePage == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span class="sidebar-icon">⌂</span>
                    <span class="sidebar-label">Dashboard</span>
                </a>
            </li>

            <li class="sidebar-item ${activePage == 'investment' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/investment" class="sidebar-link">
                    <span class="sidebar-icon">↗</span>
                    <span class="sidebar-label">Investment Rules</span>
                </a>
            </li>

            <li class="sidebar-item ${activePage == 'currency-converter' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/currency-converter" class="sidebar-link">
                    <span class="sidebar-icon">⇄</span>
                    <span class="sidebar-label">Currency Converter</span>
                </a>
            </li>

            <li class="sidebar-item ${activePage == 'transaction-history' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/transaction-history" class="sidebar-link">
                    <span class="sidebar-icon">☰</span>
                    <span class="sidebar-label">Transaction History</span>
                </a>
            </li>

        </ul>
    </nav>

    <div class="sidebar-footer">
        <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
            <button type="submit" class="btn-glow-outline sidebar-logout-btn">
                <span class="sidebar-icon">⇦</span>
                <span class="sidebar-label">Logout</span>
            </button>
        </form>
    </div>

</aside>