package com.enomy.dto;

public class CurrencyConversionResponseDTO {

    private String transactionType;
    private String baseCurrency;
    private String targetCurrency;
    private Double inputAmount;
    private Double exchangeRateUsed;
    private Double convertedAmount;
    private Double feeRateApplied;
    private Double feeValue;
    private Double finalAmount;
    private String finalLabel;
    private boolean valid;
    private String message;

    public CurrencyConversionResponseDTO() {
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

    public String getFinalLabel() {
        return finalLabel;
    }

    public void setFinalLabel(String finalLabel) {
        this.finalLabel = finalLabel;
    }

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}