<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/authentication.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/navbar.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>

<body class="auth-page">

    <jsp:include page="/WEB-INF/components/Public/navbar.jsp"/>

    <main class="auth-wrapper">
        <div class="container">
            <div class="row justify-content-center align-items-center">
                <div class="col-lg-9 col-xl-8 col-md-10 col-sm-12">

                    <div class="auth-card">
                        <div class="auth-card-top-glow"></div>

                        <div class="auth-header text-center">
                            <p class="auth-badge mb-2">Create Your Account</p>
                            <h1 class="auth-title">Join Enomy Finance</h1>
                            <p class="auth-subtitle">
                                Start using smart tools for currency conversion, savings planning, and investment tracking.
                            </p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                ${success}
                            </div>
                        </c:if>
                        
                        <div class="auth-divider"></div>

<form method="post" action="${pageContext.request.contextPath}/signup" class="auth-form" id="signupForm">

    <div class="row auth-signup-layout">

        <!-- LEFT COLUMN -->
        <div class="col-lg-6">
            <div class="mb-3">
                <label for="fullname" class="form-label auth-label">Username</label>
                <input type="text"
                       id="fullname"
                       name="fullname"
                       class="form-control auth-input"
                       placeholder="Enter your full name"
                       required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label auth-label">Email</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control auth-input"
                       placeholder="Enter your email"
                       required>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label auth-label">Password</label>
                    <div class="password-wrapper">
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control auth-input"
                               placeholder="Create your password"
                               required>
                        <span class="toggle-password" onclick="togglePassword('password', this)">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label auth-label">Confirm Password</label>
                    <div class="password-wrapper">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               class="form-control auth-input"
                               placeholder="Confirm your password"
                               required>
                        <span class="toggle-password" onclick="togglePassword('confirmPassword', this)">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN -->
        <div class="col-lg-6">
            <div class="auth-signup-side-panel">
                <div class="auth-password-strength auth-password-strength-box">
                    <span class="auth-password-strength-label">Password Strength</span>
                    <span class="auth-password-strength-value" id="passwordStrengthText">Not entered</span>
                </div>

                <ul class="auth-password-rules">
                    <li id="ruleLength">At least 8 characters</li>
                    <li id="ruleUpper">At least 1 uppercase letter</li>
                    <li id="ruleLower">At least 1 lowercase letter</li>
                    <li id="ruleNumber">At least 1 number</li>
                    <li id="ruleSymbol">At least 1 special character</li>
                </ul>

                <div id="confirmPasswordMessage" class="auth-confirm-password-message"></div>

                <button type="submit" class="btn btn-glow auth-submit-btn w-100">
                    Sign Up
                </button>

                <div class="auth-footer text-center auth-footer-signup-panel">
                    <p class="mb-0">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login" class="auth-link">Login here</a>
                    </p>
                </div>
            </div>
        </div>

    </div>
</form>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/public/navbar-behaviour.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/public/auth.js"></script>
</body>
</html>