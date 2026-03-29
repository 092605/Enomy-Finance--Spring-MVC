package com.enomy.controller.admin;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enomy.security.CustomUserDetails;
import com.enomy.service.admin.AdminCurrencyService;

@Controller
@RequestMapping("/admin/currency")
public class AdminCurrencyController {
	
	

    private final AdminCurrencyService adminCurrencyService;

    public AdminCurrencyController(AdminCurrencyService adminCurrencyService) {
        this.adminCurrencyService = adminCurrencyService;
    }

    @GetMapping
    public String loadCurrencyPage(Model model, Authentication authentication) {
        prepareCommonPage(model, authentication);
        setPageState(model, "currency", "active-rules", "active-rules");
        return "admin/admin-currency";
    }

    private void prepareCommonPage(Model model, Authentication authentication) {
        prepareTopbar(model, authentication);
        loadInitialData(model);
    }

    private void setPageState(Model model, String activePage, String activeSection, String activeNav) {
        model.addAttribute("activePage", activePage);
        model.addAttribute("activeSection", activeSection);
        model.addAttribute("activeNav", activeNav);
    }

    private void prepareTopbar(Model model, Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            model.addAttribute("fullName", userDetails.getFullName());
            model.addAttribute("loggedInEmail", userDetails.getUsername());
            model.addAttribute("accountType", "Admin Account");
        }
    }

    private void loadInitialData(Model model) {
        var activeRuleSet = adminCurrencyService.getActiveRuleSet();
        var activeFeeRules = adminCurrencyService.getActiveFeeRules();

        model.addAttribute("activeRuleSet", activeRuleSet);
        model.addAttribute("activeFeeRules", activeFeeRules);
        model.addAttribute("activeMinAmount", adminCurrencyService.getDerivedMinAmount(activeFeeRules));
        model.addAttribute("activeMaxAmount", adminCurrencyService.getDerivedMaxAmount(activeFeeRules));
        model.addAttribute("nextRuleSetIdPreview", adminCurrencyService.getNextRuleSetIdPreview());

        model.addAttribute("conversionRuleHistory", adminCurrencyService.getAllRuleSets());
        model.addAttribute("allFeeRulesForModal", adminCurrencyService.getAllFeeRules());
        model.addAttribute("transactionHistory", adminCurrencyService.getFilteredTransactions(null, null, null, null, null));
    }
}