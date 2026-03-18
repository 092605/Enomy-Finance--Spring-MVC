package com.enomy.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.enomy.security.CustomUserDetails;

@Controller
public class ClientDashboardController {

    @GetMapping("/client/dashboard")
    public String clientDashboard(Authentication authentication, Model model) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "dashboard");

        return "client/client-dashboard";
    }

    @GetMapping("/client/investment")
    public String investmentPage(Authentication authentication, Model model) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "investment");

        return "client/savings-investment";
    }

    @GetMapping("/client/currency")
    public String currencyPage(Authentication authentication, Model model) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "currency");

        return "client/client-dashboard"; // temporary placeholder
    }

    @GetMapping("/client/profile")
    public String profilePage(Authentication authentication, Model model) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "profile");

        return "client/client-dashboard"; // temporary placeholder
    }
}