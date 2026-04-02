package com.enomy.service.admin;

import java.util.List;

import com.enomy.dto.conversion.AdminCurrencyRateRowDTO;
import com.enomy.model.conversion.ConversionFeeRule;
import com.enomy.model.conversion.ConversionRuleSet;
import com.enomy.model.conversion.CurrencyTransaction;

public interface AdminCurrencyService {

    // =========================
    // ACTIVE RULE
    // =========================

    ConversionRuleSet getActiveRuleSet();

    List<ConversionFeeRule> getActiveFeeRules();

    Double getDerivedMinAmount(List<ConversionFeeRule> rules);

    Double getDerivedMaxAmount(List<ConversionFeeRule> rules);

    Long getNextRuleSetIdPreview();

    // =========================
    // CREATE / ACTIVATE
    // =========================

    void createAndActivateRuleSet(String ruleName,
                                  String description,
                                  List<Double> minAmounts,
                                  List<Double> maxAmounts,
                                  List<Double> feeRates);

    void activateRuleSet(Long ruleSetId);

    // =========================
    // HISTORY
    // =========================

    List<ConversionRuleSet> getAllRuleSets();

    List<ConversionFeeRule> getAllFeeRules();

    // =========================
    // RATES
    // =========================

    List<AdminCurrencyRateRowDTO> getFilteredRates(String baseCurrency,
                                                   String targetCurrency,
                                                   String dateFrom,
                                                   String dateTo);

    // =========================
    // TRANSACTIONS
    // =========================

    List<CurrencyTransaction> getFilteredTransactions(String baseCurrency,
                                                      String targetCurrency,
                                                      String dateFrom,
                                                      String dateTo,
                                                      String search);
}