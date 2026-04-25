package com.enomy.controller.admin.AdditionalFeature;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.enomy.security.CustomUserDetails;

/*
 * =========================================================
 * ADMIN DASHBOARD CONTROLLER
 * =========================================================
 *
 * File Name:
 * AdminDashboardController.java
 *
 * Purpose:
 * This controller handles administrator dashboard-related
 * page routing for the Enomy Finance system.
 *
 * Overview:
 * The controller is responsible for loading:
 * - Admin Dashboard page
 * - Admin Transaction History page
 *
 * It also retrieves authenticated administrator
 * information from Spring Security and supplies
 * reusable user details to the JSP views.
 *
 * Main Responsibilities:
 * - Handle admin dashboard routing
 * - Handle admin transaction history routing
 * - Retrieve authenticated admin information
 * - Supply reusable user data to JSP pages
 * - Set active sidebar navigation state
 *
 * Connected JSP Pages:
 * - admin/admin-dashboard.jsp
 * - admin/transaction-history.jsp
 *
 * Security:
 * These routes are protected by Spring Security
 * and are only accessible to authenticated users
 * with ADMIN role permissions.
 *
 * =========================================================
 */

@Controller
/*
 * Marks this class as a Spring MVC Controller.
 *
 * Spring automatically detects and registers it
 * for handling HTTP requests.
 */
public class AdminDashboardController {

	/*
	 * =========================================================
	 * ADMIN DASHBOARD ROUTE
	 * =========================================================
	 */

	@GetMapping("/admin/dashboard")
	/*
	 * Handles GET requests for:
	 * /admin/dashboard
	 */
	public String adminDashboard(
	        Authentication authentication,
	        Model model) {

	    /*
	     * Authentication object
	     *
	     * Automatically provided by Spring Security.
	     *
	     * Contains information about the currently
	     * authenticated user session.
	     */

	    /*
	     * Retrieves the authenticated user object
	     * and converts it into CustomUserDetails.
	     *
	     * CustomUserDetails contains:
	     * - Full name
	     * - Email
	     * - Role
	     * - User ID
	     */
		CustomUserDetails userDetails =
		        (CustomUserDetails) authentication.getPrincipal();

		/*
		 * =========================================================
		 * PASS DATA TO JSP
		 * =========================================================
		 */

		/*
		 * Supplies administrator full name
		 * for display in:
		 * - Topbar
		 * - Welcome message
		 */
        model.addAttribute(
                "fullName",
                userDetails.getFullName()
        );

        /*
         * Supplies logged-in email address.
         */
        model.addAttribute(
                "loggedInEmail",
                userDetails.getUsername()
        );

        /*
         * Used for active sidebar highlighting.
         *
         * Example:
         * Dashboard menu becomes active.
         */
        model.addAttribute(
                "activePage",
                "dashboard"
        );

        /*
         * Returns JSP page:
         * /WEB-INF/views/admin/admin-dashboard.jsp
         */
	    return "admin/admin-dashboard";
	}

	/*
	 * =========================================================
	 * ADMIN TRANSACTION HISTORY ROUTE
	 * =========================================================
	 */

	@GetMapping("/admin/transaction-history")
	/*
	 * Handles GET requests for:
	 * /admin/transaction-history
	 */
	public String adminHistory(
	        Authentication authentication,
	        Model model) {

	    /*
	     * Retrieves authenticated administrator details.
	     */
	    CustomUserDetails userDetails =
	            (CustomUserDetails) authentication.getPrincipal();

	    /*
	     * =========================================================
	     * PASS DATA TO JSP
	     * =========================================================
	     */

	    /*
	     * Supplies administrator full name.
	     */
	    model.addAttribute(
	            "fullName",
	            userDetails.getFullName()
	    );

	    /*
	     * Supplies logged-in email.
	     */
	    model.addAttribute(
	            "loggedInEmail",
	            userDetails.getUsername()
	    );

	    /*
	     * Activates transaction history
	     * sidebar navigation highlight.
	     */
	    model.addAttribute(
	            "activePage",
	            "transaction-history"
	    );

	    /*
	     * Returns JSP page:
	     * /WEB-INF/views/admin/transaction-history.jsp
	     */
	    return "admin/transaction-history";
	}
}