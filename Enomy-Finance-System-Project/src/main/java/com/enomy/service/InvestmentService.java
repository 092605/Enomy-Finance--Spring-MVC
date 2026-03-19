package com.enomy.service;

import java.util.List;

import com.enomy.dto.InvestmentRequestDTO;
import com.enomy.dto.InvestmentResponseDTO;
import com.enomy.model.InvestmentQuote;
import java.util.Map;
import com.enomy.dto.PlanDetailsDTO;

public interface InvestmentService {

    InvestmentResponseDTO calculateProjection(InvestmentRequestDTO request);

    void saveQuote(Long userId, InvestmentRequestDTO request);

    int countSavedQuotes(Long userId);

    List<InvestmentQuote> getSavedQuotes(Long userId);

    InvestmentResponseDTO getSavedQuoteDetails(Long quoteId, Long userId);
    
    PlanDetailsDTO getActivePlanDetails(String planType);

    Map<String, PlanDetailsDTO> getAllActivePlanDetails();
}