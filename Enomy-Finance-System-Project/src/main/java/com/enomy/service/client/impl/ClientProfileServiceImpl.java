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
}