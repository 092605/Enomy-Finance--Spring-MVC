package com.enomy.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.enomy.dao.InvestmentQuoteDao;
import com.enomy.dao.PlanRulesDao;
import com.enomy.dto.InvestmentRequestDTO;
import com.enomy.dto.InvestmentResponseDTO;
import com.enomy.dto.YearlyInvestmentResultDTO;
import com.enomy.model.InvestmentQuote;
import com.enomy.model.PlanRules;
import com.enomy.model.TaxSettings;
import com.enomy.service.InvestmentService;

@Service
public class InvestmentServiceImpl implements InvestmentService {

    @Autowired
    private PlanRulesDao planRulesDao;

    @Autowired
    private InvestmentQuoteDao investmentQuoteDao;

    @Override
    public InvestmentResponseDTO calculateProjection(InvestmentRequestDTO request) {
        validateRequest(request);

        PlanRules planRules = planRulesDao.findActiveByPlanType(request.getPlanType());
        if (planRules == null) {
            throw new IllegalArgumentException("No active plan rules found for selected plan.");
        }

        validateAgainstPlanRules(request, planRules);

        InvestmentResponseDTO response = new InvestmentResponseDTO();
        response.setPlanType(request.getPlanType());
        response.setOneYear(calculateForYears(request, planRules, 1));
        response.setFiveYears(calculateForYears(request, planRules, 5));
        response.setTenYears(calculateForYears(request, planRules, 10));

        return response;
    }

    @Override
    public void saveQuote(Long userId, InvestmentRequestDTO request) {
        validateRequest(request);

        PlanRules planRules = planRulesDao.findActiveByPlanType(request.getPlanType());
        if (planRules == null) {
            throw new IllegalArgumentException("No active plan rules found for selected plan.");
        }

        validateAgainstPlanRules(request, planRules);

        InvestmentQuote quote = new InvestmentQuote();
        quote.setUserId(userId);
        quote.setPlanType(request.getPlanType());
        quote.setInitialLumpSum(round(request.getInitialLumpSum()));
        quote.setMonthlyInvestment(round(request.getMonthlyInvestment()));
        quote.setPlanRulesId(planRules.getId());

        investmentQuoteDao.save(quote);
    }

    @Override
    public int countSavedQuotes(Long userId) {
        return investmentQuoteDao.countByUserId(userId);
    }

    @Override
    public List<InvestmentQuote> getSavedQuotes(Long userId) {
        return investmentQuoteDao.findByUserId(userId);
    }

    @Override
    public InvestmentResponseDTO getSavedQuoteDetails(Long quoteId, Long userId) {
        InvestmentQuote quote = investmentQuoteDao.findByIdAndUserId(quoteId, userId);
        if (quote == null) {
            throw new IllegalArgumentException("Saved quote not found.");
        }

        PlanRules planRules = planRulesDao.findById(quote.getPlanRulesId());
        if (planRules == null) {
            throw new IllegalArgumentException("Plan rules linked to quote were not found.");
        }

        InvestmentRequestDTO request = new InvestmentRequestDTO();
        request.setPlanType(quote.getPlanType());
        request.setInitialLumpSum(quote.getInitialLumpSum());
        request.setMonthlyInvestment(quote.getMonthlyInvestment());

        InvestmentResponseDTO response = new InvestmentResponseDTO();
        response.setPlanType(request.getPlanType());
        response.setOneYear(calculateForYears(request, planRules, 1));
        response.setFiveYears(calculateForYears(request, planRules, 5));
        response.setTenYears(calculateForYears(request, planRules, 10));

        return response;
    }

    private void validateRequest(InvestmentRequestDTO request) {
        if (request == null) {
            throw new IllegalArgumentException("Request cannot be null.");
        }

        if (request.getPlanType() == null || request.getPlanType().trim().isEmpty()) {
            throw new IllegalArgumentException("Plan type is required.");
        }

        if (request.getInitialLumpSum() < 0) {
            throw new IllegalArgumentException("Initial lump sum cannot be negative.");
        }

        if (request.getMonthlyInvestment() < 0) {
            throw new IllegalArgumentException("Monthly investment cannot be negative.");
        }
    }

