package com.enomy.service.admin;

import java.util.List;

import com.enomy.model.PlanRules;
import com.enomy.model.TaxSettings;

public interface AdminInvestmentService {

    // =========================
    // ACTIVE DISPLAY
    // =========================

    // Gets the currently active plan rule set (3 rows: Basic, Plus, Managed).
    List<PlanRules> getActivePlanSet();

    // Gets the currently active tax set (3 rows: None, Flat, Progressive).
    List<TaxSettings> getActiveTaxSet();

    // (Optional legacy use)
    TaxSettings getActiveTaxSettings();

    // =========================
    // HISTORY
    // =========================

    List<PlanRules> getAllPlanRulesHistory();

    List<TaxSettings> getAllTaxSettingsHistory();

    List<PlanRules> getPlanRuleSetByPlanSetId(Long planSetId);

    TaxSettings getTaxSettingsById(Long taxSettingsId);

    List<TaxSettings> getTaxSetByTaxSetId(Long taxSetId);

    // =========================
    // PLAN RULE CREATION
    // =========================

    // Uses currently active tax set
    void createPlanRuleSetUsingActiveTax(List<PlanRules> planRulesList);

    // Uses newly created tax set
    void createPlanRuleSetWithNewTax(List<PlanRules> planRulesList, List<TaxSettings> taxSettingsList);

    // =========================
    // TAX SETTINGS FLOW (UPDATED LOGIC)
    // =========================

    /**
     * Creates a new tax set (3 rows), activates it,
     * and clones the current active plan rules to use the new tax set.
     */
    void createAndActivateTaxSetWithClonedPlanRules(List<TaxSettings> taxSettingsList);

    /**
     * Activates an existing tax set (by tax_set_id),
     * then clones the current active plan rules to use that tax set.
     */
    void activateTaxSetWithClonedPlanRules(Long taxSetId);
}