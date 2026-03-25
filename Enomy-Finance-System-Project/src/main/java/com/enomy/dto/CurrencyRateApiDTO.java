package com.enomy.dto;

public class CurrencyRateApiDTO {

    private Double rate;
    private String date;

    public CurrencyRateApiDTO() {
    }

    public CurrencyRateApiDTO(Double rate, String date) {
        this.rate = rate;
        this.date = date;
    }

    public Double getRate() {
        return rate;
    }

    public void setRate(Double rate) {
        this.rate = rate;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}