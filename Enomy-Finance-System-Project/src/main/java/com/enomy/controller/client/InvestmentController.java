package com.enomy.controller.client;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.enomy.dao.UserDao;
import com.enomy.dto.InvestmentRequestDTO;
import com.enomy.dto.InvestmentResponseDTO;
import com.enomy.model.InvestmentQuote;
import com.enomy.model.User;
import com.enomy.service.InvestmentService;

@Controller
public class InvestmentController {

    @Autowired
    private InvestmentService investmentService;

    @Autowired
    private UserDao userDao;

    // =========================
    // LOAD INVESTMENT PAGE
    // =========================
    @GetMapping("/client/investment")
    public String showInvestmentPage(Model model, Principal principal) {
        initializeDefaultInvestmentPage(model, principal);
        return "client/savings-investment"; // ✅ UPDATED
    }

    // =========================
    // CALCULATE PROJECTION
    // =========================
    @PostMapping("/client/investment/calculate")
    public String calculateProjection(
            @ModelAttribute InvestmentRequestDTO request,
            Model model,
            Principal principal) {

        try {
            InvestmentResponseDTO response = investmentService.calculateProjection(request);

            model.addAttribute("investmentRequest", request);
            model.addAttribute("investmentResponse", response);
            model.addAttribute("selectedYear", "oneYear");
            model.addAttribute("hasCalculated", true);

            addSavedQuotesData(model, principal);

            return "client/savings-investment"; // ✅ UPDATED

        } catch (IllegalArgumentException e) {

            initializeDefaultInvestmentPage(model, principal);
            model.addAttribute("calculationError", e.getMessage());
            model.addAttribute("investmentRequest", request);

            return "client/savings-investment"; // ✅ UPDATED
        }
    }

    // =========================
    // SAVE QUOTE
    // =========================
    @PostMapping("/client/investment/save")
    public String saveQuote(
            @ModelAttribute InvestmentRequestDTO request,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            User user = getLoggedInUser(principal);
            investmentService.saveQuote(user.getId(), request);

            redirectAttributes.addFlashAttribute("saveSuccessMessage",
                    "Investment quote has been successfully saved.");

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("saveErrorMessage", e.getMessage());
        }

        return "redirect:/client/investment";
    }

    // =========================
    // VIEW ALL SAVED QUOTES
    // =========================
    @GetMapping("/client/investment/quotes")
    public String viewAllSavedQuotes(Model model, Principal principal) {

        User user = getLoggedInUser(principal);

        List<InvestmentQuote> savedQuotes = investmentService.getSavedQuotes(user.getId());
        int savedQuoteCount = investmentService.countSavedQuotes(user.getId());

        model.addAttribute("savedQuotes", savedQuotes);
        model.addAttribute("savedQuoteCount", savedQuoteCount);

        return "client/investment-saved-quotes";
    }

    // =========================
    // VIEW QUOTE DETAILS
    // =========================
    @GetMapping("/client/investment/quotes/{quoteId}")
    public String viewSavedQuoteDetails(
            @PathVariable Long quoteId,
            Principal principal,
            Model model,
            RedirectAttributes redirectAttributes) {

        try {
            User user = getLoggedInUser(principal);

            InvestmentResponseDTO response =
                    investmentService.getSavedQuoteDetails(quoteId, user.getId());

            model.addAttribute("investmentResponse", response);
            model.addAttribute("selectedYear", "oneYear");
            model.addAttribute("hasCalculated", true);

            return "client/investment-quote-details";

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("saveErrorMessage", e.getMessage());
            return "redirect:/client/investment/quotes";
        }
    }

    // =========================
    // DEFAULT PAGE STATE
    // =========================
    private void initializeDefaultInvestmentPage(Model model, Principal principal) {

        InvestmentRequestDTO defaultRequest = new InvestmentRequestDTO();
        defaultRequest.setPlanType("");
        defaultRequest.setInitialLumpSum(0.0);
        defaultRequest.setMonthlyInvestment(0.0);

        InvestmentResponseDTO defaultResponse = new InvestmentResponseDTO();
        defaultResponse.setPlanType("");

        model.addAttribute("investmentRequest", defaultRequest);
        model.addAttribute("investmentResponse", defaultResponse);
        model.addAttribute("selectedYear", "oneYear");
        model.addAttribute("hasCalculated", false);

        addSavedQuotesData(model, principal);
    }

    // =========================
    // LOAD SAVED QUOTES DATA
    // =========================
    private void addSavedQuotesData(Model model, Principal principal) {
        User user = getLoggedInUser(principal);

        int savedQuoteCount = investmentService.countSavedQuotes(user.getId());
        List<InvestmentQuote> savedQuotes = investmentService.getSavedQuotes(user.getId());

        model.addAttribute("savedQuoteCount", savedQuoteCount);
        model.addAttribute("savedQuotes", savedQuotes);
    }

    // =========================
    // GET LOGGED-IN USER
    // =========================
    private User getLoggedInUser(Principal principal) {

        if (principal == null) {
            throw new IllegalArgumentException("User is not authenticated.");
        }

        User user = userDao.findByEmail(principal.getName());

        if (user == null) {
            throw new IllegalArgumentException("Logged-in user was not found.");
        }

        return user;
    }
}