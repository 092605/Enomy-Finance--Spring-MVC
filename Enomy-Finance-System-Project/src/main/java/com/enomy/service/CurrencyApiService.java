package com.enomy.service;

public interface CurrencyApiService {

    Double getExchangeRate(String baseCurrency, String targetCurrency);
}