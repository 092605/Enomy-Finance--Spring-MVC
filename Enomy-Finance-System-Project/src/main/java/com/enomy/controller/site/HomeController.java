package com.enomy.controller.site;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.enomy.dto.conversion.CheckRateResponseDTO;
import com.enomy.service.client.CurrencyConverterService;

/*
=========================================================
SITE HOME CONTROLLER
=========================================================

File Name:
HomeController.java

Purpose:
This controller handles the public-facing pages
of the Enomy Finance system.

Overview:
This controller is responsible for rendering:
- Home page
- About page
- Public landing pages
- Public currency rate checking feature

The controller also prepares shared page data
used by public JSP pages including active
navigation states and public currency rule data.

Main Responsibilities:
- Load home page
- Load about page
- Load landing converter page
- Load landing investment page
- Handle public AJAX currency rate checking
- Supply public conversion rule data
- Configure active navigation states

Connected JSP:
- public/home.jsp
- public/about.jsp
- public/landing-converter.jsp
- public/landing-investment.jsp

Connected JavaScript:
- landing-converter.js
- navbar-behaviour.js

Connected Services:
- CurrencyConverterService

Connected DTOs:
- CheckRateResponseDTO

Main Features:
- Public website routing
- Public landing pages
- Public currency exchange preview
- AJAX-based quick rate checking
- Dynamic navbar highlighting
- Active conversion rule display
- Public investment feature showcase

Main Routes:

GET
- /
- /about
- /landing-converter
- /landing-investment

POST
- /public/check-rate-ajax

Security:
These routes are publicly accessible and do not
require user authentication.

Module:
Web Development Foundations (WDF)

System:
Enomy Finance Web Application

=========================================================
*/


@Controller
public class HomeController {

    @Autowired
    private CurrencyConverterService currencyConverterService;

    @GetMapping("/")
    public String homePage(Model model) {
        model.addAttribute("activePage", "home");
        return "public/home";
    }

    @GetMapping("/about")
    public String aboutPage(Model model) {
        model.addAttribute("activePage", "about");
        return "public/about";
    }

    @GetMapping("/landing-converter")
    public String converterPage(Model model) {
        model.addAttribute("activePage", "landing-converter");
        model.addAttribute("ruleSet", currencyConverterService.getActiveConversionRuleSet());
        return "public/landing-converter";
    }

    @GetMapping("/landing-investment")
    public String investmentPage(Model model) {
        model.addAttribute("activePage", "landing-investment");
        return "public/landing-investment";
    }
    
    
    //This is for the quick check rate calculator in public page
    @PostMapping("/public/check-rate-ajax")
    @ResponseBody
    public CheckRateResponseDTO publicCheckRateAjax(
            @RequestParam("baseCurrency") String baseCurrency,
            @RequestParam("targetCurrency") String targetCurrency) {

        return currencyConverterService.checkRate(baseCurrency, targetCurrency);
    }
}