package com.enomy.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/*
 * This class initializes Spring MVC when the application starts.
 * 
 * It replaces the old web.xml configuration file.
 * Spring will automatically detect this class and configure
 * the DispatcherServlet.
 */

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    /*
     * Root configuration for the application.
     * Usually used for services, repositories, and database configs.
     * 
     * We don't need it yet, so we return null.
     */
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return null;
    }

    /*
     * Servlet configuration class.
     * This tells Spring to use our WebConfig class.
     */
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] { WebConfig.class };
    }

    /*
     * URL mapping for the DispatcherServlet.
     * 
     * "/" means Spring MVC will handle all requests.
     */
    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }
}