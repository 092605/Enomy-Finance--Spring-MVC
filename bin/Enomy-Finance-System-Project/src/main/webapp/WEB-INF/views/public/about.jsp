<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/about.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
</head>
<body>

    <!-- NAVBAR -->
    <jsp:include page="/WEB-INF/components/navbar.jsp"/>

    <!-- ABOUT HERO -->
    <section class="about-page-hero section">
        <div class="container">
            <div class="row align-items-center g-5">

                <div class="col-lg-6">
                    <div class="about-page-content">
                        <span class="about-badge">About Enomy Finance</span>
                        <h1 class="about-page-title">Helping Users Build Smarter Financial Habits</h1>
                        <p class="about-page-text">
                            Enomy Finance is a modern web-based financial planning platform designed
                            to help users convert currencies, plan savings, and estimate investment growth
                            using simple and practical digital tools.
                        </p>
                        <p class="about-page-text">
                            Our goal is to make financial planning easier to understand, more accessible,
                            and more useful for students, beginners, and everyday users who want better
                            control over their money decisions.
                        </p>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="about-page-image-wrap card-glass">
                        <img src="${pageContext.request.contextPath}/resources/images/AboutImage Main.png"
                             alt="About Enomy Finance"
                             class="img-fluid about-page-image">
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- MISSION VISION -->
    <section class="mission-vision-section section">
        <div class="text-center section-header">
            <h2 class="section-title">Mission &amp; Vision</h2>
            <p class="section-subtitle">
                Guiding users toward financial clarity, smarter habits, and a more secure financial future.
            </p>
        </div>

        <div class="container">
            <div class="row g-4">

                <div class="col-md-6">
                    <div class="info-card card-glow h-100">
                        <h3>Our Mission</h3>
                        <p>
                            To provide simple, reliable, and user-friendly financial tools that help people
                            make better decisions in currency conversion, savings planning, and investment forecasting.
                        </p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-card card-glow h-100">
                        <h3>Our Vision</h3>
                        <p>
                            To become a trusted digital financial companion for users who want a clearer,
                            smarter, and more confident approach to personal financial management.
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- WHAT WE OFFER -->
    <section class="about-offer-section section">
        <div class="container">

            <div class="text-center section-header">
                <h2 class="section-title">What Enomy Finance Offers</h2>
                <p class="section-subtitle">
                    Our platform is designed with practical financial features that support everyday planning.
                </p>
            </div>

            <div class="row g-4">

                <div class="col-md-6 col-lg-4">
                    <div class="offer-card card-glow h-100">
                        <div class="offer-icon">
                            <img src="${pageContext.request.contextPath}/resources/images/CurrencyConverter Logo.png"
                                 alt="Currency Converter Logo"
                                 class="img-fluid about-page-image">
                        </div>
                        <h4>Currency Converter</h4>
                        <p>
                            Convert between currencies quickly and view estimated exchange values in a simple interface.
                        </p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="offer-card card-glow h-100">
                        <div class="offer-icon">
                            <img src="${pageContext.request.contextPath}/resources/images/SavingsPlanner Logo.png"
                                 alt="Savings Planner Logo"
                                 class="img-fluid about-page-image">
                        </div>
                        <h4>Savings Planner</h4>
                        <p>
                            Plan your savings goals and calculate how much you need to save over time.
                        </p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="offer-card card-glow h-100">
                        <div class="offer-icon">
                            <img src="${pageContext.request.contextPath}/resources/images/InvestmentProjection Logo.png"
                                 alt="Investment Projection Logo"
                                 class="img-fluid about-page-image">
                        </div>
                        <h4>Investment Projection</h4>
                        <p>
                            Explore estimated investment growth and understand potential future returns.
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- WHY IT MATTERS -->
    <section class="about-why-section section">
        <div class="container">
            <div class="row align-items-center g-5">

                <div class="col-lg-6 order-2 order-lg-1">
                    <div>
                        <img src="${pageContext.request.contextPath}/resources/images/About WhyMatters.png"
                             alt="Why Enomy Finance Matters"
                             class="img-fluid about-why-image">
                    </div>
                </div>

                <div class="col-lg-6 order-1 order-lg-2">
                    <div class="about-why-content">
                        <h2 class="section-title">Why Enomy Finance Matters</h2>
                        <p class="section-subtitle left-subtitle">
                            Financial planning can feel confusing, especially for users who are just starting.
                            Enomy Finance simplifies the process by offering focused tools in one place.
                        </p>

                        <div class="why-points">
                            <div class="why-point">
                                <div class="why-check">✓</div>
                                <span>Simple and beginner-friendly financial tools</span>
                            </div>
                            <div class="why-point">
                                <div class="why-check">✓</div>
                                <span>Clean and modern user experience</span>
                            </div>
                            <div class="why-point">
                                <div class="why-check">✓</div>
                                <span>Supports practical financial decision-making</span>
                            </div>
                            <div class="why-point">
                                <div class="why-check">✓</div>
                                <span>Designed for accessibility and ease of use</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="about-cta-section section">
        <div class="container">
            <div class="about-cta-card card-glass text-center">
                <h2>Start Exploring Enomy Finance Today</h2>
                <p>
                    Discover smart tools for currency conversion, savings planning, and investment tracking.
                </p>
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/" class="btn-glow">Back to Home</a>
                    <a href="${pageContext.request.contextPath}/signup" class="btn-glow-outline">Create Account</a>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/components/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/navbar-behaviour.js"></script>
</body>
</html>