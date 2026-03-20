package com.enomy.dto;

import java.util.Date;

public class TransactionReceiptDTO {

    private String transactionNumber;
    private String transactionType;
    private Date date;
    private String baseCurrency;
    private String targetCurrency;
    private Double inputAmount;
    private Double exchangeRateUsed;
    private Double convertedAmount;
    private Double feeRateApplied;
    private Double feeValue;
    private Double finalAmount;
    private String label;
    private String message;

    public TransactionReceiptDTO() {
    }

    public String getTransactionNumber() {
        return transactionNumber;
    }

    public void setTransactionNumber(String transactionNumber) {
        this.transactionNumber = transactionNumber;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}