package com.enomy.dto;

public class InvestmentResponseDTO {

    private String planType;

    private YearlyInvestmentResultDTO oneYear;
    private YearlyInvestmentResultDTO fiveYears;
    private YearlyInvestmentResultDTO tenYears;

    public InvestmentResponseDTO() {
    }

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public YearlyInvestmentResultDTO getOneYear() {
        return oneYear;
    }

    public void setOneYear(YearlyInvestmentResultDTO oneYear) {
        this.oneYear = oneYear;
    }

    public YearlyInvestmentResultDTO getFiveYears() {
        return fiveYears;
    }

    public void setFiveYears(YearlyInvestmentResultDTO fiveYears) {
        this.fiveYears = fiveYears;
    }

    public YearlyInvestmentResultDTO getTenYears() {
        return tenYears;
    }

    public void setTenYears(YearlyInvestmentResultDTO tenYears) {
        this.tenYears = tenYears;
    }
}