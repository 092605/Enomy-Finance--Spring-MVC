package com.enomy.dao;

import com.enomy.model.PlanRules;

public interface PlanRulesDao {

    PlanRules findActiveByPlanType(String planType);

    PlanRules findById(Long id);
}