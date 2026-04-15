package com.enomy.service.client.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.enomy.dao.conversion.ConversionFeeRuleDao;
import com.enomy.dao.conversion.ConversionRuleSetDao;
import com.enomy.dao.conversion.CurrencyTransactionDao;
import com.enomy.dto.conversion.CheckRateResponseDTO;
import com.enomy.dto.conversion.ConversionFeeRuleDTO;
import com.enomy.dto.conversion.ConversionRuleSetDTO;
import com.enomy.dto.conversion.CurrencyConversionRequestDTO;
import com.enomy.dto.conversion.CurrencyConversionResponseDTO;
import com.enomy.dto.conversion.CurrencyRateApiDTO;
import com.enomy.dto.conversion.TransactionReceiptDTO;
import com.enomy.model.conversion.ConversionFeeRule;
import com.enomy.model.conversion.ConversionRuleSet;
import com.enomy.model.conversion.CurrencyTransaction;
import com.enomy.service.client.CurrencyApiService;
import com.enomy.service.client.CurrencyConverterService;

@Service
public class CurrencyConverterServiceImpl implements CurrencyConverterService {

    @Autowired
    private ConversionRuleSetDao conversionRuleSetDao;

    @Autowired
    private ConversionFeeRuleDao conversionFeeRuleDao;

    @Autowired
    private CurrencyTransactionDao currencyTransactionDao;

    @Autowired
    private CurrencyApiService currencyApiService;

    @Override
    public ConversionRuleSetDTO getActiveConversionRuleSet() {
        ConversionRuleSet activeRuleSet = conversionRuleSetDao.findActiveRuleSet();

        if (activeRuleSet == null) {
            return null;
        }

        List<ConversionFeeRule> feeRules = conversionFeeRuleDao.findByRuleSetId(activeRuleSet.getId());
        List<ConversionFeeRuleDTO> feeRuleDTOs = new ArrayList<>();

        for (ConversionFeeRule rule : feeRules) {
            ConversionFeeRuleDTO dto = new ConversionFeeRuleDTO();
            dto.setMinAmount(rule.getMinAmount());
            dto.setMaxAmount(rule.getMaxAmount());
            dto.setFeeRate(rule.getFeeRate());
            feeRuleDTOs.add(dto);
        }

        ConversionRuleSetDTO ruleSetDTO = new ConversionRuleSetDTO();
        ruleSetDTO.setRuleName(activeRuleSet.getRuleName());
        ruleSetDTO.setDescription(activeRuleSet.getDescription());
        ruleSetDTO.setFeeRules(feeRuleDTOs);

        return ruleSetDTO;
    }

    @Override
    public CheckRateResponseDTO checkRate(String baseCurrency, String targetCurrency) {
        CheckRateResponseDTO response = new CheckRateResponseDTO();
        response.setBaseCurrency(baseCurrency);
        response.setTargetCurrency(targetCurrency);

        if (!isSupportedCurrency(baseCurrency) || !isSupportedCurrency(targetCurrency)) {
            response.setRate(0.0);
            response.setConvertedAmount(0.0);
            response.setRateDate(null);
            return response;
        }

        if (baseCurrency.equalsIgnoreCase(targetCurrency)) {
            response.setRate(1.0);
            response.setConvertedAmount(1.0);
            response.setRateDate(java.time.LocalDate.now().toString());
            return response;
        }

        CurrencyRateApiDTO apiRate = currencyApiService.getExchangeRateWithDate(baseCurrency, targetCurrency);

        if (apiRate == null || apiRate.getRate() == null) {
            response.setRate(0.0);
            response.setConvertedAmount(0.0);
            response.setRateDate(null);
            return response;
        }

        response.setRate(apiRate.getRate());
        response.setConvertedAmount(apiRate.getRate());
        response.setRateDate(apiRate.getDate());

        return response;
    }

