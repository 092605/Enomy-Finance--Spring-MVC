package com.enomy.dto.profile;

import java.util.List;

import com.enomy.model.EFuser.LoginActivity;
import com.enomy.model.EFuser.User;

public class ClientProfilePageDTO {

    private User user;
    private int failedTodayCount;
    private int failedThisMonthCount;
    private LoginActivity lastFailedLogin;
    private LoginActivity lastSuccessfulLogin;
    private List<LoginActivity> loginActivities;
    private LoginActivity previousSuccessfulLogin;

    public LoginActivity getPreviousSuccessfulLogin() {
        return previousSuccessfulLogin;
    }

    public void setPreviousSuccessfulLogin(LoginActivity previousSuccessfulLogin) {
        this.previousSuccessfulLogin = previousSuccessfulLogin;
    }

    public ClientProfilePageDTO() {
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getFailedTodayCount() {
        return failedTodayCount;
    }

    public void setFailedTodayCount(int failedTodayCount) {
        this.failedTodayCount = failedTodayCount;
    }

    public int getFailedThisMonthCount() {
        return failedThisMonthCount;
    }

    public void setFailedThisMonthCount(int failedThisMonthCount) {
        this.failedThisMonthCount = failedThisMonthCount;
    }

    public LoginActivity getLastFailedLogin() {
        return lastFailedLogin;
    }

    public void setLastFailedLogin(LoginActivity lastFailedLogin) {
        this.lastFailedLogin = lastFailedLogin;
    }

    public LoginActivity getLastSuccessfulLogin() {
        return lastSuccessfulLogin;
    }

    public void setLastSuccessfulLogin(LoginActivity lastSuccessfulLogin) {
        this.lastSuccessfulLogin = lastSuccessfulLogin;
    }

    public List<LoginActivity> getLoginActivities() {
        return loginActivities;
    }

    public void setLoginActivities(List<LoginActivity> loginActivities) {
        this.loginActivities = loginActivities;
    }
}