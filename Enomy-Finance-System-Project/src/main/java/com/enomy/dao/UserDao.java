package com.enomy.dao;

import com.enomy.model.User;

public interface UserDao {

    void saveUser(User user);

    User findByEmail(String email);
}