    private void validateAgainstPlanRules(InvestmentRequestDTO request, PlanRules planRules) {
        if (request.getMonthlyInvestment() < planRules.getMinMonthlyRequired()) {
            throw new IllegalArgumentException(
                "Minimum monthly investment is £" + round(planRules.getMinMonthlyRequired()) + "."
            );
        }

        if (request.getInitialLumpSum() < planRules.getMinInitialRequired()) {
            throw new IllegalArgumentException(
                "Minimum initial lump sum is £" + round(planRules.getMinInitialRequired()) + "."
            );
        }

        Double yearlyLimit = planRules.getYearlyInvestmentLimit();
        if (yearlyLimit != null) {
            double yearlyInvestment = request.getInitialLumpSum() + (request.getMonthlyInvestment() * 12);
            if (yearlyInvestment > yearlyLimit) {
                throw new IllegalArgumentException(
                    "Maximum yearly investment of £" + round(yearlyLimit) + " exceeded."
                );
            }
        }
    }

    private YearlyInvestmentResultDTO calculateForYears(
        InvestmentRequestDTO request,
        PlanRules planRules,
        int years
    ) {
        double initial = request.getInitialLumpSum();
        double monthly = request.getMonthlyInvestment();

        double totalInvested = initial + (monthly * 12 * years);

        double monthlyFee = monthly * planRules.getMonthlyFeeRate();
        double totalFee = monthlyFee * (years * 12);

        double minReturn = totalInvested * Math.pow(1 + planRules.getMinReturnRate(), years);
        double maxReturn = totalInvested * Math.pow(1 + planRules.getMaxReturnRate(), years);

        double minProfit = minReturn - totalInvested - totalFee;
        double maxProfit = maxReturn - totalInvested - totalFee;

        TaxSettings taxSettings = planRules.getTaxSettings();
        double minTax = calculateTax(minProfit, taxSettings);
        double maxTax = calculateTax(maxProfit, taxSettings);

        YearlyInvestmentResultDTO result = new YearlyInvestmentResultDTO();
        result.setYears(years);
        result.setInitialLumpSum(round(initial));
        result.setMonthlyInvestment(round(monthly));
        result.setTotalInvested(round(totalInvested));
        result.setMonthlyFee(round(monthlyFee));
        result.setTotalFee(round(totalFee));
        result.setMinReturn(round(minReturn));
        result.setMaxReturn(round(maxReturn));
        result.setMinProfit(round(minProfit));
        result.setMaxProfit(round(maxProfit));
        result.setMinTax(round(minTax));
        result.setMaxTax(round(maxTax));

        return result;
    }

    private double calculateTax(double profit, TaxSettings taxSettings) {
        if (taxSettings == null || profit <= 0) {
            return 0.0;
        }

        String taxType = taxSettings.getTaxType();
        double allowance = taxSettings.getTaxFreeAllowance();

        if ("NONE".equalsIgnoreCase(taxType)) {
            return 0.0;
        }

        if (profit <= allowance) {
            return 0.0;
        }

        if ("FLAT".equalsIgnoreCase(taxType)) {
            return (profit - allowance) * taxSettings.getLowerTaxRate();
        }

        if ("PROGRESSIVE".equalsIgnoreCase(taxType)) {
            Double upperThreshold = taxSettings.getUpperTaxThreshold();

            if (upperThreshold == null || profit <= upperThreshold) {
                return (profit - allowance) * taxSettings.getLowerTaxRate();
            }

            double lowerBracketTax = (upperThreshold - allowance) * taxSettings.getLowerTaxRate();
            double upperBracketTax = (profit - upperThreshold) * taxSettings.getUpperTaxRate();

            return lowerBracketTax + upperBracketTax;
        }

        return 0.0;
    }

    private double round(double value) {
        return BigDecimal.valueOf(value)
                .setScale(2, RoundingMode.HALF_UP)
                .doubleValue();
    }
}