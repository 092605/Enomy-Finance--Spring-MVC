package com.enomy.controller.client.AdditionalFeature;


import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.enomy.dao.EFuser.UserDao;
import com.enomy.model.EFuser.User;

/*
=========================================================
CLIENT GLOBAL MODEL CONTROLLER ADVICE
=========================================================

File Name:
ClientGlobalModel.java

Purpose:
This global controller advice automatically supplies
shared authenticated client data to all client-side
controllers and JSP pages within the Enomy Finance system.

Overview:
This class eliminates repetitive code by automatically
injecting commonly used authenticated user information
into the model for every client controller request.

The shared data becomes globally accessible inside
all client JSP pages without manually adding the
attributes in every controller method.

Main Responsibilities:
- Retrieve authenticated client information
- Supply shared User model object
- Supply shared full name attribute
- Reduce duplicated controller code
- Provide reusable authenticated user data
- Automatically populate common model attributes

Scope:
Applies only to controllers inside:
com.enomy.controller.client

Connected DAO:
- UserDao

Connected Models:
- User

Main Shared Model Attributes:
- user
- fullName

Main Features:
- Global authenticated user access
- Shared topbar data support
- Shared sidebar data support
- Shared profile information access
- Reduced controller duplication
- Automatic model population

Used By:
- Client dashboard pages
- Client profile pages
- Client currency converter pages
- Client investment pages
- Shared authenticated components

Security:
Works together with Spring Security authentication
and retrieves authenticated user information using
the logged-in Principal object.

Module:
Web Development Foundations (WDF)

System:
Enomy Finance Web Application

=========================================================
*/




@ControllerAdvice(basePackages = "com.enomy.controller.client")
public class ClientGlobalModel {

    @Autowired
    private UserDao userDao;

    @ModelAttribute("user")
    public User populateUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userDao.findByEmail(principal.getName());
    }

    @ModelAttribute("fullName")
    public String populateFullName(Principal principal) {
        if (principal == null) {
            return "";
        }

        User user = userDao.findByEmail(principal.getName());
        return user != null ? user.getFullName() : "";
    }
}