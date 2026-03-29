package com.enomy.dao;

import java.util.List;

import com.enomy.model.ConversionRuleSet;

public interface ConversionRuleSetDao {

    ConversionRuleSet findActiveRuleSet();

    void save(ConversionRuleSet ruleSet);

    void deactivateAllRuleSets();

    Long findMaxRuleSetId();

    ConversionRuleSet findById(Long id);

    void activateRuleSet(Long id);

    List<ConversionRuleSet> findAllOrderByCreatedAtDesc();
}