<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="app-topbar">

    <div class="topbar-left">
        <div class="topbar-search card-glass">
            <span class="search-icon">⌕</span>
            <input type="text" placeholder="Search dashboard..." aria-label="Search dashboard">
        </div>
    </div>

    <div class="topbar-right">
        <button type="button" class="topbar-icon-btn card-glass" aria-label="Notifications">
            🔔
        </button>

        <div class="topbar-user card-glass">
            <div class="user-avatar">A</div>
            <div class="user-meta">
                <span class="user-name">${pageContext.request.userPrincipal.name}</span>
                <small class="text-muted">Client Account</small>
            </div>
        </div>
    </div>

</header>