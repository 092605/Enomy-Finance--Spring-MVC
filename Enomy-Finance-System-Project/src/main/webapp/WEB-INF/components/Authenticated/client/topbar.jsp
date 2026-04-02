<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="topbarDisplayName" value="${not empty user.fullName ? user.fullName : fullName}" />
<c:set var="topbarInitial" value="${not empty topbarDisplayName ? fn:substring(topbarDisplayName, 0, 1) : 'C'}" />

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
            <div class="user-avatar" id="topbarProfileAvatar">
                <img
                    id="topbarProfileImage"
                    src="${empty user.profileImagePath ? '' : user.profileImagePath}"
                    alt="Profile"
                    class="${empty user.profileImagePath ? 'd-none' : ''}"
                />
                <span
                    id="topbarProfileInitial"
                    class="${empty user.profileImagePath ? '' : 'd-none'}">${topbarInitial}</span>
            </div>

            <div class="user-meta">
                <span class="user-name" id="topbarUserName">${topbarDisplayName}</span>
                <small class="Account-Type">Client Account</small>
            </div>
        </div>

    </div>

</header>