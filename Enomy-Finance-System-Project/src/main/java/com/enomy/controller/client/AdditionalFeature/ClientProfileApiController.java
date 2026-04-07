package com.enomy.controller.client.AdditionalFeature;

import java.security.Principal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.enomy.dto.profile.ChangePasswordDTO;
import com.enomy.dto.profile.ClientProfilePageDTO;
import com.enomy.dto.profile.ProfileAvatarUpdateDTO;
import com.enomy.dto.profile.ProfileInfoUpdateDTO;
import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;
import com.enomy.service.client.ClientProfileService;

@RestController
@RequestMapping("/client/api/profile")
public class ClientProfileApiController {

    @Autowired
    private ClientProfileService clientProfileService;

    @GetMapping
    public Map<String, Object> getProfile(Principal principal) {
        Map<String, Object> response = new HashMap<>();

        if (principal == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        ClientProfilePageDTO profileData = clientProfileService.getProfilePageDataByEmail(principal.getName());

        if (profileData == null) {
            response.put("success", false);
            response.put("message", "Profile not found.");
            return response;
        }

        response.put("success", true);
        response.put("profileData", profileData);
        return response;
    }

    @PutMapping("/info")
    public Map<String, Object> updateInfo(@RequestBody ProfileInfoUpdateDTO dto, Principal principal) {
        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        String fullName = dto.getFullName() != null ? dto.getFullName().trim().replaceAll("\\s+", " ") : "";

        if (!StringUtils.hasText(fullName)) {
            response.put("success", false);
            response.put("message", "Full name is required.");
            return response;
        }

        if (fullName.length() < 2) {
            response.put("success", false);
            response.put("message", "Full name must be at least 2 characters.");
            return response;
        }

        if (fullName.length() > 100) {
            response.put("success", false);
            response.put("message", "Full name must not exceed 100 characters.");
            return response;
        }

        clientProfileService.updateFullName(user.getId(), fullName);

        response.put("success", true);
        response.put("message", "Profile information updated successfully.");
        response.put("fullName", fullName);
        return response;
    }

    @PutMapping("/password")
    public Map<String, Object> updatePassword(@RequestBody ChangePasswordDTO dto, Principal principal) {
        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        String currentPassword = safe(dto.getCurrentPassword());
        String newPassword = safe(dto.getNewPassword());
        String confirmPassword = safe(dto.getConfirmPassword());

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            response.put("success", false);
            response.put("message", "Please complete all password fields.");
            return response;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.put("success", false);
            response.put("message", "New password and confirm password do not match.");
            return response;
        }

        if (newPassword.equals(currentPassword)) {
            response.put("success", false);
            response.put("message", "New password must be different from the current password.");
            return response;
        }

        if (!isStrongPassword(newPassword)) {
            response.put("success", false);
            response.put("message", "Password does not satisfy the required strength rules.");
            return response;
        }

        boolean updated = clientProfileService.updatePassword(user.getId(), currentPassword, newPassword);

        if (!updated) {
            response.put("success", false);
            response.put("message", "Current password is incorrect.");
            return response;
        }

        response.put("success", true);
        response.put("message", "Password updated successfully.");
        return response;
    }

    @PutMapping("/photo")
    public Map<String, Object> updatePhoto(@RequestBody ProfileAvatarUpdateDTO dto, Principal principal) {
        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        String imagePath = safe(dto.getProfileImagePath());

        if (imagePath.isEmpty()) {
            response.put("success", false);
            response.put("message", "Profile image path is required.");
            return response;
        }

        clientProfileService.updateProfileImagePath(user.getId(), imagePath);

        response.put("success", true);
        response.put("message", "Profile photo updated successfully.");
        response.put("profileImagePath", imagePath);
        return response;
    }

    @DeleteMapping("/photo")
    public Map<String, Object> removePhoto(Principal principal) {
        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        clientProfileService.clearProfileImagePath(user.getId());

        response.put("success", true);
        response.put("message", "Profile photo removed successfully.");
        return response;
    }

    @GetMapping("/login-activity")
    public Map<String, Object> getLoginActivity(
            @RequestParam(name = "fromDate", required = false) String fromDate,
            @RequestParam(name = "toDate", required = false) String toDate,
            Principal principal) {

        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        LocalDate from = parseDate(fromDate);
        LocalDate to = parseDate(toDate);

        if (from != null && to != null && from.isAfter(to)) {
            response.put("success", false);
            response.put("message", "The 'From' date must not be later than the 'To' date.");
            return response;
        }

        List<LoginActivity> rows = clientProfileService.getLoginActivities(user.getId(), from, to);
        List<LoginActivity> failedRows = clientProfileService.getFailedLoginActivities(user.getId(), from, to);

        response.put("success", true);
        response.put("rows", rows);
        response.put("failedRows", failedRows);
        response.put("failedCount", failedRows.size());
        return response;
    }

    @DeleteMapping
    public Map<String, Object> deleteAccount(Principal principal) {
        Map<String, Object> response = new HashMap<>();

        User user = getAuthenticatedUser(principal);
        if (user == null) {
            response.put("success", false);
            response.put("message", "User is not authenticated.");
            return response;
        }

        clientProfileService.softDeleteUser(user.getId());

        response.put("success", true);
        response.put("message", "Account deleted successfully.");
        return response;
    }

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return clientProfileService.getUserByEmail(principal.getName());
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private LocalDate parseDate(String value) {
        try {
            return (value == null || value.isBlank()) ? null : LocalDate.parse(value);
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isStrongPassword(String password) {
        return password.length() >= 8
                && password.matches(".*[A-Z].*")
                && password.matches(".*[a-z].*")
                && password.matches(".*\\d.*")
                && password.matches(".*[^A-Za-z0-9].*");
    }
}