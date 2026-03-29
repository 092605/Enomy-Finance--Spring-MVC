package com.enomy.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.enomy.model.ConversionFeeRule;
import com.enomy.model.ConversionRuleSet;
import com.enomy.model.CurrencyTransaction;
import com.enomy.service.admin.AdminCurrencyService;
import com.enomy.dto.AdminCurrencyRateRowDTO;

@RestController
@RequestMapping("/admin/api/currency")
public class AdminCurrencyApiController {

    private final AdminCurrencyService adminCurrencyService;

    public AdminCurrencyApiController(AdminCurrencyService adminCurrencyService) {
        this.adminCurrencyService = adminCurrencyService;
    }

    // =========================
    // ACTIVE RULE SECTION
    // =========================

    @GetMapping("/active-rule")
    public ResponseEntity<Map<String, Object>> getActiveRule() {
        ConversionRuleSet activeRuleSet = adminCurrencyService.getActiveRuleSet();
        List<ConversionFeeRule> activeFeeRules = adminCurrencyService.getActiveFeeRules();

        Map<String, Object> body = new HashMap<>();
        body.put("success", true);
        body.put("activeRuleSet", activeRuleSet);
        body.put("activeFeeRules", activeFeeRules);
        body.put("activeMinAmount", adminCurrencyService.getDerivedMinAmount(activeFeeRules));
        body.put("activeMaxAmount", adminCurrencyService.getDerivedMaxAmount(activeFeeRules));
        body.put("nextRuleSetIdPreview", adminCurrencyService.getNextRuleSetIdPreview());

        return ResponseEntity.ok(body);
    }

