package com.enomy.model;

import java.util.Date;

public class ConversionRuleSet {

    private Long id; // FIXED
    private String ruleName;
    private String description;
    private Boolean active;
    private Date createdAt;
    private Date updatedAt;

    public ConversionRuleSet() {
    }

    public ConversionRuleSet(Long id, String ruleName, String description, Boolean active, Date createdAt, Date updatedAt) {
        this.id = id;
        this.ruleName = ruleName;
        this.description = description;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() {   // FIXED
        return id;
    }

    public void setId(Long id) {   // FIXED
        this.id = id;
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

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}