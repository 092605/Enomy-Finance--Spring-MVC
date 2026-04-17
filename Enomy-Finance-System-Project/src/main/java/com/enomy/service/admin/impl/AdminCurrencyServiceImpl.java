package com.enomy.service.admin.impl;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.enomy.service.admin.AdminCurrencyService;
import com.enomy.service.client.CurrencyApiService;
import com.enomy.dao.conversion.ConversionFeeRuleDao;
import com.enomy.dao.conversion.ConversionRuleSetDao;
import com.enomy.dao.conversion.CurrencyTransactionDao;
import com.enomy.dto.conversion.AdminCurrencyRateRowDTO;
import com.enomy.model.conversion.ConversionFeeRule;
import com.enomy.model.conversion.ConversionRuleSet;
import com.enomy.model.conversion.CurrencyTransaction;

@Service
@Transactional
public class AdminCurrencyServiceImpl implements AdminCurrencyService {

    private final ConversionRuleSetDao conversionRuleSetDao;
    private final ConversionFeeRuleDao conversionFeeRuleDao;
    private final CurrencyTransactionDao currencyTransactionDao;
    private final CurrencyApiService currencyApiService;

    public AdminCurrencyServiceImpl(ConversionRuleSetDao conversionRuleSetDao,
                                    ConversionFeeRuleDao conversionFeeRuleDao,
                                    CurrencyTransactionDao currencyTransactionDao,
                                    CurrencyApiService currencyApiService) {
        this.conversionRuleSetDao = conversionRuleSetDao;
        this.conversionFeeRuleDao = conversionFeeRuleDao;
        this.currencyTransactionDao = currencyTransactionDao;
        this.currencyApiService = currencyApiService;
    }

    // =========================
    // ACTIVE RULE
    // =========================

