package com.enomy.model;

import java.sql.Timestamp;

public class TaxSettings {

    private Long id;
    private String taxType;
    private double taxFreeAllowance;
    private double lowerTaxRate;
    private Double lowerTaxThreshold;
    private double upperTaxRate;
    private Double upperTaxThreshold;
    private boolean active;
    private Timestamp createdAt;
    private Long taxSetId;

    public TaxSettings() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTaxType() {
        return taxType;
    }

    public void setTaxType(String taxType) {
        this.taxType = taxType;
    }

    public double getTaxFreeAllowance() {
        return taxFreeAllowance;
    }

    public void setTaxFreeAllowance(double taxFreeAllowance) {
        this.taxFreeAllowance = taxFreeAllowance;
    }

    public double getLowerTaxRate() {
        return lowerTaxRate;
    }

    public void setLowerTaxRate(double lowerTaxRate) {
        this.lowerTaxRate = lowerTaxRate;
    }

    public Double getLowerTaxThreshold() {
        return lowerTaxThreshold;
    }

    public void setLowerTaxThreshold(Double lowerTaxThreshold) {
        this.lowerTaxThreshold = lowerTaxThreshold;
    }

    public double getUpperTaxRate() {
        return upperTaxRate;
    }

    public void setUpperTaxRate(double upperTaxRate) {
        this.upperTaxRate = upperTaxRate;
    }

    public Double getUpperTaxThreshold() {
        return upperTaxThreshold;
    }

    public void setUpperTaxThreshold(Double upperTaxThreshold) {
        this.upperTaxThreshold = upperTaxThreshold;
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
    
    public Long getTaxSetId() {
        return taxSetId;
    }

    public void setTaxSetId(Long taxSetId) {
        this.taxSetId = taxSetId;
    }
}