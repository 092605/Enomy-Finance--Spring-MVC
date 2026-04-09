<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Admin Currency Converter | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/admin-currency.css">
    
    
</head>
<body class="dashboard-page">

<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/components/Authenticated/admin/sidebar.jsp" />

    <div class="dashboard-main" id="dashboardMain">

        <jsp:include page="/WEB-INF/components/Authenticated/admin/topbar.jsp" />

        <main class="dashboard-content currency-admin-page">

            <div class="currency-admin-page-header">
                <h1 class="currency-admin-page-title">Enomy Finance</h1>
                <h2 class="currency-admin-page-subtitle">Admin Currency Converter</h2>
            </div>

            <div id="currencyAdminAlerts"></div>

            <section class="currency-admin-page-layout">
                <div class="row g-4 align-items-start">

                    <div class="col-lg-9">

                        <!-- =========================
                             ACTIVE RULE + FORM
                        ========================= -->
                        <section class="currency-admin-section active" id="section-active-rules">
                            <div class="currency-admin-title-card">
                                <h3>Currency Conversion Rules</h3>
                                <p>Review the active rule and create a new rule set using the current active values as default.</p>
                            </div>

                            <div class="row g-4">

                                <div class="col-lg-5">
                                    <div class="currency-admin-panel-card sticky-currency-admin-card currency-admin-active-rule-card">
                                        <div class="currency-admin-card-inner">

                                            <div class="currency-admin-card-head">
                                                <div>
                                                    <h3 class="currency-admin-card-title">Active Conversion Rule</h3>
                                                    <p class="currency-admin-card-text">Currently active rule used by the system.</p>
                                                </div>
                                                <span class="currency-admin-version-badge" id="activeRuleSetBadge">Set ID -</span>
                                            </div>

                                            <div id="activeRuleCardContent">
                                                <div class="currency-admin-empty-state">
                                                    <h4>Loading active conversion rule...</h4>
                                                    <p>Please wait while the system retrieves the active conversion rule.</p>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-7">
                                    <div class="currency-admin-panel-card">
                                        <div class="currency-admin-card-inner">

                                            <div class="currency-admin-card-head">
                                                <div>
                                                    <h3 class="currency-admin-card-title">Create New Conversion Rule Set</h3>
                                                    <p class="currency-admin-card-text">The form is prefilled using the active rule values.</p>
                                                </div>
                                            </div>

                                            <form id="currencyRuleForm">
                                                <div class="currency-admin-form-top-grid">
                                                    <div class="currency-admin-mini-box">
                                                        <span>Preview Set ID</span>
                                                        <strong id="previewRuleSetId">-</strong>
                                                    </div>

                                                    <div class="currency-admin-mini-box">
                                                        <span>Minimum Amount</span>
                                                        <strong id="previewMinAmount">0.00</strong>
                                                    </div>

                                                    <div class="currency-admin-mini-box">
                                                        <span>Maximum Amount</span>
                                                        <strong id="previewMaxAmount">0.00</strong>
                                                    </div>
                                                </div>

                                                <div class="row g-3 mt-1">
                                                    <div class="col-md-6">
                                                        <label class="currency-admin-label">Rule Name</label>
                                                        <input type="text"
                                                               class="currency-admin-input"
                                                               id="ruleNameInput"
                                                               placeholder="Enter rule name">
                                                    </div>

                                                    <div class="col-md-6">
                                                        <label class="currency-admin-label">Description</label>
                                                        <input type="text"
                                                               class="currency-admin-input"
                                                               id="ruleDescriptionInput"
                                                               placeholder="Enter short description">
                                                    </div>
                                                </div>

                                                <div class="currency-admin-bracket-builder mt-4">
                                                    <div class="currency-admin-bracket-head">
                                                        <h4>Conversion Fee Brackets</h4>
                                                        <button type="button" class="btn-glow-outline btn-sm" id="addBracketRowBtn">
                                                            Add Row
                                                        </button>
                                                    </div>

                                                    <div id="bracketRowsWrap" class="currency-admin-bracket-rows"></div>
                                                </div>

                                                <div class="currency-admin-action-row">
                                                    <button type="submit" class="btn-glow ms-auto" id="createRuleBtn">
                                                        Create New Conversion Rule Set
                                                    </button>
                                                </div>
                                            </form>

                                        </div>
                                    </div>
                                </div>

                            </div>
                        </section>

                        <!-- =========================
                             RATES SECTION
                        ========================= -->
                        <section class="currency-admin-section" id="section-rates">
                            <div class="currency-admin-title-card">
                                <h3>Currency Rates</h3>
                                <p>Filter live or historical exchange rates using base currency, target currency, and date range.</p>
                            </div>

                            <div class="currency-admin-panel-card">
                                <div class="currency-admin-card-inner">

                                    <form id="ratesFilterForm" class="currency-admin-filter-form">
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <label class="currency-admin-label">Base Currency</label>
                                                <input type="text" class="currency-admin-input" id="rateBaseCurrency" placeholder="GBP">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="currency-admin-label">Target Currency</label>
                                                <input type="text" class="currency-admin-input" id="rateTargetCurrency" placeholder="USD">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="currency-admin-label">Date From</label>
                                                <input type="date" class="currency-admin-input" id="rateDateFrom">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="currency-admin-label">Date To</label>
                                                <input type="date" class="currency-admin-input" id="rateDateTo">
                                            </div>
                                        </div>

                                        <div class="currency-admin-action-row">
                                            <button type="button" class="btn-glow-outline" id="resetRatesBtn">Reset</button>
                                            <button type="submit" class="btn-glow">Filter Rates</button>
                                        </div>
                                    </form>

                                    <div id="ratesResultsWrap" class="mt-4">
                                        <div class="currency-admin-empty-state">
                                            <h4>No rate results yet</h4>
                                            <p>Use the filter above to load rate results.</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </section>

                        <!-- =========================
                             TRANSACTIONS SECTION
                        ========================= -->
                        <section class="currency-admin-section" id="section-transactions">
                            <div class="currency-admin-title-card">
                                <h3>Saved Transactions</h3>
                                <p>Review all saved conversion transactions using filters and search.</p>
                            </div>

                            <div class="currency-admin-panel-card">
                                <div class="currency-admin-card-inner">

                                    <form id="transactionsFilterForm" class="currency-admin-filter-form">
                                        <div class="row g-3">
                                            <div class="col-md-2">
                                                <label class="currency-admin-label">Base</label>
                                                <input type="text" class="currency-admin-input" id="txnBaseCurrency" placeholder="GBP">
                                            </div>
                                            <div class="col-md-2">
                                                <label class="currency-admin-label">Target</label>
                                                <input type="text" class="currency-admin-input" id="txnTargetCurrency" placeholder="USD">
                                            </div>
                                            <div class="col-md-2">
                                                <label class="currency-admin-label">Date From</label>
                                                <input type="date" class="currency-admin-input" id="txnDateFrom">
                                            </div>
                                            <div class="col-md-2">
                                                <label class="currency-admin-label">Date To</label>
                                                <input type="date" class="currency-admin-input" id="txnDateTo">
                                            </div>
                                            <div class="col-md-4">
                                                <label class="currency-admin-label">Search</label>
                                                <input type="text" class="currency-admin-input" id="txnSearch" placeholder="User ID or Transaction Number">
                                            </div>
                                        </div>

                                        <div class="currency-admin-action-row">
                                            <button type="button" class="btn-glow-outline" id="resetTransactionsBtn">Reset</button>
                                            <button type="submit" class="btn-glow">Filter Transactions</button>
                                        </div>
                                    </form>

                                    <div id="transactionsResultsWrap" class="mt-4">
                                        <div class="currency-admin-empty-state">
                                            <h4>No transaction results yet</h4>
                                            <p>Use the filter above to load saved transactions.</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </section>

                        <!-- =========================
                             HISTORY SECTION
                        ========================= -->
                        <section class="currency-admin-section" id="section-history">
                            <div class="currency-admin-title-card">
                                <h3>Conversion Rule History</h3>
                                <p>Review all created conversion rule sets and activate a previous one when needed.</p>
                            </div>

                            <div class="currency-admin-panel-card">
                                <div class="currency-admin-card-inner">
                                    <div id="historyResultsWrap">
                                        <div class="currency-admin-empty-state">
                                            <h4>Loading conversion rule history...</h4>
                                            <p>Please wait while the system retrieves saved rule versions.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                    </div>

                    <!-- =========================
                         RIGHT MODULE SIDEBAR
                    ========================= -->
                    <div class="col-lg-3">
                        <div class="currency-admin-module-sidebar-wrap">
                            <div class="currency-admin-module-sidebar">

                                <a href="javascript:void(0)"
                                   class="currency-admin-module-logo-link active"
                                   data-section-target="section-active-rules">
                                    <div class="module-logo-icon">¤</div>
                                    <div>
                                        <strong>Currency Converter</strong>
                                        <small>Active Conversion Rule</small>
                                    </div>
                                </a>

                                <nav class="currency-admin-module-nav">
                                    

                                    <a href="javascript:void(0)"
                                       class="currency-admin-module-nav-link"
                                       data-section-target="section-rates">
                                        Currency Rates
                                    </a>

                                    <a href="javascript:void(0)"
                                       class="currency-admin-module-nav-link"
                                       data-section-target="section-transactions">
                                        Saved Transactions
                                    </a>

                                    <a href="javascript:void(0)"
                                       class="currency-admin-module-nav-link"
                                       data-section-target="section-history">
                                        Conversion Rule History
                                    </a>
                                </nav>

                            </div>
                        </div>
                    </div>

                </div>
            </section>

        </main>

