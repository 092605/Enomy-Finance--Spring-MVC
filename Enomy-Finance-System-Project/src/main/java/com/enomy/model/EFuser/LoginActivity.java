package com.enomy.model.EFuser;

import java.sql.Timestamp;

public class LoginActivity {

    private Long id;
    private Long userId;
    private Timestamp attemptedAt;
    private String status;
    private String reason;
    private String ipAddress;
    private String deviceBrowser;

    public LoginActivity() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Timestamp getAttemptedAt() {
        return attemptedAt;
    }

    public void setAttemptedAt(Timestamp attemptedAt) {
        this.attemptedAt = attemptedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getDeviceBrowser() {
        return deviceBrowser;
    }

    public void setDeviceBrowser(String deviceBrowser) {
        this.deviceBrowser = deviceBrowser;
    }
}