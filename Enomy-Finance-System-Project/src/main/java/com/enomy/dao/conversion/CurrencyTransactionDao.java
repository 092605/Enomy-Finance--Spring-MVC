package com.enomy.dao.conversion;

import java.util.List;

import com.enomy.dto.conversion.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.model.conversion.CurrencyTransaction;

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

    // =========================
    // ADMIN TRANSACTION HISTORY
    // SAFE NEW METHOD
    // =========================
    List<AdminCurrencyTransactionHistoryRowDTO> findAdminTransactionHistory(String baseCurrency,
                                                                           String targetCurrency,
                                                                           String transactionType,
                                                                           String dateFrom,
                                                                           String dateTo,
                                                                           String search);
}