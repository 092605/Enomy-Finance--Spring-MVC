package com.enomy.service.admin;

import java.util.List;

import com.enomy.model.ConversionFeeRule;
import com.enomy.model.ConversionRuleSet;
import com.enomy.model.CurrencyTransaction;
import com.enomy.dto.AdminCurrencyRateRowDTO;

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