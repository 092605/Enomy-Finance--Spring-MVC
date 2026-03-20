package com.enomy.model;

import java.util.Date;

public class ConversionFeeRule {

    private Long id;              // FIXED
    private Long ruleSetId;       // FIXED
    private Double minAmount;
    private Double maxAmount;
    private Double feeRate;
    private Date createdAt;
    private Date updatedAt;

    public ConversionFeeRule() {
    }

    public ConversionFeeRule(Long id, Long ruleSetId, Double minAmount, Double maxAmount, Double feeRate, Date createdAt, Date updatedAt) {
        this.id = id;
        this.ruleSetId = ruleSetId;
        this.minAmount = minAmount;
        this.maxAmount = maxAmount;
        this.feeRate = feeRate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() {     // FIXED
        return id;
    }

    public void setId(Long id) {     // FIXED
        this.id = id;
    }

    public Long getRuleSetId() {     // FIXED
        return ruleSetId;
    }

    public void setRuleSetId(Long ruleSetId) {     // FIXED
        this.ruleSetId = ruleSetId;
    }

    public Double getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(Double minAmount) {
        this.minAmount = minAmount;
    }

    public Double getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(Double maxAmount) {
        this.maxAmount = maxAmount;
    }

    public Double getFeeRate() {
        return feeRate;
    }

    public void setFeeRate(Double feeRate) {
        this.feeRate = feeRate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}