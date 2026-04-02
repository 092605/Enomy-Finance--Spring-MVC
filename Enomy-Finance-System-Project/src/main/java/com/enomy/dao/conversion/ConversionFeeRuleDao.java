package com.enomy.dao.conversion;

import java.util.List;

import com.enomy.model.conversion.ConversionFeeRule;

public interface ConversionFeeRuleDao {

    void save(ConversionFeeRule feeRule);

    List<ConversionFeeRule> findByRuleSetId(Long ruleSetId);

    ConversionFeeRule findMatchingFeeRule(Long ruleSetId, Double amount);

    List<ConversionFeeRule> findAllOrderByRuleSetIdAscMinAmountAsc();
}