    @Override
    public CurrencyConversionResponseDTO calculateConversion(CurrencyConversionRequestDTO request) {
        CurrencyConversionResponseDTO response = new CurrencyConversionResponseDTO();

        response.setTransactionType(request.getTransactionType());
        response.setBaseCurrency(request.getBaseCurrency());
        response.setTargetCurrency(request.getTargetCurrency());
        response.setInputAmount(request.getAmount());

        if (request.getTransactionType() == null || request.getTransactionType().isBlank()) {
            return invalidResponse(response, "Transaction type is required.");
        }

        if (request.getBaseCurrency() == null || request.getBaseCurrency().isBlank()) {
            return invalidResponse(response, "Base currency is required.");
        }

        if (request.getTargetCurrency() == null || request.getTargetCurrency().isBlank()) {
            return invalidResponse(response, "Target currency is required.");
        }

        if (!isSupportedCurrency(request.getBaseCurrency())) {
            return invalidResponse(response, "Unsupported base currency.");
        }

        if (!isSupportedCurrency(request.getTargetCurrency())) {
            return invalidResponse(response, "Unsupported target currency.");
        }

        if (request.getBaseCurrency().equalsIgnoreCase(request.getTargetCurrency())) {
            return invalidResponse(response, "Base currency and target currency cannot be the same.");
        }

        if (request.getAmount() == null || request.getAmount() <= 0) {
            return invalidResponse(response, "Amount must be greater than zero.");
        }

        ConversionRuleSet activeRuleSet = conversionRuleSetDao.findActiveRuleSet();
        if (activeRuleSet == null) {
            return invalidResponse(response, "No active conversion rule set found.");
        }

        ConversionFeeRule matchingFeeRule =
                conversionFeeRuleDao.findMatchingFeeRule(activeRuleSet.getId(), request.getAmount());

        if (matchingFeeRule == null) {
            return invalidResponse(response, "Amount is outside the allowed conversion range.");
        }

        Double rate = currencyApiService.getExchangeRate(
                request.getBaseCurrency(),
                request.getTargetCurrency()
        );

        if (rate == null) {
            return invalidResponse(response, "Unable to fetch exchange rate at the moment.");
        }

        Double inputAmount = request.getAmount();
        Double convertedAmount = inputAmount * rate;
        Double feeRate = matchingFeeRule.getFeeRate();
        Double feeValue;
        Double finalAmount;
        String finalLabel;

        if ("BUY".equalsIgnoreCase(request.getTransactionType())) {
            feeValue = inputAmount * (feeRate / 100.0);
            finalAmount = inputAmount + feeValue;
            finalLabel = "Total Payable";
        } else if ("SELL".equalsIgnoreCase(request.getTransactionType())) {
            feeValue = convertedAmount * (feeRate / 100.0);
            finalAmount = convertedAmount - feeValue;
            finalLabel = "Total Received";
        } else {
            return invalidResponse(response, "Invalid transaction type.");
        }

        response.setExchangeRateUsed(rate);
        response.setConvertedAmount(convertedAmount);
        response.setFeeRateApplied(feeRate);
        response.setFeeValue(feeValue);
        response.setFinalAmount(finalAmount);
        response.setFinalLabel(finalLabel);
        response.setRetrievedAt(new Date());
        response.setValid(true);
        response.setMessage("Calculation successful.");

        return response;
    }

