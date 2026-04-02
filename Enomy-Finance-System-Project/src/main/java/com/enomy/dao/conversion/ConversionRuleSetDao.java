package com.enomy.dao.conversion;

import java.util.List;

import com.enomy.model.conversion.ConversionRuleSet;

public interface ConversionRuleSetDao {

    ConversionRuleSet findActiveRuleSet();

    void save(ConversionRuleSet ruleSet);

    void deactivateAllRuleSets();

    Long findMaxRuleSetId();

    ConversionRuleSet findById(Long id);

    void activateRuleSet(Long id);

    List<ConversionRuleSet> findAllOrderByCreatedAtDesc();
}