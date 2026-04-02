package com.enomy.controller.client.AdditionalFeature;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.enomy.dto.profile.ClientProfilePageDTO;
import com.enomy.service.client.ClientProfileService;

@Controller
public class ClientProfileController {

    @Autowired
    private ClientProfileService clientProfileService;

    @GetMapping("/client/profile")
    public String showProfilePage(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        ClientProfilePageDTO profileData = clientProfileService.getProfilePageDataByEmail(principal.getName());

        if (profileData == null || profileData.getUser() == null) {
            return "redirect:/login";
        }

        model.addAttribute("profileData", profileData);
        model.addAttribute("user", profileData.getUser());

        return "client/client-profile";
    }
}

