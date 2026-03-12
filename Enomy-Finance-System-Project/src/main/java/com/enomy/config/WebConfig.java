package com.enomy.config;

// Spring configuration annotations
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

// Spring MVC imports
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// View resolver for JSP
import org.springframework.web.servlet.view.InternalResourceViewResolver;

// SPRING SECURITY
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;


/*
 * This class configures Spring MVC for the application.
 * It replaces the old XML configuration (spring-servlet.xml).
 */

@Configuration // Marks this class as a Spring configuration class
@EnableWebMvc // Enables Spring MVC features like controllers, view resolution, etc.
@ComponentScan(basePackages = "com.enomy") 
// Tells Spring to scan this package and its subpackages
// for components like @Controller, @Service, @Repository

public class WebConfig implements WebMvcConfigurer {
	
	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
	    return new BCryptPasswordEncoder();
	}

    
    /*
     * ViewResolver tells Spring where JSP files are located.
     * When a controller returns a view name, Spring will build the full path.
     */
    
    @Bean
    public ViewResolver viewResolver() {

        // InternalResourceViewResolver is used for JSP views
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();

        // Location of JSP files
        resolver.setPrefix("/WEB-INF/views/");

        // File extension for JSP pages
        resolver.setSuffix(".jsp");

        return resolver;
    }


    /*
     * Enables default servlet handling.
     * This allows Tomcat to serve static resources like:
     * CSS, JavaScript, images, fonts, etc.
     */

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }


    /*
     * Maps static resource folders so Spring knows where to find them.
     *
     * Example:
     * /resources/css/style.css
     * /resources/js/script.js
     * /resources/images/logo.png
     */

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }
}