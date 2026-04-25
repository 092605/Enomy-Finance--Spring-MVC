package com.enomy.config;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

/*
 * =========================================================
 * DATABASE CONFIGURATION CLASS
 * =========================================================
 *
 * This class configures the application's connection
 * to the MySQL database using Spring Framework.
 *
 * It also registers reusable Spring Beans:
 * - DataSource
 * - JdbcTemplate
 *
 * These beans are used throughout the DAO layer
 * for executing database operations.
 *
 * =========================================================
 */

@Configuration // Marks this class as a Spring configuration class
public class DatabaseConfig {

    /*
     * =========================================================
     * DATASOURCE BEAN
     * =========================================================
     *
     * Creates and configures the database connection object.
     *
     * Spring will automatically manage this bean and make it
     * available anywhere in the application where needed.
     *
     * This DataSource is used by:
     * - JdbcTemplate
     * - DAO implementation classes
     * - Authentication modules
     * - Transaction modules
     *
     * =========================================================
     */

    @Bean // Registers this method return value as a Spring Bean
    public DataSource dataSource() {

        // DriverManagerDataSource is a simple DataSource implementation
        // used for development and small applications
        DriverManagerDataSource dataSource = new DriverManagerDataSource();

        /*
         * MYSQL JDBC DRIVER
         *
         * This tells Java which database driver to use
         * when connecting to MySQL.
         */
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");

        /*
         * DATABASE CONNECTION URL
         *
         * localhost:3306
         * -> MySQL server running locally on default port 3306
         *
         * enomy_finance_system
         * -> Database name
         *
         * useSSL=false
         * -> Disables SSL for local development
         *
         * serverTimezone=UTC
         * -> Prevents timezone-related JDBC errors
         */
        dataSource.setUrl(
            "jdbc:mysql://localhost:3306/enomy_finance_system?useSSL=false&serverTimezone=UTC"
        );

        /*
         * DATABASE USERNAME
         *
         * MySQL account username used to access the database.
         */
        dataSource.setUsername("root");

        /*
         * DATABASE PASSWORD
         *
         * Password for the MySQL account.
         *
         * NOTE:
         * Hardcoding passwords is acceptable for school projects
         * and local development, but NOT recommended for
         * production systems.
         */
        dataSource.setPassword("Nissagwapa123");

        // Returns the fully configured DataSource object
        return dataSource;
    }

    /*
     * =========================================================
     * JDBCTEMPLATE BEAN
     * =========================================================
     *
     * JdbcTemplate is a Spring utility class that simplifies
     * database operations.
     *
     * Instead of writing long JDBC boilerplate code,
     * JdbcTemplate handles:
     * - Opening database connections
     * - Closing connections
     * - Executing SQL queries
     * - Handling exceptions
     *
     * This bean will automatically use the DataSource bean
     * configured above.
     *
     * =========================================================
     */

    @Bean // Registers JdbcTemplate as a reusable Spring Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {

        /*
         * Injects the configured DataSource into JdbcTemplate.
         *
         * This allows JdbcTemplate to use the MySQL connection
         * settings defined earlier.
         */
        return new JdbcTemplate(dataSource);
    }
}