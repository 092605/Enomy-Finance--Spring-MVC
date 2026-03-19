package com.enomy.dto;

public class PlanDetailsDTO {

    private String title;
    private String maximumInvestmentPerYear;
    private String minimumMonthlyInvestment;
    private String minimumInitialInvestmentLumpSum;
    private String predictedReturnsPerYear;
    private String estimatedTax;
    private String groupFeesPerMonth;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMaximumInvestmentPerYear() {
        return maximumInvestmentPerYear;
    }

    public void setMaximumInvestmentPerYear(String maximumInvestmentPerYear) {
        this.maximumInvestmentPerYear = maximumInvestmentPerYear;
    }

    public String getMinimumMonthlyInvestment() {
        return minimumMonthlyInvestment;
    }

    public void setMinimumMonthlyInvestment(String minimumMonthlyInvestment) {
        this.minimumMonthlyInvestment = minimumMonthlyInvestment;
    }

    public String getMinimumInitialInvestmentLumpSum() {
        return minimumInitialInvestmentLumpSum;
    }

    public void setMinimumInitialInvestmentLumpSum(String minimumInitialInvestmentLumpSum) {
        this.minimumInitialInvestmentLumpSum = minimumInitialInvestmentLumpSum;
    }

    public String getPredictedReturnsPerYear() {
        return predictedReturnsPerYear;
    }

    public void setPredictedReturnsPerYear(String predictedReturnsPerYear) {
        this.predictedReturnsPerYear = predictedReturnsPerYear;
    }

    public String getEstimatedTax() {
        return estimatedTax;
    }

    public void setEstimatedTax(String estimatedTax) {
        this.estimatedTax = estimatedTax;
    }

    public String getGroupFeesPerMonth() {
        return groupFeesPerMonth;
    }

    public void setGroupFeesPerMonth(String groupFeesPerMonth) {
        this.groupFeesPerMonth = groupFeesPerMonth;
    }
}