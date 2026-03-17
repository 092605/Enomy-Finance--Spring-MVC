<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="app-sidebar" id="appSidebar">

    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/client/dashboard" class="sidebar-brand">
            <span class="brand-icon">✦</span>
            <span class="brand-text">Enomy Finance</span>
        </a>

        <button type="button" class="sidebar-toggle-btn" id="sidebarToggle" aria-label="Toggle sidebar">
            ☰
        </button>
    </div>

    <nav class="sidebar-nav">
        <ul class="sidebar-menu">

            <li class="sidebar-item active">
                <a href="${pageContext.request.contextPath}/client/dashboard" class="sidebar-link">
                    <span class="sidebar-icon">⌂</span>
                    <span class="sidebar-label">Dashboard</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/client/currency" class="sidebar-link">
                    <span class="sidebar-icon">⇄</span>
                    <span class="sidebar-label">Currency Converter</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/client/investment" class="sidebar-link">
                    <span class="sidebar-icon">↗</span>
                    <span class="sidebar-label">Savings &amp; Investment</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/client/profile" class="sidebar-link">
                    <span class="sidebar-icon">◉</span>
                    <span class="sidebar-label">Profile</span>
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