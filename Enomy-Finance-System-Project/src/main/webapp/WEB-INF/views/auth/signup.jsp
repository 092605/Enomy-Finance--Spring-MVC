<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/authentication.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css">
</head>

<body class="auth-page">

   <jsp:include page="/WEB-INF/components/navbar.jsp"/>

    <main class="auth-wrapper">
        <div class="container">
            <div class="row justify-content-center align-items-center">
                <div class="col-lg-5 col-md-7 col-sm-10">

                    <div class="auth-card">
                        <div class="auth-card-top-glow"></div>

                        <div class="auth-header text-center">
                            <p class="auth-badge mb-2">Create Your Account</p>
                            <h1 class="auth-title">Join Enomy Finance</h1>
                            <p class="auth-subtitle">
                                Start using smart tools for currency conversion, savings planning, and investment tracking.
                            </p>
                        </div>
                        
                        <!-- FORM METHOD  -->
                        
                        <%-- <c:if test="${not empty error}">
						    <div class="alert alert-danger">
						        ${error}
						    </div>
						</c:if> --%>

                        <form method="post" action="/signup" class="auth-form">
                            <div class="mb-3">
                                <label for="fullname" class="form-label auth-label">Full Name</label>
                                <input type="text" id="fullname" name="fullname" class="form-control auth-input" placeholder="Enter your full name" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label auth-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control auth-input" placeholder="Enter your email" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label auth-label">Password</label>
                                <input type="password" id="password" name="password" class="form-control auth-input" placeholder="Create your password" required>
                            </div>

                            <button type="submit" class="btn btn-glow auth-submit-btn w-100">
                                Sign Up
                            </button>
                        </form>
                        
                        
                        

                        <div class="auth-footer text-center">
                            <p class="mb-0">
                                Already have an account?
                                <a href="${pageContext.request.contextPath}/login" class="auth-link">Login here</a>
                            </p>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/navbar-behaviour.js"></script>
</body>
</html>