<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="app-topbar">

    <!-- Mobile Menu Toggle -->
    <div class="topbar-mobile-toggle-wrap">
        <button type="button"
                class="mobile-menu-btn card-glass"
                id="mobileMenuToggle"
                aria-label="Open menu">
            ☰
        </button>
    </div>

    <!-- Search -->
    <div class="topbar-left">
        <div class="topbar-search card-glass">
            <span class="search-icon">⌕</span>
            <input type="text"
                   placeholder="Search dashboard..."
                   aria-label="Search dashboard">
        </div>
    </div>

    <!-- Right Side -->
    <div class="topbar-right">

        <!-- Notification -->
        <button type="button"
                class="topbar-icon-btn card-glass"
                aria-label="Notifications">
            🔔
        </button>

        <!-- User -->
        <div class="topbar-user card-glass">
            <div class="user-avatar">
			    ${user.fullName.substring(0,1)}
			</div>
            <div class="user-meta">
                <span class="user-name">${user.fullName}</span>
                <small class="text-muted">Client Account</small>
            </div>
        </div>

    </div>

</header>