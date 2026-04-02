package com.enomy.service.client;

import java.util.List;

import com.enomy.dto.investment.InvestmentRequestDTO;
import com.enomy.dto.investment.InvestmentResponseDTO;
import com.enomy.dto.investment.PlanDetailsDTO;
import com.enomy.model.investment.InvestmentQuote;

import java.util.Map;

public interface InvestmentService {

    InvestmentResponseDTO calculateProjection(InvestmentRequestDTO request);

    void saveQuote(Long userId, InvestmentRequestDTO request);

    int countSavedQuotes(Long userId);

    List<InvestmentQuote> getSavedQuotes(Long userId);

    InvestmentResponseDTO getSavedQuoteDetails(Long quoteId, Long userId);
    
    PlanDetailsDTO getActivePlanDetails(String planType);

    Map<String, PlanDetailsDTO> getAllActivePlanDetails();
}