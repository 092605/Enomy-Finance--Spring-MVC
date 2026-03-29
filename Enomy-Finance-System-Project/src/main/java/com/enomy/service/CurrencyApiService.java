package com.enomy.service;

import java.time.LocalDate;

import com.enomy.dto.CurrencyRateApiDTO;

public interface CurrencyApiService {

    Double getExchangeRate(String baseCurrency, String targetCurrency);

    CurrencyRateApiDTO getExchangeRateWithDate(String baseCurrency, String targetCurrency);

    Double getHistoricalExchangeRate(String baseCurrency, String targetCurrency, LocalDate date);

    CurrencyRateApiDTO getHistoricalExchangeRateWithDate(String baseCurrency, String targetCurrency, LocalDate date);


}