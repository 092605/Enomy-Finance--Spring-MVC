<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                                           name="initialInvestment"
                                           class="enomy-input"
                                           placeholder="Enter amount">
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
                                           name="monthlyContribution"
                                           class="enomy-input"
                                           placeholder="Enter amount">
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
                                        <span class="selected-value">Basic Savings Plan</span>
                                        <span class="dropdown-arrow">
                                            <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
                                                <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
                                            </svg>
                                        </span>
                                    </button>

                                    <div class="custom-dropdown-menu">
                                        <div class="custom-dropdown-item active" data-value="basic">Basic Savings Plan</div>
                                        <div class="custom-dropdown-item" data-value="plus">Savings Plan Plus</div>
                                        <div class="custom-dropdown-item" data-value="managed">Managed Stock Investments</div>
                                    </div>
                                </div>

                                <input type="hidden" name="investmentPlan" id="investmentPlanValue" value="basic">
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
					                                        <h3 class="plan-details-title">Option 1 – Basic Savings Plan</h3>
					
					                                        <ul class="plan-details-list">
					                                            <li><span class="plan-bullet"></span><span>Maximum investment per year: <span class="plan-strong">£20,000</span></span></li>
					                                            <li><span class="plan-bullet"></span><span>Minimum monthly investment: <span class="plan-strong">£50</span></span></li>
					                                            <li><span class="plan-bullet"></span><span>Minimum initial investment lump sum: <span class="plan-strong">N/A</span></span></li>
					                                            <li><span class="plan-bullet"></span><span>Predicted returns per year: <span class="plan-highlight">1.2% to 2.4%</span></span></li>
					                                            <li><span class="plan-bullet"></span><span>Estimated tax: <span class="plan-strong">0%</span></span></li>
					                                            <li><span class="plan-bullet"></span><span>RBSX group fees per month: <span class="plan-strong">0.25%</span></span></li>
					                                        </ul>
					                                    </div>
					                                </div>
					                            </div>
					
					                        </div>
					                    </div>
					
					                    <!-- Result -->
					                    <div class="col-lg-6">
					                        <div class="investment-result-panel">
					                            <div class="investment-card-inner result-box">
					
					                                <h3 class="result-plan-title">Basic Savings Plan</h3>
					
					                                <div class="result-range-tabs">
					                                    <button type="button" class="result-tab-btn active">1 Year</button>
					                                    <button type="button" class="result-tab-btn">5 Years</button>
					                                    <button type="button" class="result-tab-btn">10 Years</button>
					                                </div>
					
					                                <div class="result-summary-table">
					                                    <div class="result-summary-row">
					                                        <span class="result-label">Initial Lump Sum</span>
					                                        <span class="result-value">₱14,324.00</span>
					                                    </div>
					                                    <div class="result-summary-row">
					                                        <span class="result-label">Monthly Investment</span>
					                                        <span class="result-value">₱500.00</span>
					                                    </div>
					                                </div>
					
					                                <div class="result-total-invested">
					                                    <span>Total Invested Amount</span>
					                                    <strong>₱20,324.00</strong>
					                                </div>
					
					                                <div class="result-dashed-divider"></div>
					
					                                <div class="result-section">
					                                    <h4 class="result-section-title">Return &amp; Profits</h4>
					                                    <div class="result-grid-two">
					                                        <div class="result-metric-block"><span class="result-metric-label">Min Return</span><span class="result-metric-value">0000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Min Profit</span><span class="result-metric-value">0000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Max Return</span><span class="result-metric-value">000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Max Profit</span><span class="result-metric-value">000</span></div>
					                                    </div>
					                                </div>
					
					                                <div class="result-dashed-divider"></div>
					
					                                <div class="result-section">
					                                    <h4 class="result-section-title">Tax &amp; Fee</h4>
					                                    <div class="result-grid-two">
					                                        <div class="result-metric-block"><span class="result-metric-label">Min Tax</span><span class="result-metric-value">0000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Monthly Fee</span><span class="result-metric-value">0000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Max Tax</span><span class="result-metric-value">000</span></div>
					                                        <div class="result-metric-block"><span class="result-metric-label">Total Fee</span><span class="result-metric-value">000</span></div>
					                                    </div>
					                                </div>
					
					                                <div class="result-actions">
					                                    <button type="button" class="btn-glow-outline result-discard-btn">Discard</button>
					                                    <button type="button" class="btn-glow result-save-btn">Save Quote</button>
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
					                        <p class="dashboard-card-value SumCount">1</p>
					                        <button type="button" class="btn-glow">View All</button>
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
</body>
</html>