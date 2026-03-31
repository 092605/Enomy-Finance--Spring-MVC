package com.enomy.service.admin;

import java.util.List;

import com.enomy.dto.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.dto.AdminInvestmentQuoteHistoryRowDTO;

public interface AdminTransactionHistoryService {

    // =========================
    // CURRENCY TRANSACTIONS
    // =========================
    List<AdminCurrencyTransactionHistoryRowDTO> getCurrencyTransactionHistory(String baseCurrency,
                                                                             String targetCurrency,
                                                                             String transactionType,
                                                                             String dateFrom,
                                                                             String dateTo,
                                                                             String search);

    // =========================
    // INVESTMENT QUOTES
    // =========================
    List<AdminInvestmentQuoteHistoryRowDTO> getInvestmentQuoteHistory(String planType,
                                                                      String dateFrom,
                                                                      String dateTo,
                                                                      String search);
}