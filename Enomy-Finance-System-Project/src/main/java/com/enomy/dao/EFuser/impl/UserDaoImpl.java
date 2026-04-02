package com.enomy.dao.EFuser.impl;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<User> userRowMapper = (rs, rowNum) -> {
        User user = new User();

        user.setId(rs.getLong("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setEnabled(rs.getBoolean("enabled"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setLastLoginAt(rs.getTimestamp("last_login_at"));
        user.setProfileImagePath(rs.getString("profile_image_path"));
        user.setPasswordUpdatedAt(rs.getTimestamp("password_updated_at"));

        try {
            user.setIsDeleted(rs.getObject("is_deleted") == null ? null : rs.getBoolean("is_deleted"));
        } catch (Exception e) {
            user.setIsDeleted(false);
        }

        return user;
    };

    @Override
    public void saveUser(User user) {
        String sql = """
            INSERT INTO users
            (full_name, email, password, role, enabled, created_at, password_updated_at, is_deleted)
            VALUES (?, ?, ?, ?, ?, NOW(), NOW(), 0)
        """;

        jdbcTemplate.update(
            sql,
            user.getFullName(),
            user.getEmail(),
            user.getPassword(),
            user.getRole(),
            user.isEnabled()
        );
    }

    @Override
    public User findByEmail(String email) {
        String sql = """
            SELECT * FROM users
            WHERE email = ?
              AND (is_deleted = 0 OR is_deleted IS NULL)
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, userRowMapper, email);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public User findById(Long userId) {
        String sql = """
            SELECT * FROM users
            WHERE id = ?
              AND (is_deleted = 0 OR is_deleted IS NULL)
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, userRowMapper, userId);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void updateFullName(Long userId, String fullName) {
        String sql = "UPDATE users SET full_name = ? WHERE id = ?";
        jdbcTemplate.update(sql, fullName, userId);
    }

    @Override
    public void updatePassword(Long userId, String passwordHash, LocalDateTime updatedAt) {
        String sql = "UPDATE users SET password = ?, password_updated_at = ? WHERE id = ?";
        jdbcTemplate.update(sql, passwordHash, Timestamp.valueOf(updatedAt), userId);
    }

    @Override
    public LocalDateTime findPasswordUpdatedAt(Long userId) {
        String sql = "SELECT password_updated_at FROM users WHERE id = ?";

        try {
            Timestamp timestamp = jdbcTemplate.queryForObject(sql, Timestamp.class, userId);
            return timestamp != null ? timestamp.toLocalDateTime() : null;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void updateProfileImagePath(Long userId, String profileImagePath) {
        String sql = "UPDATE users SET profile_image_path = ? WHERE id = ?";
        jdbcTemplate.update(sql, profileImagePath, userId);
    }

    @Override
    public void clearProfileImagePath(Long userId) {
        String sql = "UPDATE users SET profile_image_path = NULL WHERE id = ?";
        jdbcTemplate.update(sql, userId);
    }

    @Override
    public void updateLastLoginAt(Long userId, LocalDateTime lastLoginAt) {
        String sql = "UPDATE users SET last_login_at = ? WHERE id = ?";
        jdbcTemplate.update(sql, Timestamp.valueOf(lastLoginAt), userId);
    }

    @Override
    public void softDeleteUser(Long userId) {
        String sql = "UPDATE users SET is_deleted = 1, enabled = 0 WHERE id = ?";
        jdbcTemplate.update(sql, userId);
    }
}