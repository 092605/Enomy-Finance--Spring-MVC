package com.enomy.dto;

public class InvestmentRequestDTO {

    private String planType;
    private double initialLumpSum;
    private double monthlyInvestment;

    public InvestmentRequestDTO() {
    }

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public double getInitialLumpSum() {
        return initialLumpSum;
    }

    public void setInitialLumpSum(double initialLumpSum) {
        this.initialLumpSum = initialLumpSum;
    }

    public double getMonthlyInvestment() {
        return monthlyInvestment;
    }

    public void setMonthlyInvestment(double monthlyInvestment) {
        this.monthlyInvestment = monthlyInvestment;
    }
}