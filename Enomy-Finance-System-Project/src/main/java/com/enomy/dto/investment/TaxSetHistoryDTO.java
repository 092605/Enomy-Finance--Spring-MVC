package com.enomy.dto.investment;

import java.util.Date;
import com.enomy.model.investment.TaxSettings;

public class TaxSetHistoryDTO {

    private Long taxSetId;
    private Date createdAt;
    private boolean active;

    private TaxSettings noneTax;
    private TaxSettings flatTax;
    private TaxSettings progressiveTax;

    // =========================
    // GETTERS & SETTERS
    // =========================

    public Long getTaxSetId() {
        return taxSetId;
    }

    public void setTaxSetId(Long taxSetId) {
        this.taxSetId = taxSetId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public TaxSettings getNoneTax() {
        return noneTax;
    }

    public void setNoneTax(TaxSettings noneTax) {
        this.noneTax = noneTax;
    }

    public TaxSettings getFlatTax() {
        return flatTax;
    }

    public void setFlatTax(TaxSettings flatTax) {
        this.flatTax = flatTax;
    }

    public TaxSettings getProgressiveTax() {
        return progressiveTax;
    }

    public void setProgressiveTax(TaxSettings progressiveTax) {
        this.progressiveTax = progressiveTax;
    }
}