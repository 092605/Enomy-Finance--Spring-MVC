

<%-- =========================================================
     JSP FILE DESCRIPTION
     =========================================================
     File Name:
     savings-investment.jsp

     Purpose:
     This JSP file serves as the authenticated Savings
     and Investment module page for the Enomy Finance system.

     Overview:
     This page allows authenticated clients to calculate
     investment projections, view investment plan details,
     save investment quotes, and review previously saved
     investment quote records.

     Main Features:
     - Investment plan calculator
     - Initial lump sum input
     - Monthly contribution input
     - Investment plan selection
     - Dynamic plan details display
     - 1 year, 5 years, and 10 years projection results
     - Minimum and maximum return display
     - Profit, tax, and fee calculation display
     - Save investment quote functionality
     - Saved quotes count summary
     - Saved investment quote table
     - Modal-based saved quote detail viewing
     - Inline success and error messaging
     - Dynamic JavaScript plan switching

     CONNECTED RESOURCES

     CSS
     - theme.css
     - components.css
     - inline-messages.css
     - client-investment.css
     - client-dashboard.css
     - bootstrap.min.css

     JavaScript
     - client-dashboard.js
     - inline-messages.js
     - components.js
     - client-investment.js

     JSP COMPONENTS
     - client/sidebar.jsp
     - client/topbar.jsp
     - client/footer.jsp

     JAVA CLASSES

     Controllers
     - InvestmentController
     - ClientGlobalModel

     Services
     - InvestmentService
     - InvestmentServiceImpl

     DAO Layer
     - InvestmentQuoteDao
     - InvestmentQuoteDaoImpl
     - PlanRulesDao
     - PlanRulesDaoImpl
     - TaxSettingsDao
     - TaxSettingsDaoImpl

     Models
     - InvestmentQuote
     - PlanRules
     - TaxSettings
     - User

     DTO Classes
     - InvestmentRequestDTO
     - InvestmentResponseDTO
     - YearlyInvestmentResultDTO
     - PlanDetailsDTO

     Security Classes
     - SecurityConfig
     - CustomUserDetails
     - CustomAuthenticationSuccessHandler

     Purpose of Java Class Usage:
     - Handles authenticated investment page routing
     - Processes investment projection calculations
     - Retrieves active investment plan details
     - Applies active plan rules and tax settings
     - Calculates return, profit, tax, and fee values
     - Saves investment quote records
     - Retrieves saved investment quote history
     - Supports modal-based quote detail viewing
     - Supplies authenticated client information
     - Supports secured client-side access control

     Module:
     Web Development Foundations (WDF)

     System:
     Enomy Finance Web Application

     ========================================================= --%>




<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="currentPlanType"
	value="${empty investmentRequest.planType ? 'BASIC_SAVINGS' : investmentRequest.planType}" />
<c:set var="currentResult"
	value="${hasCalculated ? investmentResponse.oneYear : null}" />

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Savings & Investment | Enomy Finance</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/theme.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/components.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/inline-messages.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/client/client-investment.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
</head>

