package com.enomy.service.admin.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.enomy.dao.PlanRulesDao;
import com.enomy.dao.TaxSettingsDao;
import com.enomy.model.PlanRules;
import com.enomy.model.TaxSettings;
import com.enomy.service.admin.AdminInvestmentService;

@Service
public class AdminInvestmentServiceImpl implements AdminInvestmentService {

    @Autowired
    private PlanRulesDao planRulesDao;

    @Autowired
    private TaxSettingsDao taxSettingsDao;

    // =========================
    // ACTIVE DISPLAY
    // =========================

    // This gets the currently active plan rule set.
    @Override
    public List<PlanRules> getActivePlanSet() {
        return planRulesDao.findActivePlanSet();
    }

    // This gets the currently active grouped tax set (3 rows).
    @Override
    public List<TaxSettings> getActiveTaxSet() {
        return taxSettingsDao.findActiveTaxSet();
    }

    // This keeps backward compatibility for any old single-row tax usage.
    @Override
    public TaxSettings getActiveTaxSettings() {
        return taxSettingsDao.findActiveTaxSettings();
    }

    // =========================
    // HISTORY
    // =========================

    // This gets all plan rule rows for history.
    @Override
    public List<PlanRules> getAllPlanRulesHistory() {
        return planRulesDao.findAllPlanRulesOrdered();
    }

    // This gets all tax rows for history.
    @Override
    public List<TaxSettings> getAllTaxSettingsHistory() {
        return taxSettingsDao.findAllTaxSettingsOrdered();
    }

    // This gets all rows under one plan set version.
    @Override
    public List<PlanRules> getPlanRuleSetByPlanSetId(Long planSetId) {
        return planRulesDao.findByPlanSetId(planSetId);
    }

    // This gets one tax row by its individual id.
    @Override
    public TaxSettings getTaxSettingsById(Long taxSettingsId) {
        return taxSettingsDao.findById(taxSettingsId);
    }

    // This gets all 3 rows under one tax set version.
    @Override
    public List<TaxSettings> getTaxSetByTaxSetId(Long taxSetId) {
        return taxSettingsDao.findByTaxSetId(taxSetId);
    }

    // =========================
    // PLAN RULE CREATION
    // =========================

    // This creates a new plan rule set using the currently active grouped tax set.
    @Override
    @Transactional
    public void createPlanRuleSetUsingActiveTax(List<PlanRules> planRulesList) {
        List<TaxSettings> activeTaxSet = taxSettingsDao.findActiveTaxSet();

        if (activeTaxSet == null || activeTaxSet.size() < 3) {
            throw new IllegalStateException("No complete active tax set found.");
        }

        Long nextPlanSetId = planRulesDao.getNextPlanSetId();

        planRulesDao.deactivateAllPlanRules();

        for (PlanRules planRules : planRulesList) {
            planRules.setPlanSetId(nextPlanSetId);
            planRules.setTaxSettingsId(findMatchingTaxRowId(activeTaxSet, planRules.getPlanType()));
            planRules.setActive(true);
            planRulesDao.insertPlanRule(planRules);
        }
    }

    // This creates a new plan rule set with a newly created grouped tax set.
    @Override
    @Transactional
    public void createPlanRuleSetWithNewTax(List<PlanRules> planRulesList, List<TaxSettings> taxSettingsList) {
        taxSettingsDao.deactivateAllTaxSettings();

        Long nextTaxSetId = taxSettingsDao.getNextTaxSetId();

        for (TaxSettings taxSettings : taxSettingsList) {
            taxSettings.setTaxSetId(nextTaxSetId);
            taxSettings.setActive(true);
            Long insertedTaxId = taxSettingsDao.insertTaxSettings(taxSettings);
            taxSettings.setId(insertedTaxId);
        }

        Long nextPlanSetId = planRulesDao.getNextPlanSetId();

        planRulesDao.deactivateAllPlanRules();

        for (PlanRules planRules : planRulesList) {
            planRules.setPlanSetId(nextPlanSetId);
            planRules.setTaxSettingsId(findMatchingTaxRowId(taxSettingsList, planRules.getPlanType()));
            planRules.setActive(true);
            planRulesDao.insertPlanRule(planRules);
        }
    }

    // =========================
    // TAX SETTINGS FLOW
    // =========================

