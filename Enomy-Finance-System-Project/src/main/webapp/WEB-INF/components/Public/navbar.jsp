<nav class="navbar navbar-expand-lg mt-3">
    <div class="container navbar-glass px-4 py-3">

        <!-- Brand -->
        <a class="navbar-brand brand-glow" href="${pageContext.request.contextPath}/">Enomy Finance</a>

        <!-- Mobile toggle -->
        <button class="navbar-toggler custom-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#landingNavbar">
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

                <!-- ACCOUNT BUTTON -->
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
                               href="${pageContext.request.contextPath}/login">Login</a>
                        </li>
                        <li>
                            <a class="dropdown-item account-item"
                               href="${pageContext.request.contextPath}/signup">Sign Up</a>
                        </li>
                    </ul>
                </li>

            </ul>

        </div>
    </div>
</nav>