<jsp:include page="/WEB-INF/components/Authenticated/client/footer.jsp" />
    </div>
</div>

<!-- RULE HISTORY DETAILS MODAL -->
<div class="modal fade" id="ruleHistoryDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content currency-admin-modal-card">
            <div class="modal-body">

                <div class="currency-admin-history-rule-card">
                    <div class="currency-admin-history-rule-inner">

                        <div class="currency-admin-modal-head">
                            <h3 class="currency-admin-history-rule-title">Conversion Rules Details</h3>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="currency-admin-history-rule-meta">
                            <div class="currency-admin-history-rule-topline">
                                <div class="currency-admin-history-rule-id-wrap">
                                    <span class="currency-admin-history-label">Rule Set ID</span>
                                    <strong id="historyRuleSetId">-</strong>
                                </div>

                                <div class="currency-admin-history-rule-status-wrap">
                                    <span class="currency-admin-history-label">Status</span>
                                    <span id="historyRuleStatusBadge" class="currency-admin-status-badge inactive">Inactive</span>
                                </div>
                            </div>

                            <strong id="historyRuleName" class="currency-admin-history-rule-name">-</strong>

                            <p id="historyRuleDescription" class="currency-admin-history-rule-description">
                                No description available.
                            </p>
                        </div>

                        <div class="currency-admin-history-rule-summary-grid">
                            <div class="currency-admin-history-summary-box">
                                <span>Minimum Amount</span>
                                <strong id="historyRuleMin">-</strong>
                            </div>

                            <div class="currency-admin-history-summary-box">
                                <span>Maximum Amount</span>
                                <strong id="historyRuleMax">-</strong>
                            </div>
                        </div>

                        <div class="table-responsive currency-admin-history-rule-table-wrap">
                            <table class="table currency-admin-history-rule-table">
                                <thead>
                                    <tr>
                                        <th>Initial Currency Amount</th>
                                        <th>Fee Rate</th>
                                    </tr>
                                </thead>
                                <tbody id="historyRuleBracketTableBody">
                                    <tr>
                                        <td colspan="2">No rule details loaded.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="currency-admin-action-row justify-content-end mt-4">
                            <button type="button" class="btn-glow-outline" data-bs-dismiss="modal">Close</button>
                            <button type="button" id="activateRuleSetBtn" class="btn-glow">Activate Conversion Rule</button>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    window.currencyAdminApiBase = "${pageContext.request.contextPath}/admin/api/currency";
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
<script>
    window.currencyAdminApiBase = "${pageContext.request.contextPath}/admin/api/currency";
</script>
<script src="${pageContext.request.contextPath}/resources/js/admin/admin-currency.js"></script>

</body>
</html>