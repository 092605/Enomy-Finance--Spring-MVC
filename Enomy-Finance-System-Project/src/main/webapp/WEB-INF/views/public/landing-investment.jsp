<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/about.css">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/components.css">
</head>
<body>

    <!-- NAVBAR -->
    <jsp:include page="/WEB-INF/components/Public/navbar.jsp"/>

    <!-- ABOUT HERO -->
    <section class="about-page-hero section">
        <div class="container">
            <div class="row align-items-center g-5">

                <div class="col-lg-6">
                    <div class="about-page-content">
                        <span class="about-badge">Smart Investment Planning</span>
                        <h1 class="about-page-title">Investment Growth & Savings Projection</h1>
                        <p class="about-page-text">
                            Enomy Finance provides powerful investment planning tools designed to help you
                             forecast your financial future with confidence. Generate personalized projections
                              based on your initial investment, monthly contributions, and selected investment plan.
                        </p>
                        <p class="about-page-text">
                            Our system calculates estimated returns over 1, 5, and 10 years, giving you a clear 
                            view of potential growth, profits, fees, and taxes. Whether you are a beginner or an
                             experienced investor, our platform simplifies complex financial data into easy-to-understand insights.
                        </p>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/client/investment"
                               class="btn-glow text-decoration-none">
                                Try Investment Now
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="about-page-image-wrap card-glass">
                        <img src="${pageContext.request.contextPath}/resources/images/Investment Landing.png"
                             alt="About Enomy Finance"
                             class="img-fluid about-page-image">
                    </div>
                </div>

            </div>
        </div>
    </section>

   
    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/components/Public/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/public/navbar-behaviour.js"></script>
</body>
</html>