package com.enomy.controller.admin.currency;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enomy.security.CustomUserDetails;
import com.enomy.service.admin.AdminCurrencyService;


/*
 * =========================================================
 * ADMIN CURRENCY PAGE CONTROLLER
 * =========================================================
 *
 * File Name:
 * AdminCurrencyController.java
 *
 * Purpose:
 * This controller handles administrator-side Currency
 * Management page routing and initial page data loading
 * for the Enomy Finance system.
 *
 * Overview:
 * This controller is responsible for preparing and
 * rendering the Admin Currency Management module.
 *
 * It loads:
 * - Active conversion rule sets
 * - Active conversion fee brackets
 * - Historical conversion rule records
 * - Historical fee bracket records
 * - Currency transaction history preview
 * - Shared authenticated administrator information
 *
 * The controller also prepares reusable page state
 * variables used for:
 * - Sidebar navigation highlighting
 * - Active section switching
 * - Shared topbar rendering
 *
 * Main Responsibilities:
 * - Load admin currency management page
 * - Retrieve active conversion rule sets
 * - Retrieve active fee rule brackets
 * - Retrieve conversion rule history
 * - Retrieve all fee rules for modal display
 * - Retrieve transaction history preview
 * - Supply authenticated admin information
 * - Configure active page and navigation states
 * - Prepare shared page rendering data
 *
 * Connected JSP:
 * - admin/admin-currency.jsp
 *
 * Connected JavaScript:
 * - admin-currency.js
 *
 * Connected Service:
 * - AdminCurrencyService
 *
 * Connected Models:
 * - ConversionRuleSet
 * - ConversionFeeRule
 * - CurrencyTransaction
 *
 * Main Features:
 * - Active rule monitoring
 * - Fee bracket monitoring
 * - Conversion rule history preview
 * - Transaction history preview
 * - Sidebar navigation state management
 * - Shared admin topbar support
 * - Shared page initialization workflows
 *
 * Main Data Loaded:
 * - activeRuleSet
 * - activeFeeRules
 * - activeMinAmount
 * - activeMaxAmount
 * - nextRuleSetIdPreview
 * - conversionRuleHistory
 * - allFeeRulesForModal
 * - transactionHistory
 *
 * Connected API Controller:
 * - AdminCurrencyApiController
 *
 * Security:
 * This controller is protected by Spring Security
 * and accessible only to authenticated ADMIN users.
 *
 * Base Route:
 * /admin/currency
 *
 * Module:
 * Web Development Foundations (WDF)
 *
 * System:
 * Enomy Finance Web Application
 *
 * =========================================================
 */

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