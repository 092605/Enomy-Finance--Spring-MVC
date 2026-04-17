<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Currency Converter | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/client-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/client-currency.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/public/inline-messages.css">
</head>

<body class="dashboard-page">

<div class="dashboard-layout">

    <jsp:include page="/WEB-INF/components/Authenticated//client/sidebar.jsp" />

    <div class="dashboard-main" id="dashboardMain">

        <jsp:include page="/WEB-INF/components/Authenticated/client/topbar.jsp" />

        <main class="dashboard-content currency-page">

            <!-- =========================
                 PAGE HEADER
            ========================= -->
            <div class="currency-page-header">
                <h1 class="currency-page-title">Enomy Finance</h1>
                <h2 class="currency-page-subtitle">Currency Converter</h2>
            </div>

            <!-- =========================
                 PAGE CONTENT LAYOUT
            ========================= -->
            <section class="currency-page-layout">
                <div class="row g-4 align-items-start">

                    <!-- MAIN CONTENT AREA -->
                    <div class="col-lg-9">

			<!-- =========================
			     WELCOME SECTION
			========================= -->
			<c:if test="${empty activeSection or activeSection eq 'welcome'}">
			
			    <div class="currency-title-card">
			        <h3>Currency Converter</h3>
			        <p>Buy or sell supported currencies using the latest available exchange rate.</p>
			    </div>
			
			    <div class="row g-4 align-items-stretch">
			
			        <!-- Welcome Hero -->
			        <div class="col-lg-7 d-flex">
			            <div class="currency-panel-card currency-welcome-card w-100 h-100">
			                <div class="currency-card-inner">
			                    <span class="currency-badge">Quick Action</span>
			                    <h3 class="currency-card-title welcome">Buy or Sell Currency</h3>
			                    <p class="currency-card-text">
			                        Start your transaction by selecting whether you want to buy or sell currency.
			                        The system will prepare the converter automatically for your chosen transaction type.
			                    </p>
			
			                    <div class="currency-hero-actions">
			                        <a href="${pageContext.request.contextPath}/client/currency-converter/buy"
			                           class="btn-glow text-decoration-none text-center">
			                            Buy Currency
			                        </a>
			
			                        <a href="${pageContext.request.contextPath}/client/currency-converter/sell"
			                           class="btn-glow-outline text-decoration-none text-center">
			                            Sell Currency
			                        </a>
			                    </div>
			                </div>
			            </div>
			        </div>
			        
			       <!-- CHECK RATE -->
			        <div class="col-lg-5 d-flex">
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
			                                <input type="hidden" name="baseCurrency" id="checkRateBaseCurrency" value="" />
			
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
			                                <input type="hidden" name="targetCurrency" id="checkRateTargetCurrency" value="" />
			
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
			
			                        <!-- Button + sync -->
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
			
			                        <!-- inline error -->
			                        <div class="col-12">
			                            <div id="checkRateError" class="inline-error-message"></div>
			                        </div>
			
			                    </div>
			                </div>
			            </div>
			        </div>
			
			    </div>
			</c:if>
                       <!-- =========================
						     CONVERTER SECTION
						========================= -->
						<c:if test="${activeSection eq 'converter'}">
						
						    <div class="currency-title-card">
						        <h3>
						            <c:choose>
						                <c:when test="${conversionRequest.transactionType eq 'BUY'}">Lets Buy Currency!</c:when>
						                <c:when test="${conversionRequest.transactionType eq 'SELL'}">Lets Sell Currency!</c:when>
						                <c:otherwise>Currency Converter</c:otherwise>
						            </c:choose>
						        </h3>
						        <p>Complete the form below to calculate your currency transaction.</p>
						    </div>
						
						    <div class="row g-4">
						
						        <!-- LEFT STACK -->
						        <div class="col-lg-5">
						            <div class="row g-4">
						
						                <!-- Calculator -->
						                <div class="col-12">
						                    <div class="currency-panel-card">
						                        <div class="currency-card-inner">
						                            <h3 class="currency-card-title">Converter Form / Calculator</h3>
						
						                            <form action="${pageContext.request.contextPath}/client/currency-converter/calculate"
						                                  method="post"
						                                  data-partial-form="true">
						
						                                <div class="row g-3">
						
						                                    <!-- Transaction Type -->
						                                    <div class="col-12">
						                                        <label class="currency-label">Transaction Type</label>
						                                        <div class="custom-dropdown">
						                                            <input type="hidden"
						                                                   name="transactionType"
						                                                   value="${conversionRequest.transactionType}"
						                                                   required>
						
						                                            <button type="button" class="custom-dropdown-toggle">
						                                                <span class="selected-value">
						                                                    <c:choose>
						                                                        <c:when test="${not empty conversionRequest.transactionType}">
						                                                            ${conversionRequest.transactionType}
						                                                        </c:when>
						                                                        <c:otherwise>Select</c:otherwise>
						                                                    </c:choose>
						                                                </span>
						                                                <span class="dropdown-arrow">
						                                                    <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
						                                                        <path fill-rule="evenodd"
						                                                              d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.51a.75.75 0 01-1.08 0l-4.25-4.51a.75.75 0 01.02-1.06z"
						                                                              clip-rule="evenodd"/>
						                                                    </svg>
						                                                </span>
						                                            </button>
						
						                                            <div class="custom-dropdown-menu">
						                                                <div class="custom-dropdown-item ${empty conversionRequest.transactionType ? 'active' : ''}" data-value="">
						                                                    Select
						                                                </div>
						                                                <div class="custom-dropdown-item ${conversionRequest.transactionType eq 'BUY' ? 'active' : ''}" data-value="BUY">
						                                                    BUY
						                                                </div>
						                                                <div class="custom-dropdown-item ${conversionRequest.transactionType eq 'SELL' ? 'active' : ''}" data-value="SELL">
						                                                    SELL
						                                                </div>
						                                            </div>
						                                        </div>
						                                    </div>
						
						                                    <!-- Base Currency -->
						                                    <div class="col-md-6">
						                                        <label class="currency-label">Base Currency</label>
						                                        <div class="custom-dropdown">
						                                            <input type="hidden"
						                                                   name="baseCurrency"
						                                                   value="${conversionRequest.baseCurrency}"
						                                                   required>
						
						                                            <button type="button" class="custom-dropdown-toggle">
						                                                <span class="selected-value">
						                                                    <c:choose>
						                                                        <c:when test="${not empty conversionRequest.baseCurrency}">
						                                                            ${conversionRequest.baseCurrency}
						                                                        </c:when>
						                                                        <c:otherwise>Select</c:otherwise>
						                                                    </c:choose>
						                                                </span>
						                                                <span class="dropdown-arrow">
						                                                    <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
						                                                        <path fill-rule="evenodd"
						                                                              d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.51a.75.75 0 01-1.08 0l-4.25-4.51a.75.75 0 01.02-1.06z"
						                                                              clip-rule="evenodd"/>
						                                                    </svg>
						                                                </span>
						                                            </button>
						
						                                            <div class="custom-dropdown-menu">
						                                                <div class="custom-dropdown-item ${empty conversionRequest.baseCurrency ? 'active' : ''}" data-value="">
						                                                    Select
						                                                </div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'GBP' ? 'active' : ''}" data-value="GBP">GBP</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'USD' ? 'active' : ''}" data-value="USD">USD</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'EUR' ? 'active' : ''}" data-value="EUR">EUR</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'BRL' ? 'active' : ''}" data-value="BRL">BRL</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'JPY' ? 'active' : ''}" data-value="JPY">JPY</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.baseCurrency eq 'TRY' ? 'active' : ''}" data-value="TRY">TRY</div>
						                                            </div>
						                                        </div>
						                                    </div>
						
						                                    <!-- Target Currency -->
						                                    <div class="col-md-6">
						                                        <label class="currency-label">Target Currency</label>
						                                        <div class="custom-dropdown">
						                                            <input type="hidden"
						                                                   name="targetCurrency"
						                                                   value="${conversionRequest.targetCurrency}"
						                                                   required>
						
						                                            <button type="button" class="custom-dropdown-toggle">
						                                                <span class="selected-value">
						                                                    <c:choose>
						                                                        <c:when test="${not empty conversionRequest.targetCurrency}">
						                                                            ${conversionRequest.targetCurrency}
						                                                        </c:when>
						                                                        <c:otherwise>Select</c:otherwise>
						                                                    </c:choose>
						                                                </span>
						                                                <span class="dropdown-arrow">
						                                                    <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
						                                                        <path fill-rule="evenodd"
						                                                              d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.51a.75.75 0 01-1.08 0l-4.25-4.51a.75.75 0 01.02-1.06z"
						                                                              clip-rule="evenodd"/>
						                                                    </svg>
						                                                </span>
						                                            </button>
						
						                                            <div class="custom-dropdown-menu">
						                                                <div class="custom-dropdown-item ${empty conversionRequest.targetCurrency ? 'active' : ''}" data-value="">
						                                                    Select
						                                                </div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'GBP' ? 'active' : ''}" data-value="GBP">GBP</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'USD' ? 'active' : ''}" data-value="USD">USD</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'EUR' ? 'active' : ''}" data-value="EUR">EUR</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'BRL' ? 'active' : ''}" data-value="BRL">BRL</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'JPY' ? 'active' : ''}" data-value="JPY">JPY</div>
						                                                <div class="custom-dropdown-item ${conversionRequest.targetCurrency eq 'TRY' ? 'active' : ''}" data-value="TRY">TRY</div>
						                                            </div>
						                                        </div>
						                                    </div>
						
						                                    <!-- Amount -->
						                                    <div class="col-12">
						                                        <label class="currency-label">Amount to Convert</label>
						                                        <div class="enomy-input-wrap">
						                                            <input type="number"
						                                                   step="0.01"
						                                                   min="0"
						                                                   name="amount"
						                                                   class="enomy-input"
						                                                   placeholder="Enter amount"
						                                                   value="${conversionRequest.amount}">
						                                        </div>
						                                    </div>
						
						                                    <!-- Submit -->
						                                    <div class="col-12">
						                                        <button type="submit" class="btn-glow w-100">
						                                            Calculate
						                                        </button>
						                                    </div>
						                                </div>
						                            </form>
						
						                            <c:if test="${not empty conversionResult and not conversionResult.valid}">
						                                <div class="inline-error-message show mt-3">
						                                    ${conversionResult.message}
						                                </div>
						                            </c:if>
						                        </div>
						                    </div>
						                </div>
						
						                <!-- Rules Card -->
						                <div class="col-12">
						                    <div class="currency-panel-card">
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
						
						        <!-- RESULT / RECEIPT -->
						        <div class="col-lg-7">
						            <div id="resultReceiptArea">
						                <div class="currency-panel-card currency-result-card cc-narrow
						                    ${cardMode eq 'result' and not empty conversionResult and conversionResult.valid ? 'cc-result-card--success' : ''}
						                    ${cardMode eq 'receipt' and not empty receipt ? 'cc-result-card--success' : ''}">
						                    <div class="currency-card-inner">
						
						                        <!-- DEFAULT -->
						                        <c:if test="${cardMode eq 'default'}">
						                            <div class="cc-card-shell">
						                                <h3 class="currency-card-title cc-card-title-main">Result Card</h3>
						
						                                <div class="cc-top-strip--grid">
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Transaction Type</span>
						                                        <strong class="cc-top-value">-</strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Base Currency</span>
						                                        <strong class="cc-top-value">-</strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Target Currency</span>
						                                        <strong class="cc-top-value">-</strong>
						                                    </div>
						                                </div>
						
						                                <div class="cc-amount-bar">
						                                    <span class="cc-bar-label">Amount to Convert</span>
						                                    <strong class="cc-bar-value">0.00</strong>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Exchange Rate Details</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div>Exchange Rate:</div>
						                                            <div>Date Rate Retrieved:</div>
						                                            <div>Time Retrieved:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>0.00</div>
						                                            <div>—</div>
						                                            <div>—</div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Fee &amp; Converted Amount</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div class="cc-accent-label">Converted Amount:</div>
						                                            <div>Fee Rate Applied:</div>
						                                            <div>Fee Value:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>0.00</div>
						                                            <div>0.00%</div>
						                                            <div>0.00</div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-total-bar cc-total-bar--green">
						                                    <span class="cc-bar-label">Final Payable</span>
						                                    <strong class="cc-bar-value">0.00</strong>
						                                </div>
						
						                                <div class="currency-result-actions d-none">
						                                    <button type="button" class="btn-glow-outline">Cancel</button>
						                                    <button type="button" class="btn-glow">Buy Now</button>
						                                </div>
						                            </div>
						                        </c:if>
						
						                        <!-- RESULT -->
						                        <c:if test="${cardMode eq 'result' and not empty conversionResult}">
						                            <div class="cc-card-shell">
						                                <h3 class="currency-card-title cc-card-title-main">Result Card</h3>
						
						                                <c:if test="${not empty conversionResult and conversionResult.valid}">
						                                    <div class="inline-success-message show mt-2">
						                                        Calculation successful. Review the result below.
						                                    </div>
						                                </c:if>
						
						                                <div class="cc-top-strip--grid">
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Transaction Type</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${conversionResult.transactionType}" default="-"/>
						                                        </strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Base Currency</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${conversionResult.baseCurrency}" default="-"/>
						                                        </strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Target Currency</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${conversionResult.targetCurrency}" default="-"/>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="cc-amount-bar">
						                                    <span class="cc-bar-label">Amount to Convert</span>
						                                    <strong class="cc-bar-value">
						                                        <c:choose>
						                                            <c:when test="${conversionResult.baseCurrency eq 'USD'}">$</c:when>
						                                            <c:when test="${conversionResult.baseCurrency eq 'GBP'}">£</c:when>
						                                            <c:when test="${conversionResult.baseCurrency eq 'EUR'}">€</c:when>
						                                            <c:when test="${conversionResult.baseCurrency eq 'JPY'}">¥</c:when>
						                                            <c:when test="${conversionResult.baseCurrency eq 'BRL'}">R$</c:when>
						                                            <c:when test="${conversionResult.baseCurrency eq 'TRY'}">₺</c:when>
						                                            <c:otherwise>${conversionResult.baseCurrency} </c:otherwise>
						                                        </c:choose>
						                                        <fmt:formatNumber value="${conversionResult.inputAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                    </strong>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Exchange Rate Details</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div>Exchange Rate:</div>
						                                            <div>Date Rate Retrieved:</div>
						                                            <div>Time Retrieved:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>
						                                                <fmt:formatNumber value="${conversionResult.exchangeRateUsed}" minFractionDigits="2" maxFractionDigits="6"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatDate value="${conversionResult.retrievedAt}" pattern="MMM dd, yyyy"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatDate value="${conversionResult.retrievedAt}" pattern="hh:mm a"/>
						                                            </div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Fee &amp; Converted Amount</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div class="cc-accent-label">Converted Amount:</div>
						                                            <div>Fee Rate Applied:</div>
						                                            <div>Fee Value:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>
						                                                <c:choose>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${conversionResult.targetCurrency} </c:otherwise>
						                                                </c:choose>
						                                                <fmt:formatNumber value="${conversionResult.convertedAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatNumber value="${conversionResult.feeRateApplied}" minFractionDigits="1" maxFractionDigits="2"/>%
						                                            </div>
						                                            <div>
						                                                <c:choose>
						                                                    <c:when test="${conversionResult.transactionType eq 'BUY'}">
						                                                        <c:choose>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'USD'}">$</c:when>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'GBP'}">£</c:when>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'EUR'}">€</c:when>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'JPY'}">¥</c:when>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'BRL'}">R$</c:when>
						                                                            <c:when test="${conversionResult.baseCurrency eq 'TRY'}">₺</c:when>
						                                                            <c:otherwise>${conversionResult.baseCurrency} </c:otherwise>
						                                                        </c:choose>
						                                                    </c:when>
						                                                    <c:otherwise>
						                                                        <c:choose>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'USD'}">$</c:when>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'GBP'}">£</c:when>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'EUR'}">€</c:when>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'JPY'}">¥</c:when>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'BRL'}">R$</c:when>
						                                                            <c:when test="${conversionResult.targetCurrency eq 'TRY'}">₺</c:when>
						                                                            <c:otherwise>${conversionResult.targetCurrency} </c:otherwise>
						                                                        </c:choose>
						                                                    </c:otherwise>
						                                                </c:choose>
						                                                <fmt:formatNumber value="${conversionResult.feeValue}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-total-bar cc-total-bar--green">
						                                    <span class="cc-bar-label">
						                                        <c:out value="${conversionResult.finalLabel}" default="Final Payable"/>
						                                    </span>
						                                    <strong class="cc-bar-value">
						                                        <c:choose>
						                                            <c:when test="${conversionResult.transactionType eq 'BUY'}">
						                                                <c:choose>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${conversionResult.baseCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${conversionResult.baseCurrency} </c:otherwise>
						                                                </c:choose>
						                                            </c:when>
						                                            <c:otherwise>
						                                                <c:choose>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${conversionResult.targetCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${conversionResult.targetCurrency} </c:otherwise>
						                                                </c:choose>
						                                            </c:otherwise>
						                                        </c:choose>
						                                        <fmt:formatNumber value="${conversionResult.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                    </strong>
						                                </div>
						
						                                <div class="currency-result-actions cc-action-row">
						                                    <a href="${pageContext.request.contextPath}/client/currency-converter/cancel?transactionType=${conversionRequest.transactionType}"
						                                       class="btn-glow-outline text-decoration-none text-center cc-action-btn"
						                                       data-partial-link="true">
						                                        Cancel
						                                    </a>
						
						                                    <form action="${pageContext.request.contextPath}/client/currency-converter/confirm"
						                                          method="post"
						                                          class="m-0"
						                                          data-partial-form="true">
						                                        <input type="hidden" name="transactionType" value="${conversionRequest.transactionType}">
						                                        <input type="hidden" name="baseCurrency" value="${conversionRequest.baseCurrency}">
						                                        <input type="hidden" name="targetCurrency" value="${conversionRequest.targetCurrency}">
						                                        <input type="hidden" name="amount" value="${conversionRequest.amount}">
						
						                                        <button type="submit" class="btn-glow cc-action-btn">
						                                            <c:choose>
						                                                <c:when test="${conversionRequest.transactionType eq 'BUY'}">Buy Now</c:when>
						                                                <c:otherwise>Sell Now</c:otherwise>
						                                            </c:choose>
						                                        </button>
						                                    </form>
						                                </div>
						                            </div>
						                        </c:if>
						
						                        <!-- RECEIPT -->
						                        <c:if test="${cardMode eq 'receipt' and not empty receipt}">
						                            <div class="cc-card-shell">
						                                <h3 class="currency-card-title cc-card-title-main">Transaction Receipt</h3>
						
						                                <c:if test="${not empty receipt.message}">
						                                    <div class="inline-success-message show mt-2">
						                                        ${receipt.message}
						                                    </div>
						                                </c:if>
						
						                                <div class="cc-meta-block">
						                                    <div class="cc-meta-row">
						                                        <span class="cc-meta-label">Transaction Number</span>
						                                        <strong class="cc-meta-value">${receipt.transactionNumber}</strong>
						                                    </div>
						                                    <div class="cc-meta-row">
						                                        <span class="cc-meta-label">Date:</span>
						                                        <strong class="cc-meta-value">
						                                            <fmt:formatDate value="${receipt.date}" pattern="MMM dd, yyyy"/>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="cc-top-strip--grid">
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Transaction Type</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${receipt.transactionType}" default="-"/>
						                                        </strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Base Currency</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${receipt.baseCurrency}" default="-"/>
						                                        </strong>
						                                    </div>
						                                    <div class="cc-top-cell">
						                                        <span class="cc-top-label">Target Currency</span>
						                                        <strong class="cc-top-value">
						                                            <c:out value="${receipt.targetCurrency}" default="-"/>
						                                        </strong>
						                                    </div>
						                                </div>
						
						                                <div class="cc-amount-bar">
						                                    <span class="cc-bar-label">Amount to Convert</span>
						                                    <strong class="cc-bar-value">
						                                        <c:choose>
						                                            <c:when test="${receipt.baseCurrency eq 'USD'}">$</c:when>
						                                            <c:when test="${receipt.baseCurrency eq 'GBP'}">£</c:when>
						                                            <c:when test="${receipt.baseCurrency eq 'EUR'}">€</c:when>
						                                            <c:when test="${receipt.baseCurrency eq 'JPY'}">¥</c:when>
						                                            <c:when test="${receipt.baseCurrency eq 'BRL'}">R$</c:when>
						                                            <c:when test="${receipt.baseCurrency eq 'TRY'}">₺</c:when>
						                                            <c:otherwise>${receipt.baseCurrency} </c:otherwise>
						                                        </c:choose>
						                                        <fmt:formatNumber value="${receipt.inputAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                    </strong>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Exchange Rate Details</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div>Exchange Rate:</div>
						                                            <div>Date Rate Retrieved:</div>
						                                            <div>Time Retrieved:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>
						                                                <fmt:formatNumber value="${receipt.exchangeRateUsed}" minFractionDigits="2" maxFractionDigits="6"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatDate value="${receipt.date}" pattern="MMM dd, yyyy"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatDate value="${receipt.date}" pattern="hh:mm a"/>
						                                            </div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-section-divider"></div>
						
						                                <div class="cc-section-block">
						                                    <h4 class="cc-section-title">Fee &amp; Converted Amount</h4>
						
						                                    <div class="cc-detail-grid">
						                                        <div class="cc-detail-labels">
						                                            <div class="cc-accent-label">Converted Amount:</div>
						                                            <div>Fee Rate Applied:</div>
						                                            <div>Fee Value:</div>
						                                        </div>
						
						                                        <div class="cc-detail-values">
						                                            <div>
						                                                <c:choose>
						                                                    <c:when test="${receipt.targetCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${receipt.targetCurrency} </c:otherwise>
						                                                </c:choose>
						                                                <fmt:formatNumber value="${receipt.convertedAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </div>
						                                            <div>
						                                                <fmt:formatNumber value="${receipt.feeRateApplied}" minFractionDigits="1" maxFractionDigits="2"/>%
						                                            </div>
						                                            <div>
						                                                <c:choose>
						                                                    <c:when test="${receipt.transactionType eq 'BUY'}">
						                                                        <c:choose>
						                                                            <c:when test="${receipt.baseCurrency eq 'USD'}">$</c:when>
						                                                            <c:when test="${receipt.baseCurrency eq 'GBP'}">£</c:when>
						                                                            <c:when test="${receipt.baseCurrency eq 'EUR'}">€</c:when>
						                                                            <c:when test="${receipt.baseCurrency eq 'JPY'}">¥</c:when>
						                                                            <c:when test="${receipt.baseCurrency eq 'BRL'}">R$</c:when>
						                                                            <c:when test="${receipt.baseCurrency eq 'TRY'}">₺</c:when>
						                                                            <c:otherwise>${receipt.baseCurrency} </c:otherwise>
						                                                        </c:choose>
						                                                    </c:when>
						                                                    <c:otherwise>
						                                                        <c:choose>
						                                                            <c:when test="${receipt.targetCurrency eq 'USD'}">$</c:when>
						                                                            <c:when test="${receipt.targetCurrency eq 'GBP'}">£</c:when>
						                                                            <c:when test="${receipt.targetCurrency eq 'EUR'}">€</c:when>
						                                                            <c:when test="${receipt.targetCurrency eq 'JPY'}">¥</c:when>
						                                                            <c:when test="${receipt.targetCurrency eq 'BRL'}">R$</c:when>
						                                                            <c:when test="${receipt.targetCurrency eq 'TRY'}">₺</c:when>
						                                                            <c:otherwise>${receipt.targetCurrency} </c:otherwise>
						                                                        </c:choose>
						                                                    </c:otherwise>
						                                                </c:choose>
						                                                <fmt:formatNumber value="${receipt.feeValue}" minFractionDigits="2" maxFractionDigits="2"/>
						                                            </div>
						                                        </div>
						                                    </div>
						                                </div>
						
						                                <div class="cc-total-bar cc-total-bar--green">
						                                    <span class="cc-bar-label">
						                                        <c:out value="${receipt.label}" default="Paid Amount"/>
						                                    </span>
						                                    <strong class="cc-bar-value">
						                                        <c:choose>
						                                            <c:when test="${receipt.transactionType eq 'BUY'}">
						                                                <c:choose>
						                                                    <c:when test="${receipt.baseCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${receipt.baseCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${receipt.baseCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${receipt.baseCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${receipt.baseCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${receipt.baseCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${receipt.baseCurrency} </c:otherwise>
						                                                </c:choose>
						                                            </c:when>
						                                            <c:otherwise>
						                                                <c:choose>
						                                                    <c:when test="${receipt.targetCurrency eq 'USD'}">$</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'GBP'}">£</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'EUR'}">€</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'JPY'}">¥</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'BRL'}">R$</c:when>
						                                                    <c:when test="${receipt.targetCurrency eq 'TRY'}">₺</c:when>
						                                                    <c:otherwise>${receipt.targetCurrency} </c:otherwise>
						                                                </c:choose>
						                                            </c:otherwise>
						                                        </c:choose>
						                                        <fmt:formatNumber value="${receipt.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                    </strong>
						                                </div>
						
						                                <div class="currency-result-actions cc-action-row cc-action-row--center">
						                                    <a href="${pageContext.request.contextPath}/client/currency-converter/okay?transactionType=${receipt.transactionType}"
						                                       class="btn-glow text-decoration-none text-center cc-action-btn"
						                                       data-partial-link="true">
						                                        Okay
						                                    </a>
						                                </div>
						                            </div>
						                        </c:if>
						
						                    </div>
						                </div>
						            </div>
						        </div>
						
						    </div>
						</c:if>
						
						<!-- =========================
						     HISTORY SECTION
						========================= -->
						<c:if test="${activeSection eq 'history'}">
						
						    <div class="currency-title-card">
						        <h3>Transaction History</h3>
						        <p>Review your successful currency conversion transactions.</p>
						    </div>
						
						    <div class="currency-panel-card">
						        <div class="currency-card-inner">
						            <c:choose>
						                <c:when test="${not empty historyList}">
						
						                    <div class="currency-history-scroll">
						                        <div class="table-responsive">
						                            <table class="table currency-history-table">
						                                <thead>
						                                <tr>
						                                    <th>Transaction No.</th>
						                                    <th>Type</th>
						                                    <th>Date</th>
						                                    <th>Base</th>
						                                    <th>Target</th>
						                                    <th>Amount</th>
						                                    <th>Final</th>
						                                </tr>
						                                </thead>
						                                <tbody>
						                                <c:forEach var="item" items="${historyList}">
						                                    <tr>
						                                        <td>${item.transactionNumber}</td>
						                                        <td>${item.transactionType}</td>
						                                        <td>
						                                            <fmt:formatDate value="${item.date}" pattern="MMM dd, yyyy hh:mm a" timeZone="Asia/Manila"/>
						                                        </td>
						                                        <td>${item.baseCurrency}</td>
						                                        <td>${item.targetCurrency}</td>
						                                        <td>
						                                            <c:choose>
						                                                <c:when test="${item.baseCurrency eq 'USD'}">$</c:when>
						                                                <c:when test="${item.baseCurrency eq 'GBP'}">£</c:when>
						                                                <c:when test="${item.baseCurrency eq 'EUR'}">€</c:when>
						                                                <c:when test="${item.baseCurrency eq 'JPY'}">¥</c:when>
						                                                <c:when test="${item.baseCurrency eq 'BRL'}">R$</c:when>
						                                                <c:when test="${item.baseCurrency eq 'TRY'}">₺</c:when>
						                                                <c:otherwise>${item.baseCurrency} </c:otherwise>
						                                            </c:choose>
						                                            <fmt:formatNumber value="${item.inputAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                        </td>
						                                        <td>
						                                            <c:choose>
						                                                <c:when test="${item.transactionType eq 'BUY'}">
						                                                    <c:choose>
						                                                        <c:when test="${item.baseCurrency eq 'USD'}">$</c:when>
						                                                        <c:when test="${item.baseCurrency eq 'GBP'}">£</c:when>
						                                                        <c:when test="${item.baseCurrency eq 'EUR'}">€</c:when>
						                                                        <c:when test="${item.baseCurrency eq 'JPY'}">¥</c:when>
						                                                        <c:when test="${item.baseCurrency eq 'BRL'}">R$</c:when>
						                                                        <c:when test="${item.baseCurrency eq 'TRY'}">₺</c:when>
						                                                        <c:otherwise>${item.baseCurrency} </c:otherwise>
						                                                    </c:choose>
						                                                </c:when>
						                                                <c:otherwise>
						                                                    <c:choose>
						                                                        <c:when test="${item.targetCurrency eq 'USD'}">$</c:when>
						                                                        <c:when test="${item.targetCurrency eq 'GBP'}">£</c:when>
						                                                        <c:when test="${item.targetCurrency eq 'EUR'}">€</c:when>
						                                                        <c:when test="${item.targetCurrency eq 'JPY'}">¥</c:when>
						                                                        <c:when test="${item.targetCurrency eq 'BRL'}">R$</c:when>
						                                                        <c:when test="${item.targetCurrency eq 'TRY'}">₺</c:when>
						                                                        <c:otherwise>${item.targetCurrency} </c:otherwise>
						                                                    </c:choose>
						                                                </c:otherwise>
						                                            </c:choose>
						                                            <fmt:formatNumber value="${item.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
						                                        </td>
						                                    </tr>
						                                </c:forEach>
						                                </tbody>
						                            </table>
						                        </div>
						                    </div>
						
						                </c:when>
						
						                <c:otherwise>
						                    <div class="currency-empty-state">
						                        <h4>No transaction history yet</h4>
						                        <p>Your completed currency transactions will appear here.</p>
						                    </div>
						                </c:otherwise>
						            </c:choose>
						        </div>
						    </div>
						</c:if>

                    </div>

                    <!-- RIGHT MODULE SIDEBAR -->
                    <div class="col-lg-3">
                        <div class="currency-module-sidebar-wrap">
                            <div class="currency-module-sidebar">

                                <a href="${pageContext.request.contextPath}/client/currency-converter/home"
                                   class="currency-module-logo-link ${activeNav eq 'home' ? 'active' : ''}">
                                    <div class="module-logo-icon">¤</div>
                                    <div>
                                        <strong>Currency Converter</strong>
                                        <small>Back to Welcome</small>
                                    </div>
                                </a>

                                <nav class="currency-module-nav">
                                    <a href="${pageContext.request.contextPath}/client/currency-converter/history"
                                       class="currency-module-nav-link ${activeNav eq 'history' ? 'active' : ''}">
                                        Transaction History
                                    </a>

                                    <a href="${pageContext.request.contextPath}/client/currency-converter/buy"
                                       class="currency-module-nav-link ${activeNav eq 'buy' ? 'active' : ''}">
                                        Buy Currency
                                    </a>

                                    <a href="${pageContext.request.contextPath}/client/currency-converter/sell"
                                       class="currency-module-nav-link ${activeNav eq 'sell' ? 'active' : ''}">
                                        Sell Currency
                                    </a>
                                </nav>

                            </div>
                        </div>
                    </div>

                </div>
            </section>

        </main>

        <jsp:include page="/WEB-INF/components/Authenticated//client/footer.jsp" />

    </div>
</div>

<script>
    window.CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/client/client-dashboard.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/public/inline-messages.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/client/client-currency.js"></script>



</body>
</html>