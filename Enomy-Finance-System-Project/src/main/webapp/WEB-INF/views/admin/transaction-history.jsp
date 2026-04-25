<%-- =========================================================
     JSP FILE DESCRIPTION
     =========================================================
     File Name:
     transaction-history.jsp

     Purpose:
     This JSP file serves as the administrator transaction
     monitoring and transaction history management page
     for the Enomy Finance system.

     Overview:
     This page allows administrators to review and monitor
     saved Currency Converter transactions and Investment
     Quote records throughout the system.

     The page supports:
     - Currency transaction monitoring
     - Investment quote monitoring
     - Dynamic filtering workflows
     - Date range filtering
     - Currency filtering
     - Buy/Sell transaction filtering
     - Plan type filtering
     - Live search preparation
     - Dynamic transaction table rendering
     - AJAX-based backend integration

     Main Features:
     - View currency conversion transactions
     - View investment quote history
     - Filter transactions using date range
     - Filter by base currency
     - Filter by target currency
     - Filter by buy/sell type
     - Filter by investment plan type
     - Search by user ID
     - Search by user name
     - Search by transaction number
     - Search by quote reference
     - Dynamic results rendering
     - Sidebar-based section navigation
     - Prepared backend integration workflow

     Note:
     This page is primarily focused on transaction
     monitoring and administrative review workflows.
     Advanced reporting analytics and export features
     are outside the current project scope.

     CONNECTED RESOURCES

     CSS
     - theme.css
     - components.css
     - client-dashboard.css
     - admin-transaction-history.css
     - bootstrap.min.css

     JavaScript
     - dashboard.js
     - admin-transaction-history.js
     - bootstrap.bundle.min.js

     JSP COMPONENTS
     - admin/sidebar.jsp
     - admin/topbar.jsp
     - client/footer.jsp

     JAVA CLASSES

     Controllers
     - AdminTransactionHistoryController
     - AdminTransactionHistoryApiController
     - ClientGlobalModel

     Services
     - TransactionHistoryService
     - TransactionHistoryServiceImpl
     - CurrencyTransactionService
     - CurrencyTransactionServiceImpl
     - InvestmentQuoteService
     - InvestmentQuoteServiceImpl

     DAO Layer
     - CurrencyTransactionDao
     - CurrencyTransactionDaoImpl
     - SavedInvestmentQuoteDao
     - SavedInvestmentQuoteDaoImpl
     - UserDao
     - UserDaoImpl

     Models
     - CurrencyTransaction
     - SavedInvestmentQuote
     - User

     DTO Classes
     - CurrencyTransactionHistoryRowDTO
     - InvestmentQuoteHistoryRowDTO
     - TransactionHistoryFilterDTO

     Security Classes
     - SecurityConfig
     - CustomUserDetails
     - CustomAuthenticationSuccessHandler
     - CustomAuthenticationFailureHandler

     Purpose of Java Class Usage:
     - Handles administrator transaction history routing
     - Retrieves currency conversion transactions
     - Retrieves investment quote records
     - Supports AJAX-based filtering workflows
     - Supports transaction search operations
     - Retrieves authenticated administrator information
     - Supplies transaction result rows
     - Supports secured administrator access control
     - Prepares dynamic table rendering integration

     Module:
     Web Development Foundations (WDF)

     System:
     Enomy Finance Web Application

     ========================================================= --%>
     
     
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Transaction History | Enomy Finance</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/theme.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/public/components.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin/admin-transaction-history.css">
</head>
<body class="dashboard-page">

	<div class="dashboard-layout">

		<jsp:include
			page="/WEB-INF/components/Authenticated/admin/sidebar.jsp" />

		<div class="dashboard-main" id="dashboardMain">

			<jsp:include
				page="/WEB-INF/components/Authenticated/admin/topbar.jsp" />

			<main class="dashboard-content transaction-admin-page">

				<div class="transaction-admin-page-header">
					<h1 class="transaction-admin-page-title">Enomy Finance</h1>
					<h2 class="transaction-admin-page-subtitle">Admin Transaction
						History</h2>
				</div>

				<div id="transactionAdminAlerts"></div>

				<section class="transaction-admin-page-layout">
					<div class="row g-4 align-items-start">

						<!-- MAIN CONTENT -->
						<div class="col-lg-9">

							<!-- =========================
	                             CURRENCY TRANSACTIONS SECTION
	                        ========================= -->
							<section class="transaction-admin-section active"
								id="section-currency-transactions">
								<div class="transaction-admin-title-card">
									<h3>Currency Transactions</h3>
									<p>Review saved currency conversion transactions using date
										range, base and target currency, buy or sell type, and live
										search.</p>
								</div>

								<div class="transaction-admin-panel-card">
									<div class="transaction-admin-card-inner">

										<form id="currencyTransactionFilterForm"
											class="transaction-admin-filter-form">
											<div class="row g-3">
												<div class="col-md-2">
													<label class="transaction-admin-label"
														for="currencyDateFrom">Date From</label> <input
														type="date" class="transaction-admin-input"
														id="currencyDateFrom" name="dateFrom">
												</div>

												<div class="col-md-2">
													<label class="transaction-admin-label" for="currencyDateTo">Date
														To</label> <input type="date" class="transaction-admin-input"
														id="currencyDateTo" name="dateTo">
												</div>

												<div class="col-md-2">
													<label class="transaction-admin-label">Base
														Currency</label>

													<div class="custom-dropdown"
														id="currencyBaseCurrencyDropdown">
														<input type="hidden" id="currencyBaseCurrency"
															name="baseCurrency" value="">

														<button type="button" class="custom-dropdown-toggle">
															<span class="selected-value">All</span> <span
																class="dropdown-arrow"> <svg viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
											                    <polyline points="6 9 12 15 18 9"></polyline>
											                </svg>
															</span>
														</button>

														<div class="custom-dropdown-menu">
															<div class="custom-dropdown-item active" data-value="">All</div>
															<div class="custom-dropdown-item" data-value="GBP">GBP</div>
															<div class="custom-dropdown-item" data-value="USD">USD</div>
															<div class="custom-dropdown-item" data-value="EUR">EUR</div>
															<div class="custom-dropdown-item" data-value="BRL">BRL</div>
															<div class="custom-dropdown-item" data-value="JPY">JPY</div>
															<div class="custom-dropdown-item" data-value="TRY">TRY</div>
														</div>
													</div>
												</div>

												<div class="col-md-2">
													<label class="transaction-admin-label">Target
														Currency</label>

													<div class="custom-dropdown"
														id="currencyTargetCurrencyDropdown">
														<input type="hidden" id="currencyTargetCurrency"
															name="targetCurrency" value="">

														<button type="button" class="custom-dropdown-toggle">
															<span class="selected-value">All</span> <span
																class="dropdown-arrow"> <svg viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
										                    <polyline points="6 9 12 15 18 9"></polyline>
										                </svg>
															</span>
														</button>

														<div class="custom-dropdown-menu">
															<div class="custom-dropdown-item active" data-value="">All</div>
															<div class="custom-dropdown-item" data-value="GBP">GBP</div>
															<div class="custom-dropdown-item" data-value="USD">USD</div>
															<div class="custom-dropdown-item" data-value="EUR">EUR</div>
															<div class="custom-dropdown-item" data-value="BRL">BRL</div>
															<div class="custom-dropdown-item" data-value="JPY">JPY</div>
															<div class="custom-dropdown-item" data-value="TRY">TRY</div>
														</div>
													</div>
												</div>

												<div class="col-md-2">
													<label class="transaction-admin-label">Buy / Sell</label>

													<div class="custom-dropdown"
														id="currencyTransactionTypeDropdown">
														<input type="hidden" id="currencyTransactionType"
															name="transactionType" value="">

														<button type="button" class="custom-dropdown-toggle">
															<span class="selected-value">All</span> <span
																class="dropdown-arrow"> <svg viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
											                    <polyline points="6 9 12 15 18 9"></polyline>
											                </svg>
															</span>
														</button>

														<div class="custom-dropdown-menu">
															<div class="custom-dropdown-item active" data-value="">All</div>
															<div class="custom-dropdown-item" data-value="BUY">Buy</div>
															<div class="custom-dropdown-item" data-value="SELL">Sell</div>
														</div>
													</div>
												</div>

												<div class="col-md-2">
													<label class="transaction-admin-label" for="currencySearch">Search</label>
													<input type="text" class="transaction-admin-input"
														id="currencySearch" name="search"
														placeholder="User ID, name, or transaction no.">
												</div>
											</div>

											<div class="transaction-admin-action-row">
												<button type="button" class="btn-glow-outline"
													id="resetCurrencyTransactionFiltersBtn">Reset</button>

												<button type="submit" class="btn-glow"
													id="submitCurrencyTransactionFiltersBtn">Filter
													Currency Transactions</button>
											</div>
										</form>

										<div class="transaction-admin-results-head">
											<div>
												<h4 class="transaction-admin-results-title">Currency
													Transaction Results</h4>
												<p class="transaction-admin-results-text">Prepared for
													backend result rendering and live search integration.</p>
											</div>

											<div class="transaction-admin-results-meta">
												<span class="transaction-admin-meta-badge"
													id="currencyResultsCountBadge">0 Results</span>
											</div>
										</div>

										<div id="currencyTransactionsResultsWrap">
											<div class="transaction-admin-empty-state">
												<h4>No currency transactions loaded yet</h4>
												<p>Currency transaction records will appear here once
													backend integration is connected.</p>
											</div>

											<div class="table-responsive d-none"
												id="currencyTransactionsTableWrap">
												<table class="table transaction-admin-history-table"
													id="currencyTransactionsTable">
													<thead>
														<tr>
															<th>Transaction No.</th>
															<th>User ID</th>
															<th>User Name</th>
															<th>Type</th>
															<th>Base</th>
															<th>Target</th>
															<th>Input Amount</th>
															<th>Final Amount</th>
															<th>Status</th>
															<th>Date</th>
														</tr>
													</thead>
													<tbody id="currencyTransactionsTableBody">
													</tbody>
												</table>
											</div>
										</div>

									</div>
								</div>
							</section>

							<!-- =========================
	                             INVESTMENT QUOTES SECTION
	                        ========================= -->
							<section class="transaction-admin-section"
								id="section-investment-quotes">
								<div class="transaction-admin-title-card">
									<h3>Investment Quotes</h3>
									<p>Review saved investment quotes using date range, plan
										type, and live search by user ID, user name, or quote ID.</p>
								</div>

								<div class="transaction-admin-panel-card">
									<div class="transaction-admin-card-inner">

										<form id="investmentQuoteFilterForm"
											class="transaction-admin-filter-form">
											<div class="row g-3">
												<div class="col-md-3">
													<label class="transaction-admin-label"
														for="investmentDateFrom">Date From</label> <input
														type="date" class="transaction-admin-input"
														id="investmentDateFrom" name="dateFrom">
												</div>

												<div class="col-md-3">
													<label class="transaction-admin-label"
														for="investmentDateTo">Date To</label> <input type="date"
														class="transaction-admin-input" id="investmentDateTo"
														name="dateTo">
												</div>

												<div class="col-md-3">
													<label class="transaction-admin-label">Plan Type</label>

													<div class="custom-dropdown"
														id="investmentPlanTypeDropdown">
														<input type="hidden" id="investmentPlanType"
															name="planType" value="">

														<button type="button" class="custom-dropdown-toggle">
															<span class="selected-value">All</span> <span
																class="dropdown-arrow"> <svg viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
											                    <polyline points="6 9 12 15 18 9"></polyline>
											                </svg>
															</span>
														</button>

														<div class="custom-dropdown-menu">
															<div class="custom-dropdown-item active" data-value="">All</div>
															<div class="custom-dropdown-item"
																data-value="BASIC_SAVINGS">Basic Savings</div>
															<div class="custom-dropdown-item"
																data-value="SAVINGS_PLUS">Savings Plus</div>
															<div class="custom-dropdown-item"
																data-value="MANAGED_STOCKS">Managed Stocks</div>
														</div>
													</div>
												</div>

												<div class="col-md-3">
													<label class="transaction-admin-label"
														for="investmentSearch">Search</label> <input type="text"
														class="transaction-admin-input" id="investmentSearch"
														name="search"
														placeholder="User ID, name, or transaction no.">
												</div>
											</div>

											<div class="transaction-admin-action-row">
												<button type="button" class="btn-glow-outline"
													id="resetInvestmentQuoteFiltersBtn">Reset</button>

												<button type="submit" class="btn-glow"
													id="submitInvestmentQuoteFiltersBtn">Filter
													Investment Quotes</button>
											</div>
										</form>

										<div class="transaction-admin-results-head">
											<div>
												<h4 class="transaction-admin-results-title">Investment
													Quote Results</h4>
												<p class="transaction-admin-results-text">Prepared for
													backend result rendering and live search integration.</p>
											</div>

											<div class="transaction-admin-results-meta">
												<span class="transaction-admin-meta-badge"
													id="investmentResultsCountBadge">0 Results</span>
											</div>
										</div>

										<div id="investmentQuotesResultsWrap">
											<div class="transaction-admin-empty-state">
												<h4>No investment quotes loaded yet</h4>
												<p>Investment quote records will appear here once
													backend integration is connected.</p>
											</div>

											<div class="table-responsive d-none"
												id="investmentQuotesTableWrap">
												<table class="table transaction-admin-history-table"
													id="investmentQuotesTable">
													<thead>
														<tr>
															<th>Quote Reference</th>
															<th>User ID</th>
															<th>User Name</th>
															<th>Plan Type</th>
															<th>Initial Lump Sum</th>
															<th>Monthly Investment</th>
															<th>Plan Rule ID</th>
															<th>Date</th>
														</tr>
													</thead>
													<tbody id="investmentQuotesTableBody">
													</tbody>
												</table>
											</div>
										</div>

									</div>
								</div>
							</section>

						</div>

						<!-- RIGHT SIDEBAR -->
						<div class="col-lg-3">
							<div class="transaction-admin-module-sidebar-wrap">
								<div class="transaction-admin-module-sidebar">

									<a href="javascript:void(0)"
										class="transaction-admin-module-logo-link active"
										data-section-target="section-currency-transactions">
										<div class="module-logo-icon">☰</div>
										<div>
											<strong>Transaction History</strong> <small>Admin
												monitoring page</small>
										</div>
									</a>

									<nav class="transaction-admin-module-nav">
										<a href="javascript:void(0)"
											class="transaction-admin-module-nav-link active"
											data-section-target="section-currency-transactions">
											Currency Transactions </a> <a href="javascript:void(0)"
											class="transaction-admin-module-nav-link"
											data-section-target="section-investment-quotes">
											Investment Quotes </a>
									</nav>

								</div>
							</div>
						</div>

					</div>
				</section>

			</main>

			<jsp:include
				page="/WEB-INF/components/Authenticated/client/footer.jsp" />

		</div>
	</div>

	<script> window.transactionHistoryApiBase = "${pageContext.request.contextPath}/admin/api/transaction-history"; </script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/admin/admin-transaction-history.js"></script>

</body>
</html>