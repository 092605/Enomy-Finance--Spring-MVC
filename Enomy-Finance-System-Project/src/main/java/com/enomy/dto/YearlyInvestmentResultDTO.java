package com.enomy.dto;

public class YearlyInvestmentResultDTO {

    private int years;

    private double initialLumpSum;
    private double monthlyInvestment;
    private double totalInvested;

    private double minReturn;
    private double maxReturn;

    private double minProfit;
    private double maxProfit;

    private double minTax;
    private double maxTax;

    private double monthlyFee;
    private double totalFee;

    public YearlyInvestmentResultDTO() {
    }

    public int getYears() {
        return years;
    }

    public void setYears(int years) {
        this.years = years;
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

    public double getTotalInvested() {
        return totalInvested;
    }

    public void setTotalInvested(double totalInvested) {
        this.totalInvested = totalInvested;
    }

    public double getMinReturn() {
        return minReturn;
    }

    public void setMinReturn(double minReturn) {
        this.minReturn = minReturn;
    }

    public double getMaxReturn() {
        return maxReturn;
    }

    public void setMaxReturn(double maxReturn) {
        this.maxReturn = maxReturn;
    }

    public double getMinProfit() {
        return minProfit;
    }

    public void setMinProfit(double minProfit) {
        this.minProfit = minProfit;
    }

    public double getMaxProfit() {
        return maxProfit;
    }

    public void setMaxProfit(double maxProfit) {
        this.maxProfit = maxProfit;
    }

    public double getMinTax() {
        return minTax;
    }

    public void setMinTax(double minTax) {
        this.minTax = minTax;
    }

    public double getMaxTax() {
        return maxTax;
    }

    public void setMaxTax(double maxTax) {
        this.maxTax = maxTax;
    }

    public double getMonthlyFee() {
        return monthlyFee;
    }

    public void setMonthlyFee(double monthlyFee) {
        this.monthlyFee = monthlyFee;
    }

    public double getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(double totalFee) {
        this.totalFee = totalFee;
    }
}