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

        return "client/client-dashboard";
    }
}