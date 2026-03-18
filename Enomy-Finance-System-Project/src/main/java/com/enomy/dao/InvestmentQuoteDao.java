package com.enomy.dao;

import java.util.List;

import com.enomy.model.InvestmentQuote;

public interface InvestmentQuoteDao {

    void save(InvestmentQuote investmentQuote);

    int countByUserId(Long userId);

    List<InvestmentQuote> findByUserId(Long userId);

    InvestmentQuote findByIdAndUserId(Long id, Long userId);
}