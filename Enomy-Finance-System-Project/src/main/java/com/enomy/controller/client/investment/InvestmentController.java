package com.enomy.controller.client.investment;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.dto.investment.InvestmentRequestDTO;
import com.enomy.dto.investment.InvestmentResponseDTO;

import com.enomy.dto.investment.YearlyInvestmentResultDTO;
import com.enomy.model.EFuser.User;
import com.enomy.model.investment.InvestmentQuote;
import com.enomy.service.client.InvestmentService;

/*
=========================================================
CLIENT INVESTMENT CONTROLLER
=========================================================

File Name:
InvestmentController.java

Purpose:
This controller handles the authenticated client-side
Savings and Investment module of the Enomy Finance system.

Overview:
This controller manages the complete investment
projection workflow including:
- Investment projection calculation
- Investment quote saving
- Saved quote retrieval
- Saved quote detail viewing
- AJAX-based investment operations
- Investment result rendering

The controller also prepares shared page data,
topbar information, active page states,
saved quote information, and investment result data
for the client investment module.

Main Responsibilities:
- Load investment page
- Calculate investment projections
- Save investment quotes
- Retrieve saved quotes
- Retrieve saved quote details
- Handle AJAX calculation workflows
- Handle AJAX save workflows
- Prepare default page state
- Retrieve authenticated user information
- Prepare shared page model attributes

Connected JSP:
- client/savings-investment.jsp
- client/investment-saved-quotes.jsp
- client/investment-quote-details.jsp

Connected JavaScript:
- client-investment.js
- client-dashboard.js

Connected Services:
- InvestmentService

Connected DAO:
- UserDao

Connected Models:
- User
- InvestmentQuote

Connected DTOs:
- InvestmentRequestDTO
- InvestmentResponseDTO
- YearlyInvestmentResultDTO

Main Features:
- Investment projection calculation
- Multi-year investment forecasting
- Saved investment quote management
- AJAX-based calculation workflow
- AJAX-based save workflow
- Saved quote detail modal workflow
- Plan detail preview display
- Shared topbar rendering
- Investment result rendering
- Validation and error handling

Supported Investment Plans:
- BASIC_SAVINGS
- SAVINGS_PLUS
- MANAGED_STOCKS

Main Sections:
- Investment Calculator
- Projection Results
- Saved Quotes
- Quote Detail Modal

Main Routes:

GET
- /client/investment
- /client/investment/quotes
- /client/investment/quotes/{quoteId}
- /client/investment/quotes/{quoteId}/details

POST
- /client/investment/calculate
- /client/investment/save
- /client/investment/calculate-ajax
- /client/investment/save-ajax

Security:
This controller is protected by Spring Security
and accessible only to authenticated CLIENT users.

Module:
Web Development Foundations (WDF)

System:
Enomy Finance Web Application

=========================================================
*/


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
        addTopbarUserData(model, principal, "investment");
        model.addAttribute("currentPlanType", "");
        model.addAttribute("allPlanDetails", investmentService.getAllActivePlanDetails());
        model.addAttribute("planDetails", investmentService.getActivePlanDetails("BASIC_SAVINGS"));
        return "client/savings-investment";
    }

    // =========================
    // TOPBAR USER DATA
    // =========================
    private void addTopbarUserData(Model model, Principal principal, String activePage) {
        User user = getLoggedInUser(principal);

        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("loggedInEmail", user.getEmail());
        model.addAttribute("activePage", activePage);
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
            model.addAttribute("allPlanDetails", investmentService.getAllActivePlanDetails());
            model.addAttribute("planDetails", investmentService.getActivePlanDetails(request.getPlanType()));

            addTopbarUserData(model, principal, "investment");
            addSavedQuotesData(model, principal);

            return "client/savings-investment";

        } catch (IllegalArgumentException e) {

            initializeDefaultInvestmentPage(model, principal);
            model.addAttribute("calculationError", e.getMessage());
            model.addAttribute("investmentRequest", request);
            model.addAttribute("allPlanDetails", investmentService.getAllActivePlanDetails());
            model.addAttribute("planDetails", investmentService.getActivePlanDetails(request.getPlanType()));

            addTopbarUserData(model, principal, "investment");

            return "client/savings-investment";
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
            @PathVariable("quoteId") Long quoteId,
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
    // AJAX SAVED QUOTE DETAILS
    // For modal result card on same page
    // =========================
    @GetMapping(value = "/client/investment/quotes/{quoteId}/details", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSavedQuoteDetailsAjax(
            @PathVariable("quoteId") Long quoteId,
            Principal principal) {

        try {
            User user = getLoggedInUser(principal);

            InvestmentResponseDTO investmentResponse =
                    investmentService.getSavedQuoteDetails(quoteId, user.getId());

            List<InvestmentQuote> savedQuotes = investmentService.getSavedQuotes(user.getId());
            InvestmentQuote matchedQuote = null;

            for (InvestmentQuote quote : savedQuotes) {
                if (quote.getId() != null && quote.getId().equals(quoteId)) {
                    matchedQuote = quote;
                    break;
                }
            }

            if (matchedQuote == null) {
                return "{"
                    + "\"success\":false,"
                    + "\"message\":\"Saved quote not found.\""
                    + "}";
            }

            YearlyInvestmentResultDTO one = investmentResponse.getOneYear();
            YearlyInvestmentResultDTO five = investmentResponse.getFiveYears();
            YearlyInvestmentResultDTO ten = investmentResponse.getTenYears();

            if (one == null || five == null || ten == null) {
                return "{"
                    + "\"success\":false,"
                    + "\"message\":\"Calculation data is incomplete. Please try again.\""
                    + "}";
            }

            return "{"
                + "\"success\":true,"
                + "\"quoteId\":" + matchedQuote.getId() + ","
                + "\"planType\":\"" + escapeJson(matchedQuote.getPlanType()) + "\","
                + "\"planLabel\":\"" + escapeJson(resolvePlanDisplayName(matchedQuote.getPlanType())) + "\","
                + "\"createdAt\":\"" + escapeJson(formatTimestamp(matchedQuote.getCreatedAt())) + "\","

                + "\"oneYear\":{"
                + "\"years\":" + one.getYears() + ","
                + "\"initialLumpSum\":" + one.getInitialLumpSum() + ","
                + "\"monthlyInvestment\":" + one.getMonthlyInvestment() + ","
                + "\"totalInvested\":" + one.getTotalInvested() + ","
                + "\"minReturn\":" + one.getMinReturn() + ","
                + "\"maxReturn\":" + one.getMaxReturn() + ","
                + "\"minProfit\":" + one.getMinProfit() + ","
                + "\"maxProfit\":" + one.getMaxProfit() + ","
                + "\"minTax\":" + one.getMinTax() + ","
                + "\"maxTax\":" + one.getMaxTax() + ","
                + "\"monthlyFee\":" + one.getMonthlyFee() + ","
                + "\"totalFee\":" + one.getTotalFee()
                + "},"

                + "\"fiveYears\":{"
                + "\"years\":" + five.getYears() + ","
                + "\"initialLumpSum\":" + five.getInitialLumpSum() + ","
                + "\"monthlyInvestment\":" + five.getMonthlyInvestment() + ","
                + "\"totalInvested\":" + five.getTotalInvested() + ","
                + "\"minReturn\":" + five.getMinReturn() + ","
                + "\"maxReturn\":" + five.getMaxReturn() + ","
                + "\"minProfit\":" + five.getMinProfit() + ","
                + "\"maxProfit\":" + five.getMaxProfit() + ","
                + "\"minTax\":" + five.getMinTax() + ","
                + "\"maxTax\":" + five.getMaxTax() + ","
                + "\"monthlyFee\":" + five.getMonthlyFee() + ","
                + "\"totalFee\":" + five.getTotalFee()
                + "},"

                + "\"tenYears\":{"
                + "\"years\":" + ten.getYears() + ","
                + "\"initialLumpSum\":" + ten.getInitialLumpSum() + ","
                + "\"monthlyInvestment\":" + ten.getMonthlyInvestment() + ","
                + "\"totalInvested\":" + ten.getTotalInvested() + ","
                + "\"minReturn\":" + ten.getMinReturn() + ","
                + "\"maxReturn\":" + ten.getMaxReturn() + ","
                + "\"minProfit\":" + ten.getMinProfit() + ","
                + "\"maxProfit\":" + ten.getMaxProfit() + ","
                + "\"minTax\":" + ten.getMinTax() + ","
                + "\"maxTax\":" + ten.getMaxTax() + ","
                + "\"monthlyFee\":" + ten.getMonthlyFee() + ","
                + "\"totalFee\":" + ten.getTotalFee()
                + "}"

                + "}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{"
                + "\"success\":false,"
                + "\"message\":\"Unable to load saved quote details.\""
                + "}";
        }
    }
    
    
    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("\\", "\\\\")   // escape backslash
                .replace("\"", "\\\"")   // escape double quote
                .replace("\n", "\\n")    // escape new line
                .replace("\r", "\\r")    // escape carriage return
                .replace("\t", "\\t");   // escape tab
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

    // =========================
    // HELPER: BUILD YEAR RESULT MAP
    // =========================
    private Map<String, Object> buildYearResultMap(YearlyInvestmentResultDTO result) {
        Map<String, Object> yearMap = new LinkedHashMap<>();

        if (result == null) {
            return yearMap;
        }

        yearMap.put("years", result.getYears());
        yearMap.put("initialLumpSum", result.getInitialLumpSum());
        yearMap.put("monthlyInvestment", result.getMonthlyInvestment());
        yearMap.put("totalInvested", result.getTotalInvested());

        yearMap.put("minReturn", result.getMinReturn());
        yearMap.put("maxReturn", result.getMaxReturn());

        yearMap.put("minProfit", result.getMinProfit());
        yearMap.put("maxProfit", result.getMaxProfit());

        yearMap.put("minTax", result.getMinTax());
        yearMap.put("maxTax", result.getMaxTax());

        yearMap.put("monthlyFee", result.getMonthlyFee());
        yearMap.put("totalFee", result.getTotalFee());

        return yearMap;
    }

    // =========================
    // HELPER: PLAN LABEL
    // =========================
    private String resolvePlanDisplayName(String planType) {
        if ("BASIC_SAVINGS".equals(planType)) {
            return "Basic Savings Plan";
        }
        if ("SAVINGS_PLUS".equals(planType)) {
            return "Savings Plan Plus";
        }
        if ("MANAGED_STOCKS".equals(planType)) {
            return "Managed Stock Investments";
        }
        return "Investment Result";
    }

    // =========================
    // HELPER: FORMAT DATE
    // =========================
    private String formatTimestamp(java.sql.Timestamp timestamp) {
        if (timestamp == null) {
            return "-";
        }

        SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return formatter.format(timestamp);
    }
    
    
 // =========================
 // AJAX CALCULATE PROJECTION
 // =========================
 @PostMapping(value = "/client/investment/calculate-ajax", produces = "application/json")
 @ResponseBody
 public ResponseEntity<?> calculateProjectionAjax(
         @RequestBody InvestmentRequestDTO request) {

     try {
         InvestmentResponseDTO response = investmentService.calculateProjection(request);

         Map<String, Object> result = new LinkedHashMap<>();
         result.put("success", true);
         result.put("message", "Calculation successful.");
         result.put("planType", response.getPlanType());
         result.put("oneYear", buildYearResultMap(response.getOneYear()));
         result.put("fiveYears", buildYearResultMap(response.getFiveYears()));
         result.put("tenYears", buildYearResultMap(response.getTenYears()));

         return ResponseEntity.ok(result);

     } catch (IllegalArgumentException e) {

         Map<String, Object> error = new LinkedHashMap<>();
         error.put("success", false);
         error.put("message", e.getMessage());

         return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
     }
 }
 
//=========================
//AJAX SAVE QUOTE
//=========================
@PostMapping(value = "/client/investment/save-ajax", produces = "application/json")
@ResponseBody
public ResponseEntity<?> saveQuoteAjax(
      @RequestBody InvestmentRequestDTO request,
      Principal principal) {

  try {
      User user = getLoggedInUser(principal);
      investmentService.saveQuote(user.getId(), request);

      int savedQuoteCount = investmentService.countSavedQuotes(user.getId());

      Map<String, Object> result = new LinkedHashMap<>();
      result.put("success", true);
      result.put("message", "Investment quote has been successfully saved.");
      result.put("savedQuoteCount", savedQuoteCount);

      return ResponseEntity.ok(result);

  } catch (IllegalArgumentException e) {
      Map<String, Object> error = new LinkedHashMap<>();
      error.put("success", false);
      error.put("message", e.getMessage());

      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
  }
}
 
}