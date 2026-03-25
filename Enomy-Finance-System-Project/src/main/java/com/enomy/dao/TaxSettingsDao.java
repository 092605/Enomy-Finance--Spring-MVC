package com.enomy.dao;

import java.util.List;

import com.enomy.model.TaxSettings;

public interface TaxSettingsDao {

    // This keeps the existing single-row lookup by tax row id.
    TaxSettings findById(Long id);

    // This gets the currently active tax row if ever needed for backward compatibility.
    TaxSettings findActiveTaxSettings();

    // This gets all tax rows ordered for history and modal use.
    List<TaxSettings> findAllTaxSettingsOrdered();

    // This deactivates all tax rows before activating a new set.
    void deactivateAllTaxSettings();

    // This activates one tax row by id if ever needed for backward compatibility.
    void activateTaxSettingsById(Long id);

    // This inserts one tax row and returns its generated id.
    Long insertTaxSettings(TaxSettings taxSettings);

    // This gets all 3 rows belonging to the currently active tax set.
    List<TaxSettings> findActiveTaxSet();

    // This gets all 3 rows belonging to one tax set version.
    List<TaxSettings> findByTaxSetId(Long taxSetId);

    // This gets the next tax_set_id value for a new grouped tax version.
    Long getNextTaxSetId();

    // This activates all rows that belong to one tax set.
    void activateTaxSettingsBySetId(Long taxSetId);
}