    // This creates a new tax set, activates it, and clones the current active plan rules to use the new tax ids.
    @Override
    @Transactional
    public void createAndActivateTaxSetWithClonedPlanRules(List<TaxSettings> taxSettingsList) {
        List<PlanRules> activePlanSet = planRulesDao.findActivePlanSet();

        if (activePlanSet == null || activePlanSet.size() < 3) {
            throw new IllegalStateException("No complete active plan rule set found.");
        }

        // Step 1: deactivate old tax rows
        taxSettingsDao.deactivateAllTaxSettings();

        // Step 2: create new tax set
        Long nextTaxSetId = taxSettingsDao.getNextTaxSetId();

        for (TaxSettings taxSettings : taxSettingsList) {
            taxSettings.setTaxSetId(nextTaxSetId);
            taxSettings.setActive(true);
            Long insertedTaxId = taxSettingsDao.insertTaxSettings(taxSettings);
            taxSettings.setId(insertedTaxId);
        }

        // Step 3: clone current active plan rules into a new plan set
        clonePlanRulesUsingTaxSet(activePlanSet, taxSettingsList);
    }

    // This activates an existing tax set, then clones the current active plan rules to use that tax set.
    @Override
    @Transactional
    public void activateTaxSetWithClonedPlanRules(Long taxSetId) {
        List<PlanRules> activePlanSet = planRulesDao.findActivePlanSet();
        List<TaxSettings> selectedTaxSet = taxSettingsDao.findByTaxSetId(taxSetId);

        if (activePlanSet == null || activePlanSet.size() < 3) {
            throw new IllegalStateException("No complete active plan rule set found.");
        }

        if (selectedTaxSet == null || selectedTaxSet.size() < 3) {
            throw new IllegalStateException("No complete tax set found.");
        }

        // Step 1: activate the selected tax set
        taxSettingsDao.deactivateAllTaxSettings();
        taxSettingsDao.activateTaxSettingsBySetId(taxSetId);

        // Step 2: clone the current active plan rules into a new plan set
        clonePlanRulesUsingTaxSet(activePlanSet, selectedTaxSet);
    }

    // =========================
    // HELPER METHODS
    // =========================

    // This clones a plan set and remaps each plan to the matching tax row.
    private void clonePlanRulesUsingTaxSet(List<PlanRules> sourcePlanSet, List<TaxSettings> taxSettingsList) {
        Long nextPlanSetId = planRulesDao.getNextPlanSetId();

        planRulesDao.deactivateAllPlanRules();

        for (PlanRules activePlan : sourcePlanSet) {
            PlanRules clonedPlan = new PlanRules();

            clonedPlan.setPlanType(activePlan.getPlanType());
            clonedPlan.setMinReturnRate(activePlan.getMinReturnRate());
            clonedPlan.setMaxReturnRate(activePlan.getMaxReturnRate());
            clonedPlan.setMonthlyFeeRate(activePlan.getMonthlyFeeRate());
            clonedPlan.setYearlyInvestmentLimit(activePlan.getYearlyInvestmentLimit());
            clonedPlan.setMinMonthlyRequired(activePlan.getMinMonthlyRequired());
            clonedPlan.setMinInitialRequired(activePlan.getMinInitialRequired());

            clonedPlan.setPlanSetId(nextPlanSetId);
            clonedPlan.setTaxSettingsId(findMatchingTaxRowId(taxSettingsList, activePlan.getPlanType()));
            clonedPlan.setActive(true);

            planRulesDao.insertPlanRule(clonedPlan);
        }
    }

    // This matches a plan type to its corresponding tax row id.
    private Long findMatchingTaxRowId(List<TaxSettings> taxSettingsList, String planType) {
        String expectedTaxType = mapPlanTypeToTaxType(planType);

        for (TaxSettings taxSettings : taxSettingsList) {
            if (expectedTaxType.equalsIgnoreCase(taxSettings.getTaxType())) {
                return taxSettings.getId();
            }
        }

        throw new IllegalStateException("No matching tax row found for plan type: " + planType);
    }

    // This enforces the fixed mapping between plan types and tax types.
    private String mapPlanTypeToTaxType(String planType) {
    	if ("BASIC_SAVINGS".equalsIgnoreCase(planType)) {
    	    return "NONE";
    	}
    	if ("SAVINGS_PLUS".equalsIgnoreCase(planType)) {
    	    return "FLAT";
    	}
    	if ("MANAGED_STOCKS".equalsIgnoreCase(planType)) {
    	    return "PROGRESSIVE";
    	}

        throw new IllegalArgumentException("Unknown plan type: " + planType);
    }
}