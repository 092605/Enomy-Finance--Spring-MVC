package com.enomy.model;

import java.sql.Timestamp;

public class InvestmentQuote {

    private Long id;
    private Long userId;
    private String planType;
    private double initialLumpSum;
    private double monthlyInvestment;
    private Long planRulesId;
    private Timestamp createdAt;

    private PlanRules planRules;

    public InvestmentQuote() {
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

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public double getInitialLumpSum() {
        return initialLumpSum;
    }

    public void setInitialLumpSum(double initialLumpSum) {
        this.initialLumpSum = initialLumpSum;
    }

    public double getMonthlyInvestment() {
        return monthlyInvestment;
    }

    public void setMonthlyInvestment(double monthlyInvestment) {
        this.monthlyInvestment = monthlyInvestment;
    }

    public Long getPlanRulesId() {
        return planRulesId;
    }

    public void setPlanRulesId(Long planRulesId) {
        this.planRulesId = planRulesId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public PlanRules getPlanRules() {
        return planRules;
    }

    public void setPlanRules(PlanRules planRules) {
        this.planRules = planRules;
    }
}