    @Override
    @Transactional(readOnly = true)
    public ConversionRuleSet getActiveRuleSet() {
        return conversionRuleSetDao.findActiveRuleSet();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ConversionFeeRule> getActiveFeeRules() {
        ConversionRuleSet activeRuleSet = conversionRuleSetDao.findActiveRuleSet();

        if (activeRuleSet == null) {
            return new ArrayList<>();
        }

        return sortRules(conversionFeeRuleDao.findByRuleSetId(activeRuleSet.getId()));
    }

    @Override
    public Double getDerivedMinAmount(List<ConversionFeeRule> rules) {
        List<ConversionFeeRule> sorted = sortRules(rules);

        if (sorted.isEmpty()) {
            return null;
        }

        return sorted.get(0).getMinAmount();
    }

    @Override
    public Double getDerivedMaxAmount(List<ConversionFeeRule> rules) {
        List<ConversionFeeRule> sorted = sortRules(rules);

        if (sorted.isEmpty()) {
            return null;
        }

        return sorted.get(sorted.size() - 1).getMaxAmount();
    }

    @Override
    @Transactional(readOnly = true)
    public Long getNextRuleSetIdPreview() {
        Long maxId = conversionRuleSetDao.findMaxRuleSetId();
        return maxId == null ? 1L : maxId + 1L;
    }

    // =========================
    // CREATE / ACTIVATE
    // =========================

    @Override
    public void createAndActivateRuleSet(String ruleName,
                                         String description,
                                         List<Double> minAmounts,
                                         List<Double> maxAmounts,
                                         List<Double> feeRates) {

        validateBracketInputs(minAmounts, maxAmounts, feeRates);

        List<ConversionFeeRule> draftRules = buildDraftRules(minAmounts, maxAmounts, feeRates);
        validateRuleBrackets(draftRules);

        conversionRuleSetDao.deactivateAllRuleSets();

        ConversionRuleSet newRuleSet = new ConversionRuleSet();
        newRuleSet.setRuleName(isBlank(ruleName) ? null : ruleName.trim());
        newRuleSet.setDescription(isBlank(description) ? null : description.trim());
        newRuleSet.setActive(true);

        conversionRuleSetDao.save(newRuleSet);

        // Re-read active set to get the generated ID using your existing DAO pattern.
        ConversionRuleSet savedActiveRuleSet = conversionRuleSetDao.findActiveRuleSet();
        if (savedActiveRuleSet == null) {
            throw new IllegalStateException("New conversion rule set was saved but could not be reloaded.");
        }

        for (ConversionFeeRule draftRule : draftRules) {
            ConversionFeeRule feeRule = new ConversionFeeRule();
            feeRule.setRuleSetId(savedActiveRuleSet.getId());
            feeRule.setMinAmount(draftRule.getMinAmount());
            feeRule.setMaxAmount(draftRule.getMaxAmount());
            feeRule.setFeeRate(draftRule.getFeeRate());

            conversionFeeRuleDao.save(feeRule);
        }
    }

    @Override
    public void activateRuleSet(Long ruleSetId) {
        if (ruleSetId == null) {
            throw new IllegalArgumentException("Rule set ID is required.");
        }

        ConversionRuleSet targetRuleSet = conversionRuleSetDao.findById(ruleSetId);
        if (targetRuleSet == null) {
            throw new IllegalArgumentException("Selected conversion rule set was not found.");
        }

        conversionRuleSetDao.deactivateAllRuleSets();
        conversionRuleSetDao.activateRuleSet(ruleSetId);
    }

    // =========================
    // HISTORY
    // =========================

    @Override
    @Transactional(readOnly = true)
    public List<ConversionRuleSet> getAllRuleSets() {

        List<ConversionRuleSet> list = conversionRuleSetDao.findAllOrderByCreatedAtDesc();

        list.sort((a, b) -> {
            if (Boolean.TRUE.equals(a.getActive())) return -1;
            if (Boolean.TRUE.equals(b.getActive())) return 1;

            // fallback: newest first
            if (a.getCreatedAt() == null || b.getCreatedAt() == null) return 0;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });

        return list;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ConversionFeeRule> getAllFeeRules() {
        return conversionFeeRuleDao.findAllOrderByRuleSetIdAscMinAmountAsc();
    }

    // =========================
    // RATES
    // =========================

    @Override
    @Transactional(readOnly = true)
    public List<AdminCurrencyRateRowDTO> getFilteredRates(String baseCurrency,
                                                          String targetCurrency,
                                                          String dateFrom,
                                                          String dateTo) {

        System.out.println("=== ENTER getFilteredRates ===");
        System.out.println("BaseCurrency: " + baseCurrency);
        System.out.println("TargetCurrency: " + targetCurrency);
        System.out.println("DateFrom: " + dateFrom);
        System.out.println("DateTo: " + dateTo);

        List<AdminCurrencyRateRowDTO> results = new ArrayList<>();

        if (isBlank(baseCurrency) || isBlank(targetCurrency)) {
            System.out.println("⚠️ Base or Target currency is blank");
            return results;
        }

        List<LocalDate> dates = buildDateRange(dateFrom, dateTo);

        System.out.println("Generated Dates: " + dates);

        for (LocalDate date : dates) {

            System.out.println("➡ Fetching rate for date: " + date);

            Double rate = currencyApiService.getHistoricalExchangeRate(
                    baseCurrency.toUpperCase(Locale.ROOT),
                    targetCurrency.toUpperCase(Locale.ROOT),
                    date
            );

            System.out.println("Returned rate: " + rate);

            if (rate != null) {
                AdminCurrencyRateRowDTO row = new AdminCurrencyRateRowDTO();
                row.setBaseCurrency(baseCurrency.toUpperCase(Locale.ROOT));
                row.setTargetCurrency(targetCurrency.toUpperCase(Locale.ROOT));
                row.setExchangeRate(rate);
                row.setRateDate(date.toString());
                row.setRetrievedAt(LocalDateTime.now().toString());

                results.add(row);
            }
        }

        System.out.println("Final results size: " + results.size());

        return results;
    }

    // =========================
    // TRANSACTIONS
    // =========================

    @Override
    @Transactional(readOnly = true)
    public List<CurrencyTransaction> getFilteredTransactions(String baseCurrency,
                                                             String targetCurrency,
                                                             String dateFrom,
                                                             String dateTo,
                                                             String search) {
        return currencyTransactionDao.findFilteredTransactions(
                normalizeBlank(baseCurrency),
                normalizeBlank(targetCurrency),
                normalizeBlank(dateFrom),
                normalizeBlank(dateTo),
                normalizeBlank(search)
        );
    }

    // =========================
    // HELPERS
    // =========================

    private void validateBracketInputs(List<Double> minAmounts,
                                       List<Double> maxAmounts,
                                       List<Double> feeRates) {

        if (minAmounts == null || maxAmounts == null || feeRates == null) {
            throw new IllegalArgumentException("Bracket values are required.");
        }

        if (minAmounts.isEmpty() || maxAmounts.isEmpty() || feeRates.isEmpty()) {
            throw new IllegalArgumentException("At least one bracket is required.");
        }

        if (minAmounts.size() != maxAmounts.size() || minAmounts.size() != feeRates.size()) {
            throw new IllegalArgumentException("Bracket rows are incomplete.");
        }
    }

    private List<ConversionFeeRule> buildDraftRules(List<Double> minAmounts,
                                                    List<Double> maxAmounts,
                                                    List<Double> feeRates) {

        List<ConversionFeeRule> rules = new ArrayList<>();

        for (int i = 0; i < minAmounts.size(); i++) {
            Double min = minAmounts.get(i);
            Double max = maxAmounts.get(i);
            Double fee = feeRates.get(i);

            if (min == null || max == null || fee == null) {
                throw new IllegalArgumentException("Every bracket row must be fully completed.");
            }

            ConversionFeeRule rule = new ConversionFeeRule();
            rule.setMinAmount(min);
            rule.setMaxAmount(max);
            rule.setFeeRate(fee);

            rules.add(rule);
        }

        return sortRules(rules);
    }

    private void validateRuleBrackets(List<ConversionFeeRule> rules) {
        if (rules == null || rules.isEmpty()) {
            throw new IllegalArgumentException("At least one bracket is required.");
        }

        for (int i = 0; i < rules.size(); i++) {
            ConversionFeeRule current = rules.get(i);

            if (current.getMinAmount() == null || current.getMaxAmount() == null || current.getFeeRate() == null) {
                throw new IllegalArgumentException("Each bracket must contain minimum, maximum, and fee rate.");
            }

            if (current.getMinAmount() >= current.getMaxAmount()) {
                throw new IllegalArgumentException("Each bracket minimum must be less than the maximum.");
            }

            if (current.getFeeRate() < 0) {
                throw new IllegalArgumentException("Fee rate cannot be negative.");
            }

            if (i > 0) {
                ConversionFeeRule previous = rules.get(i - 1);

                if (previous.getMaxAmount() > current.getMinAmount()) {
                    throw new IllegalArgumentException("Fee brackets must not overlap.");
                }

                double expectedNextMin = roundToTwoDecimals(previous.getMaxAmount() + 0.01);
                double actualMin = roundToTwoDecimals(current.getMinAmount());

                if (actualMin != expectedNextMin) {
                    throw new IllegalArgumentException("Fee brackets must be continuous with no gaps.");
                }
            }
        }
    }
    
    private double roundToTwoDecimals(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private List<ConversionFeeRule> sortRules(List<ConversionFeeRule> rules) {
        if (rules == null) {
            return new ArrayList<>();
        }

        return rules.stream()
                .sorted(Comparator.comparing(ConversionFeeRule::getMinAmount, Comparator.nullsLast(Double::compareTo)))
                .collect(Collectors.toList());
    }

    private List<LocalDate> buildDateRange(String dateFrom, String dateTo) {
    	
    	System.out.println("=== buildDateRange ===");
    	System.out.println("Input From: " + dateFrom);
    	System.out.println("Input To: " + dateTo);
    	
        List<LocalDate> dates = new ArrayList<>();

        if (isBlank(dateFrom) && isBlank(dateTo)) {
            dates.add(LocalDate.now());
            return dates;
        }

        LocalDate from = isBlank(dateFrom) ? LocalDate.now() : parseFlexibleDate(dateFrom);
        LocalDate to = isBlank(dateTo) ? from : parseFlexibleDate(dateTo);

        if (from == null || to == null) {
            throw new IllegalArgumentException("Invalid date format. Please use a valid date.");
        }

        if (to.isBefore(from)) {
            throw new IllegalArgumentException("Date To must not be earlier than Date From.");
        }

        LocalDate cursor = from;
        while (!cursor.isAfter(to)) {
            dates.add(cursor);
            cursor = cursor.plusDays(1);
        }

        return dates;
    }

    private LocalDate parseFlexibleDate(String value) {
        if (isBlank(value)) {
            return null;
        }

        String input = value.trim();

        DateTimeFormatter[] formatters = new DateTimeFormatter[] {
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ofPattern("MM/dd/yyyy")
        };

        for (DateTimeFormatter formatter : formatters) {
            try {
                return LocalDate.parse(input, formatter);
            } catch (Exception ignored) {
            }
        }

        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String normalizeBlank(String value) {
        return isBlank(value) ? null : value.trim();
    }

   
}