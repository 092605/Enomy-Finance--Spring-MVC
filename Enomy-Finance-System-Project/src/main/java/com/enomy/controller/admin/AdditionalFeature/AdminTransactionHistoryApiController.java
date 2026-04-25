package com.enomy.controller.admin.AdditionalFeature;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.enomy.dto.conversion.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.dto.investment.AdminInvestmentQuoteHistoryRowDTO;
import com.enomy.service.admin.AdminTransactionHistoryService;

/*
 * =========================================================
 * ADMIN TRANSACTION HISTORY API CONTROLLER
 * =========================================================
 *
 * File Name:
 * AdminTransactionHistoryApiController.java
 *
 * Purpose:
 * This REST API controller handles AJAX-based filtering
 * and retrieval of administrator transaction history data.
 *
 * Overview:
 * The controller provides backend API endpoints for:
 * - Currency transaction history filtering
 * - Investment quote history filtering
 *
 * The data returned by this controller is typically
 * consumed dynamically using JavaScript (AJAX)
 * inside the admin transaction history page.
 *
 * Main Responsibilities:
 * - Receive transaction filter requests
 * - Process currency transaction filtering
 * - Process investment quote filtering
 * - Return JSON API responses
 * - Handle transaction search operations
 * - Handle filtering exceptions safely
 *
 * Connected Frontend:
 * - transaction-history.jsp
 * - admin-transaction-history.js
 *
 * API Base Route:
 * /admin/api/transaction-history
 *
 * Security:
 * These endpoints are protected by Spring Security
 * and are accessible only to authenticated
 * ADMIN users.
 *
 * =========================================================
 */

@RestController
/*
 * @RestController
 *
 * Combines:
 * - @Controller
 * - @ResponseBody
 *
 * Automatically returns JSON responses.
 */
@RequestMapping("/admin/api/transaction-history")
/*
 * Base URL for all API endpoints in this controller.
 */
public class AdminTransactionHistoryApiController {

    /*
     * =========================================================
     * SERVICE DEPENDENCY
     * =========================================================
     */

    private final AdminTransactionHistoryService
            adminTransactionHistoryService;

    /*
     * Constructor Injection
     *
     * Injects the service layer responsible for
     * retrieving transaction history data.
     */
    public AdminTransactionHistoryApiController(
            AdminTransactionHistoryService
                    adminTransactionHistoryService) {

        this.adminTransactionHistoryService =
                adminTransactionHistoryService;
    }

    /*
     * =========================================================
     * CURRENCY TRANSACTION FILTER API
     * =========================================================
     */

    @PostMapping("/currency/filter")
    /*
     * Handles POST requests for:
     *
     * /admin/api/transaction-history/currency/filter
     *
     * Used by AJAX requests from the admin page.
     */
    public ResponseEntity<Map<String, Object>>
    filterCurrencyTransactions(

            /*
             * @RequestBody
             *
             * Automatically converts incoming JSON request
             * into a Java object.
             */
            @RequestBody
            CurrencyTransactionHistoryFilterRequest request) {

        /*
         * Response body map
         *
         * Used to build JSON response data.
         */
        Map<String, Object> body = new HashMap<>();

        try {

            /*
             * Retrieves filtered currency transactions
             * from the service layer.
             */
            List<AdminCurrencyTransactionHistoryRowDTO>
                    results =

                    adminTransactionHistoryService
                    .getCurrencyTransactionHistory(

                            /*
                             * FILTER PARAMETERS
                             */

                            request.getBaseCurrency(),
                            request.getTargetCurrency(),
                            request.getTransactionType(),
                            request.getDateFrom(),
                            request.getDateTo(),
                            request.getSearch()
                    );

            /*
             * SUCCESS RESPONSE
             */

            body.put("success", true);

            /*
             * Adds filtered transaction rows
             * into the JSON response.
             */
            body.put("currencyTransactions", results);

            /*
             * Returns HTTP 200 OK response.
             */
            return ResponseEntity.ok(body);

        } catch (Exception e) {

            /*
             * ERROR RESPONSE
             */

            body.put("success", false);

            /*
             * Returns actual exception message if available.
             * Otherwise returns fallback message.
             */
            body.put(
                    "message",

                    e.getMessage() != null
                    ? e.getMessage()
                    : "Unable to retrieve currency transaction history."
            );

            /*
             * Returns HTTP 400 Bad Request response.
             */
            return ResponseEntity.badRequest().body(body);
        }
    }

