package com.enomy.service;

import java.util.List;

import com.enomy.dto.CheckRateResponseDTO;
import com.enomy.dto.ConversionRuleSetDTO;
import com.enomy.dto.CurrencyConversionRequestDTO;
import com.enomy.dto.CurrencyConversionResponseDTO;
import com.enomy.dto.TransactionReceiptDTO;

public interface CurrencyConverterService {

    ConversionRuleSetDTO getActiveConversionRuleSet();

    CheckRateResponseDTO checkRate(String baseCurrency, String targetCurrency);

    CurrencyConversionResponseDTO calculateConversion(CurrencyConversionRequestDTO request);

    TransactionReceiptDTO confirmTransaction(CurrencyConversionRequestDTO request, Long userId);

    List<TransactionReceiptDTO> getTransactionHistory(Long userId);
}