package com.enomy.dto;

import java.util.Date;

public class AdminInvestmentQuoteHistoryRowDTO {

    private Long quoteId; // since no transaction_number in your table

    private Long userId;
    private String userName;

    private String planType;

    private Double initialLumpSum;
    private Double monthlyInvestment;

    private Long planRuleId;

    private Date createdAt;

    // =========================
    // GETTERS & SETTERS
    // =========================

    public Long getQuoteId() {
        return quoteId;
    }

    public void setQuoteId(Long quoteId) {
        this.quoteId = quoteId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public Double getInitialLumpSum() {
        return initialLumpSum;
    }

    public void setInitialLumpSum(Double initialLumpSum) {
        this.initialLumpSum = initialLumpSum;
    }

    public Double getMonthlyInvestment() {
        return monthlyInvestment;
    }

    public void setMonthlyInvestment(Double monthlyInvestment) {
        this.monthlyInvestment = monthlyInvestment;
    }

    public Long getPlanRuleId() {
        return planRuleId;
    }

    public void setPlanRuleId(Long planRuleId) {
        this.planRuleId = planRuleId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}