package com.enomy.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ClientDashboardController {

    @GetMapping("/client/dashboard")
    public String clientDashboard(Authentication authentication, Model model) {
        model.addAttribute("loggedInEmail", authentication.getName());
        return "client/client-dashboard";
    }
}