<body class="dashboard-page">

	<div class="dashboard-layout">

		<jsp:include
			page="/WEB-INF/components/Authenticated//client/sidebar.jsp" />

		<div class="dashboard-main" id="dashboardMain">

			<jsp:include
				page="/WEB-INF/components/Authenticated/client/topbar.jsp" />

			<main class="dashboard-content savings-page">

				<div class="investment-page-header">
					<h1 class="investment-page-title">Enomy Finance</h1>
					<h2 class="investment-page-subtitle">Investment Plan</h2>
				</div>

				<section class="investment-section-view" id="investmentMainSection">
					<section class="investment-split-card">
						<div class="row g-4 align-items-start">

							<div class="col-lg-9">

								<div class="row g-4 investment-split-row">

									<div class="col-lg-6">
										<div class="row g-4">

											<!-- Calculator -->
											<div class="col-12">
												<div class="investment-left-panel">
													<div class="investment-card-inner Inv-Calc">
														<div class="investment-panel-block">
															<h3 class="investment-card-title">Investment Plan
																Calculator</h3>

															<form
																action="${pageContext.request.contextPath}/client/investment/calculate"
																method="post">

																<div class="row">
																	<div class="col-md-6">
																		<div class="investment-form-group">
																			<label for="initialInvestment">Initial
																				Investment (£)</label>
																			<div class="enomy-input-wrap">
																				<span class="enomy-prefix">£</span> <input
																					type="number" step="0.01" id="initialInvestment"
																					name="initialLumpSum" class="enomy-input"
																					placeholder="Enter amount"
																					value="${investmentRequest.initialLumpSum}">
																			</div>
																		</div>
																	</div>

																	<div class="col-md-6">
																		<div class="investment-form-group">
																			<label for="monthlyContribution">Monthly
																				Contribution (£)</label>
																			<div class="enomy-input-wrap">
																				<span class="enomy-prefix">£</span> <input
																					type="number" step="0.01" id="monthlyContribution"
																					name="monthlyInvestment" class="enomy-input"
																					placeholder="Enter amount"
																					value="${investmentRequest.monthlyInvestment}">
																			</div>
																		</div>
																	</div>
																</div>

																<div class="row align-items-end">
																	<c:set var="selectedPlanType"
																		value="${empty investmentRequest.planType ? 'BASIC_SAVINGS' : investmentRequest.planType}" />

																	<div class="col-md-6">
																		<div class="investment-form-group">
																			<label>Select Investment Plan</label>

																			<div class="custom-dropdown investment-dropdown"
																				id="investmentPlanDropdown">
																				<button class="custom-dropdown-toggle" type="button">
																					<span class="selected-value"> <c:choose>
																							<c:when
																								test="${selectedPlanType eq 'BASIC_SAVINGS'}">Basic Savings Plan</c:when>
																							<c:when
																								test="${selectedPlanType eq 'SAVINGS_PLUS'}">Savings Plan Plus</c:when>
																							<c:when
																								test="${selectedPlanType eq 'MANAGED_STOCKS'}">Managed Stock Investments</c:when>
																							<c:otherwise>Investment Quote Result</c:otherwise>
																						</c:choose>
																					</span> <span class="dropdown-arrow"> <svg
																							width="16" height="16" viewBox="0 0 20 20"
																							fill="none">
                                                                                            <path
																								d="M6 8L10 12L14 8" stroke="white"
																								stroke-width="2" stroke-linecap="round" />
                                                                                        </svg>
																					</span>
																				</button>

																				<div class="custom-dropdown-menu">
																					<div
																						class="custom-dropdown-item ${selectedPlanType eq 'BASIC_SAVINGS' ? 'active' : ''}"
																						data-value="BASIC_SAVINGS">Basic Savings
																						Plan</div>
																					<div
																						class="custom-dropdown-item ${selectedPlanType eq 'SAVINGS_PLUS' ? 'active' : ''}"
																						data-value="SAVINGS_PLUS">Savings Plan Plus</div>
																					<div
																						class="custom-dropdown-item ${selectedPlanType eq 'MANAGED_STOCKS' ? 'active' : ''}"
																						data-value="MANAGED_STOCKS">Managed Stock
																						Investments</div>
																				</div>
																			</div>

																			<input type="hidden" name="planType"
																				id="investmentPlanValue" value="${selectedPlanType}">
																		</div>
																	</div>

																	<div class="col-md-6">
																		<div class="investment-form-group">
																			<label class="invisible">Calculate Projection</label>
																			<button type="submit"
																				class="btn-glow calculate-projection-btn w-100">
																				Calculate Projection</button>
																		</div>
																	</div>
																</div>

															</form>

															<div id="investmentCalcError"
																class="inline-error-message mt-3"></div>
															<div id="investmentCalcSuccess"
																class="inline-success-message mt-3"></div>

														</div>
													</div>
												</div>
											</div>

											<!-- Plan Details -->
											<div class="col-12">
												<div class="investment-middle-panel">
													<div class="investment-card-inner plan-details-box"
														id="planDetailsBox">

														<h3 class="plan-details-title" id="planDetailsTitle">${planDetails.title}</h3>

														<ul class="plan-details-list">
															<li><span class="plan-bullet"></span> <span>Maximum
																	investment per year: <span class="plan-strong"
																	id="planMaxInvestment">${planDetails.maximumInvestmentPerYear}</span>
															</span></li>
															<li><span class="plan-bullet"></span> <span>Minimum
																	monthly investment: <span class="plan-strong"
																	id="planMinMonthly">${planDetails.minimumMonthlyInvestment}</span>
															</span></li>
															<li><span class="plan-bullet"></span> <span>Minimum
																	initial investment lump sum: <span class="plan-strong"
																	id="planMinLumpSum">${planDetails.minimumInitialInvestmentLumpSum}</span>
															</span></li>
															<li><span class="plan-bullet"></span> <span>Predicted
																	returns per year: <span class="plan-highlight"
																	id="planReturns">${planDetails.predictedReturnsPerYear}</span>
															</span></li>
															<li><span class="plan-bullet"></span> <span>Estimated
																	tax: <span class="plan-strong" id="planTax"> <c:out
																			value="${planDetails.estimatedTax}" escapeXml="false" />
																</span>
															</span></li>
															<li><span class="plan-bullet"></span> <span>RBSX
																	group fees per month: <span class="plan-strong"
																	id="planFees">${planDetails.groupFeesPerMonth}</span>
															</span></li>
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

												<h3 class="result-plan-title" id="resultPlanTitle">
													<c:choose>
														<c:when test="${hasCalculated eq false}">
                                                            Investment Result
                                                        </c:when>
														<c:when test="${currentPlanType eq 'BASIC_SAVINGS'}">
                                                            Basic Savings Plan
                                                        </c:when>
														<c:when test="${currentPlanType eq 'SAVINGS_PLUS'}">
                                                            Savings Plan Plus
                                                        </c:when>
														<c:when test="${currentPlanType eq 'MANAGED_STOCKS'}">
                                                            Managed Stock Investments
                                                        </c:when>
														<c:otherwise>
                                                            Investment Result
                                                        </c:otherwise>
													</c:choose>
												</h3>

												<c:if test="${not empty saveSuccessMessage}">
													<div class="inline-success-message show mt-3">
														${saveSuccessMessage}</div>
												</c:if>

												<c:if test="${not empty saveErrorMessage}">
													<div class="inline-error-message show mt-3">
														${saveErrorMessage}</div>
												</c:if>

												<c:if test="${hasCalculated and empty calculationError}">
													<div class="inline-success-message show mt-2">
														Calculation successful. Review the result below.</div>
												</c:if>

												<div id="investmentResultError"
													class="inline-error-message mt-3"></div>
												<div id="investmentResultSuccess"
													class="inline-success-message mt-3"></div>

												<div class="result-range-tabs">
													<button type="button" class="result-tab-btn active"
														data-year="oneYear">1 Year</button>
													<button type="button" class="result-tab-btn"
														data-year="fiveYears">5 Years</button>
													<button type="button" class="result-tab-btn"
														data-year="tenYears">10 Years</button>
												</div>

												<div class="result-summary-table">
													<div class="result-summary-row">
														<span class="result-label">Initial Lump Sum</span> <span
															class="result-value" id="resultInitialLumpSum"> £<fmt:formatNumber
																value="${hasCalculated ? currentResult.initialLumpSum : 0}"
																type="number" minFractionDigits="2"
																maxFractionDigits="2" />
														</span>
													</div>
													<div class="result-summary-row">
														<span class="result-label">Monthly Investment</span> <span
															class="result-value" id="resultMonthlyInvestment">
															£<fmt:formatNumber
																value="${hasCalculated ? currentResult.monthlyInvestment : 0}"
																type="number" minFractionDigits="2"
																maxFractionDigits="2" />
														</span>
													</div>
												</div>

												<div class="result-total-invested">
													<span>Total Invested Amount</span> <strong
														id="resultTotalInvested"> £<fmt:formatNumber
															value="${hasCalculated ? currentResult.totalInvested : 0}"
															type="number" minFractionDigits="2" maxFractionDigits="2" />
													</strong>
												</div>

												<div class="result-dashed-divider"></div>

												<div class="result-section">
													<h4 class="result-section-title">Return &amp; Profits</h4>
													<div class="result-grid-two">
														<div class="result-metric-block">
															<span class="result-metric-label">Min Return</span> <span
																class="result-metric-value" id="resultMinReturn">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.minReturn : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Min Profit</span> <span
																class="result-metric-value" id="resultMinProfit">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.minProfit : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Max Return</span> <span
																class="result-metric-value" id="resultMaxReturn">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.maxReturn : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Max Profit</span> <span
																class="result-metric-value" id="resultMaxProfit">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.maxProfit : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
													</div>
												</div>

												<div class="result-dashed-divider"></div>

												<div class="result-section">
													<h4 class="result-section-title">Tax &amp; Fee</h4>
													<div class="result-grid-two">
														<div class="result-metric-block">
															<span class="result-metric-label">Min Tax</span> <span
																class="result-metric-value" id="resultMinTax">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.minTax : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Monthly Fee</span> <span
																class="result-metric-value" id="resultMonthlyFee">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.monthlyFee : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Max Tax</span> <span
																class="result-metric-value" id="resultMaxTax">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.maxTax : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
														<div class="result-metric-block">
															<span class="result-metric-label">Total Fee</span> <span
																class="result-metric-value" id="resultTotalFee">£<fmt:formatNumber
																	value="${hasCalculated ? currentResult.totalFee : 0}"
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2" /></span>
														</div>
													</div>
												</div>

												<div class="result-actions ${hasCalculated ? '' : 'd-none'}">

													<a
														href="${pageContext.request.contextPath}/client/investment"
														class="btn-glow-outline result-discard-btn text-decoration-none text-center">
														Discard </a>

													<form
														action="${pageContext.request.contextPath}/client/investment/save"
														method="post" class="m-0" id="saveQuoteForm">

														<input type="hidden" name="planType"
															id="saveQuotePlanType"
															value="${investmentRequest.planType}"> <input
															type="hidden" name="initialLumpSum"
															id="saveQuoteInitialLumpSum"
															value="${investmentRequest.initialLumpSum}"> <input
															type="hidden" name="monthlyInvestment"
															id="saveQuoteMonthlyInvestment"
															value="${investmentRequest.monthlyInvestment}">

														<button type="submit" class="btn-glow result-save-btn"
															id="saveQuoteBtn">Save Quote</button>
													</form>

												</div>

											</div>
										</div>
									</div>

									<!-- Hidden results data store -->
									<div id="resultDataStore" class="d-none"
										data-plan-type="${investmentResponse.planType}"
										data-one-initial="${hasCalculated ? investmentResponse.oneYear.initialLumpSum : 0}"
										data-one-monthly="${hasCalculated ? investmentResponse.oneYear.monthlyInvestment : 0}"
										data-one-total="${hasCalculated ? investmentResponse.oneYear.totalInvested : 0}"
										data-one-min-return="${hasCalculated ? investmentResponse.oneYear.minReturn : 0}"
										data-one-max-return="${hasCalculated ? investmentResponse.oneYear.maxReturn : 0}"
										data-one-min-profit="${hasCalculated ? investmentResponse.oneYear.minProfit : 0}"
										data-one-max-profit="${hasCalculated ? investmentResponse.oneYear.maxProfit : 0}"
										data-one-min-tax="${hasCalculated ? investmentResponse.oneYear.minTax : 0}"
										data-one-max-tax="${hasCalculated ? investmentResponse.oneYear.maxTax : 0}"
										data-one-monthly-fee="${hasCalculated ? investmentResponse.oneYear.monthlyFee : 0}"
										data-one-total-fee="${hasCalculated ? investmentResponse.oneYear.totalFee : 0}"
										data-five-initial="${hasCalculated ? investmentResponse.fiveYears.initialLumpSum : 0}"
										data-five-monthly="${hasCalculated ? investmentResponse.fiveYears.monthlyInvestment : 0}"
										data-five-total="${hasCalculated ? investmentResponse.fiveYears.totalInvested : 0}"
										data-five-min-return="${hasCalculated ? investmentResponse.fiveYears.minReturn : 0}"
										data-five-max-return="${hasCalculated ? investmentResponse.fiveYears.maxReturn : 0}"
										data-five-min-profit="${hasCalculated ? investmentResponse.fiveYears.minProfit : 0}"
										data-five-max-profit="${hasCalculated ? investmentResponse.fiveYears.maxProfit : 0}"
										data-five-min-tax="${hasCalculated ? investmentResponse.fiveYears.minTax : 0}"
										data-five-max-tax="${hasCalculated ? investmentResponse.fiveYears.maxTax : 0}"
										data-five-monthly-fee="${hasCalculated ? investmentResponse.fiveYears.monthlyFee : 0}"
										data-five-total-fee="${hasCalculated ? investmentResponse.fiveYears.totalFee : 0}"
										data-ten-initial="${hasCalculated ? investmentResponse.tenYears.initialLumpSum : 0}"
										data-ten-monthly="${hasCalculated ? investmentResponse.tenYears.monthlyInvestment : 0}"
										data-ten-total="${hasCalculated ? investmentResponse.tenYears.totalInvested : 0}"
										data-ten-min-return="${hasCalculated ? investmentResponse.tenYears.minReturn : 0}"
										data-ten-max-return="${hasCalculated ? investmentResponse.tenYears.maxReturn : 0}"
										data-ten-min-profit="${hasCalculated ? investmentResponse.tenYears.minProfit : 0}"
										data-ten-max-profit="${hasCalculated ? investmentResponse.tenYears.maxProfit : 0}"
										data-ten-min-tax="${hasCalculated ? investmentResponse.tenYears.minTax : 0}"
										data-ten-max-tax="${hasCalculated ? investmentResponse.tenYears.maxTax : 0}"
										data-ten-monthly-fee="${hasCalculated ? investmentResponse.tenYears.monthlyFee : 0}"
										data-ten-total-fee="${hasCalculated ? investmentResponse.tenYears.totalFee : 0}">
									</div>

								</div>

							</div>

							<div class="col-lg-3">
								<div class="saved-quotes-side-panel">
									<div class="card-glow dashboard-card saved-quotes-summary-card">
										<div class="dashboard-card-header">
											<h5>Saved Quotes</h5>
										</div>

										<div class="dashboard-card-body saved-quotes-summary-body">
											<p class="dashboard-card-value SumCount">${savedQuoteCount}</p>
											<button type="button"
												class="btn-glow text-center border-0 investment-view-all-btn"
												id="showSavedQuotesBtn">View All</button>
										</div>
									</div>

									<div class="saved-quotes-list-wrap d-none"></div>
								</div>
							</div>

						</div>
					</section>
				</section>

				<section class="investment-section-view d-none"
					id="investmentQuotesSection">
					<div class="investment-quotes-panel">
						<div class="investment-card-inner investment-quotes-card">

							<div class="investment-quotes-header">
								<div>
									<h3 class="investment-quotes-title">Saved Investment
										Quotes</h3>
									<p class="investment-quotes-subtitle">
										Total Saved Quotes: <strong>${savedQuoteCount}</strong>
									</p>
								</div>

								<button type="button"
									class="btn-glow-outline investment-back-btn"
									id="backToCalculatorBtn">← Back to Calculator</button>
							</div>

							<div class="investment-quotes-table-wrap">
								<c:choose>
									<c:when test="${not empty savedQuotes}">
										<div class="table-responsive">
											<table
												class="table investment-quotes-table align-middle mb-0">
												<thead>
													<tr>
														<th>Quote ID</th>
														<th>Plan Type</th>
														<th>Initial Lump Sum</th>
														<th>Monthly Investment</th>
														<th>Created At</th>
														<th class="text-center">Action</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="quote" items="${savedQuotes}">
														<tr>
															<td>#${quote.id}</td>
															<td><c:choose>
																	<c:when test="${quote.planType eq 'BASIC_SAVINGS'}">Basic Savings Plan</c:when>
																	<c:when test="${quote.planType eq 'SAVINGS_PLUS'}">Savings Plan Plus</c:when>
																	<c:when test="${quote.planType eq 'MANAGED_STOCKS'}">Managed Stock Investments</c:when>
																	<c:otherwise>${quote.planType}</c:otherwise>
																</c:choose></td>
															<td>£<fmt:formatNumber
																	value="${quote.initialLumpSum}" type="number"
																	minFractionDigits="2" maxFractionDigits="2" /></td>
															<td>£<fmt:formatNumber
																	value="${quote.monthlyInvestment}" type="number"
																	minFractionDigits="2" maxFractionDigits="2" /></td>
															<td><fmt:formatDate value="${quote.createdAt}"
																	pattern="dd MMM yyyy, hh:mm a" /></td>
															<td class="text-center">
																<button type="button"
																	class="btn-glow-outline investment-quote-view-btn"
																	data-quote-id="${quote.id}"
																	data-quote-plan-type="${quote.planType}"
																	data-quote-plan-label="<c:choose><c:when test='${quote.planType eq "BASIC_SAVINGS"}'>Basic Savings Plan</c:when><c:when test='${quote.planType eq "SAVINGS_PLUS"}'>Savings Plan Plus</c:when><c:when test='${quote.planType eq "MANAGED_STOCKS"}'>Managed Stock Investments</c:when><c:otherwise>${quote.planType}</c:otherwise></c:choose>"
																	data-quote-initial="<fmt:formatNumber value='${quote.initialLumpSum}' type='number' minFractionDigits='2' maxFractionDigits='2'/>"
																	data-quote-monthly="<fmt:formatNumber value='${quote.monthlyInvestment}' type='number' minFractionDigits='2' maxFractionDigits='2'/>"
																	data-quote-created="<fmt:formatDate value='${quote.createdAt}' pattern='dd MMM yyyy, hh:mm a'/>">
																	View</button>
															</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</c:when>

									<c:otherwise>
										<div class="investment-empty-state">
											<div class="investment-empty-icon">📄</div>
											<h4>No saved quotes yet</h4>
											<p>Your saved investment quotes will appear here once you
												save one from the calculator.</p>
											<button type="button"
												class="btn-glow-outline investment-back-btn"
												id="backToCalculatorBtnEmpty">Back to Calculator</button>
										</div>
									</c:otherwise>
								</c:choose>
							</div>

						</div>
					</div>
				</section>

			</main>

			<jsp:include
				page="/WEB-INF/components/Authenticated//client/footer.jsp" />

		</div>
	</div>

	<div class="investment-quote-modal-overlay d-none"
		id="investmentQuoteModalOverlay">
		<div
			class="investment-quote-modal-card investment-quote-result-modal-card"
			id="investmentQuoteModalCard">

			<div class="investment-quote-modal-head">
				<div class="w-100">
					<p class="investment-quote-modal-kicker">Saved Quote Details</p>
					<h3 class="result-plan-title investment-quote-result-title"
						id="modalResultPlanTitle">Investment Result</h3>

					<div class="investment-quote-meta-row">
						<div class="investment-quote-meta-pill">
							<span class="investment-quote-meta-label">Quote ID</span> <strong
								class="investment-quote-meta-value" id="modalQuoteId">-</strong>
						</div>

						<div class="investment-quote-meta-pill">
							<span class="investment-quote-meta-label">Saved Date</span> <strong
								class="investment-quote-meta-value" id="modalQuoteCreated">-</strong>
						</div>
					</div>
				</div>

				<button type="button" class="investment-quote-modal-close"
					id="closeQuoteModalBtn" aria-label="Close modal">×</button>
			</div>

			<div class="investment-quote-modal-body">

				<div class="result-range-tabs investment-quote-result-tabs">
					<button type="button"
						class="result-tab-btn modal-result-tab-btn active"
						data-modal-year="oneYear">1 Year</button>
					<button type="button" class="result-tab-btn modal-result-tab-btn"
						data-modal-year="fiveYears">5 Years</button>
					<button type="button" class="result-tab-btn modal-result-tab-btn"
						data-modal-year="tenYears">10 Years</button>
				</div>

				<div class="result-summary-table">
					<div class="result-summary-row">
						<span class="result-label">Initial Lump Sum</span> <span
							class="result-value" id="modalResultInitialLumpSum">£0.00</span>
					</div>
					<div class="result-summary-row">
						<span class="result-label">Monthly Investment</span> <span
							class="result-value" id="modalResultMonthlyInvestment">£0.00</span>
					</div>
				</div>

				<div class="result-total-invested">
					<span>Total Invested Amount</span> <strong
						id="modalResultTotalInvested">£0.00</strong>
				</div>

				<div class="result-dashed-divider"></div>

				<div class="result-section">
					<h4 class="result-section-title">Return &amp; Profits</h4>
					<div class="result-grid-two">
						<div class="result-metric-block">
							<span class="result-metric-label">Min Return</span> <span
								class="result-metric-value" id="modalResultMinReturn">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Min Profit</span> <span
								class="result-metric-value" id="modalResultMinProfit">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Max Return</span> <span
								class="result-metric-value" id="modalResultMaxReturn">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Max Profit</span> <span
								class="result-metric-value" id="modalResultMaxProfit">£0.00</span>
						</div>
					</div>
				</div>

				<div class="result-dashed-divider"></div>

				<div class="result-section">
					<h4 class="result-section-title">Tax &amp; Fee</h4>
					<div class="result-grid-two">
						<div class="result-metric-block">
							<span class="result-metric-label">Min Tax</span> <span
								class="result-metric-value" id="modalResultMinTax">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Monthly Fee</span> <span
								class="result-metric-value" id="modalResultMonthlyFee">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Max Tax</span> <span
								class="result-metric-value" id="modalResultMaxTax">£0.00</span>
						</div>

						<div class="result-metric-block">
							<span class="result-metric-label">Total Fee</span> <span
								class="result-metric-value" id="modalResultTotalFee">£0.00</span>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>

	<script>
        window.planDetailsData = {
            BASIC_SAVINGS: {
                title: "${allPlanDetails['BASIC_SAVINGS'].title}",
                maximumInvestmentPerYear: "${allPlanDetails['BASIC_SAVINGS'].maximumInvestmentPerYear}",
                minimumMonthlyInvestment: "${allPlanDetails['BASIC_SAVINGS'].minimumMonthlyInvestment}",
                minimumInitialInvestmentLumpSum: "${allPlanDetails['BASIC_SAVINGS'].minimumInitialInvestmentLumpSum}",
                predictedReturnsPerYear: "${allPlanDetails['BASIC_SAVINGS'].predictedReturnsPerYear}",
                estimatedTax: "${allPlanDetails['BASIC_SAVINGS'].estimatedTax}",
                groupFeesPerMonth: "${allPlanDetails['BASIC_SAVINGS'].groupFeesPerMonth}"
            },
            SAVINGS_PLUS: {
                title: "${allPlanDetails['SAVINGS_PLUS'].title}",
                maximumInvestmentPerYear: "${allPlanDetails['SAVINGS_PLUS'].maximumInvestmentPerYear}",
                minimumMonthlyInvestment: "${allPlanDetails['SAVINGS_PLUS'].minimumMonthlyInvestment}",
                minimumInitialInvestmentLumpSum: "${allPlanDetails['SAVINGS_PLUS'].minimumInitialInvestmentLumpSum}",
                predictedReturnsPerYear: "${allPlanDetails['SAVINGS_PLUS'].predictedReturnsPerYear}",
                estimatedTax: "${allPlanDetails['SAVINGS_PLUS'].estimatedTax}",
                groupFeesPerMonth: "${allPlanDetails['SAVINGS_PLUS'].groupFeesPerMonth}"
            },
            MANAGED_STOCKS: {
                title: "${allPlanDetails['MANAGED_STOCKS'].title}",
                maximumInvestmentPerYear: "${allPlanDetails['MANAGED_STOCKS'].maximumInvestmentPerYear}",
                minimumMonthlyInvestment: "${allPlanDetails['MANAGED_STOCKS'].minimumMonthlyInvestment}",
                minimumInitialInvestmentLumpSum: "${allPlanDetails['MANAGED_STOCKS'].minimumInitialInvestmentLumpSum}",
                predictedReturnsPerYear: "${allPlanDetails['MANAGED_STOCKS'].predictedReturnsPerYear}",
                estimatedTax: "${allPlanDetails['MANAGED_STOCKS'].estimatedTax}",
                groupFeesPerMonth: "${allPlanDetails['MANAGED_STOCKS'].groupFeesPerMonth}"
            }
        };
    </script>

	<script
		src="${pageContext.request.contextPath}/resources/js/client/client-dashboard.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/public/inline-messages.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/public/components.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/client/client-investment.js"></script>

</body>
</html>