package com.enomy.security;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Collection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.enomy.dao.EFuser.LoginActivityDao;
import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private UserDao userDao;

    @Autowired
    private LoginActivityDao loginActivityDao;

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String email = authentication.getName();
        User user = userDao.findByEmail(email);

        if (user != null) {
            userDao.updateLastLoginAt(user.getId(), LocalDateTime.now());

            LoginActivity activity = new LoginActivity();
            activity.setUserId(user.getId());
            activity.setAttemptedAt(Timestamp.valueOf(LocalDateTime.now()));
            activity.setStatus("SUCCESS");
            activity.setReason("Login successful");
            activity.setIpAddress(request.getRemoteAddr());
            activity.setDeviceBrowser(request.getHeader("User-Agent"));

            loginActivityDao.save(activity);
        }

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        for (GrantedAuthority authority : authorities) {
            if (authority.getAuthority().equals("ROLE_ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            if (authority.getAuthority().equals("ROLE_CLIENT")) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/login?error=true");
    }
}