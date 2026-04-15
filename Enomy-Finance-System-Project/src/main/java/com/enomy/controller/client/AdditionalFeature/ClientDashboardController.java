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