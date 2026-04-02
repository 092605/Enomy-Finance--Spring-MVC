package com.enomy.service.client;

import java.time.LocalDate;

import com.enomy.dto.conversion.CurrencyRateApiDTO;

public interface CurrencyApiService {

    Double getExchangeRate(String baseCurrency, String targetCurrency);

    CurrencyRateApiDTO getExchangeRateWithDate(String baseCurrency, String targetCurrency);

    Double getHistoricalExchangeRate(String baseCurrency, String targetCurrency, LocalDate date);

    CurrencyRateApiDTO getHistoricalExchangeRateWithDate(String baseCurrency, String targetCurrency, LocalDate date);


}