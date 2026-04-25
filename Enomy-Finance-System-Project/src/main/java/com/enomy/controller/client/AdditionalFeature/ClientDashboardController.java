package com.enomy.controller.client.AdditionalFeature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;
import com.enomy.security.CustomUserDetails;
import com.enomy.service.client.InvestmentService;

import java.util.Map;
import com.enomy.dto.investment.PlanDetailsDTO;

/*
=========================================================
CLIENT DASHBOARD CONTROLLER
=========================================================

File Name:
ClientDashboardController.java

Purpose:
This controller handles the Client Dashboard page
of the Enomy Finance system.

Overview:
This controller is responsible for loading and
preparing personalized dashboard data for
authenticated client users.

The dashboard provides:
- Client welcome information
- Saved investment quote statistics
- Active investment plan previews
- Shared authenticated user information

Main Responsibilities:
- Load client dashboard page
- Retrieve authenticated client information
- Retrieve saved quote statistics
- Retrieve active investment plan details
- Supply shared dashboard model attributes
- Prepare dashboard page state

Connected JSP:
- client/client-dashboard.jsp

Connected Services:
- InvestmentService

Connected DAO:
- UserDao

Connected Models:
- User

Connected DTOs:
- PlanDetailsDTO

Main Features:
- Personalized client dashboard
- Saved quote count monitoring
- Active investment plan preview display
- Shared topbar user information
- Dashboard navigation state management

Main Data Loaded:
- fullName
- loggedInEmail
- activePage
- savedQuoteCount
- activePlanDetailsMap

Security:
This controller is protected by Spring Security
and accessible only to authenticated CLIENT users.

Main Route:
GET /client/dashboard

Module:
Web Development Foundations (WDF)

System:
Enomy Finance Web Application

=========================================================
*/


@Controller
public class ClientDashboardController {

    @Autowired
    private InvestmentService investmentService;

    @Autowired
    private UserDao userDao;

    @GetMapping("/client/dashboard")
    public String clientDashboard(Authentication authentication, Model model) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        User user = userDao.findByEmail(userDetails.getUsername());

        int savedQuoteCount = 0;
        if (user != null) {
            savedQuoteCount = investmentService.countSavedQuotes(user.getId());
        }

        Map<String, PlanDetailsDTO> activePlanDetailsMap = investmentService.getAllActivePlanDetails();

        model.addAttribute("fullName", userDetails.getFullName());
        model.addAttribute("loggedInEmail", userDetails.getUsername());
        model.addAttribute("activePage", "dashboard");
        model.addAttribute("savedQuoteCount", savedQuoteCount);
        model.addAttribute("activePlanDetailsMap", activePlanDetailsMap);

        return "client/client-dashboard";
    }
}



