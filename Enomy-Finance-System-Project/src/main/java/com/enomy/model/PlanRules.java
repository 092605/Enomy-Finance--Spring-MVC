package com.enomy.model;

import java.sql.Timestamp;

public class PlanRules {

    private Long id;
    private String planType;
    private double minReturnRate;
    private double maxReturnRate;
    private double monthlyFeeRate;
    private Double yearlyInvestmentLimit;
    private double minMonthlyRequired;
    private double minInitialRequired;
    private Long taxSettingsId;
    private boolean active;
    private Timestamp createdAt;

    private TaxSettings taxSettings;

    public PlanRules() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public double getMinReturnRate() {
        return minReturnRate;
    }

    public void setMinReturnRate(double minReturnRate) {
        this.minReturnRate = minReturnRate;
    }

    public double getMaxReturnRate() {
        return maxReturnRate;
    }

    public void setMaxReturnRate(double maxReturnRate) {
        this.maxReturnRate = maxReturnRate;
    }

    public double getMonthlyFeeRate() {
        return monthlyFeeRate;
    }

    public void setMonthlyFeeRate(double monthlyFeeRate) {
        this.monthlyFeeRate = monthlyFeeRate;
    }

    public Double getYearlyInvestmentLimit() {
        return yearlyInvestmentLimit;
    }

    public void setYearlyInvestmentLimit(Double yearlyInvestmentLimit) {
        this.yearlyInvestmentLimit = yearlyInvestmentLimit;
    }

    public double getMinMonthlyRequired() {
        return minMonthlyRequired;
    }

    public void setMinMonthlyRequired(double minMonthlyRequired) {
        this.minMonthlyRequired = minMonthlyRequired;
    }

    public double getMinInitialRequired() {
        return minInitialRequired;
    }

    public void setMinInitialRequired(double minInitialRequired) {
        this.minInitialRequired = minInitialRequired;
    }

    public Long getTaxSettingsId() {
        return taxSettingsId;
    }

    public void setTaxSettingsId(Long taxSettingsId) {
        this.taxSettingsId = taxSettingsId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public TaxSettings getTaxSettings() {
        return taxSettings;
    }

    public void setTaxSettings(TaxSettings taxSettings) {
        this.taxSettings = taxSettings;
    }
}