    @Override
    public TransactionReceiptDTO confirmTransaction(CurrencyConversionRequestDTO request, Long userId) {

        CurrencyConversionResponseDTO calculation = calculateConversion(request);

        if (calculation == null || !calculation.isValid()) {
            return null;
        }

        ConversionRuleSet activeRuleSet = conversionRuleSetDao.findActiveRuleSet();
        if (activeRuleSet == null) {
            return null;
        }

        // 🔥 SINGLE SOURCE OF TIME (VERY IMPORTANT)
        Date now = new Date();

        // =========================
        // SAVE TRANSACTION
        // =========================
        CurrencyTransaction transaction = new CurrencyTransaction();
        transaction.setTransactionNumber(generateTransactionNumber(userId));
        transaction.setUserId(userId);
        transaction.setTransactionType(calculation.getTransactionType());
        transaction.setBaseCurrency(calculation.getBaseCurrency());
        transaction.setTargetCurrency(calculation.getTargetCurrency());
        transaction.setInputAmount(calculation.getInputAmount());
        transaction.setExchangeRateUsed(calculation.getExchangeRateUsed());
        transaction.setConvertedAmount(calculation.getConvertedAmount());
        transaction.setFeeRateApplied(calculation.getFeeRateApplied());
        transaction.setFeeValue(calculation.getFeeValue());
        transaction.setFinalAmount(calculation.getFinalAmount());
        transaction.setRuleSetId(activeRuleSet.getId());
        transaction.setStatus("SUCCESS");

        // 🔥 THIS FIXES YOUR DATE ISSUE
        transaction.setCreatedAt(now);

        currencyTransactionDao.save(transaction);

        // =========================
        // BUILD RECEIPT (USE SAME TIME)
        // =========================
        TransactionReceiptDTO receipt = new TransactionReceiptDTO();
        receipt.setTransactionNumber(transaction.getTransactionNumber());
        receipt.setTransactionType(transaction.getTransactionType());

        // 🔥 SAME TIMESTAMP AS DATABASE
        receipt.setDate(now);

        receipt.setBaseCurrency(transaction.getBaseCurrency());
        receipt.setTargetCurrency(transaction.getTargetCurrency());
        receipt.setInputAmount(transaction.getInputAmount());
        receipt.setExchangeRateUsed(transaction.getExchangeRateUsed());
        receipt.setConvertedAmount(transaction.getConvertedAmount());
        receipt.setFeeRateApplied(transaction.getFeeRateApplied());
        receipt.setFeeValue(transaction.getFeeValue());
        receipt.setFinalAmount(transaction.getFinalAmount());

        // =========================
        // LABEL LOGIC
        // =========================
        if ("BUY".equalsIgnoreCase(transaction.getTransactionType())) {
            receipt.setLabel("Paid Amount");
        } else {
            receipt.setLabel("Received Amount");
        }

        receipt.setMessage("Transaction successful. Receipt has been saved.");

        return receipt;
    }
    @Override
    public List<TransactionReceiptDTO> getTransactionHistory(Long userId) {
        List<CurrencyTransaction> transactions = currencyTransactionDao.findByUserId(userId);
        List<TransactionReceiptDTO> history = new ArrayList<>();

        for (CurrencyTransaction transaction : transactions) {
            TransactionReceiptDTO receipt = new TransactionReceiptDTO();
            receipt.setTransactionNumber(transaction.getTransactionNumber());
            receipt.setTransactionType(transaction.getTransactionType());
            receipt.setDate(transaction.getCreatedAt());
            receipt.setBaseCurrency(transaction.getBaseCurrency());
            receipt.setTargetCurrency(transaction.getTargetCurrency());
            receipt.setInputAmount(transaction.getInputAmount());
            receipt.setExchangeRateUsed(transaction.getExchangeRateUsed());
            receipt.setConvertedAmount(transaction.getConvertedAmount());
            receipt.setFeeRateApplied(transaction.getFeeRateApplied());
            receipt.setFeeValue(transaction.getFeeValue());
            receipt.setFinalAmount(transaction.getFinalAmount());

            if ("BUY".equalsIgnoreCase(transaction.getTransactionType())) {
                receipt.setLabel("Paid Amount");
            } else {
                receipt.setLabel("Received Amount");
            }

            receipt.setMessage(transaction.getStatus());
            history.add(receipt);
        }

        return history;
    }

    private CurrencyConversionResponseDTO invalidResponse(CurrencyConversionResponseDTO response, String message) {
        response.setExchangeRateUsed(0.0);
        response.setConvertedAmount(0.0);
        response.setFeeRateApplied(0.0);
        response.setFeeValue(0.0);
        response.setFinalAmount(0.0);
        response.setFinalLabel("");
        response.setValid(false);
        response.setMessage(message);
        return response;
    }

    private boolean isSupportedCurrency(String currency) {
        return currency != null && (
                currency.equalsIgnoreCase("GBP") ||
                currency.equalsIgnoreCase("USD") ||
                currency.equalsIgnoreCase("EUR") ||
                currency.equalsIgnoreCase("BRL") ||
                currency.equalsIgnoreCase("JPY") ||
                currency.equalsIgnoreCase("TRY")
        );
    }

    private String generateTransactionNumber(Long userId) {
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        return "CC-" + userId + "-" + timestamp;
    }
}