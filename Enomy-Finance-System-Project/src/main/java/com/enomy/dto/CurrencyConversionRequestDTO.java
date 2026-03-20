package com.enomy.dto;

public class CurrencyConversionRequestDTO {

    private String transactionType;
    private String baseCurrency;
    private String targetCurrency;
    private Double amount;

    public CurrencyConversionRequestDTO() {
    }

    public CurrencyConversionRequestDTO(String transactionType, String baseCurrency, String targetCurrency, Double amount) {
        this.transactionType = transactionType;
        this.baseCurrency = baseCurrency;
        this.targetCurrency = targetCurrency;
        this.amount = amount;
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

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }
}