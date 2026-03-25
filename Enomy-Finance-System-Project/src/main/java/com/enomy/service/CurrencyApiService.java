package com.enomy.service;

import com.enomy.dto.CurrencyRateApiDTO;

public interface CurrencyApiService {

    Double getExchangeRate(String baseCurrency, String targetCurrency);

    CurrencyRateApiDTO getExchangeRateWithDate(String baseCurrency, String targetCurrency);
}