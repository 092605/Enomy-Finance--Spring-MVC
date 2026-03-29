package com.enomy.dao;

import java.util.List;

import com.enomy.model.CurrencyTransaction;

public interface CurrencyTransactionDao {

    void save(CurrencyTransaction transaction);

    List<CurrencyTransaction> findByUserId(Long userId);

    CurrencyTransaction findByTransactionNumberAndUserId(String transactionNumber, Long userId);

    int countByUserId(Long userId);

    List<CurrencyTransaction> findFilteredTransactions(String baseCurrency,
                                                      String targetCurrency,
                                                      String dateFrom,
                                                      String dateTo,
                                                      String search);
}