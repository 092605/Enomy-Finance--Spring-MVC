package com.enomy.dao;

import com.enomy.model.ConversionRuleSet;

public interface ConversionRuleSetDao {

    ConversionRuleSet findActiveRuleSet();

    void save(ConversionRuleSet ruleSet);

    void deactivateAllRuleSets();
}