<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="currentPlanType" value="${empty investmentRequest.planType ? 'BASIC_SAVINGS' : investmentRequest.planType}" />
<c:set var="currentResult" value="${hasCalculated ? investmentResponse.oneYear : null}" />

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savings & Investment | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/savings-investment.css">
</head>

<body class="dashboard-page">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/components/Authenticated/sidebar.jsp" />

        <div class="dashboard-main" id="dashboardMain">

            <jsp:include page="/WEB-INF/components/Authenticated/topbar.jsp" />

            <main class="dashboard-content savings-page">

                <div class="investment-page-header">
                    <h1 class="investment-page-title">Enomy Finance</h1>
                    <h2 class="investment-page-subtitle">Investment Plan</h2>
                </div>

                <c:if test="${not empty calculationError}">
                    <div class="alert alert-danger">${calculationError}</div>
                </c:if>

                <c:if test="${not empty saveSuccessMessage}">
                    <div class="alert alert-success">${saveSuccessMessage}</div>
                </c:if>

                <c:if test="${not empty saveErrorMessage}">
                    <div class="alert alert-danger">${saveErrorMessage}</div>
                </c:if>

                <section class="investment-split-card">
                    <div class="row g-4 align-items-start">

                        <!-- LEFT GROUP -->
                        <div class="col-lg-9">

                            <div class="row g-4 investment-split-row">

                                <!-- Left stacked side -->
                                <div class="col-lg-6">
                                    <div class="row g-4">

                                        <!-- Calculator -->
                                        <div class="col-12">
                                            <div class="investment-left-panel">
                                                <div class="investment-card-inner Inv-Calc">
                                                    <div class="investment-panel-block">
                                                        <h3 class="investment-card-title">Investment Plan Calculator</h3>

                                                        <form action="${pageContext.request.contextPath}/client/investment/calculate" method="post">

                                                            <!-- Row 1: Initial + Monthly -->
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <div class="investment-form-group">
                                                                        <label for="initialInvestment">Initial Investment (£)</label>
                                                                        <div class="enomy-input-wrap">
                                                                            <span class="enomy-prefix">£</span>
                                                                            <input type="number"
                                                                                   step="0.01"
                                                                                   id="initialInvestment"
                                                                                   name="initialLumpSum"
                                                                                   class="enomy-input"
                                                                                   placeholder="Enter amount"
                                                                                   value="${investmentRequest.initialLumpSum}">
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <div class="investment-form-group">
                                                                        <label for="monthlyContribution">Monthly Contribution (£)</label>
                                                                        <div class="enomy-input-wrap">
                                                                            <span class="enomy-prefix">£</span>
                                                                            <input type="number"
                                                                                   step="0.01"
                                                                                   id="monthlyContribution"
                                                                                   name="monthlyInvestment"
                                                                                   class="enomy-input"
                                                                                   placeholder="Enter amount"
                                                                                   value="${investmentRequest.monthlyInvestment}">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Row 2: Dropdown + Button -->
                                                            <div class="row align-items-end">
                                                                <div class="col-md-6">
                                                                    <div class="investment-form-group">
                                                                        <label>Select Investment Plan</label>

                                                                        <div class="custom-dropdown investment-dropdown" id="investmentPlanDropdown">
                                                                            <button class="custom-dropdown-toggle" type="button">
                                                                                <span class="selected-value">
                                                                                    <c:choose>
                                                                                        <c:when test="${currentPlanType eq 'BASIC_SAVINGS'}">Basic Savings Plan</c:when>
                                                                                        <c:when test="${currentPlanType eq 'SAVINGS_PLUS'}">Savings Plan Plus</c:when>
                                                                                        <c:when test="${currentPlanType eq 'MANAGED_STOCKS'}">Managed Stock Investments</c:when>
                                                                                        <c:otherwise>Basic Savings Plan</c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                                <span class="dropdown-arrow">
                                                                                    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
                                                                                        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
                                                                                    </svg>
                                                                                </span>
                                                                            </button>

                                                                            <div class="custom-dropdown-menu">
                                                                                <div class="custom-dropdown-item ${currentPlanType eq 'BASIC_SAVINGS' ? 'active' : ''}" data-value="BASIC_SAVINGS">Basic Savings Plan</div>
                                                                                <div class="custom-dropdown-item ${currentPlanType eq 'SAVINGS_PLUS' ? 'active' : ''}" data-value="SAVINGS_PLUS">Savings Plan Plus</div>
                                                                                <div class="custom-dropdown-item ${currentPlanType eq 'MANAGED_STOCKS' ? 'active' : ''}" data-value="MANAGED_STOCKS">Managed Stock Investments</div>
                                                                            </div>
                                                                        </div>

                                                                        <input type="hidden" name="planType" id="investmentPlanValue" value="${currentPlanType}">
                                                                    </div>
                                                                </div>

                                                                <div class="col-md-6">
                                                                    <div class="investment-form-group">
                                                                        <label class="invisible">Calculate Projection</label>
                                                                        <button type="submit" class="btn-glow calculate-projection-btn w-100">
                                                                            Calculate Projection
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Plan Details -->
                                        <div class="col-12">
                                            <div class="investment-middle-panel">
                                                <div class="investment-card-inner plan-details-box">

                                                    <c:choose>
                                                        <c:when test="${currentPlanType eq 'BASIC_SAVINGS'}">
                                                            <h3 class="plan-details-title">Option 1 – Basic Savings Plan</h3>
                                                            <ul class="plan-details-list">
                                                                <li><span class="plan-bullet"></span><span>Maximum investment per year: <span class="plan-strong">£20,000</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum monthly investment: <span class="plan-strong">£50</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum initial investment lump sum: <span class="plan-strong">N/A</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Predicted returns per year: <span class="plan-highlight">1.2% to 2.4%</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Estimated tax: <span class="plan-strong">0%</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>RBSX group fees per month: <span class="plan-strong">0.25%</span></span></li>
                                                            </ul>
                                                        </c:when>

                                                        <c:when test="${currentPlanType eq 'SAVINGS_PLUS'}">
                                                            <h3 class="plan-details-title">Option 2 – Savings Plan Plus</h3>
                                                            <ul class="plan-details-list">
                                                                <li><span class="plan-bullet"></span><span>Maximum investment per year: <span class="plan-strong">£30,000</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum monthly investment: <span class="plan-strong">£50</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum initial investment lump sum: <span class="plan-strong">£300</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Predicted returns per year: <span class="plan-highlight">3% to 5.5%</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Estimated tax: <span class="plan-strong">10% on profits above £12,000</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>RBSX group fees per month: <span class="plan-strong">0.3%</span></span></li>
                                                            </ul>
                                                        </c:when>

                                                        <c:when test="${currentPlanType eq 'MANAGED_STOCKS'}">
                                                            <h3 class="plan-details-title">Option 3 – Managed Stock Investments</h3>
                                                            <ul class="plan-details-list">
                                                                <li><span class="plan-bullet"></span><span>Maximum investment per year: <span class="plan-strong">Unlimited</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum monthly investment: <span class="plan-strong">£150</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Minimum initial investment lump sum: <span class="plan-strong">£1000</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Predicted returns per year: <span class="plan-highlight">4% to 23%</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>Estimated tax: <span class="plan-strong">10% above £12,000 and 20% above £40,000</span></span></li>
                                                                <li><span class="plan-bullet"></span><span>RBSX group fees per month: <span class="plan-strong">1.3%</span></span></li>
                                                            </ul>
                                                        </c:when>
                                                    </c:choose>

                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <!-- Result -->
                                <div class="col-lg-6">
                                    <div class="investment-result-panel">
                                        <div class="investment-card-inner result-box">

                                            <h3 class="result-plan-title">
                                                <c:choose>
                                                    <c:when test="${currentPlanType eq 'BASIC_SAVINGS'}">Basic Savings Plan</c:when>
                                                    <c:when test="${currentPlanType eq 'SAVINGS_PLUS'}">Savings Plan Plus</c:when>
                                                    <c:when test="${currentPlanType eq 'MANAGED_STOCKS'}">Managed Stock Investments</c:when>
                                                    <c:otherwise>Basic Savings Plan</c:otherwise>
                                                </c:choose>
                                            </h3>

                                            <div class="result-range-tabs">
                                                <button type="button" class="result-tab-btn active">1 Year</button>
                                                <button type="button" class="result-tab-btn">5 Years</button>
                                                <button type="button" class="result-tab-btn">10 Years</button>
                                            </div>

                                            <div class="result-summary-table">
                                                <div class="result-summary-row">
                                                    <span class="result-label">Initial Lump Sum</span>
                                                    <span class="result-value">
                                                        £<fmt:formatNumber value="${hasCalculated ? currentResult.initialLumpSum : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                    </span>
                                                </div>
                                                <div class="result-summary-row">
                                                    <span class="result-label">Monthly Investment</span>
                                                    <span class="result-value">
                                                        £<fmt:formatNumber value="${hasCalculated ? currentResult.monthlyInvestment : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="result-total-invested">
                                                <span>Total Invested Amount</span>
                                                <strong>
                                                    £<fmt:formatNumber value="${hasCalculated ? currentResult.totalInvested : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                </strong>
                                            </div>

                                            <div class="result-dashed-divider"></div>

                                            <div class="result-section">
                                                <h4 class="result-section-title">Return &amp; Profits</h4>
                                                <div class="result-grid-two">
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Min Return</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.minReturn : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Min Profit</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.minProfit : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Max Return</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.maxReturn : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Max Profit</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.maxProfit : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="result-dashed-divider"></div>

                                            <div class="result-section">
                                                <h4 class="result-section-title">Tax &amp; Fee</h4>
                                                <div class="result-grid-two">
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Min Tax</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.minTax : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Monthly Fee</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.monthlyFee : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Max Tax</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.maxTax : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                    <div class="result-metric-block">
                                                        <span class="result-metric-label">Total Fee</span>
                                                        <span class="result-metric-value">£<fmt:formatNumber value="${hasCalculated ? currentResult.totalFee : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="result-actions ${hasCalculated ? '' : 'd-none'}">

                                                <a href="${pageContext.request.contextPath}/client/investment" class="btn-glow-outline result-discard-btn text-decoration-none text-center">
                                                    Discard
                                                </a>

                                                <form action="${pageContext.request.contextPath}/client/investment/save" method="post" class="m-0">
                                                    <input type="hidden" name="planType" value="${investmentRequest.planType}">
                                                    <input type="hidden" name="initialLumpSum" value="${investmentRequest.initialLumpSum}">
                                                    <input type="hidden" name="monthlyInvestment" value="${investmentRequest.monthlyInvestment}">
                                                    <button type="submit" class="btn-glow result-save-btn">Save Quote</button>
                                                </form>

                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>

                        </div>

                        <!-- RIGHT SEPARATE CARD -->
                        <div class="col-lg-3">
                            <div class="saved-quotes-side-panel">
                                <div class="card-glow dashboard-card saved-quotes-summary-card">
                                    <div class="dashboard-card-header">
                                        <h5>Saved Quotes</h5>
                                    </div>

                                    <div class="dashboard-card-body saved-quotes-summary-body">
                                        <p class="dashboard-card-value SumCount">${savedQuoteCount}</p>
                                        <a href="${pageContext.request.contextPath}/client/investment/quotes" class="btn-glow text-decoration-none text-center">
                                            View All
                                        </a>
                                    </div>
                                </div>

                                <div class="saved-quotes-list-wrap d-none">
                                    <!-- future expanded list goes here -->
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

            </main>

            <jsp:include page="/WEB-INF/components/Authenticated/footer.jsp" />

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/Investment-Main.js"></script>

</body>
</html>