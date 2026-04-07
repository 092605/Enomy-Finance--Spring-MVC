package com.enomy.service.client.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.enomy.dao.EFuser.LoginActivityDao;
import com.enomy.dao.EFuser.UserDao;
import com.enomy.dto.profile.ClientProfilePageDTO;
import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;
import com.enomy.service.client.ClientProfileService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

@Service
public class ClientProfileServiceImpl implements ClientProfileService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private LoginActivityDao loginActivityDao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public ClientProfilePageDTO getProfilePageDataByEmail(String email) {
        User user = userDao.findByEmail(email);
        if (user == null) {
            return null;
        }

        ClientProfilePageDTO dto = new ClientProfilePageDTO();
        dto.setUser(user);
        dto.setFailedTodayCount(loginActivityDao.countFailedToday(user.getId()));
        dto.setFailedThisMonthCount(loginActivityDao.countFailedThisMonth(user.getId()));
        dto.setLastFailedLogin(loginActivityDao.findLastFailedLogin(user.getId()));
        dto.setLastSuccessfulLogin(loginActivityDao.findLastSuccessfulLogin(user.getId()));
        dto.setPreviousSuccessfulLogin(loginActivityDao.findPreviousSuccessfulLogin(user.getId()));
        dto.setLoginActivities(loginActivityDao.findAllByUserId(user.getId()));

        return dto;
    }

    @Override
    public User getUserByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public void updateFullName(Long userId, String fullName) {
        userDao.updateFullName(userId, fullName);
    }

    @Override
    public boolean updatePassword(Long userId, String currentPassword, String newPassword) {
        User user = userDao.findById(userId);

        if (user == null) {
            return false;
        }

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return false;
        }

        String encodedPassword = passwordEncoder.encode(newPassword);
        userDao.updatePassword(userId, encodedPassword, LocalDateTime.now());
        return true;
    }

    @Override
    public void updateProfileImagePath(Long userId, String profileImagePath) {
        userDao.updateProfileImagePath(userId, profileImagePath);
    }

    @Override
    public void clearProfileImagePath(Long userId) {
        userDao.clearProfileImagePath(userId);
    }

    @Override
    public List<LoginActivity> getLoginActivities(Long userId, LocalDate fromDate, LocalDate toDate) {
        return loginActivityDao.findByUserIdAndDateRange(userId, fromDate, toDate);
    }

    @Override
    public List<LoginActivity> getFailedLoginActivities(Long userId, LocalDate fromDate, LocalDate toDate) {
        return loginActivityDao.findFailedByUserIdAndDateRange(userId, fromDate, toDate);
    }

    @Override
    public void softDeleteUser(Long userId) {
        userDao.softDeleteUser(userId);
    }
    
    @Override
    public String saveProfileImage(Long userId, MultipartFile file) throws IOException {
        User user = userDao.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found.");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";

        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String fileName = "profile_" + userId + "_" + UUID.randomUUID() + extension;

        Path uploadDir = Paths.get("uploads/profile");
        Files.createDirectories(uploadDir);

        Path filePath = uploadDir.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        String dbPath = "/uploads/profile/" + fileName;

        userDao.updateProfileImagePath(userId, dbPath);

        return dbPath;
    }
}