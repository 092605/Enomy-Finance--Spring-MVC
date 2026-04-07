package com.enomy.controller.client.AdditionalFeature;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.enomy.dto.profile.ClientProfilePageDTO;
import com.enomy.model.EFuser.User;
import com.enomy.service.client.ClientProfileService;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @PostMapping("/upload-photo")
    @ResponseBody
    public Map<String, Object> uploadProfilePhoto(
            @RequestParam("profileImage") MultipartFile file,
            Principal principal) {

        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        if (file == null || file.isEmpty()) {
            response.put("success", false);
            response.put("message", "Please select an image file.");
            return response;
        }

        String contentType = file.getContentType();
        if (contentType == null || !(
                contentType.equalsIgnoreCase("image/png") ||
                contentType.equalsIgnoreCase("image/jpeg") ||
                contentType.equalsIgnoreCase("image/jpg") ||
                contentType.equalsIgnoreCase("image/webp"))) {
            response.put("success", false);
            response.put("message", "Only PNG, JPG, JPEG, and WEBP files are allowed.");
            return response;
        }

        try {
            String imagePath = clientProfileService.saveProfileImage(user.getId(), file);
            response.put("success", true);
            response.put("message", "Profile photo uploaded successfully.");
            response.put("profileImagePath", imagePath);
            return response;
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to upload profile photo.");
            return response;
        }
    }

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return clientProfileService.getUserByEmail(principal.getName());
    }
}