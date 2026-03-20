package com.enomy.model;

import java.util.Date;

public class CurrencyTransaction {

    private Long id;
    private String transactionNumber;
    private Long userId;
    private String transactionType;

    private String baseCurrency;
    private String targetCurrency;

    private Double inputAmount;
    private Double exchangeRateUsed;
    private Double convertedAmount;

    private Double feeRateApplied;
    private Double feeValue;
    private Double finalAmount;

    private Long ruleSetId;
    private String status;
    private Date createdAt;

    public CurrencyTransaction() {
    }

    public CurrencyTransaction(Long id, String transactionNumber, Long userId, String transactionType,
                               String baseCurrency, String targetCurrency, Double inputAmount,
                               Double exchangeRateUsed, Double convertedAmount, Double feeRateApplied,
                               Double feeValue, Double finalAmount, Long ruleSetId,
                               String status, Date createdAt) {
        this.id = id;
        this.transactionNumber = transactionNumber;
        this.userId = userId;
        this.transactionType = transactionType;
        this.baseCurrency = baseCurrency;
        this.targetCurrency = targetCurrency;
        this.inputAmount = inputAmount;
        this.exchangeRateUsed = exchangeRateUsed;
        this.convertedAmount = convertedAmount;
        this.feeRateApplied = feeRateApplied;
        this.feeValue = feeValue;
        this.finalAmount = finalAmount;
        this.ruleSetId = ruleSetId;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTransactionNumber() {
        return transactionNumber;
    }

    public void setTransactionNumber(String transactionNumber) {
        this.transactionNumber = transactionNumber;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public String getBaseCurrency() {
        return baseCurrency;
    }

    public void setBaseCurrency(String baseCurrency) {
        this.baseCurrency = baseCurrency;
    }

    public String getTargetCurrency() {
        return targetCurrency;
    }

    public void setTargetCurrency(String targetCurrency) {
        this.targetCurrency = targetCurrency;
    }

    public Double getInputAmount() {
        return inputAmount;
    }

    public void setInputAmount(Double inputAmount) {
        this.inputAmount = inputAmount;
    }

    public Double getExchangeRateUsed() {
        return exchangeRateUsed;
    }

    public void setExchangeRateUsed(Double exchangeRateUsed) {
        this.exchangeRateUsed = exchangeRateUsed;
    }

    public Double getConvertedAmount() {
        return convertedAmount;
    }

    public void setConvertedAmount(Double convertedAmount) {
        this.convertedAmount = convertedAmount;
    }

    public Double getFeeRateApplied() {
        return feeRateApplied;
    }

    public void setFeeRateApplied(Double feeRateApplied) {
        this.feeRateApplied = feeRateApplied;
    }

    public Double getFeeValue() {
        return feeValue;
    }

    public void setFeeValue(Double feeValue) {
        this.feeValue = feeValue;
    }

    public Double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(Double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public Long getRuleSetId() {
        return ruleSetId;
    }

    public void setRuleSetId(Long ruleSetId) {
        this.ruleSetId = ruleSetId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}