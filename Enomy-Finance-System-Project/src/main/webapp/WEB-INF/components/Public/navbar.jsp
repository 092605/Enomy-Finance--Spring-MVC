<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="navbarDisplayName" value="${not empty navbarFullName ? navbarFullName : 'Client'}" />
<c:set var="navbarInitial" value="${not empty navbarDisplayName ? fn:substring(navbarDisplayName, 0, 1) : 'C'}" />
<c:set var="navbarAvatarSrc"
       value="${empty navbarProfileImagePath
               ? pageContext.request.contextPath.concat('/resources/images/avatars/default-avatar.png')
               : pageContext.request.contextPath.concat(navbarProfileImagePath)}" />

<nav class="navbar navbar-expand-lg mt-3">
    <div class="container navbar-glass px-4 py-3">

        <a class="navbar-brand brand-glow"
           href="${pageContext.request.contextPath}/">
            Enomy Finance
        </a>

        <button class="navbar-toggler custom-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#landingNavbar"
                aria-controls="landingNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="landingNavbar">
            <ul class="navbar-nav align-items-lg-center gap-lg-3">

                <li class="nav-item">
                    <a class="nav-link nav-link-glass ${activePage == 'home' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/">
                        Home
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-glass ${activePage == 'about' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/about">
                        About
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-glass ${activePage == 'landing-converter' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/landing-converter">
                        Currency Converter
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-glass ${activePage == 'landing-investment' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/landing-investment">
                        Savings and Investment
                    </a>
                </li>

                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <li class="nav-item dropdown ms-lg-2 account-dropdown">
                            <a class="logged-user-trigger"
                               href="#"
                               role="button"
                               data-bs-toggle="dropdown"
                               aria-expanded="false">

								<div class="logged-user-avatar" id="navbarProfileAvatar">
								    <img
								        id="navbarProfileImage"
								        src="${navbarAvatarSrc}"
								        alt="User Avatar"
								        class="${empty navbarProfileImagePath ? 'd-none' : ''}" />
								
								    <span
								        id="navbarProfileInitial"
								        class="${empty navbarProfileImagePath ? '' : 'd-none'}">${navbarInitial}</span>
								</div>

                                <div class="logged-user-meta">
                                    <span class="logged-user-name">${navbarFullName}</span>
                                    <span class="logged-user-role">
                                        <c:choose>
                                            <c:when test="${navbarRole eq 'CLIENT'}">Client Account</c:when>
                                            <c:when test="${navbarRole eq 'ADMIN'}">Admin Account</c:when>
                                            <c:otherwise>User Account</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end account-menu profile-menu">
                                <c:choose>
                                    <c:when test="${navbarRole eq 'CLIENT'}">
                                        <li>
                                            <a class="dropdown-item account-item"
                                               href="${pageContext.request.contextPath}/client/dashboard">
                                                Go to Dashboard
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item account-item"
                                               href="${pageContext.request.contextPath}/client/currency-converter/home">
                                                Convert Currency
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item account-item"
                                               href="${pageContext.request.contextPath}/client/investment">
                                                Investment Plan
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item account-item"
                                               href="${pageContext.request.contextPath}/client/profile">
                                                Profile
                                            </a>
                                        </li>
                                    </c:when>

                                    <c:when test="${navbarRole eq 'ADMIN'}">
                                        <li>
                                            <a class="dropdown-item account-item"
                                               href="${pageContext.request.contextPath}/admin/dashboard">
                                                Go to Dashboard
                                            </a>
                                        </li>
                                    </c:when>
                                </c:choose>

                                <li><hr class="dropdown-divider"></li>

                                <li>
                                    <a class="dropdown-item account-item"
                                       href="${pageContext.request.contextPath}/logout">
                                        Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <li class="nav-item dropdown ms-lg-2 account-dropdown">
                            <a class="btn btn-glow account-dropdown-toggle"
                               href="#"
                               role="button"
                               data-bs-toggle="dropdown"
                               aria-expanded="false">
                                Account
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end account-menu">
                                <li>
                                    <a class="dropdown-item account-item"
                                       href="${pageContext.request.contextPath}/login">
                                        Login
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item account-item"
                                       href="${pageContext.request.contextPath}/signup">
                                        Sign Up
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>

            </ul>
        </div>
    </div>
</nav>