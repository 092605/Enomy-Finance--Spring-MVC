package com.enomy.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.enomy.dao.UserDao;
import com.enomy.model.User;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Controller
public class AuthController {

    @Autowired
    private UserDao userDao;
    

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

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
            model.addAttribute("error", "Email is already registered.");
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