package com.enomy.dto;

public class CheckRateResponseDTO {

    private String baseCurrency;
    private String targetCurrency;
    private Double rate;
    private Double convertedAmount;
    private String rateDate;

    public CheckRateResponseDTO() {
    }

    public CheckRateResponseDTO(String baseCurrency, String targetCurrency, Double rate, Double convertedAmount, String rateDate) {
        this.baseCurrency = baseCurrency;
        this.targetCurrency = targetCurrency;
        this.rate = rate;
        this.convertedAmount = convertedAmount;
        this.rateDate = rateDate;
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

    public Double getRate() {
        return rate;
    }

    public void setRate(Double rate) {
        this.rate = rate;
    }

    public Double getConvertedAmount() {
        return convertedAmount;
    }

    public void setConvertedAmount(Double convertedAmount) {
        this.convertedAmount = convertedAmount;
    }

    public String getRateDate() {
        return rateDate;
    }

    public void setRateDate(String rateDate) {
        this.rateDate = rateDate;
    }
}