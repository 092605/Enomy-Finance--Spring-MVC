package com.enomy.config;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/*
 * =========================================================
 * WEB APPLICATION INITIALIZER
 * =========================================================
 *
 * File Name:
 * WebAppInitializer.java
 *
 * Purpose:
 * This class serves as the main entry point and
 * configuration bootstrapper for the Enomy Finance
 * web application.
 *
 * Overview:
 * It replaces the traditional web.xml file and
 * configures the Spring MVC application entirely
 * using Java-based configuration.
 *
 * Main Responsibilities:
 * - Registers Spring root configuration classes
 * - Registers Spring MVC servlet configuration
 * - Maps DispatcherServlet routes
 * - Configures multipart file upload support
 * - Initializes the web application on startup
 *
 * Connected Configuration Classes:
 * - DatabaseConfig.java
 * - SecurityConfig.java
 * - WebConfig.java
 *
 * Main Features Enabled:
 * - Spring MVC
 * - Database connection
 * - Spring Security
 * - File upload support
 * - Controller routing
 * - JSP view resolution
 * - Multipart/form-data processing
 *
 * =========================================================
 */

public class WebAppInitializer
        extends AbstractAnnotationConfigDispatcherServletInitializer {

    /*
     * =========================================================
     * ROOT APPLICATION CONFIGURATION
     * =========================================================
     */

    @Override
    protected Class<?>[] getRootConfigClasses() {

        /*
         * Registers global application configuration classes.
         *
         * DatabaseConfig
         * -> Configures MySQL database connection
         * -> Registers JdbcTemplate
         *
         * SecurityConfig
         * -> Configures Spring Security
         * -> Handles authentication and authorization
         */

        return new Class[] {
            DatabaseConfig.class,
            SecurityConfig.class
        };
    }

    /*
     * =========================================================
     * SERVLET CONFIGURATION
     * =========================================================
     */

    @Override
    protected Class<?>[] getServletConfigClasses() {

        /*
         * Registers Spring MVC configuration.
         *
         * WebConfig handles:
         * - View resolvers
         * - Static resources
         * - Component scanning
         * - MVC setup
         */

        return new Class[] { WebConfig.class };
    }

    /*
     * =========================================================
     * DISPATCHER SERVLET MAPPING
     * =========================================================
     */

    @Override
    protected String[] getServletMappings() {

        /*
         * Maps the DispatcherServlet to "/"
         *
         * Meaning:
         * All incoming requests are handled
         * by Spring MVC.
         */

        return new String[] { "/" };
    }

    /*
     * =========================================================
     * MULTIPART / FILE UPLOAD CONFIGURATION
     * =========================================================
     */

    @Override
    protected void customizeRegistration(
            ServletRegistration.Dynamic registration) {

        /*
         * MultipartConfigElement enables
         * file upload support in the application.
         *
         * Used for:
         * - Profile image upload
         * - Avatar upload
         * - Future document/image upload features
         */

        MultipartConfigElement multipartConfig =
                new MultipartConfigElement(

            /*
             * Temporary file storage location.
             *
             * null means:
             * Use default server temp directory.
             */
            null,

            /*
             * Maximum single uploaded file size
             *
             * 5 MB
             */
            5 * 1024 * 1024,

            /*
             * Maximum total request size
             *
             * 10 MB
             */
            10 * 1024 * 1024,

            /*
             * File size threshold before writing
             * to disk storage.
             *
             * 1 MB
             */
            1024 * 1024
        );

        /*
         * Registers multipart configuration
         * to the servlet registration.
         */

        registration.setMultipartConfig(multipartConfig);
    }
}