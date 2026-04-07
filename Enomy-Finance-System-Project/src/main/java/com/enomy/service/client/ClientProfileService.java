package com.enomy.service.client;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.enomy.dto.profile.ClientProfilePageDTO;
import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;

public interface ClientProfileService {

    ClientProfilePageDTO getProfilePageDataByEmail(String email);

    User getUserByEmail(String email);

    void updateFullName(Long userId, String fullName);

    boolean updatePassword(Long userId, String currentPassword, String newPassword);

    void updateProfileImagePath(Long userId, String profileImagePath);

    void clearProfileImagePath(Long userId);

    List<LoginActivity> getLoginActivities(Long userId, LocalDate fromDate, LocalDate toDate);

    List<LoginActivity> getFailedLoginActivities(Long userId, LocalDate fromDate, LocalDate toDate);

    void softDeleteUser(Long userId);

    String saveProfileImage(Long userId, MultipartFile file) throws IOException;
}