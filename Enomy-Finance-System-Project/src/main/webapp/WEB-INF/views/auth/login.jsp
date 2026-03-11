<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

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
                            <p class="auth-badge mb-2">Welcome Back</p>
                            <h1 class="auth-title">Login to Your Account</h1>
                            <p class="auth-subtitle">
                                Access your Enomy Finance tools and continue managing your finances smarter.
                            </p>
                        </div>
                        
                        
                        <!-- error message -->
                        
                        <%-- <c:if test="${not empty success}">
						    <div class="alert alert-success" role="alert">
						        ${success}
						    </div>
						</c:if>
						
						<c:if test="${param.error == 'true'}">
						    <div class="alert alert-danger" role="alert">
						        Invalid email or password.
						    </div>
						</c:if>
						
						<c:if test="${param.logout == 'true'}">
						    <div class="alert alert-success" role="alert">
						        You have been logged out successfully.
						    </div>
						</c:if> --%>
						
						 <!-- FORM METHOD -->

                        <form method="post" action="/login" class="auth-form">
                            <div class="mb-3">
                                <label for="email" class="form-label auth-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control auth-input" placeholder="Enter your email" required>
                            </div>

                            <div class="mb-3">
							    <label for="password" class="form-label auth-label">Password</label>
							
							    <div class="password-wrapper">
							        <input type="password"
							               id="password"
							               name="password"
							               class="form-control auth-input"
							               placeholder="Enter your password"
							               required>
							
							        <span class="toggle-password" onclick="togglePassword('password', this)">
							            <i class="bi bi-eye"></i>
							        </span>
							    </div>
							</div>

                            <button type="submit" class="btn btn-glow auth-submit-btn w-100">
                                Login
                            </button>
                        </form>

                        <div class="auth-footer text-center">
                            <p class="mb-0">
                                Don’t have an account?
                                <a href="/signup" class="auth-link">Sign up here</a>
                            </p>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/navbar-behaviour.js"></script>
	 <script src="${pageContext.request.contextPath}/resources/js/auth.js"></script>
	
</body>
</html>