package com.enomy.dao.investment;

import java.util.List;

import com.enomy.dto.investment.AdminInvestmentQuoteHistoryRowDTO;
import com.enomy.model.investment.InvestmentQuote;

public interface InvestmentQuoteDao {

    void save(InvestmentQuote investmentQuote);

    int countByUserId(Long userId);

    List<InvestmentQuote> findByUserId(Long userId);

    InvestmentQuote findByIdAndUserId(Long id, Long userId);

    // =========================
    // ADMIN TRANSACTION HISTORY
    // SAFE NEW METHOD
    // =========================
    List<AdminInvestmentQuoteHistoryRowDTO> findAdminInvestmentQuoteHistory(String planType,
                                                                            String dateFrom,
                                                                            String dateTo,
                                                                            String search);
}