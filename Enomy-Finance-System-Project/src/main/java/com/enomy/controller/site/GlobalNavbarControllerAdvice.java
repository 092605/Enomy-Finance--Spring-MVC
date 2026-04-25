package com.enomy.controller.site;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

/*
=========================================================
GLOBAL NAVBAR CONTROLLER ADVICE
=========================================================

File Name:
GlobalNavbarControllerAdvice.java

Purpose:
This global controller advice automatically supplies
shared navbar-related authenticated user data
to JSP pages throughout the Enomy Finance system.

Overview:
This class is responsible for dynamically preparing
navigation bar data based on the currently
authenticated user session.

The shared navbar data becomes globally accessible
inside JSP pages without manually adding the
attributes inside every controller.

Main Responsibilities:
- Detect authenticated users
- Retrieve logged-in user information
- Supply shared navbar model attributes
- Support dynamic navbar rendering
- Support authenticated-aware UI rendering
- Reduce duplicated controller code

Connected DAO:
- UserDao

Connected Models:
- User

Main Shared Model Attributes:
- isLoggedIn
- navbarFullName
- navbarRole
- navbarProfileImagePath

Main Features:
- Dynamic navbar rendering
- Authenticated user detection
- Shared navbar profile display
- Shared role-aware navigation
- Shared profile image rendering
- Global model population
- Reduced controller duplication

Used By:
- Public pages
- Client pages
- Admin pages
- Shared navbar components
- Shared authenticated layouts

Security:
Works together with Spring Security authentication
and retrieves authenticated user information using
the logged-in Principal object.

Module:
Web Development Foundations (WDF)

System:
Enomy Finance Web Application

=========================================================
*/


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


