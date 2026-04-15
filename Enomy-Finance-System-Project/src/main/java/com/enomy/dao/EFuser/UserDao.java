package com.enomy.dao.EFuser;

import java.time.LocalDateTime;

import com.enomy.model.EFuser.User;

public interface UserDao {

    void saveUser(User user);

    User findByEmail(String email);

    User findById(Long userId);

    void updateFullName(Long userId, String fullName);

    void updatePassword(Long userId, String passwordHash, LocalDateTime updatedAt);

    LocalDateTime findPasswordUpdatedAt(Long userId);

    void updateProfileImagePath(Long userId, String profileImagePath);

    void clearProfileImagePath(Long userId);

    void updateLastLoginAt(Long userId, LocalDateTime lastLoginAt);

    void softDeleteUser(Long userId);
    
    User findByFullName(String fullName);
}