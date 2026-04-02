package com.enomy.security;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.enomy.dao.EFuser.LoginActivityDao;
import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;

@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

    @Autowired
    private UserDao userDao;

    @Autowired
    private LoginActivityDao loginActivityDao;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception)
            throws IOException, ServletException {

        String email = request.getParameter("username");

        // fallback (VERY IMPORTANT)
        if (email == null || email.isBlank()) {
            Object lastUsername = request.getSession()
                    .getAttribute("SPRING_SECURITY_LAST_USERNAME");

            if (lastUsername != null) {
                email = lastUsername.toString();
            }
        }

        if (email != null && !email.isBlank()) {
            User user = userDao.findByEmail(email);

            if (user != null) {
                LoginActivity activity = new LoginActivity();
                activity.setUserId(user.getId());
                activity.setAttemptedAt(Timestamp.valueOf(LocalDateTime.now()));
                activity.setStatus("FAILED");
                activity.setReason("Invalid email or password");
                activity.setIpAddress(request.getRemoteAddr());
                activity.setDeviceBrowser(request.getHeader("User-Agent"));

                loginActivityDao.save(activity);
            }
        }

        response.sendRedirect(request.getContextPath() + "/login?error=true");
    }
}