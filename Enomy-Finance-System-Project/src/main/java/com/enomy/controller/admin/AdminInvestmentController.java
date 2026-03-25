package com.enomy.controller.admin;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.enomy.model.PlanRules;
import com.enomy.model.TaxSettings;
import com.enomy.security.CustomUserDetails;
import com.enomy.service.admin.AdminInvestmentService;

@Controller
@RequestMapping("/admin/investment")
public class AdminInvestmentController {

    private final AdminInvestmentService adminInvestmentService;

    public AdminInvestmentController(AdminInvestmentService adminInvestmentService) {
        this.adminInvestmentService = adminInvestmentService;
    }

    // This opens the page in Active Rules view by default.
    @GetMapping
    public String loadInvestmentPage(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "investment", "active-rules", "active-rules");
        return "admin/admin-investment";
    }

    // This shows the Active Rules section directly.
    @GetMapping("/active-rules")
    public String showActiveRules(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "investment", "active-rules", "active-rules");
        return "admin/admin-investment";
    }

    // This opens the Plan Rules wizard and starts at the first step.
    @GetMapping("/plan-rules")
    public String showPlanRules(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "investment", "plan-rules", "plan-rules");

        model.addAttribute("planRuleStep", "basic");
        model.addAttribute("selectedTaxMode", "ACTIVE");
        model.addAttribute("embeddedTaxSaved", "false");

        return "admin/admin-investment";
    }

    // This opens the standalone Tax Settings section.
    @GetMapping("/tax-settings")
    public String showTaxSettings(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "investment", "tax-settings", "tax-settings");
        return "admin/admin-investment";
    }

 // This opens neutral History and defaults to Plan Rule History.
    @GetMapping("/history")
    public String showHistory(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "investment", "history", "history");

        model.addAttribute("activeHistoryTab", "plan");
        return "admin/admin-investment";
    }

	 // This opens History directly in Tax Settings History and keeps the change-flow flag.
	    @GetMapping("/history/tax")
	    public String showTaxHistory(@RequestParam(name = "fromChangeFlow", required = false) Boolean fromChangeFlow,
	                                 Model model,
	                                 Authentication authentication) {
	        prepareCommonPage(model, authentication);
	        setPageState(model, "investment", "history", "history");
	
	        model.addAttribute("activeHistoryTab", "tax");
	
	        if (Boolean.TRUE.equals(fromChangeFlow)) {
	            model.addAttribute("fromChangeFlow", true);
	        }
	
	        return "admin/admin-investment";
	    }
	    
		 // This creates a new grouped tax set from the standalone tax form,
		 // activates it, and creates a new copied active plan rule set.
		 @PostMapping("/tax-settings/create")
		 public String createTaxSettings(@RequestParam Map<String, String> formData,
		                                 Model model,
		                                 Authentication authentication) {
		     try {
		         List<TaxSettings> taxSettingsList = buildTaxSettingsSetFromForm(formData, "");
	
		         adminInvestmentService.createAndActivateTaxSetWithClonedPlanRules(taxSettingsList);
	
		         prepareCommonPage(model, authentication);
		         setPageState(model, "investment", "active-rules", "active-rules");
		         model.addAttribute("successMessage", "Tax settings created and activated successfully.");
	
		         return "admin/admin-investment";
	
		     } catch (Exception e) {
		         prepareCommonPage(model, authentication);
		         setPageState(model, "investment", "tax-settings", "tax-settings");
		         model.addAttribute("errorMessage", "Unable to create tax settings. Please check the inputs and try again.");
		         return "admin/admin-investment";
		     }
		 }

			// This activates a grouped tax set from the history modal,
			// then creates a new copied active plan rule set that uses that tax set.
			@PostMapping("/tax-settings/activate")
			public String activateTaxSettings(@RequestParam(name = "taxSetId") Long taxSetId,
			                                  @RequestParam(name = "fromChangeFlow", required = false) Boolean fromChangeFlow,
			                                  Model model,
			                                  Authentication authentication) {
			    try {
			        adminInvestmentService.activateTaxSetWithClonedPlanRules(taxSetId);
	
			        prepareCommonPage(model, authentication);
			        setPageState(model, "investment", "active-rules", "active-rules");
			        model.addAttribute("successMessage", "Tax settings activated successfully.");
	
			        return "admin/admin-investment";
	
			    } catch (Exception e) {
			        prepareCommonPage(model, authentication);
			        setPageState(model, "investment", "history", "history");
			        model.addAttribute("activeHistoryTab", "tax");
			        model.addAttribute("errorMessage", "Unable to activate tax settings. Please try again.");
			        return "admin/admin-investment";
			    }
			}
		
    // This creates a new plan rule set using the currently active grouped tax set.
    @PostMapping("/plan-rules/create/using-active-tax")
    public String createPlanRuleUsingActiveTax(@RequestParam Map<String, String> formData,
                                               Model model,
                                               Authentication authentication) {
        try {
            List<PlanRules> planRulesList = buildPlanRulesFromForm(formData);

            adminInvestmentService.createPlanRuleSetUsingActiveTax(planRulesList);

            prepareCommonPage(model, authentication);
            setPageState(model, "investment", "active-rules", "active-rules");
            model.addAttribute("successMessage", "New plan rule set created and activated using active tax settings.");

            return "admin/admin-investment";

        } catch (Exception e) {
            prepareCommonPage(model, authentication);
            setPageState(model, "investment", "plan-rules", "plan-rules");

            model.addAttribute("planRuleStep", "tax-selection");
            model.addAttribute("selectedTaxMode", "ACTIVE");
            model.addAttribute("embeddedTaxSaved", "false");
            model.addAttribute("planWizardDraft", formData);
            model.addAttribute("errorMessage", "Failed to create plan rule set. Please check your inputs.");

            return "admin/admin-investment";
        }
    }

    // This creates a new plan rule set with a newly created grouped tax set from the wizard.
    @PostMapping("/plan-rules/create/with-new-tax")
    public String createPlanRuleWithNewTax(@RequestParam Map<String, String> formData,
                                           Model model,
                                           Authentication authentication) {
        try {
            List<PlanRules> planRulesList = buildPlanRulesFromForm(formData);
            List<TaxSettings> taxSettingsList = buildTaxSettingsSetFromForm(formData, "embedded");

            adminInvestmentService.createPlanRuleSetWithNewTax(planRulesList, taxSettingsList);

            prepareCommonPage(model, authentication);
            setPageState(model, "investment", "active-rules", "active-rules");
            model.addAttribute("successMessage", "New plan rule set and tax settings created and activated successfully.");

            return "admin/admin-investment";

        } catch (Exception e) {
            prepareCommonPage(model, authentication);
            setPageState(model, "investment", "plan-rules", "plan-rules");

            model.addAttribute("planRuleStep", "tax-selection");
            model.addAttribute("selectedTaxMode", "NEW");
            model.addAttribute("embeddedTaxSaved", "true");
            model.addAttribute("planWizardDraft", formData);
            model.addAttribute("embeddedTaxDraft", buildEmbeddedTaxDraftMap(formData));
            model.addAttribute("errorMessage", "Failed to create plan rule set with new tax settings.");

            return "admin/admin-investment";
        }
    }

    // This prepares shared data used by all page states.
    private void prepareCommonPage(Model model, Authentication authentication) {
        prepareTopbar(model, authentication);
        loadActiveData(model);
        loadSharedHistoryData(model);
    }

    // This sets sidebar page, section state, and module nav state together.
    private void setPageState(Model model, String activePage, String activeSection, String activeNav) {
        model.addAttribute("activePage", activePage);
        model.addAttribute("activeSection", activeSection);
        model.addAttribute("activeNav", activeNav);
    }

    // This loads the logged-in admin details for the shared topbar and greetings.
    private void prepareTopbar(Model model, Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            model.addAttribute("fullName", userDetails.getFullName());
            model.addAttribute("loggedInEmail", userDetails.getUsername());
            model.addAttribute("accountType", "Admin Account");
        }
    }

    // This loads the currently active plan set and currently active grouped tax set.
    private void loadActiveData(Model model) {
        List<PlanRules> activePlans = adminInvestmentService.getActivePlanSet();
        List<TaxSettings> activeTaxSet = adminInvestmentService.getActiveTaxSet();

        model.addAttribute("activePlanSet", activePlans);
        model.addAttribute("activeTaxSet", activeTaxSet);

        // This keeps one row available for backward-safe fallback if some JSP still references it.
        TaxSettings activeTaxSettings = (activeTaxSet != null && !activeTaxSet.isEmpty()) ? activeTaxSet.get(0) : null;
        model.addAttribute("activeTaxSettings", activeTaxSettings);
    }

    // This loads grouped history data and full row data for modal display.
    private void loadSharedHistoryData(Model model) {
        List<PlanRules> allPlanRows = adminInvestmentService.getAllPlanRulesHistory();
        List<TaxSettings> allTaxRows = adminInvestmentService.getAllTaxSettingsHistory();

        model.addAttribute("allPlanRuleRowsForModal", allPlanRows);
        model.addAttribute("allTaxRowsForModal", allTaxRows);

        model.addAttribute("planRulesHistory", buildPlanHistorySummaryRows(allPlanRows));
        model.addAttribute("taxSettingsHistory", buildTaxHistorySummaryRows(allTaxRows));
    }

    // This creates one summary row per plan_set_id so the plan history table does not repeat 3 rows.
    private List<PlanRules> buildPlanHistorySummaryRows(List<PlanRules> allRows) {
        Map<Long, PlanRules> grouped = new LinkedHashMap<>();

        if (allRows != null) {
            for (PlanRules row : allRows) {
                if (row.getPlanSetId() != null && !grouped.containsKey(row.getPlanSetId())) {
                    grouped.put(row.getPlanSetId(), row);
                }
            }
        }

        return new ArrayList<>(grouped.values());
    }

    // This creates one summary row per tax_set_id so the tax history table does not repeat 3 rows.
    private List<TaxSettings> buildTaxHistorySummaryRows(List<TaxSettings> allRows) {
        Map<Long, TaxSettings> grouped = new LinkedHashMap<>();

        if (allRows != null) {
            for (TaxSettings row : allRows) {
                if (row.getTaxSetId() != null && !grouped.containsKey(row.getTaxSetId())) {
                    grouped.put(row.getTaxSetId(), row);
                }
            }
        }

        return new ArrayList<>(grouped.values());
    }

    // This preserves grouped embedded tax inputs after a failed wizard submit.
    private Map<String, String> buildEmbeddedTaxDraftMap(Map<String, String> formData) {
        Map<String, String> draft = new LinkedHashMap<>();

        draft.put("noneTaxFreeAllowance", formData.get("embeddedNoneTaxFreeAllowance"));

        draft.put("flatTaxFreeAllowance", formData.get("embeddedFlatTaxFreeAllowance"));
        draft.put("flatTaxRate", formData.get("embeddedFlatTaxRate"));

        draft.put("progTaxFreeAllowance", formData.get("embeddedProgTaxFreeAllowance"));
        draft.put("progLowerRate", formData.get("embeddedProgLowerRate"));
        draft.put("progLowerThreshold", formData.get("embeddedProgLowerThreshold"));
        draft.put("progUpperRate", formData.get("embeddedProgUpperRate"));
        draft.put("progUpperThreshold", formData.get("embeddedProgUpperThreshold"));

        return draft;
    }

    // This converts the three plan steps into 3 PlanRules objects.
    private List<PlanRules> buildPlanRulesFromForm(Map<String, String> formData) {
        List<PlanRules> list = new ArrayList<>();
        list.add(buildSinglePlan(formData, "basic", "BASIC_SAVINGS"));
        list.add(buildSinglePlan(formData, "plus", "SAVINGS_PLUS"));
        list.add(buildSinglePlan(formData, "managed", "MANAGED_STOCKS"));
        return list;
    }

    // This builds one PlanRules object from a prefixed set of form fields.
    private PlanRules buildSinglePlan(Map<String, String> formData, String prefix, String planType) {
        PlanRules plan = new PlanRules();

        plan.setPlanType(planType);
        plan.setYearlyInvestmentLimit(parseDoubleOrNull(formData.get(prefix + "YearlyInvestmentLimit")));
        plan.setMinMonthlyRequired(parseDouble(formData.get(prefix + "MinMonthlyRequired")));
        plan.setMinInitialRequired(parseDouble(formData.get(prefix + "MinInitialRequired")));
        plan.setMonthlyFeeRate(parseDouble(formData.get(prefix + "MonthlyFeeRate")));
        plan.setMinReturnRate(parseDouble(formData.get(prefix + "MinReturnRate")));
        plan.setMaxReturnRate(parseDouble(formData.get(prefix + "MaxReturnRate")));

        return plan;
    }

 // This builds the grouped tax set and supports both standalone and embedded form prefixes.
    private List<TaxSettings> buildTaxSettingsSetFromForm(Map<String, String> formData, String mode) {
        List<TaxSettings> list = new ArrayList<>();

        boolean embedded = "embedded".equalsIgnoreCase(mode);

        String noneTaxFreeAllowanceKey = embedded ? "embeddedNoneTaxFreeAllowance" : "noneTaxFreeAllowance";

        String flatTaxFreeAllowanceKey = embedded ? "embeddedFlatTaxFreeAllowance" : "flatTaxFreeAllowance";
        String flatTaxRateKey = embedded ? "embeddedFlatTaxRate" : "flatTaxRate";

        String progTaxFreeAllowanceKey = embedded ? "embeddedProgTaxFreeAllowance" : "progTaxFreeAllowance";
        String progLowerRateKey = embedded ? "embeddedProgLowerRate" : "progLowerRate";
        String progLowerThresholdKey = embedded ? "embeddedProgLowerThreshold" : "progLowerThreshold";
        String progUpperRateKey = embedded ? "embeddedProgUpperRate" : "progUpperRate";
        String progUpperThresholdKey = embedded ? "embeddedProgUpperThreshold" : "progUpperThreshold";

        // NONE row
        TaxSettings none = new TaxSettings();
        none.setTaxType("NONE");
        none.setTaxFreeAllowance(parseDouble(formData.get(noneTaxFreeAllowanceKey)));
        none.setLowerTaxRate(0);
        none.setLowerTaxThreshold(null);
        none.setUpperTaxRate(0);
        none.setUpperTaxThreshold(null);

        // FLAT row
        TaxSettings flat = new TaxSettings();
        flat.setTaxType("FLAT");
        flat.setTaxFreeAllowance(parseDouble(formData.get(flatTaxFreeAllowanceKey)));
        flat.setLowerTaxRate(parseDouble(formData.get(flatTaxRateKey)));
        flat.setLowerTaxThreshold(null);
        flat.setUpperTaxRate(0);
        flat.setUpperTaxThreshold(null);

        // PROGRESSIVE row
        TaxSettings progressive = new TaxSettings();
        progressive.setTaxType("PROGRESSIVE");
        progressive.setTaxFreeAllowance(parseDouble(formData.get(progTaxFreeAllowanceKey)));
        progressive.setLowerTaxRate(parseDouble(formData.get(progLowerRateKey)));
        progressive.setLowerTaxThreshold(parseDoubleOrNull(formData.get(progLowerThresholdKey)));
        progressive.setUpperTaxRate(parseDouble(formData.get(progUpperRateKey)));
        progressive.setUpperTaxThreshold(parseDoubleOrNull(formData.get(progUpperThresholdKey)));

        list.add(none);
        list.add(flat);
        list.add(progressive);

        return list;
    }

    // This safely parses a required numeric value with zero as fallback.
    private double parseDouble(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0.0;
        }
        return Double.parseDouble(value);
    }

    // This safely parses an optional numeric value.
    private Double parseDoubleOrNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return Double.parseDouble(value);
    }
}