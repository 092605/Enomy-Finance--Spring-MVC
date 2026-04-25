package com.enomy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import org.springframework.web.servlet.view.InternalResourceViewResolver;

import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

/*
 * =========================================================
 * SPRING MVC WEB CONFIGURATION
 * =========================================================
 *
 * File Name:
 * WebConfig.java
 *
 * Purpose:
 * This class configures the Spring MVC framework
 * for the Enomy Finance web application.
 *
 * Overview:
 * It replaces the traditional XML-based Spring MVC
 * configuration and manages:
 * - JSP view resolution
 * - Static resource handling
 * - Multipart file uploads
 * - Component scanning
 * - MVC activation
 *
 * Main Responsibilities:
 * - Configure JSP file location
 * - Configure JSP file extension
 * - Enable Spring MVC
 * - Configure static resources
 * - Configure uploaded file access
 * - Configure multipart file upload support
 * - Enable controller scanning
 *
 * Connected Features:
 * - JSP rendering
 * - CSS loading
 * - JavaScript loading
 * - Image loading
 * - Profile photo uploads
 * - Controller routing
 * - Multipart form handling
 *
 * =========================================================
 */

@Configuration // Marks this as a Spring configuration class
@EnableWebMvc // Enables Spring MVC framework support
@ComponentScan(basePackages = "com.enomy")
/*
 * Scans the com.enomy package
 * for:
 * - Controllers
 * - Services
 * - DAO implementations
 * - Components
 * - Security classes
 */
public class WebConfig implements WebMvcConfigurer {

    /*
     * =========================================================
     * VIEW RESOLVER CONFIGURATION
     * =========================================================
     */

    @Bean
    public ViewResolver viewResolver() {

        /*
         * InternalResourceViewResolver
         *
         * Responsible for resolving JSP page locations.
         *
         * Example:
         * Returning "home"
         * becomes:
         * /WEB-INF/views/home.jsp
         */

        InternalResourceViewResolver resolver =
                new InternalResourceViewResolver();

        /*
         * JSP folder location.
         */
        resolver.setPrefix("/WEB-INF/views/");

        /*
         * JSP file extension.
         */
        resolver.setSuffix(".jsp");

        /*
         * Returns configured view resolver bean.
         */
        return resolver;
    }

    /*
     * =========================================================
     * MULTIPART FILE UPLOAD CONFIGURATION
     * =========================================================
     */

    @Bean
    public MultipartResolver multipartResolver() {

        /*
         * StandardServletMultipartResolver
         *
         * Enables multipart/form-data handling.
         *
         * Used for:
         * - Profile image upload
         * - Avatar upload
         * - Future document upload support
         */

        return new StandardServletMultipartResolver();
    }

    /*
     * =========================================================
     * DEFAULT SERVLET HANDLING
     * =========================================================
     */

    @Override
    public void configureDefaultServletHandling(
            DefaultServletHandlerConfigurer configurer) {

        /*
         * Enables forwarding of static resource requests
         * to the container's default servlet.
         *
         * Allows:
         * - CSS files
         * - JS files
         * - Images
         * - Fonts
         * - Uploaded resources
         * to load properly.
         */

        configurer.enable();
    }

    /*
     * =========================================================
     * STATIC RESOURCE HANDLERS
     * =========================================================
     */

    @Override
    public void addResourceHandlers(
            ResourceHandlerRegistry registry) {

        /*
         * =========================================================
         * APPLICATION STATIC RESOURCES
         * =========================================================
         *
         * Maps:
         * /resources/**
         *
         * To:
         * /resources/
         *
         * Used for:
         * - CSS
         * - JavaScript
         * - Images
         * - Animations
         * - Icons
         */

        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");

        /*
         * =========================================================
         * UPLOADED FILES
         * =========================================================
         *
         * Maps:
         * /uploads/**
         *
         * To:
         * uploads/ folder in the file system
         *
         * Used for:
         * - Uploaded profile photos
         * - Custom avatars
         * - Future uploaded documents/images
         */

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");
    }
}