    @PostMapping("/rules")
    public ResponseEntity<Map<String, Object>> createRuleSet(@RequestBody CreateRuleSetRequest request) {
        Map<String, Object> body = new HashMap<>();

        try {
            adminCurrencyService.createAndActivateRuleSet(
                    request.getRuleName(),
                    request.getDescription(),
                    request.getMinAmounts(),
                    request.getMaxAmounts(),
                    request.getFeeRates()
            );

            ConversionRuleSet activeRuleSet = adminCurrencyService.getActiveRuleSet();
            List<ConversionFeeRule> activeFeeRules = adminCurrencyService.getActiveFeeRules();

            body.put("success", true);
            body.put("message", "New conversion rule set created and activated successfully.");
            body.put("activeRuleSet", activeRuleSet);
            body.put("activeFeeRules", activeFeeRules);
            body.put("activeMinAmount", adminCurrencyService.getDerivedMinAmount(activeFeeRules));
            body.put("activeMaxAmount", adminCurrencyService.getDerivedMaxAmount(activeFeeRules));
            body.put("nextRuleSetIdPreview", adminCurrencyService.getNextRuleSetIdPreview());

            return ResponseEntity.ok(body);

        } catch (Exception e) {
            body.put("success", false);
            body.put("message", e.getMessage() != null ? e.getMessage() : "Unable to create conversion rule set.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    // =========================
    // HISTORY SECTION
    // =========================

    @GetMapping("/rules/history")
    public ResponseEntity<Map<String, Object>> getRuleHistory() {
        Map<String, Object> body = new HashMap<>();
        body.put("success", true);
        body.put("conversionRuleHistory", adminCurrencyService.getAllRuleSets());
        body.put("allFeeRulesForModal", adminCurrencyService.getAllFeeRules());
        return ResponseEntity.ok(body);
    }

    @GetMapping("/rules/{ruleSetId}")
    public ResponseEntity<Map<String, Object>> getRuleDetails(
            @PathVariable("ruleSetId") Long ruleSetId) {
        Map<String, Object> body = new HashMap<>();

        try {
            System.out.println("=== GET RULE DETAILS ===");
            System.out.println("RuleSetId: " + ruleSetId);

            List<ConversionRuleSet> allRuleSets = adminCurrencyService.getAllRuleSets();
            ConversionRuleSet selected = allRuleSets.stream()
                    .filter(r -> r.getId().equals(ruleSetId))
                    .findFirst()
                    .orElse(null);

            if (selected == null) {
                body.put("success", false);
                body.put("message", "Rule set not found.");
                return ResponseEntity.badRequest().body(body);
            }

            List<ConversionFeeRule> details = adminCurrencyService.getAllFeeRules().stream()
                    .filter(r -> r.getRuleSetId().equals(ruleSetId))
                    .toList();

            Map<String, Object> ruleSetDto = new HashMap<>();
            ruleSetDto.put("id", selected.getId());
            ruleSetDto.put("ruleName", selected.getRuleName());
            ruleSetDto.put("description", selected.getDescription());
            ruleSetDto.put("active", selected.getActive());

            List<Map<String, Object>> feeRuleDtos = details.stream().map(rule -> {
                Map<String, Object> row = new HashMap<>();
                row.put("minAmount", rule.getMinAmount());
                row.put("maxAmount", rule.getMaxAmount());
                row.put("feeRate", rule.getFeeRate());
                return row;
            }).toList();

            body.put("success", true);
            body.put("ruleSet", ruleSetDto);
            body.put("feeRules", feeRuleDtos);
            body.put("minAmount", adminCurrencyService.getDerivedMinAmount(details));
            body.put("maxAmount", adminCurrencyService.getDerivedMaxAmount(details));

            System.out.println("Rule details response prepared successfully.");
            return ResponseEntity.ok(body);

        } catch (Exception e) {
            System.out.println("=== ERROR IN getRuleDetails ===");
            e.printStackTrace();

            body.put("success", false);
            body.put("message", e.getMessage() != null ? e.getMessage() : "Unable to load rule details.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    @PostMapping("/rules/{ruleSetId}/activate")
    public ResponseEntity<Map<String, Object>> activateRuleSet(@PathVariable("ruleSetId") Long ruleSetId) {
        Map<String, Object> body = new HashMap<>();

        try {
            adminCurrencyService.activateRuleSet(ruleSetId);

            body.put("success", true);
            body.put("message", "Conversion rule set activated successfully.");
            body.put("activeRuleSet", adminCurrencyService.getActiveRuleSet());
            body.put("conversionRuleHistory", adminCurrencyService.getAllRuleSets());

            return ResponseEntity.ok(body);

        } catch (Exception e) {
            e.printStackTrace();
            body.put("success", false);
            body.put("message", e.getMessage() != null ? e.getMessage() : "Unable to activate conversion rule set.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    // =========================
    // RATES SECTION
    // =========================

    @PostMapping("/rates/filter")
    public ResponseEntity<Map<String, Object>> filterRates(@RequestBody RatesFilterRequest request) {

        Map<String, Object> body = new HashMap<>();

        try {
            // 🔍 DEBUG INPUT
            System.out.println("=== FILTER RATES REQUEST ===");
            System.out.println("Base: " + request.getBaseCurrency());
            System.out.println("Target: " + request.getTargetCurrency());
            System.out.println("Date From: " + request.getDateFrom());
            System.out.println("Date To: " + request.getDateTo());

            List<AdminCurrencyRateRowDTO> results = adminCurrencyService.getFilteredRates(
                    request.getBaseCurrency(),
                    request.getTargetCurrency(),
                    request.getDateFrom(),
                    request.getDateTo()
            );

            body.put("success", true);
            body.put("rateResults", results);

            return ResponseEntity.ok(body);

        } catch (Exception e) {
            // 🔥 VERY IMPORTANT → shows real error in Eclipse console
            System.out.println("=== ERROR IN filterRates ===");
            e.printStackTrace();

            body.put("success", false);
            body.put("message", e.getMessage() != null ? e.getMessage() : "Unable to retrieve currency rates.");
            return ResponseEntity.badRequest().body(body);
        }
    }
    // =========================
    // TRANSACTIONS SECTION
    // =========================

    @PostMapping("/transactions/filter")
    public ResponseEntity<Map<String, Object>> filterTransactions(@RequestBody TransactionsFilterRequest request) {
        Map<String, Object> body = new HashMap<>();

        try {
            List<CurrencyTransaction> results = adminCurrencyService.getFilteredTransactions(
                    request.getBaseCurrency(),
                    request.getTargetCurrency(),
                    request.getDateFrom(),
                    request.getDateTo(),
                    request.getSearch()
            );

            body.put("success", true);
            body.put("transactionHistory", results);
            return ResponseEntity.ok(body);

        } catch (Exception e) {
            body.put("success", false);
            body.put("message", e.getMessage() != null ? e.getMessage() : "Unable to retrieve transactions.");
            return ResponseEntity.badRequest().body(body);
        }
    }

    // =========================
    // REQUEST DTOs
    // =========================

    public static class CreateRuleSetRequest {
        private String ruleName;
        private String description;
        private List<Double> minAmounts;
        private List<Double> maxAmounts;
        private List<Double> feeRates;

        public String getRuleName() { return ruleName; }
        public void setRuleName(String ruleName) { this.ruleName = ruleName; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public List<Double> getMinAmounts() { return minAmounts; }
        public void setMinAmounts(List<Double> minAmounts) { this.minAmounts = minAmounts; }

        public List<Double> getMaxAmounts() { return maxAmounts; }
        public void setMaxAmounts(List<Double> maxAmounts) { this.maxAmounts = maxAmounts; }

        public List<Double> getFeeRates() { return feeRates; }
        public void setFeeRates(List<Double> feeRates) { this.feeRates = feeRates; }
    }

    public static class RatesFilterRequest {
        private String baseCurrency;
        private String targetCurrency;
        private String dateFrom;
        private String dateTo;

        public String getBaseCurrency() { return baseCurrency; }
        public void setBaseCurrency(String baseCurrency) { this.baseCurrency = baseCurrency; }

        public String getTargetCurrency() { return targetCurrency; }
        public void setTargetCurrency(String targetCurrency) { this.targetCurrency = targetCurrency; }

        public String getDateFrom() { return dateFrom; }
        public void setDateFrom(String dateFrom) { this.dateFrom = dateFrom; }

        public String getDateTo() { return dateTo; }
        public void setDateTo(String dateTo) { this.dateTo = dateTo; }
    }

    public static class TransactionsFilterRequest {
        private String baseCurrency;
        private String targetCurrency;
        private String dateFrom;
        private String dateTo;
        private String search;

        public String getBaseCurrency() { return baseCurrency; }
        public void setBaseCurrency(String baseCurrency) { this.baseCurrency = baseCurrency; }

        public String getTargetCurrency() { return targetCurrency; }
        public void setTargetCurrency(String targetCurrency) { this.targetCurrency = targetCurrency; }

        public String getDateFrom() { return dateFrom; }
        public void setDateFrom(String dateFrom) { this.dateFrom = dateFrom; }

        public String getDateTo() { return dateTo; }
        public void setDateTo(String dateTo) { this.dateTo = dateTo; }

        public String getSearch() { return search; }
        public void setSearch(String search) { this.search = search; }
    }
}