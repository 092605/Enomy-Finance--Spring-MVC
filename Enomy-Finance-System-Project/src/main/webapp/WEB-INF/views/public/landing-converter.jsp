<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/landing-converter.css">
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
                        <span class="about-badge">Smart Currency Tools</span>
                        <h1 class="about-page-title">Real-Time Currency Converter </h1>
                        <p class="about-page-text">
                         Enomy Finance provides a fast, accurate, and user-friendly currency conversion 
                         tool designed to help you make smarter financial decisions. Convert between major 
                         global currencies using real-time exchange rates, and instantly see the value of your transactions.	
                        </p>
                        <p class="about-page-text">
                            Whether you are planning international purchases, tracking exchange values, or managing
                             financial transactions, our converter ensures transparency and reliability. The system 
                             applies up-to-date rates and clearly displays any applicable transaction limits and fees,
                              giving you full control over your conversions.
                        </p>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="about-page-image-wrap card-glass">
                        <img src="${pageContext.request.contextPath}/resources/images/Currency Converter Landing.png"
                             alt="About Enomy Finance"
                             class="img-fluid about-page-image">
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- CHECK RATE + ACTIVE RULE SET -->
    <section class="landing-converter-tools-section">
        <div class="container">
            <div class="row g-4 align-items-stretch">

                <!-- CHECK RATE CALCULATOR -->
                <div class="col-lg-6 d-flex">
                    <div class="currency-panel-card currency-checkrate-card w-100 h-100">
                        <div class="currency-card-inner">
                            <div class="currency-card-header-row">
                                <h3 class="currency-card-title">Check Rate Calculator</h3>
                                <span class="currency-mini-badge">Base Amount: 1</span>
                            </div>

                            <div class="row g-3">

								<!-- Base Currency -->
								<div class="col-md-6">
								    <label class="currency-label">Base Currency</label>
								
								    <div class="custom-dropdown currency-dropdown">
								        <input type="hidden" id="checkRateBaseCurrency" value="" />
								
								        <button class="custom-dropdown-toggle" type="button">
								            <span class="selected-value">Select</span>
								            <span class="dropdown-arrow">
								                <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
								                    <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
								                </svg>
								            </span>
								        </button>
								
								        <div class="custom-dropdown-menu">
								            <div class="custom-dropdown-item" data-value="GBP">GBP</div>
								            <div class="custom-dropdown-item" data-value="USD">USD</div>
								            <div class="custom-dropdown-item" data-value="EUR">EUR</div>
								            <div class="custom-dropdown-item" data-value="BRL">BRL</div>
								            <div class="custom-dropdown-item" data-value="JPY">JPY</div>
								            <div class="custom-dropdown-item" data-value="TRY">TRY</div>
								        </div>
								    </div>
								</div>
								
								<!-- Target Currency -->
								<div class="col-md-6">
								    <label class="currency-label">Target Currency</label>
								
								    <div class="custom-dropdown currency-dropdown">
								        <input type="hidden" id="checkRateTargetCurrency" value="" />
								
								        <button class="custom-dropdown-toggle" type="button">
								            <span class="selected-value">Select</span>
								            <span class="dropdown-arrow">
								                <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
								                    <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
								                </svg>
								            </span>
								        </button>
								
								        <div class="custom-dropdown-menu">
								            <div class="custom-dropdown-item" data-value="GBP">GBP</div>
								            <div class="custom-dropdown-item" data-value="USD">USD</div>
								            <div class="custom-dropdown-item" data-value="EUR">EUR</div>
								            <div class="custom-dropdown-item" data-value="BRL">BRL</div>
								            <div class="custom-dropdown-item" data-value="JPY">JPY</div>
								            <div class="custom-dropdown-item" data-value="TRY">TRY</div>
								        </div>
								    </div>
								</div>

                                <!-- Result -->
                                <div class="col-12">
                                    <div class="currency-checkrate-preview-box">
                                        <div class="currency-checkrate-preview-title">Rate Result</div>
                                        <div class="currency-checkrate-preview-value" id="checkRateResultValue">
                                            Rate Result...
                                        </div>
                                    </div>
                                </div>

                                <!-- Button + Info -->
                                <div class="col-12">
                                    <div class="currency-checkrate-actions">
                                        <button type="button" class="btn-glow currency-checkrate-btn" id="checkRateBtn">
                                            Check Rate
                                        </button>

                                        <div class="currency-checkrate-sync">
                                            Rate date:<br>
                                            <strong id="checkRateRateDate">Not available</strong><br><br>

                                            Fetched at:<br>
                                            <strong id="checkRateFetchedAt">Not available</strong>
                                        </div>
                                    </div>
                                </div>

                                <!-- Note -->
                                <div class="col-12">
                                    <p class="landing-converter-public-note mb-0">
                                        Note: This public rate checker uses a base amount of 1 for quick preview only. 
                                        Login or sign up to use the full converter with custom amounts, full transaction details, 
                                        and applicable fee calculation.
                                    </p>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- ACTIVE RULE SET -->
                <div class="col-lg-6 d-flex">
                    <div class="currency-panel-card w-100 h-100">
                        <div class="currency-card-inner">
                            <h3 class="currency-card-title">Conversion Rules Details</h3>

                            <c:choose>
                                <c:when test="${not empty ruleSet}">
                                    <div class="currency-rule-meta">
                                        <strong>${ruleSet.ruleName}</strong>
                                        <c:if test="${not empty ruleSet.description}">
                                            <p>${ruleSet.description}</p>
                                        </c:if>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table currency-rules-table">
                                            <thead>
                                                <tr>
                                                    <th>Initial Currency Amount</th>
                                                    <th>Fee Rate</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="feeRule" items="${ruleSet.feeRules}">
                                                    <tr>
                                                        <td>
                                                            <fmt:formatNumber value="${feeRule.minAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                            -
                                                            <fmt:formatNumber value="${feeRule.maxAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${feeRule.feeRate}" minFractionDigits="1" maxFractionDigits="2"/>%
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <p class="currency-empty-text">No active conversion rules found.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <jsp:include page="/WEB-INF/components/Public/footer.jsp"/>

   <script>
    window.CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/resources/js/public/navbar-behaviour.js"></script>

<!-- REUSED -->
<script src="${pageContext.request.contextPath}/resources/js/client/client-dashboard.js"></script>

<!-- PUBLIC ONLY -->
<script src="${pageContext.request.contextPath}/resources/js/public/landing-converter.js"></script>
</body>
</html>