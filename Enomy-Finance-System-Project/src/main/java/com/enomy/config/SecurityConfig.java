package com.enomy.config;

import jakarta.servlet.DispatcherType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.enomy.security.CustomAuthenticationFailureHandler;
import com.enomy.security.CustomAuthenticationSuccessHandler;

/*
 * =========================================================
 * SECURITY CONFIGURATION CLASS
 * =========================================================
 *
 * This class configures the Spring Security system
 * of the Enomy Finance application.
 *
 * Main Responsibilities:
 * - Configure authentication
 * - Configure authorization rules
 * - Configure login/logout behavior
 * - Configure password encryption
 * - Protect secured routes
 * - Handle role-based access
 *
 * Roles Used:
 * - CLIENT
 * - ADMIN
 *
 * Public Pages:
 * - Home
 * - About
 * - Landing Converter
 * - Landing Investment
 * - Login
 * - Signup
 *
 * Protected Pages:
 * - /client/**
 * - /admin/**
 *
 * =========================================================
 */

@Configuration // Marks this as a Spring configuration class
@EnableWebSecurity // Enables Spring Security for the application
@EnableMethodSecurity // Allows method-level security annotations
@ComponentScan(basePackages = "com.enomy") // Scans components inside the package
public class SecurityConfig {

    /*
     * =========================================================
     * DEPENDENCY INJECTION
     * =========================================================
     */

    @Autowired
    private UserDetailsService userDetailsService;

    /*
     * UserDetailsService
     *
     * Responsible for loading user information
     * from the database during authentication.
     *
     * Usually connected to:
     * - CustomUserDetailsService
     */

    @Autowired
    private CustomAuthenticationSuccessHandler successHandler;

    /*
     * CustomAuthenticationSuccessHandler
     *
     * Handles successful login behavior.
     *
     * Example:
     * - Redirect CLIENT to client dashboard
     * - Redirect ADMIN to admin dashboard
     */

    @Autowired
    private CustomAuthenticationFailureHandler failureHandler;

    /*
     * CustomAuthenticationFailureHandler
     *
     * Handles failed login attempts.
     *
     * Example:
     * - Show invalid credentials message
     * - Record failed login activity
     */

    /*
     * =========================================================
     * PASSWORD ENCODER BEAN
     * =========================================================
     */

    @Bean
    public PasswordEncoder passwordEncoder() {

        /*
         * BCryptPasswordEncoder
         *
         * Encrypts user passwords securely before storing
         * them inside the database.
         *
         * Important:
         * Passwords are NEVER stored as plain text.
         */

        return new BCryptPasswordEncoder();
    }

    /*
     * =========================================================
     * AUTHENTICATION PROVIDER
     * =========================================================
     */

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {

        /*
         * DaoAuthenticationProvider
         *
         * Responsible for authenticating users
         * using database records.
         */

        DaoAuthenticationProvider authProvider =
                new DaoAuthenticationProvider();

        /*
         * Connects the authentication provider
         * to the custom user details service.
         */
        authProvider.setUserDetailsService(userDetailsService);

        /*
         * Connects password encryption logic.
         */
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }

    /*
     * =========================================================
     * MAIN SECURITY FILTER CHAIN
     * =========================================================
     */

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http)
            throws Exception {

        http

            /*
             * =========================================================
             * AUTHENTICATION PROVIDER
             * =========================================================
             */

            .authenticationProvider(authenticationProvider())

            /*
             * =========================================================
             * CSRF CONFIGURATION
             * =========================================================
             */

            .csrf(csrf -> csrf.disable())

            /*
             * CSRF disabled because:
             * - Project uses custom AJAX workflows
             * - Simplifies development/testing
             *
             * Note:
             * Production systems usually keep CSRF enabled.
             */

            /*
             * =========================================================
             * AUTHORIZATION RULES
             * =========================================================
             */

            .authorizeHttpRequests(auth -> auth

                /*
                 * Allows internal request forwarding
                 * and error dispatching.
                 */
                .dispatcherTypeMatchers(
                    DispatcherType.FORWARD,
                    DispatcherType.INCLUDE,
                    DispatcherType.ERROR
                ).permitAll()

                /*
                 * PUBLIC ROUTES
                 *
                 * These pages are accessible without login.
                 */
                .requestMatchers(
                        "/",
                        "/about",
                        "/landing-converter",
                        "/landing-investment",
                        "/public/check-rate-ajax",
                        "/login",
                        "/signup",
                        "/error",
                        "/resources/**"
                    ).permitAll()

                /*
                 * CLIENT ROUTES
                 *
                 * Only users with CLIENT role
                 * can access these pages.
                 */
                .requestMatchers("/client/**")
                .hasRole("CLIENT")

                /*
                 * ADMIN ROUTES
                 *
                 * Only users with ADMIN role
                 * can access these pages.
                 */
                .requestMatchers("/admin/**")
                .hasRole("ADMIN")

                /*
                 * Any remaining routes
                 * require authentication.
                 */
                .anyRequest().authenticated()
            )

            /*
             * =========================================================
             * LOGIN CONFIGURATION
             * =========================================================
             */

            .formLogin(form -> form

                /*
                 * Custom login page path.
                 */
                .loginPage("/login")

                /*
                 * URL that processes login submissions.
                 */
                .loginProcessingUrl("/login")

                /*
                 * Handles successful login logic.
                 */
                .successHandler(successHandler)

                /*
                 * Handles failed login logic.
                 */
                .failureHandler(failureHandler)

                /*
                 * Allows everyone to access login.
                 */
                .permitAll()
            )

            /*
             * =========================================================
             * LOGOUT CONFIGURATION
             * =========================================================
             */

            .logout(logout -> logout

                /*
                 * Logout endpoint.
                 */
                .logoutUrl("/logout")

                /*
                 * Redirect after successful logout.
                 */
                .logoutSuccessUrl("/login?logout=true")

                /*
                 * Allows everyone to perform logout.
                 */
                .permitAll()
            );

        /*
         * Builds and returns the configured
         * SecurityFilterChain object.
         */
        return http.build();
    }
}