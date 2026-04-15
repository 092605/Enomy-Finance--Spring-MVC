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

@Controller
public class HomeController {

    @Autowired
    private CurrencyConverterService currencyConverterService;

    @GetMapping("/")
    public String hopePage(Model model) {
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