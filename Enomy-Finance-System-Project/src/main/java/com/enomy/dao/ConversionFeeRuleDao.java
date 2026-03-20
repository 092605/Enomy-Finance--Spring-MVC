package com.enomy.dao;

import java.util.List;

import com.enomy.model.ConversionFeeRule;

public interface ConversionFeeRuleDao {

    void save(ConversionFeeRule feeRule);

    List<ConversionFeeRule> findByRuleSetId(Long ruleSetId);

    ConversionFeeRule findMatchingFeeRule(Long ruleSetId, Double amount);
}