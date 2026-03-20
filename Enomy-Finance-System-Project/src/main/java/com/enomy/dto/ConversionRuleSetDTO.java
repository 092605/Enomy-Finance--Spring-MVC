package com.enomy.dto;

import java.util.List;

public class ConversionRuleSetDTO {

    private String ruleName;
    private String description;
    private List<ConversionFeeRuleDTO> feeRules;

    public ConversionRuleSetDTO() {
    }

    public ConversionRuleSetDTO(String ruleName, String description, List<ConversionFeeRuleDTO> feeRules) {
        this.ruleName = ruleName;
        this.description = description;
        this.feeRules = feeRules;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<ConversionFeeRuleDTO> getFeeRules() {
        return feeRules;
    }

    public void setFeeRules(List<ConversionFeeRuleDTO> feeRules) {
        this.feeRules = feeRules;
    }
}