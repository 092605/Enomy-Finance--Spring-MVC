package com.enomy.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.enomy.dao.UserDao;
import com.enomy.model.User;


/*This class handles database access*/
@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
	private JdbcTemplate jdbcTemplate; /* injected automatically from DatabaseConfig.java */

    
	/* Converts database rows → Java User object. */
    private RowMapper<User> userRowMapper = (rs, rowNum) -> {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setEnabled(rs.getBoolean("enabled"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    };

    
	/* Used when: User signs up It inserts a row into:users table*/
    
    @Override
    public void saveUser(User user) {

        String sql = "INSERT INTO users (full_name, email, password, role, enabled) VALUES (?, ?, ?, ?, ?)";

        jdbcTemplate.update(
                sql,
                user.getFullName(),
                user.getEmail(),
                user.getPassword(),
                user.getRole(),
                user.isEnabled()
        );
    }
    
    
    /* Used for:

    	Login authentication
    	Duplicate email checking
    	Spring Security user loading */

    @Override
    public User findByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email = ?";

        try {
            return jdbcTemplate.queryForObject(sql, userRowMapper, email);
        } catch (Exception e) {
            return null;
        }
    }
}