    /*
     * =========================================================
     * INVESTMENT QUOTE FILTER API
     * =========================================================
     */

    @PostMapping("/investment/filter")
    /*
     * Handles POST requests for:
     *
     * /admin/api/transaction-history/investment/filter
     */
    public ResponseEntity<Map<String, Object>>
    filterInvestmentQuotes(

            @RequestBody
            InvestmentQuoteHistoryFilterRequest request) {

        /*
         * Response body container.
         */
        Map<String, Object> body = new HashMap<>();

        try {

            /*
             * Retrieves filtered investment quote records.
             */
            List<AdminInvestmentQuoteHistoryRowDTO>
                    results =

                    adminTransactionHistoryService
                    .getInvestmentQuoteHistory(

                            /*
                             * FILTER PARAMETERS
                             */

                            request.getPlanType(),
                            request.getDateFrom(),
                            request.getDateTo(),
                            request.getSearch()
                    );

            /*
             * SUCCESS RESPONSE
             */

            body.put("success", true);

            /*
             * Adds filtered investment quote rows.
             */
            body.put("investmentQuotes", results);

            /*
             * Returns HTTP 200 OK response.
             */
            return ResponseEntity.ok(body);

        } catch (Exception e) {

            /*
             * ERROR RESPONSE
             */

            body.put("success", false);

            body.put(
                    "message",

                    e.getMessage() != null
                    ? e.getMessage()
                    : "Unable to retrieve investment quote history."
            );

            /*
             * Returns HTTP 400 Bad Request response.
             */
            return ResponseEntity.badRequest().body(body);
        }
    }

    /*
     * =========================================================
     * REQUEST DTO CLASSES
     * =========================================================
     *
     * These classes are used to receive incoming
     * JSON filter request data from AJAX calls.
     *
     * They act as temporary request containers.
     */

    /*
     * =========================================================
     * CURRENCY TRANSACTION FILTER REQUEST DTO
     * =========================================================
     */

    public static class CurrencyTransactionHistoryFilterRequest {

        /*
         * FILTER FIELDS
         */

        private String baseCurrency;
        private String targetCurrency;
        private String transactionType;
        private String dateFrom;
        private String dateTo;
        private String search;

        /*
         * =========================================================
         * GETTERS AND SETTERS
         * =========================================================
         *
         * Required for:
         * - JSON mapping
         * - Spring request binding
         * - JavaBean compatibility
         */

        public String getBaseCurrency() {
            return baseCurrency;
        }

        public void setBaseCurrency(String baseCurrency) {
            this.baseCurrency = baseCurrency;
        }

        public String getTargetCurrency() {
            return targetCurrency;
        }

        public void setTargetCurrency(String targetCurrency) {
            this.targetCurrency = targetCurrency;
        }

        public String getTransactionType() {
            return transactionType;
        }

        public void setTransactionType(String transactionType) {
            this.transactionType = transactionType;
        }

        public String getDateFrom() {
            return dateFrom;
        }

        public void setDateFrom(String dateFrom) {
            this.dateFrom = dateFrom;
        }

        public String getDateTo() {
            return dateTo;
        }

        public void setDateTo(String dateTo) {
            this.dateTo = dateTo;
        }

        public String getSearch() {
            return search;
        }

        public void setSearch(String search) {
            this.search = search;
        }
    }

    /*
     * =========================================================
     * INVESTMENT QUOTE FILTER REQUEST DTO
     * =========================================================
     */

    public static class InvestmentQuoteHistoryFilterRequest {

        /*
         * FILTER FIELDS
         */

        private String planType;
        private String dateFrom;
        private String dateTo;
        private String search;

        /*
         * =========================================================
         * GETTERS AND SETTERS
         * =========================================================
         */

        public String getPlanType() {
            return planType;
        }

        public void setPlanType(String planType) {
            this.planType = planType;
        }

        public String getDateFrom() {
            return dateFrom;
        }

        public void setDateFrom(String dateFrom) {
            this.dateFrom = dateFrom;
        }

        public String getDateTo() {
            return dateTo;
        }

        public void setDateTo(String dateTo) {
            this.dateTo = dateTo;
        }

        public String getSearch() {
            return search;
        }

        public void setSearch(String search) {
            this.search = search;
        }
    }
}