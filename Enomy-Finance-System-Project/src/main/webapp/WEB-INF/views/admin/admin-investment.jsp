<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Investment Rules | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/admin-investment.css">
</head>

<body class="dashboard-page">

<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/components/Authenticated/admin/sidebar.jsp" />

    <div class="dashboard-main" id="dashboardMain">

        <jsp:include page="/WEB-INF/components/Authenticated/admin/topbar.jsp" />

        <main class="dashboard-content investment-page">

            <div class="investment-page-header">
                <h1 class="investment-page-title">Enomy Finance</h1>
                <h2 class="investment-page-subtitle">Admin Investment Rules</h2>
            </div>

            <!-- GLOBAL ALERTS -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success investment-alert-success mb-4">
                    ${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger investment-alert-error mb-4">
                    ${errorMessage}
                </div>
            </c:if>

            <c:if test="${not empty formErrors}">
                <div class="alert alert-danger investment-alert-error mb-4">
                    <strong>Please check the following:</strong>
                    <ul class="mb-0 mt-2">
                        <c:forEach var="err" items="${formErrors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <!-- PREP ACTIVE PLANS -->
            <c:set var="activeBasic" value="${null}" />
            <c:set var="activePlus" value="${null}" />
            <c:set var="activeManaged" value="${null}" />

            <c:forEach var="plan" items="${activePlanSet}">
                <c:if test="${plan.planType eq 'BASIC'}">
                    <c:set var="activeBasic" value="${plan}" />
                </c:if>
                <c:if test="${plan.planType eq 'PLUS'}">
                    <c:set var="activePlus" value="${plan}" />
                </c:if>
                <c:if test="${plan.planType eq 'MANAGED'}">
                    <c:set var="activeManaged" value="${plan}" />
                </c:if>
            </c:forEach>

            <section class="investment-page-layout">
                <div class="row g-4 align-items-start">

                    <!-- MAIN CONTENT -->
                    <div class="col-lg-9">

                        <!-- =========================
                             ACTIVE RULES SECTION
                        ========================= -->
                        <c:if test="${empty activeSection or activeSection eq 'active-rules'}">

                            <div class="investment-title-card">
                                <h3>Active Rules</h3>
                                <p>Review the currently active plan rule set and tax settings used by the system.</p>
                            </div>

                            <div class="row g-4">

                                <!-- ACTIVE PLAN RULE -->
                                <div class="col-lg-7">
                                    <div class="investment-panel-card">
                                        <div class="investment-card-inner">
                                            <div class="investment-card-head">
                                                <div>
                                                    <h3 class="investment-card-title">Active Plan Rule</h3>
                                                    <p class="investment-card-text">Current active investment plan rule set.</p>
                                                </div>

                                                <c:if test="${not empty activePlanSet}">
                                                    <span class="investment-version-badge">
                                                        Version ${activePlanSet[0].planSetId}
                                                    </span>
                                                </c:if>
                                            </div>

                                            <div class="investment-plan-tabs" data-tab-group="active-plan-tabs">
                                                <button type="button" class="investment-tab-btn active" data-tab-target="active-basic">Basic Savings</button>
                                                <button type="button" class="investment-tab-btn" data-tab-target="active-plus">Savings Plus</button>
                                                <button type="button" class="investment-tab-btn" data-tab-target="active-managed">Managed Stocks</button>
                                            </div>

                                            <div class="investment-tab-panels">
                                                <div class="investment-tab-panel active" id="active-basic">
                                                    <c:choose>
                                                        <c:when test="${not empty activeBasic}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activeBasic.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activeBasic.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activeBasic.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activeBasic.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activeBasic.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activeBasic.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activeBasic.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activeBasic.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Basic Savings rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="investment-tab-panel" id="active-plus">
                                                    <c:choose>
                                                        <c:when test="${not empty activePlus}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activePlus.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activePlus.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activePlus.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activePlus.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activePlus.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activePlus.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activePlus.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activePlus.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Savings Plus rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="investment-tab-panel" id="active-managed">
                                                    <c:choose>
                                                        <c:when test="${not empty activeManaged}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activeManaged.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activeManaged.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activeManaged.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activeManaged.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activeManaged.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activeManaged.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activeManaged.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activeManaged.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Managed Stocks rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="investment-action-row mt-4">
                                                <a href="${pageContext.request.contextPath}/admin/investment/plan-rules"
                                                   class="btn-glow text-decoration-none text-center">
                                                    Create New Plan Rule
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

								<!-- PREP ACTIVE TAX SET ROWS FOR ACTIVE RULES SECTION -->
								<c:set var="activeTaxNone" value="${null}" />
								<c:set var="activeTaxFlat" value="${null}" />
								<c:set var="activeTaxProgressive" value="${null}" />
								
								<c:forEach var="tax" items="${activeTaxSet}">
								    <c:if test="${tax.taxType eq 'NONE'}">
								        <c:set var="activeTaxNone" value="${tax}" />
								    </c:if>
								    <c:if test="${tax.taxType eq 'FLAT'}">
								        <c:set var="activeTaxFlat" value="${tax}" />
								    </c:if>
								    <c:if test="${tax.taxType eq 'PROGRESSIVE'}">
								        <c:set var="activeTaxProgressive" value="${tax}" />
								    </c:if>
								</c:forEach>
								
								<!-- ACTIVE TAX SETTINGS -->
								<div class="col-lg-5">
								    <div class="investment-panel-card">
								        <div class="investment-card-inner">
								
								            <div class="investment-card-head">
								                <div>
								                    <h3 class="investment-card-title">Active Tax Settings</h3>
								                    <p class="investment-card-text">Current tax rules applied by the system.</p>
								                </div>
								
								                <c:if test="${not empty activeTaxSet}">
								                    <span class="investment-version-badge">
								                        Version ${activeTaxSet[0].taxSetId}
								                    </span>
								                </c:if>
								            </div>
								
								            <c:choose>
								                <c:when test="${not empty activeTaxSet}">
								
								                    <!-- TAX TYPE SWITCHER -->
								                    <div class="investment-tax-switcher">
								                        <div class="investment-tax-switch-top">
								                            <select class="investment-select investment-tax-type-select" id="activeTaxTypeSelect">
								                                <option value="active-tax-none">None</option>
								                                <option value="active-tax-flat">Flat</option>
								                                <option value="active-tax-progressive">Progressive</option>
								                            </select>
								
								                            <div class="investment-tax-rate-preview">
								                                <span id="activeTaxQuickRate">0%</span>
								                            </div>
								                        </div>
								                    </div>
								
								                    <!-- NONE PANEL -->
								                    <div class="investment-tax-view-panel active" id="active-tax-none">
								                        <div class="investment-tax-main-box">
								                            <span>Tax Free Allowance</span>
								                            <strong>
								                                <c:choose>
								                                    <c:when test="${not empty activeTaxNone}">
								                                        £<fmt:formatNumber value="${activeTaxNone.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
								                                    </c:when>
								                                    <c:otherwise>0.00</c:otherwise>
								                                </c:choose>
								                            </strong>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Lower</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxNone}">
								                                            <fmt:formatNumber value="${activeTaxNone.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxNone and not empty activeTaxNone.lowerTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxNone.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Upper</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxNone}">
								                                            <fmt:formatNumber value="${activeTaxNone.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxNone and not empty activeTaxNone.upperTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxNone.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								                    </div>
								
								                    <!-- FLAT PANEL -->
								                    <div class="investment-tax-view-panel" id="active-tax-flat">
								                        <div class="investment-tax-main-box">
								                            <span>Tax Free Allowance</span>
								                            <strong>
								                                <c:choose>
								                                    <c:when test="${not empty activeTaxFlat}">
								                                        £<fmt:formatNumber value="${activeTaxFlat.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
								                                    </c:when>
								                                    <c:otherwise>0.00</c:otherwise>
								                                </c:choose>
								                            </strong>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Lower</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxFlat}">
								                                            <fmt:formatNumber value="${activeTaxFlat.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxFlat and not empty activeTaxFlat.lowerTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxFlat.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Upper</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxFlat}">
								                                            <fmt:formatNumber value="${activeTaxFlat.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxFlat and not empty activeTaxFlat.upperTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxFlat.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								                    </div>
								
								                    <!-- PROGRESSIVE PANEL -->
								                    <div class="investment-tax-view-panel" id="active-tax-progressive">
								                        <div class="investment-tax-main-box">
								                            <span>Tax Free Allowance</span>
								                            <strong>
								                                <c:choose>
								                                    <c:when test="${not empty activeTaxProgressive}">
								                                        £<fmt:formatNumber value="${activeTaxProgressive.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
								                                    </c:when>
								                                    <c:otherwise>0.00</c:otherwise>
								                                </c:choose>
								                            </strong>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Lower</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxProgressive}">
								                                            <fmt:formatNumber value="${activeTaxProgressive.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Lower Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxProgressive and not empty activeTaxProgressive.lowerTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxProgressive.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								
								                        <div class="investment-tax-subsection">
								                            <h4>Upper</h4>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Tax Rate</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxProgressive}">
								                                            <fmt:formatNumber value="${activeTaxProgressive.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
								                                        </c:when>
								                                        <c:otherwise>0.00%</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								
								                            <div class="investment-tax-input-display">
								                                <span>Upper Threshold</span>
								                                <strong>
								                                    <c:choose>
								                                        <c:when test="${not empty activeTaxProgressive and not empty activeTaxProgressive.upperTaxThreshold}">
								                                            £<fmt:formatNumber value="${activeTaxProgressive.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
								                                        </c:when>
								                                        <c:otherwise>0.00</c:otherwise>
								                                    </c:choose>
								                                </strong>
								                            </div>
								                        </div>
								                    </div>
								
								                </c:when>
								
								                <c:otherwise>
								                    <p class="investment-empty-text">No active tax settings found.</p>
								                </c:otherwise>
								            </c:choose>
								
								            <div class="investment-action-stack mt-4">
								                <a href="${pageContext.request.contextPath}/admin/investment/tax-settings"
								                   class="btn-glow text-decoration-none text-center">
								                    Create New Tax Settings
								                </a>
								
								                <a href="${pageContext.request.contextPath}/admin/investment/history/tax?fromChangeFlow=true"
												   class="btn-glow-outline text-decoration-none text-center">
												    Change Tax Settings
												</a>
								            </div>
								
								        </div>
								    </div>
								</div>

                            </div>
                        </c:if>

                        <!-- =========================
                             PLAN RULES SECTION
                        ========================= -->
                        <c:if test="${activeSection eq 'plan-rules'}">

                            <div class="investment-title-card">
                                <h3>Create New Plan Rule Set</h3>
                                <p>Build a new plan rule version one plan at a time, then choose the tax settings to attach.</p>
                            </div>

                            <div class="row g-4">

                                <!-- LEFT REFERENCE -->
                                <div class="col-lg-5">
                                    <div class="investment-panel-card">
                                        <div class="investment-card-inner">
                                            <div class="investment-card-head">
                                                <div>
                                                    <h3 class="investment-card-title">Active Plan Rule</h3>
                                                    <p class="investment-card-text">Current active investment plan rule set.</p>
                                                </div>

                                                <c:if test="${not empty activePlanSet}">
                                                    <span class="investment-version-badge">
                                                        Version ${activePlanSet[0].planSetId}
                                                    </span>
                                                </c:if>
                                            </div>

                                            <div class="investment-plan-tabs" data-tab-group="active-plan-tabs">
                                                <button type="button" class="investment-tab-btn active" data-tab-target="active-basic">Basic Savings</button>
                                                <button type="button" class="investment-tab-btn" data-tab-target="active-plus">Savings Plus</button>
                                                <button type="button" class="investment-tab-btn" data-tab-target="active-managed">Managed Stocks</button>
                                            </div>

                                            <div class="investment-tab-panels">
                                                <div class="investment-tab-panel active" id="active-basic">
                                                    <c:choose>
                                                        <c:when test="${not empty activeBasic}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activeBasic.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activeBasic.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activeBasic.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activeBasic.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activeBasic.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activeBasic.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activeBasic.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activeBasic.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Basic Savings rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="investment-tab-panel" id="active-plus">
                                                    <c:choose>
                                                        <c:when test="${not empty activePlus}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activePlus.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activePlus.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activePlus.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activePlus.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activePlus.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activePlus.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activePlus.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activePlus.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Savings Plus rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="investment-tab-panel" id="active-managed">
                                                    <c:choose>
                                                        <c:when test="${not empty activeManaged}">
                                                            <div class="investment-info-grid">
                                                                <div><span>Maximum Investment/Year</span><strong><c:choose><c:when test="${not empty activeManaged.yearlyInvestmentLimit}">£<fmt:formatNumber value="${activeManaged.yearlyInvestmentLimit}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>Unlimited</c:otherwise></c:choose></strong></div>
                                                                <div><span>Minimum Monthly Investment</span><strong>£<fmt:formatNumber value="${activeManaged.minMonthlyRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Initial Lump Sum</span><strong>£<fmt:formatNumber value="${activeManaged.minInitialRequired}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                                                                <div><span>Minimum Return Rate</span><strong><fmt:formatNumber value="${activeManaged.minReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Maximum Return Rate</span><strong><fmt:formatNumber value="${activeManaged.maxReturnRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Monthly Fee Rate</span><strong><fmt:formatNumber value="${activeManaged.monthlyFeeRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                                                                <div><span>Tax Type</span><strong>${activeManaged.taxSettings.taxType}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="investment-empty-text">No active Managed Stocks rule found.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                           
                                        </div>
                                    </div>
                                </div>

                                <!-- RIGHT WIZARD -->
                                <div class="col-lg-7">
                                    <div class="investment-panel-card">
                                        <div class="investment-card-inner">

                                            <div class="investment-wizard-progress">
                                                <div class="investment-step-chip active" data-step-chip="basic">Basic Savings</div>
                                                <div class="investment-step-chip" data-step-chip="plus">Savings Plus</div>
                                                <div class="investment-step-chip" data-step-chip="managed">Managed Stocks</div>
                                                <div class="investment-step-chip" data-step-chip="tax-selection">Tax Selection</div>
                                                <div class="investment-step-chip" data-step-chip="tax-form">Tax Form</div>
                                            </div>

                                            <form id="planRuleWizardForm" method="post">
                                                <input type="hidden" name="selectedTaxMode" id="selectedTaxMode" value="${empty selectedTaxMode ? 'ACTIVE' : selectedTaxMode}">
                                                <input type="hidden" name="embeddedTaxSaved" id="embeddedTaxSaved" value="${embeddedTaxSaved}">
                                                <input type="hidden" name="currentWizardStep" id="currentWizardStep" value="${empty planRuleStep ? 'basic' : planRuleStep}">

                                                <!-- BASIC -->
                                                <div class="investment-wizard-step active" data-step="basic">
                                                    <div class="investment-form-head">
                                                        <h3 class="investment-card-title">Basic Savings</h3>
                                                        <p class="investment-card-text">Enter details for the Basic Savings plan.</p>
                                                    </div>

                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Investment/Year</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicYearlyInvestmentLimit" value="${planWizardDraft.basicYearlyInvestmentLimit}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Monthly Investment</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicMinMonthlyRequired" value="${planWizardDraft.basicMinMonthlyRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Initial Lump Sum</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicMinInitialRequired" value="${planWizardDraft.basicMinInitialRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Monthly Fee Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicMonthlyFeeRate" value="${planWizardDraft.basicMonthlyFeeRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicMinReturnRate" value="${planWizardDraft.basicMinReturnRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="basicMaxReturnRate" value="${planWizardDraft.basicMaxReturnRate}">
                                                        </div>
                                                    </div>

                                                    <div class="investment-action-row">
                                                        <button type="button" class="btn-glow ms-auto wizard-next" data-next-step="plus">Next</button>
                                                    </div>
                                                </div>

                                                <!-- PLUS -->
                                                <div class="investment-wizard-step" data-step="plus">
                                                    <div class="investment-form-head">
                                                        <h3 class="investment-card-title">Savings Plus</h3>
                                                        <p class="investment-card-text">Enter details for the Savings Plus plan.</p>
                                                    </div>

                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Investment/Year</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusYearlyInvestmentLimit" value="${planWizardDraft.plusYearlyInvestmentLimit}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Monthly Investment</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusMinMonthlyRequired" value="${planWizardDraft.plusMinMonthlyRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Initial Lump Sum</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusMinInitialRequired" value="${planWizardDraft.plusMinInitialRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Monthly Fee Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusMonthlyFeeRate" value="${planWizardDraft.plusMonthlyFeeRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusMinReturnRate" value="${planWizardDraft.plusMinReturnRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="plusMaxReturnRate" value="${planWizardDraft.plusMaxReturnRate}">
                                                        </div>
                                                    </div>

                                                    <div class="investment-action-row">
                                                        <button type="button" class="btn-glow-outline wizard-prev" data-prev-step="basic">Back</button>
                                                        <button type="button" class="btn-glow wizard-next" data-next-step="managed">Next</button>
                                                    </div>
                                                </div>

                                                <!-- MANAGED -->
                                                <div class="investment-wizard-step" data-step="managed">
                                                    <div class="investment-form-head">
                                                        <h3 class="investment-card-title">Managed Stocks</h3>
                                                        <p class="investment-card-text">Enter details for the Managed Stocks plan.</p>
                                                    </div>

                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Investment/Year</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedYearlyInvestmentLimit" value="${planWizardDraft.managedYearlyInvestmentLimit}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Monthly Investment</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedMinMonthlyRequired" value="${planWizardDraft.managedMinMonthlyRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Initial Lump Sum</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedMinInitialRequired" value="${planWizardDraft.managedMinInitialRequired}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Monthly Fee Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedMonthlyFeeRate" value="${planWizardDraft.managedMonthlyFeeRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Minimum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedMinReturnRate" value="${planWizardDraft.managedMinReturnRate}">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="investment-label">Maximum Return Rate (%)</label>
                                                            <input type="number" step="0.01" class="investment-input" name="managedMaxReturnRate" value="${planWizardDraft.managedMaxReturnRate}">
                                                        </div>
                                                    </div>

                                                    <div class="investment-action-row">
                                                        <button type="button" class="btn-glow-outline wizard-prev" data-prev-step="plus">Back</button>
                                                        <button type="button" class="btn-glow wizard-next" data-next-step="tax-selection">Next</button>
                                                    </div>
                                                </div>

                                                <!-- TAX SELECTION -->
                                                <div class="investment-wizard-step" data-step="tax-selection">
                                                    <div class="investment-form-head">
                                                        <h3 class="investment-card-title">Tax Settings Selection</h3>
                                                        <p class="investment-card-text">Use the current active tax settings or create a new one for this plan rule set.</p>
                                                    </div>

                                                    <div class="investment-tax-selection-card">
                                                        <div class="investment-tax-selection-top">
                                                            <div>
                                                                <span class="investment-mini-label">Current Active Tax Settings</span>
                                                                <strong class="investment-selection-version">
                                                                    <c:choose>
                                                                        <c:when test="${not empty activeTaxSet}">
																		    Version ${activeTaxSet[0].taxSetId}
																		</c:when>
                                                                        <c:otherwise>No active tax settings</c:otherwise>
                                                                    </c:choose>
                                                                </strong>
                                                                
                                                            </div>

                                                            <button type="button"
                                                                    class="btn-glow-outline btn-sm"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#activeTaxDetailsModal">
                                                                View Details
                                                            </button>
                                                        </div>

                                                        <div class="investment-radio-group">
                                                            <label class="investment-radio-card ${empty selectedTaxMode or selectedTaxMode eq 'ACTIVE' ? 'active' : ''}" data-tax-mode="ACTIVE">
                                                                <input type="radio" name="taxModeChoice" value="ACTIVE" ${empty selectedTaxMode or selectedTaxMode eq 'ACTIVE' ? 'checked' : ''}>
                                                                <span>Use Current Active Tax Settings</span>
                                                            </label>

                                                            <label class="investment-radio-card ${selectedTaxMode eq 'NEW' ? 'active' : ''}" data-tax-mode="NEW">
                                                                <input type="radio" name="taxModeChoice" value="NEW" ${selectedTaxMode eq 'NEW' ? 'checked' : ''}>
                                                                <span>Create New Tax Settings</span>
                                                            </label>
                                                        </div>

                                                        <div id="embeddedTaxSavedBanner" class="investment-saved-banner ${embeddedTaxSaved eq 'true' ? '' : 'd-none'}">
                                                            New tax settings have been saved for this flow. They are not active yet.
                                                        </div>
                                                    </div>

                                                    <div class="investment-action-row" id="taxSelectionPrimaryActions">
                                                        <button type="button" class="btn-glow-outline wizard-prev" data-prev-step="managed">Back</button>
                                                        <button type="button" id="taxSelectionPrimaryBtn" class="btn-glow">
                                                            <c:choose>
                                                                <c:when test="${selectedTaxMode eq 'NEW'}">Continue</c:when>
                                                                <c:otherwise>Create and Activate</c:otherwise>
                                                            </c:choose>
                                                        </button>
                                                    </div>

                                                    <div id="taxSelectionSecondaryActions" class="investment-secondary-actions ${embeddedTaxSaved eq 'true' ? '' : 'd-none'}">
                                                        <button type="button" id="editEmbeddedTaxBtn" class="btn-glow-outline">Edit Tax Settings</button>
                                                        <button type="button" id="finalCreateActivateBtn" class="btn-glow">Create and Activate</button>
                                                    </div>
                                                </div>

												<!-- EMBEDDED TAX FORM STEP -->
												<div class="investment-wizard-step ${planRuleStep eq 'tax-form' ? 'active' : ''}" data-step="tax-form">
												    <div class="investment-card-inner">
												        <div class="investment-form-head">
												            <h3 class="investment-card-title">Create New Tax Settings</h3>
												            <p class="investment-card-text">This tax form belongs to the current Plan Rule flow.</p>
												        </div>
												
												        <div class="investment-tax-create-grid">
												
												            <!-- NONE -->
												            <div class="investment-tax-create-column">
												                <h4>None</h4>
												
												                <input type="number"
												                       step="0.01"
												                       class="investment-input"
												                       name="embeddedNoneTaxFreeAllowance"
												                       value="${embeddedTaxDraft.noneTaxFreeAllowance}"
												                       placeholder="Tax Free Allowance">
												
												                <div class="investment-tax-subsection">
												                    <h5>Lower</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Lower Tax Rate 0%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Lower Threshold 00">
												                </div>
												
												                <div class="investment-tax-subsection">
												                    <h5>Upper</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Upper Tax Rate 0%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Upper Threshold 00">
												                </div>
												            </div>
												
												            <!-- FLAT -->
												            <div class="investment-tax-create-column">
												                <h4>Flat</h4>
												
												                <input type="number"
												                       step="0.01"
												                       class="investment-input"
												                       name="embeddedFlatTaxFreeAllowance"
												                       value="${embeddedTaxDraft.flatTaxFreeAllowance}"
												                       placeholder="Tax Free Allowance">
												
												                <div class="investment-tax-subsection">
												                    <h5>Lower</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           name="embeddedFlatTaxRate"
												                           value="${embeddedTaxDraft.flatTaxRate}"
												                           placeholder="Lower Tax Rate 00%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Lower Threshold 00">
												                </div>
												
												                <div class="investment-tax-subsection">
												                    <h5>Upper</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Upper Tax Rate 00%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           value="0"
												                           readonly
												                           placeholder="Upper Threshold 00">
												                </div>
												            </div>
												
												            <!-- PROGRESSIVE -->
												            <div class="investment-tax-create-column">
												                <h4>Progressive</h4>
												
												                <input type="number"
												                       step="0.01"
												                       class="investment-input"
												                       name="embeddedProgTaxFreeAllowance"
												                       value="${embeddedTaxDraft.progTaxFreeAllowance}"
												                       placeholder="Tax Free Allowance">
												
												                <div class="investment-tax-subsection">
												                    <h5>Lower</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           name="embeddedProgLowerRate"
												                           value="${embeddedTaxDraft.progLowerRate}"
												                           placeholder="Lower Tax Rate 00%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           name="embeddedProgLowerThreshold"
												                           value="${embeddedTaxDraft.progLowerThreshold}"
												                           placeholder="Lower Threshold 00">
												                </div>
												
												                <div class="investment-tax-subsection">
												                    <h5>Upper</h5>
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           name="embeddedProgUpperRate"
												                           value="${embeddedTaxDraft.progUpperRate}"
												                           placeholder="Upper Tax Rate 00%">
												
												                    <input type="number"
												                           step="0.01"
												                           class="investment-input"
												                           name="embeddedProgUpperThreshold"
												                           value="${embeddedTaxDraft.progUpperThreshold}"
												                           placeholder="Upper Threshold 00">
												                </div>
												            </div>
												
												        </div>
												
												        <div class="investment-action-row mt-4">
												            <button type="button"
												                    class="btn-glow-outline wizard-prev"
												                    data-prev-step="tax-selection">
												                Back
												            </button>
												
												            <button type="button"
												                    class="btn-glow"
												                    id="saveEmbeddedTaxBtn">
												                Save
												            </button>
												        </div>
												    </div>
												</div>
                                            </form>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

						<!-- =========================
						     TAX SETTINGS SECTION
						========================= -->
						<c:if test="${activeSection eq 'tax-settings'}">
						
						    <div class="investment-title-card">
						        <h3>Tax Settings</h3>
						        <p>Review the active tax settings and create a new version when needed.</p>
						    </div>
						
						    <!-- PREP ACTIVE TAX SET ROWS -->
						    <c:set var="activeTaxNone" value="${null}" />
						    <c:set var="activeTaxFlat" value="${null}" />
						    <c:set var="activeTaxProgressive" value="${null}" />
						
						    <c:forEach var="tax" items="${activeTaxSet}">
						        <c:if test="${tax.taxType eq 'NONE'}">
						            <c:set var="activeTaxNone" value="${tax}" />
						        </c:if>
						        <c:if test="${tax.taxType eq 'FLAT'}">
						            <c:set var="activeTaxFlat" value="${tax}" />
						        </c:if>
						        <c:if test="${tax.taxType eq 'PROGRESSIVE'}">
						            <c:set var="activeTaxProgressive" value="${tax}" />
						        </c:if>
						    </c:forEach>
						
						    <div class="row g-4">
						
						        <!-- LEFT: ACTIVE TAX SETTINGS CARD -->
						        <div class="col-lg-5">
						            <div class="investment-panel-card sticky-investment-card">
						                <div class="investment-card-inner">
						                    <div class="investment-card-head">
						                        <div>
						                            <h3 class="investment-card-title">Active Tax Settings</h3>
						                            <p class="investment-card-text">Current version applied by the system.</p>
						                        </div>
						
						                        <c:if test="${not empty activeTaxSet}">
						                            <span class="investment-version-badge">
						                                Version ${activeTaxSet[0].taxSetId}
						                            </span>
						                        </c:if>
						                    </div>
						
						                    <c:choose>
						                        <c:when test="${not empty activeTaxSet}">
						
						                            <!-- ACTIVE TAX SWITCHER -->
						                            <div class="investment-tax-switcher">
						                                <div class="investment-tax-switch-top">
						                                    <select class="investment-select investment-tax-type-select" id="activeTaxTypeSelect">
						                                        <option value="active-tax-none">None</option>
						                                        <option value="active-tax-flat">Flat</option>
						                                        <option value="active-tax-progressive">Progressive</option>
						                                    </select>
						
						                                    <div class="investment-tax-rate-preview">
						                                        <span id="activeTaxQuickRate">0%</span>
						                                    </div>
						                                </div>
						                            </div>
						
						                            <!-- NONE -->
						                            <div class="investment-tax-view-panel active" id="active-tax-none">
						                                <div class="investment-tax-main-box">
						                                    <span>Tax Free Allowance</span>
						                                    <strong>
						                                        <c:choose>
						                                            <c:when test="${not empty activeTaxNone}">
						                                                £<fmt:formatNumber value="${activeTaxNone.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </c:when>
						                                            <c:otherwise>0.00</c:otherwise>
						                                        </c:choose>
						                                    </strong>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Lower</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxNone}">
						                                                    <fmt:formatNumber value="${activeTaxNone.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxNone.lowerTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxNone.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Upper</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxNone}">
						                                                    <fmt:formatNumber value="${activeTaxNone.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxNone.upperTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxNone.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						                            </div>
						
						                            <!-- FLAT -->
						                            <div class="investment-tax-view-panel" id="active-tax-flat">
						                                <div class="investment-tax-main-box">
						                                    <span>Tax Free Allowance</span>
						                                    <strong>
						                                        <c:choose>
						                                            <c:when test="${not empty activeTaxFlat}">
						                                                £<fmt:formatNumber value="${activeTaxFlat.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </c:when>
						                                            <c:otherwise>0.00</c:otherwise>
						                                        </c:choose>
						                                    </strong>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Lower</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxFlat}">
						                                                    <fmt:formatNumber value="${activeTaxFlat.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxFlat.lowerTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxFlat.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Upper</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxFlat}">
						                                                    <fmt:formatNumber value="${activeTaxFlat.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxFlat.upperTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxFlat.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						                            </div>
						
						                            <!-- PROGRESSIVE -->
						                            <div class="investment-tax-view-panel" id="active-tax-progressive">
						                                <div class="investment-tax-main-box">
						                                    <span>Tax Free Allowance</span>
						                                    <strong>
						                                        <c:choose>
						                                            <c:when test="${not empty activeTaxProgressive}">
						                                                £<fmt:formatNumber value="${activeTaxProgressive.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </c:when>
						                                            <c:otherwise>0.00</c:otherwise>
						                                        </c:choose>
						                                    </strong>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Lower</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxProgressive}">
						                                                    <fmt:formatNumber value="${activeTaxProgressive.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Lower Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxProgressive.lowerTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxProgressive.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h4>Upper</h4>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Tax Rate</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxProgressive}">
						                                                    <fmt:formatNumber value="${activeTaxProgressive.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%
						                                                </c:when>
						                                                <c:otherwise>0.00%</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                    <div class="investment-tax-input-display">
						                                        <span>Upper Threshold</span>
						                                        <strong>
						                                            <c:choose>
						                                                <c:when test="${not empty activeTaxProgressive.upperTaxThreshold}">
						                                                    £<fmt:formatNumber value="${activeTaxProgressive.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/>
						                                                </c:when>
						                                                <c:otherwise>0.00</c:otherwise>
						                                            </c:choose>
						                                        </strong>
						                                    </div>
						                                </div>
						                            </div>
						
						                        </c:when>
						                        <c:otherwise>
						                            <p class="investment-empty-text">No active tax settings found.</p>
						                        </c:otherwise>
						                    </c:choose>
						
						                    <div class="investment-action-row mt-4">
						                        <a href="${pageContext.request.contextPath}/admin/investment/history/tax?fromChangeFlow=true"
												   class="btn-glow-outline text-decoration-none text-center">
												    Change Tax Settings
												</a>
						                    </div>
						                </div>
						            </div>
						        </div>
						
						        <!-- RIGHT: CREATE NEW TAX SETTINGS -->
						        <div class="col-lg-7">
						            <div class="investment-panel-card">
						                <div class="investment-card-inner">
						                    <div class="investment-form-head">
						                        <h3 class="investment-card-title">Create New Tax Settings</h3>
						                        <p class="investment-card-text">Create and activate a new grouped tax settings version immediately.</p>
						                    </div>
						
						                    <form action="${pageContext.request.contextPath}/admin/investment/tax-settings/create" method="post">
						
						                        <div class="investment-tax-create-grid">
						
						                            <!-- NONE -->
						                            <div class="investment-tax-create-column">
						                                <h4>None</h4>
						
						                                <input type="number"
						                                       step="0.01"
						                                       class="investment-input"
						                                       name="noneTaxFreeAllowance"
						                                       placeholder="Tax Free Allowance">
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Lower</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Lower Tax Rate 0%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Lower Threshold 00">
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Upper</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Upper Tax Rate 0%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Upper Threshold 00">
						                                </div>
						                            </div>
						
						                            <!-- FLAT -->
						                            <div class="investment-tax-create-column">
						                                <h4>Flat</h4>
						
						                                <input type="number"
						                                       step="0.01"
						                                       class="investment-input"
						                                       name="flatTaxFreeAllowance"
						                                       placeholder="Tax Free Allowance">
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Lower</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           name="flatTaxRate"
						                                           placeholder="Lower Tax Rate 00%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Lower Threshold 00">
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Upper</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Upper Tax Rate 00%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           value="0"
						                                           readonly
						                                           placeholder="Upper Threshold 00">
						                                </div>
						                            </div>
						
						                            <!-- PROGRESSIVE -->
						                            <div class="investment-tax-create-column">
						                                <h4>Progressive</h4>
						
						                                <input type="number"
						                                       step="0.01"
						                                       class="investment-input"
						                                       name="progTaxFreeAllowance"
						                                       placeholder="Tax Free Allowance">
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Lower</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           name="progLowerRate"
						                                           placeholder="Lower Tax Rate 00%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           name="progLowerThreshold"
						                                           placeholder="Lower Threshold 00">
						                                </div>
						
						                                <div class="investment-tax-subsection">
						                                    <h5>Upper</h5>
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           name="progUpperRate"
						                                           placeholder="Upper Tax Rate 00%">
						                                    <input type="number"
						                                           step="0.01"
						                                           class="investment-input"
						                                           name="progUpperThreshold"
						                                           placeholder="Upper Threshold 00">
						                                </div>
						                            </div>
						
						                        </div>
						
						                        <div class="investment-action-row mt-4">
						                            <button type="submit" class="btn-glow ms-auto">Create and Activate</button>
						                        </div>
						                    </form>
						                </div>
						            </div>
						        </div>
						
						    </div>
						</c:if>

                        <!-- =========================
                             HISTORY SECTION
                        ========================= -->
                        <c:if test="${activeSection eq 'history'}">

                            <div class="investment-title-card">
                                <h3>History</h3>
                                <p>Review previous versions of plan rules and tax settings.</p>
                            </div>

                            <div class="investment-panel-card">
                                <div class="investment-card-inner">

                                    <div class="investment-history-tabs">
                                        <a href="${pageContext.request.contextPath}/admin/investment/history"
                                           class="investment-history-tab ${activeHistoryTab eq 'plan' ? 'active' : ''}">
                                            Show Plan Rule History
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/investment/history/tax${param.fromChangeFlow eq 'true' ? '?fromChangeFlow=true' : ''}"
                                           class="investment-history-tab ${activeHistoryTab eq 'tax' ? 'active' : ''}">
                                            Show Tax Settings History
                                        </a>
                                    </div>

                                    <!-- PLAN HISTORY -->
                                    <c:if test="${activeHistoryTab eq 'plan'}">
                                        <c:choose>
                                            <c:when test="${not empty planRulesHistory}">
                                                <div class="table-responsive">
                                                    <table class="table investment-history-table">
                                                        <thead>
                                                        <tr>
                                                            <th>Version</th>
                                                            <th>Date Created</th>
                                                            <th>Date Last Used</th>
                                                            <th>Status</th>
                                                            <th>View</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="item" items="${planRulesHistory}">
                                                            <tr>
                                                                <td>Version ${item.planSetId}</td>
                                                                <td><fmt:formatDate value="${item.createdAt}" pattern="MMM dd, yyyy hh:mm a"/></td>
                                                                <td><fmt:formatDate value="${item.createdAt}" pattern="MMM dd, yyyy hh:mm a"/></td>
                                                                <td>
                                                                    <span class="investment-status-badge ${item.active ? 'active' : 'inactive'}">
                                                                        ${item.active ? 'Active' : 'Inactive'}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <button type="button"
                                                                            class="btn-glow-outline btn-sm view-plan-history-btn"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#planHistoryDetailsModal"
                                                                            data-plan-set-id="${item.planSetId}">
                                                                        View
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="investment-empty-state">
                                                    <h4>No plan rule history yet</h4>
                                                    <p>Saved plan rule versions will appear here.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <!-- TAX HISTORY -->
                                    <c:if test="${activeHistoryTab eq 'tax'}">
                                        <c:choose>
                                            <c:when test="${not empty taxSettingsHistory}">
                                                <div class="table-responsive">
                                                    <table class="table investment-history-table">
                                                        <thead>
                                                        <tr>
                                                            <th>Version</th>
                                                            <th>Date Created</th>
                                                            <th>Date Last Used</th>
                                                            <th>Status</th>
                                                            <th>View</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="tax" items="${taxSettingsHistory}">
                                                            <tr>
                                                                <td>Version ${tax.taxSetId}</td>
                                                                <td><fmt:formatDate value="${tax.createdAt}" pattern="MMM dd, yyyy hh:mm a"/></td>
                                                                <td><fmt:formatDate value="${tax.createdAt}" pattern="MMM dd, yyyy hh:mm a"/></td>
                                                                <td>
                                                                    <span class="investment-status-badge ${tax.active ? 'active' : 'inactive'}">
                                                                        ${tax.active ? 'Active' : 'Inactive'}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <button type="button"
																	        class="btn-glow-outline btn-sm view-tax-history-btn"
																	        data-bs-toggle="modal"
																	        data-bs-target="#taxHistoryDetailsModal"
																	        data-tax-set-id="${tax.taxSetId}"
																	        data-tax-id="${tax.id}"
																	        data-tax-type="${tax.taxType}"
																	        data-tax-free-allowance="${tax.taxFreeAllowance}"
																	        data-lower-tax-rate="${tax.lowerTaxRate}"
																	        data-lower-tax-threshold="${tax.lowerTaxThreshold}"
																	        data-upper-tax-rate="${tax.upperTaxRate}"
																	        data-upper-tax-threshold="${tax.upperTaxThreshold}"
																	        data-is-active="${tax.active}">
																	    View
																	</button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="investment-empty-state">
                                                    <h4>No tax settings history yet</h4>
                                                    <p>Saved tax settings versions will appear here.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                </div>
                            </div>

                        </c:if>

                    </div>

                    <!-- RIGHT MODULE SIDEBAR -->
                    <div class="col-lg-3">
                        <div class="investment-module-sidebar-wrap">
                            <div class="investment-module-sidebar">

                                <a href="${pageContext.request.contextPath}/admin/investment"
                                   class="investment-module-logo-link ${activeNav eq 'active-rules' ? 'active' : ''}">
                                    <div class="module-logo-icon">¤</div>
                                    <div>
                                        <strong>Investment Rules</strong>
                                        <small>Active Rules</small>
                                    </div>
                                </a>

                                <nav class="investment-module-nav">
                                    <a href="${pageContext.request.contextPath}/admin/investment/plan-rules"
                                       class="investment-module-nav-link ${activeNav eq 'plan-rules' ? 'active' : ''}">
                                        Create New Plan Rule
                                    </a>

                                    <a href="${pageContext.request.contextPath}/admin/investment/tax-settings"
                                       class="investment-module-nav-link ${activeNav eq 'tax-settings' ? 'active' : ''}">
                                        Create New Tax Settings
                                    </a>

                                    <a href="${pageContext.request.contextPath}/admin/investment/history"
                                       class="investment-module-nav-link ${activeNav eq 'history' ? 'active' : ''}">
                                        History
                                    </a>
                                </nav>

                            </div>
                        </div>
                    </div>

                </div>
            </section>

        </main>

        <jsp:include page="/WEB-INF/components/Authenticated/footer.jsp" />

    </div>
</div>

<!-- ACTIVE TAX DETAILS MODAL -->
<div class="modal fade" id="activeTaxDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content investment-modal-card">
            <div class="modal-body">
                <div class="investment-modal-head">
                    <h3>Active Tax Settings Details</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <c:if test="${not empty activeTaxSettings}">
                    <div class="investment-tax-display modal-tax-display">
                        <div class="investment-tax-display-item"><span>Tax Type</span><strong>${activeTaxSettings.taxType}</strong></div>
                        <div class="investment-tax-display-item"><span>Tax Free Allowance</span><strong>£<fmt:formatNumber value="${activeTaxSettings.taxFreeAllowance}" minFractionDigits="2" maxFractionDigits="2"/></strong></div>
                        <div class="investment-tax-display-item"><span>Lower Tax Rate</span><strong><fmt:formatNumber value="${activeTaxSettings.lowerTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                        <div class="investment-tax-display-item"><span>Lower Threshold</span><strong><c:choose><c:when test="${not empty activeTaxSettings.lowerTaxThreshold}">£<fmt:formatNumber value="${activeTaxSettings.lowerTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>-</c:otherwise></c:choose></strong></div>
                        <div class="investment-tax-display-item"><span>Upper Tax Rate</span><strong><fmt:formatNumber value="${activeTaxSettings.upperTaxRate}" minFractionDigits="2" maxFractionDigits="2"/>%</strong></div>
                        <div class="investment-tax-display-item"><span>Upper Threshold</span><strong><c:choose><c:when test="${not empty activeTaxSettings.upperTaxThreshold}">£<fmt:formatNumber value="${activeTaxSettings.upperTaxThreshold}" minFractionDigits="2" maxFractionDigits="2"/></c:when><c:otherwise>-</c:otherwise></c:choose></strong></div>
                    </div>
                </c:if>

                <div class="investment-action-row justify-content-end mt-4">
                    <button type="button" class="btn-glow-outline" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- PLAN HISTORY DETAILS MODAL -->
<div class="modal fade" id="planHistoryDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content investment-modal-card">
            <div class="modal-body">
                <div class="investment-modal-head">
                    <h3>Plan Rule Details</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="investment-plan-tabs" data-tab-group="plan-history-modal-tabs">
                    <button type="button" class="investment-tab-btn active" data-tab-target="modal-plan-basic">Basic Savings</button>
                    <button type="button" class="investment-tab-btn" data-tab-target="modal-plan-plus">Savings Plus</button>
                    <button type="button" class="investment-tab-btn" data-tab-target="modal-plan-managed">Managed Stocks</button>
                </div>

                <div class="investment-tab-panels">
                    <div class="investment-tab-panel active" id="modal-plan-basic">
                        <div class="investment-info-grid">
                            <div><span>Maximum Investment/Year</span><strong id="modal-basic-yearly-limit">-</strong></div>
                            <div><span>Minimum Monthly</span><strong id="modal-basic-monthly">-</strong></div>
                            <div><span>Minimum Initial Lump Sum</span><strong id="modal-basic-initial">-</strong></div>
                            <div><span>Min Return</span><strong id="modal-basic-min-return">-</strong></div>
                            <div><span>Max Return</span><strong id="modal-basic-max-return">-</strong></div>
                            <div><span>Monthly Fee</span><strong id="modal-basic-fee">-</strong></div>
                        </div>
                    </div>

                    <div class="investment-tab-panel" id="modal-plan-plus">
                        <div class="investment-info-grid">
                            <div><span>Maximum Investment/Year</span><strong id="modal-plus-yearly-limit">-</strong></div>
                            <div><span>Minimum Monthly</span><strong id="modal-plus-monthly">-</strong></div>
                            <div><span>Minimum Initial Lump Sum</span><strong id="modal-plus-initial">-</strong></div>
                            <div><span>Min Return</span><strong id="modal-plus-min-return">-</strong></div>
                            <div><span>Max Return</span><strong id="modal-plus-max-return">-</strong></div>
                            <div><span>Monthly Fee</span><strong id="modal-plus-fee">-</strong></div>
                        </div>
                    </div>

                    <div class="investment-tab-panel" id="modal-plan-managed">
                        <div class="investment-info-grid">
                            <div><span>Maximum Investment/Year</span><strong id="modal-managed-yearly-limit">-</strong></div>
                            <div><span>Minimum Monthly</span><strong id="modal-managed-monthly">-</strong></div>
                            <div><span>Minimum Initial Lump Sum</span><strong id="modal-managed-initial">-</strong></div>
                            <div><span>Min Return</span><strong id="modal-managed-min-return">-</strong></div>
                            <div><span>Max Return</span><strong id="modal-managed-max-return">-</strong></div>
                            <div><span>Monthly Fee</span><strong id="modal-managed-fee">-</strong></div>
                        </div>
                    </div>
                </div>

                <div class="investment-action-row justify-content-end mt-4">
                    <button type="button" class="btn-glow-outline" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- TAX HISTORY DETAILS MODAL -->
<div class="modal fade" id="taxHistoryDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content investment-modal-card">
            <div class="modal-body">
                <div class="investment-modal-head">
                    <h3>Tax Settings Details</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="investment-tax-display modal-tax-display">
                    <div class="investment-tax-display-item"><span>Tax Type</span><strong id="history-tax-type">-</strong></div>
                    <div class="investment-tax-display-item"><span>Tax Free Allowance</span><strong id="history-tax-free-allowance">-</strong></div>
                    <div class="investment-tax-display-item"><span>Lower Tax Rate</span><strong id="history-lower-tax-rate">-</strong></div>
                    <div class="investment-tax-display-item"><span>Lower Threshold</span><strong id="history-lower-tax-threshold">-</strong></div>
                    <div class="investment-tax-display-item"><span>Upper Tax Rate</span><strong id="history-upper-tax-rate">-</strong></div>
                    <div class="investment-tax-display-item"><span>Upper Threshold</span><strong id="history-upper-tax-threshold">-</strong></div>
                </div>

                <form id="activateTaxSettingsForm"
			      action="${pageContext.request.contextPath}/admin/investment/tax-settings/activate"
			      method="post">
			    <input type="hidden" name="taxSetId" id="activateTaxSetId">
			    <input type="hidden" name="fromChangeFlow" value="${fromChangeFlow}">
			</form>

                <div class="investment-action-row justify-content-end mt-4">
                    <button type="button" class="btn-glow-outline" data-bs-dismiss="modal">Close</button>
                    <button type="button" id="openActivateConfirmBtn" class="btn-glow">Activate Tax Settings</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ACTIVATE CONFIRM MODAL -->
<div class="modal fade" id="activateConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content investment-modal-card">
            <div class="modal-body">
                <div class="investment-confirm-box">
                    <h3>Activate Tax Settings</h3>
                    <p>Are you sure you want to apply this tax settings version?</p>

                    <div class="investment-action-row justify-content-center">
                        <button type="button" class="btn-glow-outline" data-bs-dismiss="modal">Select Again</button>
                        <button type="button" id="confirmActivateTaxBtn" class="btn-glow">Yes</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- PLAN HISTORY DATA -->
<script>
    window.planHistoryDetails = {
        <c:forEach var="plan" items="${allPlanRuleRowsForModal}" varStatus="status">
        "${plan.planSetId}_${plan.planType}": {
            planSetId: "${plan.planSetId}",
            planType: "${plan.planType}",
            yearlyInvestmentLimit: "${plan.yearlyInvestmentLimit}",
            minMonthlyRequired: "${plan.minMonthlyRequired}",
            minInitialRequired: "${plan.minInitialRequired}",
            minReturnRate: "${plan.minReturnRate}",
            maxReturnRate: "${plan.maxReturnRate}",
            monthlyFeeRate: "${plan.monthlyFeeRate}"
        }<c:if test="${not status.last}">,</c:if>
        </c:forEach>
    };

    window.investmentPageConfig = {
        activeSection: "${empty activeSection ? 'active-rules' : activeSection}",
        activeHistoryTab: "${activeHistoryTab}",
        planRuleStep: "${empty planRuleStep ? 'basic' : planRuleStep}",
        selectedTaxMode: "${empty selectedTaxMode ? 'ACTIVE' : selectedTaxMode}",
        embeddedTaxSaved: "${embeddedTaxSaved}",
        fromChangeFlow: "${param.fromChangeFlow}"
    };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin/admin-investment.js"></script>

</body>
</html>