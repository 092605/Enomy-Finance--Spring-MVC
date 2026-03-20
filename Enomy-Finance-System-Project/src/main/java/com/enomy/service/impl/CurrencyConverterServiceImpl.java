package com.enomy.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.enomy.dao.ConversionFeeRuleDao;
import com.enomy.dao.ConversionRuleSetDao;
import com.enomy.dao.CurrencyTransactionDao;
import com.enomy.dto.CheckRateResponseDTO;
import com.enomy.dto.ConversionFeeRuleDTO;
import com.enomy.dto.ConversionRuleSetDTO;
import com.enomy.dto.CurrencyConversionRequestDTO;
import com.enomy.dto.CurrencyConversionResponseDTO;
import com.enomy.dto.TransactionReceiptDTO;
import com.enomy.model.ConversionFeeRule;
import com.enomy.model.ConversionRuleSet;
import com.enomy.model.CurrencyTransaction;
import com.enomy.service.CurrencyApiService;
import com.enomy.service.CurrencyConverterService;

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
            return response;
        }

        if (baseCurrency.equalsIgnoreCase(targetCurrency)) {
            response.setRate(1.0);
            response.setConvertedAmount(1.0);
            return response;
        }

        Double rate = currencyApiService.getExchangeRate(baseCurrency, targetCurrency);

        if (rate == null) {
            response.setRate(0.0);
            response.setConvertedAmount(0.0);
            return response;
        }

        response.setRate(rate);
        response.setConvertedAmount(rate); // check rate always based on amount = 1

        return response;
    }

    @Override
    public CurrencyConversionResponseDTO calculateConversion(CurrencyConversionRequestDTO request) {
        CurrencyConversionResponseDTO response = new CurrencyConversionResponseDTO();

        response.setTransactionType(request.getTransactionType());
        response.setBaseCurrency(request.getBaseCurrency());
        response.setTargetCurrency(request.getTargetCurrency());
        response.setInputAmount(request.getAmount());

        // 1. Basic validation
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

        // 2. Get active rule set
        ConversionRuleSet activeRuleSet = conversionRuleSetDao.findActiveRuleSet();
        if (activeRuleSet == null) {
            return invalidResponse(response, "No active conversion rule set found.");
        }

        // 3. Find matching fee bracket
        ConversionFeeRule matchingFeeRule =
                conversionFeeRuleDao.findMatchingFeeRule(activeRuleSet.getId(), request.getAmount());

        if (matchingFeeRule == null) {
            return invalidResponse(response, "Amount is outside the allowed conversion range.");
        }

        // 4. Get live exchange rate from API
        Double rate = currencyApiService.getExchangeRate(
                request.getBaseCurrency(),
                request.getTargetCurrency()
        );

        if (rate == null) {
            return invalidResponse(response, "Unable to fetch exchange rate at the moment.");
        }

        // 5. Perform calculation
        Double convertedAmount = request.getAmount() * rate;
        Double feeValue = convertedAmount * (matchingFeeRule.getFeeRate() / 100.0);
        Double finalAmount = convertedAmount - feeValue;

        // 6. Fill response
        response.setExchangeRateUsed(rate);
        response.setConvertedAmount(convertedAmount);
        response.setFeeRateApplied(matchingFeeRule.getFeeRate());
        response.setFeeValue(feeValue);
        response.setFinalAmount(finalAmount);

        if ("BUY".equalsIgnoreCase(request.getTransactionType())) {
            response.setFinalLabel("Final Payable");
        } else {
            response.setFinalLabel("Final Received");
        }

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

        currencyTransactionDao.save(transaction);

        TransactionReceiptDTO receipt = new TransactionReceiptDTO();
        receipt.setTransactionNumber(transaction.getTransactionNumber());
        receipt.setTransactionType(transaction.getTransactionType());
        receipt.setDate(new Date());
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