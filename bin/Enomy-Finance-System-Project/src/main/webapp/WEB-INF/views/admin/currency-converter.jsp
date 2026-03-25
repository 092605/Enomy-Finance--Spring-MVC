<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Currency Converter | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
</head>

<body class="dashboard-page">

<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/components/Authenticated/admin/sidebar.jsp" />

    <div class="dashboard-main" id="dashboardMain">

        <jsp:include page="/WEB-INF/components/Authenticated/admin/topbar.jsp" />

      <main class="dashboard-content">
	    <div class="container-fluid">
	
	        <div class="card-glass p-4 rounded-4">
	
	           <h1 class="mb-2">
				    Hello, ${fullName} 👋
				</h1>
					
	            <!-- This is a subtitle for context -->
	            <p class="text-muted mb-0">
	                Welcome back to Currency Converter. 
	            </p>
	
	        </div>
	
	    </div>
	</main>

        <jsp:include page="/WEB-INF/components/Authenticated/footer.jsp" />

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
</body>
</html>