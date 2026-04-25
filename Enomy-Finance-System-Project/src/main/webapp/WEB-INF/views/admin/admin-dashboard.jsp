<%-- =========================================================
     JSP FILE DESCRIPTION
     =========================================================
     File Name:
     admin-dashboard.jsp

     Purpose:
     This JSP file serves as the main Admin Dashboard page
     for the Enomy Finance system.

     Overview:
     The dashboard acts primarily as a navigation and entry
     point for administrators to access different management
     modules within the system.

     Note:
     This dashboard page is intentionally kept minimal and
     does not contain advanced analytics, reporting, or
     deeper administrative functionalities because these
     features are outside the current project scope and are
     not the main focus of the implementation.

     Main Responsibilities:
     - Display administrator welcome message
     - Provide authenticated admin layout
     - Load reusable admin sidebar and topbar
     - Serve as a navigation hub to admin modules

     Connected Components:
     - admin/sidebar.jsp
     - admin/topbar.jsp
     - client/footer.jsp

    Connected Resources:
     
     CSS
     - theme.css
     - components.css
     - client-dashboard.css (Reuse the css of client dahsboard)
     - bootstrap.min.css

     
     JS
     - bootstrap.bundle.min.js
     
    
    JAVA CLASSES

     Controllers
     - AdminDashboardController

     Security Classes
     - CustomUserDetails
     - CustomAuthenticationSuccessHandler
     - CustomAuthenticationFailureHandler

     Models
     - User

     DAO Layer
     - UserDao
     - UserDaoImpl

     Purpose of Java Class Usage:
     - Handles administrator dashboard page routing
     - Retrieves authenticated administrator information
     - Supplies the fullName value displayed in the welcome message
     - Supports secured administrator access
     - Redirects authenticated admin users after successful login

     Module:
     Web Development Foundations (WDF)

     System:
     Enomy Finance Web Application

     ========================================================= --%>


<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | Enomy Finance</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
</head>

<body class="dashboard-page">

	<div class="dashboard-layout">

		<jsp:include
			page="/WEB-INF/components/Authenticated/admin/sidebar.jsp" />

		<div class="dashboard-main" id="dashboardMain">

			<jsp:include
				page="/WEB-INF/components/Authenticated/admin/topbar.jsp" />

			<main class="dashboard-content">
				<div class="container-fluid">

					<div class="card-glass p-4 rounded-4">

						<h1 class="mb-2">Hello, ${fullName} 👋</h1>

						<!-- This is a subtitle for context -->
						<p class="text-muted mb-0">Welcome back to your admin
							dashboard. Manage system settings and monitor activity.</p>

					</div>

				</div>
			</main>

			<jsp:include
				page="/WEB-INF/components/Authenticated/client/footer.jsp" />

		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>