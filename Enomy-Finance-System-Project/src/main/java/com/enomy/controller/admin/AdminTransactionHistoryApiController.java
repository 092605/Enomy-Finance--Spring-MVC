package com.enomy.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.enomy.dto.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.dto.AdminInvestmentQuoteHistoryRowDTO;
import com.enomy.service.admin.AdminTransactionHistoryService;

@RestController
@RequestMapping("/admin/api/transaction-history")
public class AdminTransactionHistoryApiController {

    private final AdminTransactionHistoryService adminTransactionHistoryService;

    public AdminTransactionHistoryApiController(AdminTransactionHistoryService adminTransactionHistoryService) {
        this.adminTransactionHistoryService = adminTransactionHistoryService;
    }

    // =========================
    // CURRENCY TRANSACTIONS
    // =========================
    @PostMapping("/currency/filter")
    public ResponseEntity<Map<String, Object>> filterCurrencyTransactions(
            @RequestBody CurrencyTransactionHistoryFilterRequest request) {

        Map<String, Object> body = new HashMap<>();

        try {
            List<AdminCurrencyTransactionHistoryRowDTO> results =
                    adminTransactionHistoryService.getCurrencyTransactionHistory(
                            request.getBaseCurrency(),
                            request.getTargetCurrency(),
                            request.getTransactionType(),
                            request.getDateFrom(),
                            request.getDateTo(),
                            request.getSearch()
                    );

            body.put("success", true);
            body.put("currencyTransactions", results);
            return ResponseEntity.ok(body);

        } catch (Exception e) {
            body.put("success", false);
            body.put("message", e.getMessage() != null
                    ? e.getMessage()
                    : "Unable to retrieve currency transaction history.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    // =========================
    // INVESTMENT QUOTES
    // =========================
    @PostMapping("/investment/filter")
    public ResponseEntity<Map<String, Object>> filterInvestmentQuotes(
            @RequestBody InvestmentQuoteHistoryFilterRequest request) {

        Map<String, Object> body = new HashMap<>();

        try {
            List<AdminInvestmentQuoteHistoryRowDTO> results =
                    adminTransactionHistoryService.getInvestmentQuoteHistory(
                            request.getPlanType(),
                            request.getDateFrom(),
                            request.getDateTo(),
                            request.getSearch()
                    );

            body.put("success", true);
            body.put("investmentQuotes", results);
            return ResponseEntity.ok(body);

        } catch (Exception e) {
            body.put("success", false);
            body.put("message", e.getMessage() != null
                    ? e.getMessage()
                    : "Unable to retrieve investment quote history.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    // =========================
    // REQUEST DTOs
    // =========================
    public static class CurrencyTransactionHistoryFilterRequest {
        private String baseCurrency;
        private String targetCurrency;
        private String transactionType;
        private String dateFrom;
        private String dateTo;
        private String search;

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

    public static class InvestmentQuoteHistoryFilterRequest {
        private String planType;
        private String dateFrom;
        private String dateTo;
        private String search;

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