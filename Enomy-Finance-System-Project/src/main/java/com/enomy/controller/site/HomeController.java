package com.enomy.controller.site;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String landingPage(Model model) {

        // tells navbar that Home is active
        model.addAttribute("activePage", "home");

        return "public/landing";
    }

    @GetMapping("/about")
    public String aboutPage(Model model) {

        model.addAttribute("activePage", "about");

        return "public/about";
    }

    @GetMapping("/landing-converter")
    public String converterPage(Model model) {

        model.addAttribute("activePage", "landing-converter");

        return "public/landing-converter";
    }

    @GetMapping("/landing-investment")
    public String investmentPage(Model model) {

        model.addAttribute("activePage", "landing-investment");

        return "public/landing-investment";
    }
}