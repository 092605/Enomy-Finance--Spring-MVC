package com.enomy.controller.client.AdditionalFeature;


import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

@ControllerAdvice(basePackages = "com.enomy.controller.client")
public class ClientGlobalModel {

    @Autowired
    private UserDao userDao;

    @ModelAttribute("user")
    public User populateUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userDao.findByEmail(principal.getName());
    }

    @ModelAttribute("fullName")
    public String populateFullName(Principal principal) {
        if (principal == null) {
            return "";
        }

        User user = userDao.findByEmail(principal.getName());
        return user != null ? user.getFullName() : "";
    }
}