package com.enomy.controller.client.conversion;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.dto.conversion.CheckRateResponseDTO;
import com.enomy.dto.conversion.ConversionRuleSetDTO;
import com.enomy.dto.conversion.CurrencyConversionRequestDTO;
import com.enomy.dto.conversion.CurrencyConversionResponseDTO;
import com.enomy.dto.conversion.TransactionReceiptDTO;
import com.enomy.model.EFuser.User;
import com.enomy.security.CustomUserDetails;
import com.enomy.service.client.CurrencyConverterService;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/*
=========================================================
CLIENT CURRENCY CONVERTER CONTROLLER
=========================================================

File Name:
CurrencyConverterController.java

Purpose:
This controller handles the authenticated client-side
Currency Converter module of the Enomy Finance system.

Overview:
This controller manages the complete currency conversion
workflow for authenticated client users including:
- Currency rate checking
- Currency conversion calculation
- Transaction confirmation
- Receipt generation
- Transaction history viewing
- BUY and SELL conversion workflows

The controller also prepares shared page data,
topbar information, active navigation states,
and conversion card states for the JSP page.

Main Responsibilities:
- Load currency converter page
- Load BUY conversion workflow
- Load SELL conversion workflow
- Load welcome/home section
- Load transaction history section
- Handle exchange rate checking
- Handle AJAX exchange rate requests
- Calculate currency conversions
- Confirm currency transactions
- Generate transaction receipts
- Reset/cancel conversion workflows
- Retrieve authenticated user information
- Prepare shared page model attributes

Connected JSP:
- client/currency-converter.jsp

Connected JavaScript:
- currency-converter.js
- client-dashboard.js

Connected Services:
- CurrencyConverterService

Connected DAO:
- UserDao

Connected Models:
- User

Connected DTOs:
- CheckRateResponseDTO
- ConversionRuleSetDTO
- CurrencyConversionRequestDTO
- CurrencyConversionResponseDTO
- TransactionReceiptDTO

Main Features:
- BUY currency conversion workflow
- SELL currency conversion workflow
- Exchange rate checking
- AJAX-based rate checking
- Conversion calculation
- Receipt generation
- Transaction history viewing
- Conversion rule preview display
- Shared topbar rendering
- Navigation state management
- Conversion card state management

Main Sections:
- Welcome Section
- Converter Section
- Transaction History Section

Main Routes:

GET
- /client/currency-converter
- /client/currency-converter/home
- /client/currency-converter/buy
- /client/currency-converter/sell
- /client/currency-converter/history
- /client/currency-converter/cancel
- /client/currency-converter/okay

POST
- /client/currency-converter/check-rate
- /client/currency-converter/check-rate-ajax
- /client/currency-converter/calculate
- /client/currency-converter/confirm

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
@RequestMapping("/client/currency-converter")
public class CurrencyConverterController {

    @Autowired
    private CurrencyConverterService currencyConverterService;

    @Autowired
    private UserDao userDao;
    
    
	/*
	 * @GetMapping("/client/currency") public String currencyPage(Authentication
	 * authentication, Model model) {
	 * 
	 * CustomUserDetails userDetails = (CustomUserDetails)
	 * authentication.getPrincipal();
	 * 
	 * model.addAttribute("fullName", userDetails.getFullName());
	 * model.addAttribute("loggedInEmail", userDetails.getUsername());
	 * model.addAttribute("activePage", "currency");
	 * 
	 * return "client/currency-converter"; // temporary placeholder }
	 */

    // =========================
    // LOAD DEFAULT CURRENCY CONVERTER PAGE
    // =========================
    @GetMapping
    public String showCurrencyConverterPage(Model model, Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        model.addAttribute("activeSection", "welcome");
        model.addAttribute("activeNav", "home");

        return "client/currency-converter";
    }

    // =========================
    // LOGO / HOME CLICK -> WELCOME VIEW
    // =========================
    @GetMapping("/home")
    public String showWelcomeView(Model model, Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        model.addAttribute("activeSection", "welcome");
        model.addAttribute("activeNav", "home");

        return "client/currency-converter";
    }

    // =========================
    // BUY CLICK -> CONVERTER SECTION
    // =========================
    @GetMapping("/buy")
    public String showBuyConverter(Model model, Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CurrencyConversionRequestDTO request = new CurrencyConversionRequestDTO();
        request.setTransactionType("BUY");

        model.addAttribute("conversionRequest", request);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav", "buy");
        model.addAttribute("cardMode", "default");

        return "client/currency-converter";
    }

    // =========================
    // SELL CLICK -> CONVERTER SECTION
    // =========================
    @GetMapping("/sell")
    public String showSellConverter(Model model, Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CurrencyConversionRequestDTO request = new CurrencyConversionRequestDTO();
        request.setTransactionType("SELL");

        model.addAttribute("conversionRequest", request);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav", "sell");
        model.addAttribute("cardMode", "default");

        return "client/currency-converter";
    }

    // =========================
    // TRANSACTION HISTORY SECTION
    // =========================
    @GetMapping("/history")
    public String showTransactionHistory(Model model, Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        Long userId = getLoggedInUserId(principal);
        List<TransactionReceiptDTO> historyList = currencyConverterService.getTransactionHistory(userId);

        model.addAttribute("historyList", historyList);
        model.addAttribute("activeSection", "history");
        model.addAttribute("activeNav", "history");

        return "client/currency-converter";
    }

    // =========================
    // CHECK RATE (WELCOME VIEW)
    // =========================
    @PostMapping("/check-rate")
    public String checkRate(String baseCurrency,
                            String targetCurrency,
                            Model model,
                            Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CheckRateResponseDTO checkRateResult =
                currencyConverterService.checkRate(baseCurrency, targetCurrency);

        model.addAttribute("checkRateResult", checkRateResult);
        model.addAttribute("activeSection", "welcome");
        model.addAttribute("activeNav", "home");

        return "client/currency-converter";
    }
    
	
	 @PostMapping("/check-rate-ajax")
	 
	 @ResponseBody public CheckRateResponseDTO
	 checkRateAjax(@RequestParam("baseCurrency") String baseCurrency,
	 
	 @RequestParam("targetCurrency") String targetCurrency) {
	 
	 return currencyConverterService.checkRate(baseCurrency, targetCurrency); }
	 
    
  

    // =========================
    // CALCULATE CONVERSION -> RESULT CARD
    // =========================
    @PostMapping("/calculate")
    public String calculateConversion(@ModelAttribute("conversionRequest") CurrencyConversionRequestDTO request,
                                      Model model,
                                      Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CurrencyConversionResponseDTO conversionResult =
                currencyConverterService.calculateConversion(request);

        model.addAttribute("conversionRequest", request);
        model.addAttribute("conversionResult", conversionResult);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav",
                "BUY".equalsIgnoreCase(request.getTransactionType()) ? "buy" : "sell");
        model.addAttribute("cardMode", "result");

        return "client/currency-converter";
    }

    // =========================
    // CONFIRM TRANSACTION -> RECEIPT CARD
    // =========================
    @PostMapping("/confirm")
    public String confirmTransaction(@ModelAttribute("conversionRequest") CurrencyConversionRequestDTO request,
                                     Model model,
                                     Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        Long userId = getLoggedInUserId(principal);

        TransactionReceiptDTO receipt =
                currencyConverterService.confirmTransaction(request, userId);

        model.addAttribute("conversionRequest", request);
        model.addAttribute("receipt", receipt);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav",
                "BUY".equalsIgnoreCase(request.getTransactionType()) ? "buy" : "sell");
        model.addAttribute("cardMode", "receipt");

        return "client/currency-converter";
    }

    // =========================
    // CANCEL -> RESET CONVERTER SECTION
    // =========================
    @GetMapping("/cancel")
    public String cancelConversion(@RequestParam(value = "transactionType", required = false) String transactionType,
                                   Model model,
                                   Principal principal) {

        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CurrencyConversionRequestDTO request = new CurrencyConversionRequestDTO();
        request.setTransactionType(transactionType);

        model.addAttribute("conversionRequest", request);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav",
                "BUY".equalsIgnoreCase(transactionType) ? "buy" :
                "SELL".equalsIgnoreCase(transactionType) ? "sell" : "home");
        model.addAttribute("cardMode", "default");

        return "client/currency-converter";
    }
    
    // =========================
    // OKAY FROM RECEIPT 
    // =========================
    @GetMapping("/okay")
    public String resetAfterReceipt(@RequestParam(value = "transactionType", required = false) String transactionType,
                                    Model model,
                                    Principal principal) {
        prepareDefaultModel(model);
        addTopbarUserData(model, principal, "currency-converter");

        CurrencyConversionRequestDTO request = new CurrencyConversionRequestDTO();
        request.setTransactionType(transactionType);

        model.addAttribute("conversionRequest", request);
        model.addAttribute("activeSection", "converter");
        model.addAttribute("activeNav",
                "BUY".equalsIgnoreCase(transactionType) ? "buy" :
                "SELL".equalsIgnoreCase(transactionType) ? "sell" : "home");
        model.addAttribute("cardMode", "default");

        return "client/currency-converter";
    }

    // =========================
    // LOAD COMMON PAGE DATA
    // =========================
    private void prepareDefaultModel(Model model) {
        ConversionRuleSetDTO ruleSet = currencyConverterService.getActiveConversionRuleSet();

        model.addAttribute("ruleSet", ruleSet);
        model.addAttribute("conversionRequest", new CurrencyConversionRequestDTO());
        model.addAttribute("cardMode", "default");
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
    // GET LOGGED-IN USER ID
    // =========================
    private Long getLoggedInUserId(Principal principal) {
        return getLoggedInUser(principal).getId();
    }
}