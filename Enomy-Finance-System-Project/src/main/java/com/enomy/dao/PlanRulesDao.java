package com.enomy.dao;

import java.util.List;

import com.enomy.model.PlanRules;

public interface PlanRulesDao {

    // ✅ EXISTING (DO NOT TOUCH)
    PlanRules findActiveByPlanType(String planType);

    PlanRules findById(Long id);

    // ============================
    // 🆕 ADMIN METHODS (ADD ONLY)
    // ============================

    /**
     * Get all active plan rules (should return 3 rows: Basic, Plus, Managed)
     */
    List<PlanRules> findActivePlanSet();

    /**
     * Get all plan rules ordered by plan_set_id DESC (for history)
     */
    List<PlanRules> findAllPlanRulesOrdered();

    /**
     * Get next plan_set_id (for new version)
     */
    Long getNextPlanSetId();

    /**
     * Deactivate all plan rules
     */
    void deactivateAllPlanRules();

    /**
     * Insert a new plan rule row
     */
    void insertPlanRule(PlanRules planRules);
    
    List<PlanRules> findByPlanSetId(Long planSetId);
}