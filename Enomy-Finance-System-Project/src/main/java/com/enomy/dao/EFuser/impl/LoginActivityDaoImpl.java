package com.enomy.dao.EFuser.impl;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.enomy.dao.EFuser.LoginActivityDao;
import com.enomy.model.EFuser.LoginActivity;

@Repository
public class LoginActivityDaoImpl implements LoginActivityDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<LoginActivity> rowMapper = (rs, rowNum) -> {
        LoginActivity item = new LoginActivity();
        item.setId(rs.getLong("id"));
        item.setUserId(rs.getLong("user_id"));
        item.setAttemptedAt(rs.getTimestamp("attempted_at"));
        item.setStatus(rs.getString("status"));
        item.setReason(rs.getString("reason"));
        item.setIpAddress(rs.getString("ip_address"));
        item.setDeviceBrowser(rs.getString("device_browser"));
        return item;
    };

    @Override
    public void save(LoginActivity activity) {
        String sql = """
            INSERT INTO user_login_activity
            (user_id, attempted_at, status, reason, ip_address, device_browser)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        jdbcTemplate.update(
            sql,
            activity.getUserId(),
            activity.getAttemptedAt() != null ? activity.getAttemptedAt() : new Timestamp(System.currentTimeMillis()),
            activity.getStatus(),
            activity.getReason(),
            activity.getIpAddress(),
            activity.getDeviceBrowser()
        );
    }

    @Override
    public List<LoginActivity> findAllByUserId(Long userId) {
        String sql = """
            SELECT * FROM user_login_activity
            WHERE user_id = ?
            ORDER BY attempted_at DESC
        """;
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    @Override
    public List<LoginActivity> findByUserIdAndDateRange(Long userId, LocalDate fromDate, LocalDate toDate) {
        StringBuilder sql = new StringBuilder("""
            SELECT * FROM user_login_activity
            WHERE user_id = ?
        """);

        if (fromDate != null) {
            sql.append(" AND DATE(attempted_at) >= ?");
        }
        if (toDate != null) {
            sql.append(" AND DATE(attempted_at) <= ?");
        }

        sql.append(" ORDER BY attempted_at DESC");

        if (fromDate != null && toDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(fromDate), Date.valueOf(toDate));
        } else if (fromDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(fromDate));
        } else if (toDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(toDate));
        } else {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId);
        }
    }

    @Override
    public List<LoginActivity> findFailedByUserIdAndDateRange(Long userId, LocalDate fromDate, LocalDate toDate) {
        StringBuilder sql = new StringBuilder("""
            SELECT * FROM user_login_activity
            WHERE user_id = ?
              AND status = 'FAILED'
        """);

        if (fromDate != null) {
            sql.append(" AND DATE(attempted_at) >= ?");
        }
        if (toDate != null) {
            sql.append(" AND DATE(attempted_at) <= ?");
        }

        sql.append(" ORDER BY attempted_at DESC");

        if (fromDate != null && toDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(fromDate), Date.valueOf(toDate));
        } else if (fromDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(fromDate));
        } else if (toDate != null) {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId, Date.valueOf(toDate));
        } else {
            return jdbcTemplate.query(sql.toString(), rowMapper, userId);
        }
    }

    @Override
    public int countFailedToday(Long userId) {
        String sql = """
            SELECT COUNT(*)
            FROM user_login_activity
            WHERE user_id = ?
              AND status = 'FAILED'
              AND DATE(attempted_at) = CURDATE()
        """;
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    @Override
    public int countFailedThisMonth(Long userId) {
        String sql = """
            SELECT COUNT(*)
            FROM user_login_activity
            WHERE user_id = ?
              AND status = 'FAILED'
              AND YEAR(attempted_at) = YEAR(CURDATE())
              AND MONTH(attempted_at) = MONTH(CURDATE())
        """;
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    @Override
    public LoginActivity findLastFailedLogin(Long userId) {
        String sql = """
            SELECT * FROM user_login_activity
            WHERE user_id = ?
              AND status = 'FAILED'
            ORDER BY attempted_at DESC
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, userId);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public LoginActivity findLastSuccessfulLogin(Long userId) {
        String sql = """
            SELECT * FROM user_login_activity
            WHERE user_id = ?
              AND status = 'SUCCESS'
            ORDER BY attempted_at DESC
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, userId);
        } catch (Exception e) {
            return null;
        }
    }
}