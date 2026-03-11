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
                        <span class="about-badge">Landing Converter</span>
                        <h1 class="about-page-title">Landing Currency Converter </h1>
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

   
    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/components/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/navbar-behaviour.js"></script>
</body>
</html>