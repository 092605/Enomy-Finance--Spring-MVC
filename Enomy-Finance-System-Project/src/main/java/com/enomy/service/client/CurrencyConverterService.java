package com.enomy.service.client;

import java.util.List;

import com.enomy.dto.conversion.CheckRateResponseDTO;
import com.enomy.dto.conversion.ConversionRuleSetDTO;
import com.enomy.dto.conversion.CurrencyConversionRequestDTO;
import com.enomy.dto.conversion.CurrencyConversionResponseDTO;
import com.enomy.dto.conversion.TransactionReceiptDTO;

public interface CurrencyConverterService {

    ConversionRuleSetDTO getActiveConversionRuleSet();

    CheckRateResponseDTO checkRate(String baseCurrency, String targetCurrency);

    CurrencyConversionResponseDTO calculateConversion(CurrencyConversionRequestDTO request);

    TransactionReceiptDTO confirmTransaction(CurrencyConversionRequestDTO request, Long userId);

    List<TransactionReceiptDTO> getTransactionHistory(Long userId);
}