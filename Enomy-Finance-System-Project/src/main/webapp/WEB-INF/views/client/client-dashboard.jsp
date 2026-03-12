<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Dashboard | Enomy Finance</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css">

</head>

<body>

<!-- NAVBAR -->
<jsp:include page="/WEB-INF/components/navbar.jsp"/>

<div class="container py-5">

    <div class="card shadow p-4">

        <h2 class="mb-3">Client Dashboard</h2>

        <p class="text-muted">
            Welcome,
            <strong>${loggedInEmail}</strong>
        </p>

        <hr>

        <p>
            This is the client dashboard.
            Your financial tools will appear here.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/logout">
            <button class="btn btn-danger mt-3">Logout</button>
        </form>

    </div>

</div>

</body>
</html>