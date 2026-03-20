package com.enomy.dto;

public class ConversionFeeRuleDTO {

    private Double minAmount;
    private Double maxAmount;
    private Double feeRate;

    public ConversionFeeRuleDTO() {
    }

    public ConversionFeeRuleDTO(Double minAmount, Double maxAmount, Double feeRate) {
        this.minAmount = minAmount;
        this.maxAmount = maxAmount;
        this.feeRate = feeRate;
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
}