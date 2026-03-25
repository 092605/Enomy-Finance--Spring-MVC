package com.enomy.controller.admin;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.enomy.security.CustomUserDetails;

@Controller
public class AdminDashboardController {

	@GetMapping("/admin/dashboard")
	public String adminDashboard(Authentication authentication, Model model) {

		CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "dashboard");

	    return "admin/admin-dashboard";
	}
	
	
	@GetMapping("/admin/currency")
	public String adminCurrency(Authentication authentication, Model model) {

		CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "dashboard");

	    return "admin/currency-converter";
	}
	
	@GetMapping("/admin/history")
	public String adminHistory(Authentication authentication, Model model) {

		CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "dashboard");

	    return "admin/transaction-history";
	}
}