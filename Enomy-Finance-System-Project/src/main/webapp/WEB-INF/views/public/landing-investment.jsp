

<%-- =========================================================
     JSP FILE DESCRIPTION
     =========================================================
     File Name:
     landing-investment.jsp

     Purpose:
     This JSP file serves as the public Investment
     landing page for the Enomy Finance system.

     Overview:
     This page introduces visitors to the Enomy Finance
     Savings and Investment feature. It explains how users
     can generate investment projections using initial
     investment amounts, monthly contributions, and selected
     investment plans.

     Main Features:
     - Public investment feature introduction
     - Savings and investment projection overview
     - 1 year, 5 years, and 10 years projection explanation
     - Investment growth, profit, fee, and tax explanation
     - Public call-to-action button
     - Authenticated-aware navigation support
     - Responsive informational layout

     CONNECTED RESOURCES

     CSS
     - theme.css
     - about.css
     - components.css
     - bootstrap.min.css

     JavaScript
     - navbar-behaviour.js
     - bootstrap.bundle.min.js

     JSP COMPONENTS
     - Public/navbar.jsp
     - Public/footer.jsp

     JAVA CLASSES

     Controllers
     - HomeController
     - GlobalNavbarControllerAdvice
     - InvestmentController

     Services
     - InvestmentService
     - InvestmentServiceImpl

     DAO Layer
     - PlanRulesDao
     - PlanRulesDaoImpl
     - TaxSettingsDao
     - TaxSettingsDaoImpl

     Models
     - PlanRules
     - TaxSettings
     - User

     DTO Classes
     - PlanDetailsDTO
     - InvestmentRequestDTO
     - InvestmentResponseDTO
     - YearlyInvestmentResultDTO

     Security Classes
     - SecurityConfig
     - CustomUserDetails
     - CustomAuthenticationSuccessHandler

     Purpose of Java Class Usage:
     - Handles public investment landing page routing
     - Supports authenticated-aware navbar rendering
     - Provides navigation to the secured investment module
     - Supports investment plan and projection workflows
     - Supplies secured access when users enter the full investment page

     Note:
     This page is mainly informational. Full investment
     calculation, saved quote history, and personalized
     projection features are handled in the authenticated
     client investment module.

     Module:
     Web Development Foundations (WDF)

     System:
     Enomy Finance Web Application

     ========================================================= --%>




<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About | Enomy Finance</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/theme.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/about.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/components.css">
</head>
<body>

	<!-- NAVBAR -->
	<jsp:include page="/WEB-INF/components/Public/navbar.jsp" />

	<!-- ABOUT HERO -->
	<section class="about-page-hero section">
		<div class="container">
			<div class="row align-items-center g-5">

				<div class="col-lg-6">
					<div class="about-page-content">
						<span class="about-badge">Smart Investment Planning</span>
						<h1 class="about-page-title">Investment Growth & Savings
							Projection</h1>
						<p class="about-page-text">Enomy Finance provides powerful
							investment planning tools designed to help you forecast your
							financial future with confidence. Generate personalized
							projections based on your initial investment, monthly
							contributions, and selected investment plan.</p>
						<p class="about-page-text">Our system calculates estimated
							returns over 1, 5, and 10 years, giving you a clear view of
							potential growth, profits, fees, and taxes. Whether you are a
							beginner or an experienced investor, our platform simplifies
							complex financial data into easy-to-understand insights.</p>

						<div class="mt-4">
							<a href="${pageContext.request.contextPath}/client/investment"
								class="btn-glow text-decoration-none"> Try Investment Now </a>
						</div>
					</div>
				</div>

				<div class="col-lg-6">
					<div class="about-page-image-wrap card-glass">
						<img
							src="${pageContext.request.contextPath}/resources/images/Investment Landing.png"
							alt="About Enomy Finance" class="img-fluid about-page-image">
					</div>
				</div>

			</div>
		</div>
	</section>


	<!-- FOOTER -->
	<jsp:include page="/WEB-INF/components/Public/footer.jsp" />

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/public/navbar-behaviour.js"></script>
</body>
</html>