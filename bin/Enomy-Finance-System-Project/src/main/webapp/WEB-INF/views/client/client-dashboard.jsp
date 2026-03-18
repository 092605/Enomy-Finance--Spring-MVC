


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Dashboard | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
</head>

<body class="dashboard-page">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/components/Authenticated/sidebar.jsp" />

        <div class="dashboard-main" id="dashboardMain">

            <jsp:include page="/WEB-INF/components/Authenticated/topbar.jsp" />

            <main class="dashboard-content">

                <!-- Welcome Section -->
                <section class="dashboard-welcome">
                    <h1>Hello, ${fullName}</h1>
                    <p class="Welcome-sub">Here is an overview of your financial activity.</p>
                </section>

                <!-- Top Summary Cards -->
                <section class="dashboard-section">
                    <div class="row g-5">

                        <div class="col-xl-3 col-md-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Investment Quotes</h5>
                                </div>
                                <div class="dashboard-card-body Inv-Count">
                                    <p class="dashboard-card-value SumCount">1</p>
                                    <button class="btn-glow">View All</button>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-5 col-md-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Contribution Tracker</h5>
                                </div>
                                <div class="dashboard-card-body">
                                    <p class="mb-2">Basic Savings Plan</p>
                                    <div class="tracker-bar">
                                        <div class="tracker-bar-fill"></div>
                                    </div>
                                    <p class="text-muted mt-3 mb-2">Next Due: Aug 30, 2026</p>

                                    <div class="d-flex flex-wrap gap-2 align-items-center">
                                        <span class="tracker-progress">3 / 12 months</span>
                                        <button class="btn-glow-outline">Mark as Paid</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                       <div class="col-xl-4 col-md-12">
						    <div class="card-glow dashboard-card h-100">
						        <div class="dashboard-card-header">
						            <h5>Investment Projection</h5>
						        </div>
						        <div class="dashboard-card-body">
						            <p class="dashboard-card-value projection">₱150,000.00</p>
						            <p class="text-muted mb-3">Estimated after 1 year</p>
						
						           <div class="projection-actions">
									    <button class="btn-glow">View Projection</button>
									
									    <div class="custom-dropdown" id="projectionDropdown">
									        <button class="custom-dropdown-toggle" type="button">
									            <span class="selected-value">1 Year</span>
									            <span class="dropdown-arrow">
												    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
												        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
												    </svg>
												</span>
									        </button>
									
									        <div class="custom-dropdown-menu">
									            <div class="custom-dropdown-item active" data-value="1">1 Year</div>
									            <div class="custom-dropdown-item" data-value="5">5 Years</div>
									            <div class="custom-dropdown-item" data-value="10">10 Years</div>
									        </div>
									    </div>
									</div>
						        </div>
						    </div>
						</div>

                    </div>
                </section>

              <!-- Enomy Finance Tools -->
				<section class="dashboard-section">
				
				
				    <div class="section-title-wrap mb-5">
				        <h3>Enomy Finance Tools</h3>
				    </div>
				
				    <!-- Row 1 -->
				    <div class="row g-5">
				
				        <!-- Currency Converter -->
				        <div class="col-lg-3">
				            <div class="card-glow dashboard-card h-100">
				                <div class="dashboard-card-header">
				                    <h5>Currency Converter</h5>
				                </div>
				                
				                 <div class="header-divider"></div>
				
				                <div class="dashboard-card-body mt-5">

								    <!-- Row 1: Base + Target -->
								    <div class="row g-3">

									    <!-- Base -->
									    <div class="col-6">
									        <label class="form-label">Base</label>
									
									        <div class="custom-dropdown currency-dropdown">
									            <button class="custom-dropdown-toggle" type="button">
									            <span class="selected-value">GBP</span>
									            <span class="dropdown-arrow">
												    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
												        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
												    </svg>
												</span>
									        </button>
									
									            <div class="custom-dropdown-menu">
									                <div class="custom-dropdown-item active" data-value="GBP">GBP</div>
									                <div class="custom-dropdown-item" data-value="USD">USD</div>
									                <div class="custom-dropdown-item" data-value="EUR">EUR</div>
									            </div>
									        </div>
									    </div>
									
									    <!-- Target -->
									    <div class="col-6">
									        <label class="form-label">Target</label>
									
									        <div class="custom-dropdown currency-dropdown">
									            <button class="custom-dropdown-toggle" type="button">
									                <span class="selected-value">USD</span>
									                <span class="dropdown-arrow">
													    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
													        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
													    </svg>
													</span>
									            </button>
									
									            <div class="custom-dropdown-menu">
									                <div class="custom-dropdown-item active" data-value="USD">USD</div>
									                <div class="custom-dropdown-item" data-value="GBP">GBP</div>
									                <div class="custom-dropdown-item" data-value="EUR">EUR</div>
									            </div>
									        </div>
									    </div>
									
									</div>
								
								    <!-- Middle: Result -->
								    <div class="dashboard-result-box mt-4 text-center">
								        Calculation Result...
								    </div>
								
								    <!-- Row 2: Input + Button -->
								   <div class="d-flex gap-2 mt-5">
									    <input type="text" class="form-control dashboard-input flex-grow-1" placeholder="Input amount...">
									
									    <button class="btn-glow">
									        Calculate
									    </button>
									</div>
								
								</div>
				            </div>
				        </div>
				
				        <!-- Currency Rates -->
				        <div class="col-lg-3">
				            <div class="card-glow dashboard-card h-100 ">
				                <div class="dashboard-card-header">
				                    <h5>Currency Rates</h5>
				                </div>
				                
				                <div class="header-divider"></div>
				
				              <div class="dashboard-card-body mt-5">
								
								    <!-- Row 1: Base + Target -->
								    <div class="row g-3">
								        <div class="col-6">
								            <label class="form-label">Base</label>
								
								            <div class="custom-dropdown currency-dropdown">
								                <button class="custom-dropdown-toggle" type="button">
								                    <span class="selected-value">GBP</span>
								                    <span class="dropdown-arrow">
													    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
													        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
													    </svg>
													</span>
								                </button>
								
								                <div class="custom-dropdown-menu">
								                    <div class="custom-dropdown-item active" data-value="GBP">GBP</div>
								                    <div class="custom-dropdown-item" data-value="USD">USD</div>
								                    <div class="custom-dropdown-item" data-value="EUR">EUR</div>
								                </div>
								            </div>
								        </div>
								
								        <div class="col-6">
								            <label class="form-label">Target</label>
								
								            <div class="custom-dropdown currency-dropdown">
								                <button class="custom-dropdown-toggle" type="button">
								                    <span class="selected-value">USD</span>
								                    <span class="dropdown-arrow">
													    <svg width="16" height="16" viewBox="0 0 20 20" fill="none">
													        <path d="M6 8L10 12L14 8" stroke="white" stroke-width="2" stroke-linecap="round"/>
													    </svg>
													</span>
								                </button>
								
								                <div class="custom-dropdown-menu">
								                    <div class="custom-dropdown-item active" data-value="USD">USD</div>
								                    <div class="custom-dropdown-item" data-value="GBP">GBP</div>
								                    <div class="custom-dropdown-item" data-value="EUR">EUR</div>
								                </div>
								            </div>
								        </div>
								    </div>
								
								    <!-- Row 2: Rate Result -->
								    <div class="dashboard-result-box mt-4 text-center">
								        Rate Result...
								    </div>
								
								    <!-- Row 3: Button -->
								   <div class="rate-actions mt-5">
									    <button class="btn-glow">Check Rate</button>
									
									    <span class="rate-updated">
									        Rates last synced: <br><strong>Aug 20, 2026 • 10:00 AM</strong></br>
									    </span>
									</div>
								
								</div>
				            </div>
				        </div>
				
				        <!-- Investment Plans -->
							<div class="col-lg-6 d-flex justify-content-center">
							
							
                               <div class="card-glow dashboard-card h-100 investment-card">
                               
							        <div class="dashboard-card-header">
							            <h5>Investment Plans</h5>
							        </div>
							
							        <div class="dashboard-card-body investment-plans-card">
							
							            <!-- Plan Tabs -->
							            <div class="plan-selector">
							                <button class="plan-tab active" type="button" data-plan-id="1">Option 1</button>
							                <button class="plan-tab" type="button" data-plan-id="2">Option 2</button>
							                <button class="plan-tab" type="button" data-plan-id="3">Option 3</button>
							            </div>
							
							            <!-- Plan Overview -->
							            <div class="plan-overview card-glass">
							                <h6 class="plan-title">Option 1 – Basic Savings Plan</h6>
							
							                <div class="plan-divider"></div>
							                
							                
											<div class="plan-details-scroll">	
								                <ul class="plan-details-list">
								                    <li>
								                        <span class="detail-label">Maximum investment per year:</span>
								                        <span class="plan-detail-value" data-field="maxInvestment">£20 000</span>
								                    </li>
								                    <li>
								                        <span class="detail-label">Minimum monthly investment:</span>
								                        <span class="plan-detail-value" data-field="minMonthly">£50</span>
								                    </li>
								                    <li>
								                        <span class="detail-label">Minimum initial investment lump sum:</span>
								                        <span class="plan-detail-value" data-field="minLumpSum">N/A</span>
								                    </li>
								                    <li>
								                        <span class="detail-label">Predicted returns per year:</span>
								                        <span class="plan-detail-value" data-field="returns">1.2% to 2.4%</span>
								                    </li>
								                    <li>
								                        <span class="detail-label">Estimated tax:</span>
								                        <span class="plan-detail-value" data-field="tax">0%</span>
								                    </li>
								                    <li>
								                        <span class="detail-label">Group fees per month:</span>
								                        <span class="plan-detail-value" data-field="fees">0.25%</span>
								                    </li>
								                </ul>
														                
							                </div>
							                
							                <div class="plan-divider bottom-divider"></div>
							                <div class="plan-actions">
								                    <button class="btn-glow use-plan-btn" type="button">Use This Plan</button>
								            </div>
							            </div>
							
							        </div>
							    </div>
							</div>
				
				    </div>
				
				    <!-- Row 2 -->
				    <div class="row g-4 recent-activity-row">
					    <div class="col-12">
					        <div class="card-glow dashboard-card dashboard-list-card mb-5">
					            <div class="dashboard-card-header dashboard-list-header">
					                <div>
					                    <h5>Recent Transactions</h5>
					                    <p class="dashboard-list-subtitle">Latest conversions, quotes, and investment-related activity</p>
					                </div>
					            </div>
					
					            <div class="dashboard-card-body">
					                <div class="table-responsive">
					                    <table class="table dashboard-table dashboard-list-table align-middle">
					                        <thead>
					                            <tr>
					                                <th>#</th>
					                                <th>Date</th>
					                                <th>Activity</th>
					                                <th>Category</th>
					                                <th>Status</th>
					                                <th>Action</th>
					                            </tr>
					                        </thead>
					                        <tbody>
					                            <tr>
					                                <td>
					                                    <span class="list-index-badge">01</span>
					                                </td>
					                                <td>Aug 15, 2026</td>
					                                <td>USD → GBP Conversion</td>
					                                <td>Currency Converter</td>
					                                <td><span class="status-badge status-success">Completed</span></td>
					                                <td><button class="btn-glow-outline btn-sm">View</button></td>
					                            </tr>
					
					                            <tr>
					                                <td>
					                                    <span class="list-index-badge">02</span>
					                                </td>
					                                <td>Aug 10, 2026</td>
					                                <td>Saved Investment Quote</td>
					                                <td>Investment Plans</td>
					                                <td><span class="status-badge status-info">Saved</span></td>
					                                <td><button class="btn-glow-outline btn-sm">View</button></td>
					                            </tr>
					
					                            <tr>
					                                <td>
					                                    <span class="list-index-badge">03</span>
					                                </td>
					                                <td>Jul 8, 2026</td>
					                                <td>GBP → EUR Conversion</td>
					                                <td>Currency Rates</td>
					                                <td><span class="status-badge status-success">Checked</span></td>
					                                <td><button class="btn-glow-outline btn-sm">View</button></td>
					                            </tr>
					                        </tbody>
					                    </table>
					                </div>
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









<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
</html> --%>

