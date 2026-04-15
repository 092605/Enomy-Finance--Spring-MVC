package com.enomy.controller.site;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

@ControllerAdvice
public class GlobalNavbarControllerAdvice {

    @Autowired
    private UserDao userDao;

    @ModelAttribute
    public void addNavbarData(Model model, Principal principal) {
        if (principal == null) {
            model.addAttribute("isLoggedIn", false);
            return;
        }

        User user = userDao.findByEmail(principal.getName());

        if (user != null) {
            model.addAttribute("isLoggedIn", true);
            model.addAttribute("navbarFullName", user.getFullName());
            model.addAttribute("navbarRole", user.getRole());
            model.addAttribute("navbarProfileImagePath", user.getProfileImagePath());
        } else {
            model.addAttribute("isLoggedIn", false);
        }
    }
}


