package com.enomy.controller.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

import org.springframework.security.crypto.password.PasswordEncoder;

/*
 * =========================================================
 * AUTHENTICATION CONTROLLER
 * =========================================================
 *
 * File Name:
 * AuthController.java
 *
 * Purpose:
 * This controller handles authentication-related
 * public workflows for the Enomy Finance system.
 *
 * Overview:
 * This controller is responsible for:
 * - Loading login page
 * - Loading signup page
 * - Processing user registration
 * - Validating signup form inputs
 * - Creating new client accounts
 * - Handling registration error messages
 *
 * Main Responsibilities:
 * - Render login page
 * - Render signup page
 * - Validate password confirmation
 * - Validate unique email registration
 * - Validate unique username registration
 * - Encrypt user passwords
 * - Create new client accounts
 * - Save user records to the database
 * - Return authentication success/error messages
 *
 * Connected JSP:
 * - auth/login.jsp
 * - auth/signup.jsp
 *
 * Connected DAO:
 * - UserDao
 *
 * Connected Models:
 * - User
 *
 * Connected Security Components:
 * - PasswordEncoder
 * - BCryptPasswordEncoder
 *
 * Main Features:
 * - Public login page routing
 * - Public signup page routing
 * - Client account registration
 * - Password confirmation validation
 * - Duplicate email validation
 * - Duplicate username validation
 * - BCrypt password encryption
 * - Success and error message handling
 * - Default CLIENT role assignment
 *
 * Main Routes:
 *
 * GET
 * - /login
 * - /signup
 *
 * POST
 * - /signup
 *
 * Security:
 * These routes are publicly accessible.
 *
 * Password Security:
 * User passwords are encrypted using
 * BCryptPasswordEncoder before storage.
 *
 * Default User Role:
 * Newly registered accounts are automatically
 * assigned the CLIENT role.
 *
 * Module:
 * Web Development Foundations (WDF)
 *
 * System:
 * Enomy Finance Web Application
 *
 * =========================================================
 */


@Controller
public class AuthController {

    @Autowired
    private UserDao userDao;
    

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginPage(Model model) {
        model.addAttribute("activePage", "login");
        return "auth/login";
    }

    @GetMapping("/signup")
    public String signupPage(Model model) {
        model.addAttribute("activePage", "signup");
        return "auth/signup";
    }

    @PostMapping("/signup")
    public String processSignup(
            @RequestParam("fullname") String fullName,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model) {

        model.addAttribute("activePage", "signup");

        // check if password and confirm password match
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "auth/signup";
        }

        // check if email already exists
        User existingUser = userDao.findByEmail(email);
        if (existingUser != null) {
            model.addAttribute("error", "Email is already registered. Please use another email.");
            return "auth/signup";
        }
        
        // check if Username already exists
        User existingByFullName = userDao.findByFullName(fullName);
        if (existingByFullName != null) {
            model.addAttribute("error", "Username is already taken.");
            return "auth/signup";
        }

        // create new user
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password)); // BCrypt passwprd
        user.setRole("CLIENT");
        user.setEnabled(true);

        // save to database
        userDao.saveUser(user);

        model.addAttribute("success", "Account created successfully. You can now log in.");
        return "auth/login";
    }
}