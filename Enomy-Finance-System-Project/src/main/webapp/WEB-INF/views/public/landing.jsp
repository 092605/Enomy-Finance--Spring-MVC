<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${contextPath}/resources/css/landing.css">
    <link rel="stylesheet" href="${contextPath}/resources/css/navbar.css">
    <link rel="stylesheet" href="${contextPath}/resources/css/footer.css">
</head>

<body>

    <!-- NAVBAR -->
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <!-- Wrapper Hero + About -->
    <div class="landing-flow-wrapper">

        <div class="flow-lottie-bg">
            <lottie-player
                src="${contextPath}/resources/animations/Technology-Network.json"
                background="transparent"
                speed="0.7"
                loop
                autoplay>
            </lottie-player>
        </div>

        <!-- HERO SECTION -->
        <section class="hero-section container py-5">

            <div class="row align-items-center">

                <!-- Left Content -->
                <div class="col-lg-6">

                    <h1 class="hero-title">
                        Smart Finance Tools for <br>
                        Currency and Savings
                    </h1>

                    <p class="hero-subtitle mt-3">
                        Convert currencies, plan investments, and track your
                        financial growth easily with Enomy Finance.
                    </p>

                    <div class="hero-buttons mt-4">
                        <a href="${contextPath}/landing-converter" class="btn btn-glow me-3">
                            Try Currency Converter
                        </a>

                        <a href="${contextPath}/login" class="btn btn-outline-light">
                            Sign Up
                        </a>
                    </div>

                </div>

                <!-- Right Image / Animation -->
                <div class="col-lg-6 hero-left">

                    <div class="hero-lottie-right">
                        <lottie-player
                            src="${contextPath}/resources/animations/Isometric-data-analysis.json"
                            background="transparent"
                            speed="0.7"
                            loop
                            autoplay>
                        </lottie-player>
                    </div>

                </div>

            </div>

        </section>

        <!-- ABOUT SECTION -->
        <section class="about-section container py-5" id="about">

            <div class="text-center mb-5">
                <h2 class="section-title">ABOUT ENOMY FINANCE</h2>
            </div>

            <div class="row align-items-center g-5">

                <!-- Left Side -->
                <div class="col-lg-6">
                    <div class="about-image-card">
                        <img src="${contextPath}/resources/images/enomy-finance-main.png"
                             alt="Enomy Finance Illustration"
                             class="about-image">
                    </div>
                </div>

                <!-- Right Side -->
                <div class="col-lg-6">

                    <p class="about-description">
                        Enomy Finance is a web-based financial planning system that helps users
                        convert currencies, plan savings, and estimate investment growth.
                        The platform provides simple tools for individuals who want to manage
                        their finances more effectively.
                    </p>

                    <div class="latest-articles mt-4">
                        <h5 class="mb-3">Latest Articles</h5>

                        <div class="article-card mb-3">
                            <div class="article-icon">📰</div>
                            <div class="article-content">
                                <h4>Understanding Currency Conversion</h4>
                                <p>Learn how exchange values affect your money.</p>
                            </div>
                        </div>

                        <div class="article-card mb-3">
                            <div class="article-icon">📈</div>
                            <div class="article-content">
                                <h4>Savings Planning Basics</h4>
                                <p>Plan your savings goals step by step.</p>
                            </div>
                        </div>

                        <div class="article-card">
                            <div class="article-icon">💡</div>
                            <div class="article-content">
                                <h4>Investment Growth Insights</h4>
                                <p>See how long-term financial growth works.</p>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </section>
    </div>

    <!-- FINANCIAL TOOLS SECTION -->
    <section class="financial-tools-section" id="tools">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="section-title">Our Financial Tools</h2>
                <p class="section-subtitle">
                    Explore our smart tools designed to help you manage your finances with ease.
                </p>
            </div>

            <div class="row g-4">

                <div class="col-md-6 col-lg-4">
                    <div class="tool-card">
                        <img src="${contextPath}/resources/images/Currency Converter.png" alt="Currency Converter">
                        <h4>Currency Converter</h4>
                        <p>
                            Convert currencies using real-time rates and quickly estimate exchange
                            values for different currencies.
                        </p>
                        <a href="#" class="tool-btn">Try Tool</a>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="tool-card">
                        <img src="${contextPath}/resources/images/Savings Planner.png" alt="Savings Planner">
                        <h4>Savings Planner</h4>
                        <p>
                            Calculate savings goals and create simple plans to help you stay on
                            track with your financial targets.
                        </p>
                        <a href="#" class="tool-btn">Try Tool</a>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="tool-card">
                        <img src="${contextPath}/resources/images/Investment Projection.png" alt="Investment Projection">
                        <h4>Investment Projection</h4>
                        <p>
                            See projected growth of your investments and understand possible returns
                            over time.
                        </p>
                        <a href="#" class="tool-btn">Try Tool</a>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- HOW IT WORKS SECTION -->
    <section class="how-it-works-section section" id="how-it-works">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="how-title">How It Works</h2>
                <p class="how-subtitle">
                    Enomy Finance makes financial planning simple with three easy steps.
                </p>
            </div>

            <div class="row align-items-center g-5">

                <!-- Left Side Steps -->
                <div class="col-lg-6">
                    <div class="steps-wrapper">

                        <div class="step-card">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h4>Convert Currency</h4>
                                <p>Instantly convert between currencies using reliable exchange values.</p>
                            </div>
                        </div>

                        <div class="step-card">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h4>Plan Savings</h4>
                                <p>Set financial goals and calculate savings to stay on track.</p>
                            </div>
                        </div>

                        <div class="step-card">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h4>Track Investments</h4>
                                <p>View projected growth and better understand your financial future.</p>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Right Side Animation -->
                <div class="col-lg-6 hero-left">
                    <div class="hero-lottie-right">
                        <lottie-player
                            src="${contextPath}/resources/animations/Marketing analytics.json"
                            background="transparent"
                            speed="0.7"
                            loop
                            autoplay>
                        </lottie-player>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- WHY CHOOSE ENOMY FINANCE SECTION -->
    <section class="why-choose-section section" id="why-choose">
        <div class="container">
            <div class="row align-items-center g-5">

                <!-- Left Side Animation -->
                <div class="col-lg-6 why-lottie">
                    <div class="why-lottie-gif">
                        <lottie-player
                            src="${contextPath}/resources/animations/check list.json"
                            background="transparent"
                            speed="0.7"
                            loop
                            autoplay>
                        </lottie-player>
                    </div>
                </div>

                <!-- Right Side Content -->
                <div class="col-lg-6">
                    <div class="why-content">
                        <h2 class="why-title">Why Choose Enomy Finance?</h2>
                        <p class="why-description">
                            Enomy Finance is designed to make financial management easier,
                            smarter, and more accessible for users who want practical tools
                            for everyday planning.
                        </p>

                        <div class="why-list">

                            <div class="why-item">
                                <div class="why-icon">✓</div>
                                <div class="why-text">
                                    <h5>Simple Financial Tools</h5>
                                    <p>Use easy-to-understand tools for currency conversion, savings planning, and investment projection.</p>
                                </div>
                            </div>

                            <div class="why-item">
                                <div class="why-icon">✓</div>
                                <div class="why-text">
                                    <h5>Accurate Calculations</h5>
                                    <p>Get reliable computed results that help support better financial decision-making.</p>
                                </div>
                            </div>

                            <div class="why-item">
                                <div class="why-icon">✓</div>
                                <div class="why-text">
                                    <h5>User-Friendly Experience</h5>
                                    <p>Navigate a clean and modern interface built for smooth interaction across devices.</p>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- START MANAGING SECTION -->
    <section class="start-managing-section section" id="start-managing">
        <div class="container">
            <div class="row align-items-center g-5">

                <!-- LEFT CONTENT -->
                <div class="col-lg-5">
                    <div class="start-content">
                        <span class="start-badge">Get Started</span>
                        <h2 class="start-title">Start Managing Your Finances Today</h2>
                        <p class="start-description">
                            Create a free account to save your conversion results, track your savings goals,
                            and monitor your investment growth with ease.
                        </p>

                        <div class="start-actions">
                            <a href="${contextPath}/signup" class="btn-glow">Create Free Account</a>
                        </div>
                    </div>
                </div>

                <!-- RIGHT FORM -->
                <div class="col-lg-7">
                    <div class="start-form-card card-glass">
                        <h3 class="form-title">Send Us a Message</h3>
                        <p class="form-subtitle">
                            Have questions about Enomy Finance? Fill out the form and we’ll get back to you.
                        </p>

                        <form class="start-form">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">Name</label>
                                    <input type="text" class="form-control custom-input" id="fullName" placeholder="Enter your name">
                                </div>

                                <div class="col-md-6">
                                    <label for="emailAddress" class="form-label">Email</label>
                                    <input type="email" class="form-control custom-input" id="emailAddress" placeholder="Enter your email">
                                </div>

                                <div class="col-12">
                                    <label for="subject" class="form-label">Subject</label>
                                    <input type="text" class="form-control custom-input" id="subject" placeholder="Enter subject">
                                </div>

                                <div class="col-12">
                                    <label for="message" class="form-label">Message</label>
                                    <textarea class="form-control custom-input custom-textarea" id="message" rows="5" placeholder="Write your message here"></textarea>
                                </div>

                                <div class="col-12 text-center">
                                    <button type="submit" class="btn-glow send-message">Send Message</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/navbar-behaviour.js"></script>
</body>
</html>