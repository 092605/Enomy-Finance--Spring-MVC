package com.enomy.service.admin.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.enomy.dao.conversion.CurrencyTransactionDao;
import com.enomy.dao.investment.InvestmentQuoteDao;
import com.enomy.dto.conversion.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.dto.investment.AdminInvestmentQuoteHistoryRowDTO;
import com.enomy.service.admin.AdminTransactionHistoryService;

@Service
@Transactional(readOnly = true)
public class AdminTransactionHistoryServiceImpl implements AdminTransactionHistoryService {

    private final CurrencyTransactionDao currencyTransactionDao;
    private final InvestmentQuoteDao investmentQuoteDao;

    public AdminTransactionHistoryServiceImpl(CurrencyTransactionDao currencyTransactionDao,
                                              InvestmentQuoteDao investmentQuoteDao) {
        this.currencyTransactionDao = currencyTransactionDao;
        this.investmentQuoteDao = investmentQuoteDao;
    }

    // =========================
    // CURRENCY TRANSACTIONS
    // =========================
    @Override
    public List<AdminCurrencyTransactionHistoryRowDTO> getCurrencyTransactionHistory(String baseCurrency,
                                                                                     String targetCurrency,
                                                                                     String transactionType,
                                                                                     String dateFrom,
                                                                                     String dateTo,
                                                                                     String search) {

        return currencyTransactionDao.findAdminTransactionHistory(
                normalizeBlank(baseCurrency),
                normalizeBlank(targetCurrency),
                normalizeBlank(transactionType),
                normalizeBlank(dateFrom),
                normalizeBlank(dateTo),
                normalizeBlank(search)
        );
    }

    // =========================
    // INVESTMENT QUOTES
    // =========================
    @Override
    public List<AdminInvestmentQuoteHistoryRowDTO> getInvestmentQuoteHistory(String planType,
                                                                             String dateFrom,
                                                                             String dateTo,
                                                                             String search) {

        return investmentQuoteDao.findAdminInvestmentQuoteHistory(
                normalizeBlank(planType),
                normalizeBlank(dateFrom),
                normalizeBlank(dateTo),
                normalizeBlank(search)
        );
    }

    // =========================
    // HELPERS
    // =========================
    private String normalizeBlank(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}