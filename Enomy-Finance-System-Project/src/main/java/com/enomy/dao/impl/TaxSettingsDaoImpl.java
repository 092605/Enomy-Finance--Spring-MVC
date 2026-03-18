package com.enomy.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.enomy.dao.TaxSettingsDao;
import com.enomy.model.TaxSettings;

@Repository
public class TaxSettingsDaoImpl implements TaxSettingsDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<TaxSettings> taxSettingsRowMapper = (rs, rowNum) -> {
        TaxSettings taxSettings = new TaxSettings();
        taxSettings.setId(rs.getLong("id"));
        taxSettings.setTaxType(rs.getString("tax_type"));
        taxSettings.setTaxFreeAllowance(rs.getDouble("tax_free_allowance"));
        taxSettings.setLowerTaxRate(rs.getDouble("lower_tax_rate"));

        Object lowerThreshold = rs.getObject("lower_tax_threshold");
        taxSettings.setLowerTaxThreshold(lowerThreshold != null ? rs.getDouble("lower_tax_threshold") : null);

        taxSettings.setUpperTaxRate(rs.getDouble("upper_tax_rate"));

        Object upperThreshold = rs.getObject("upper_tax_threshold");
        taxSettings.setUpperTaxThreshold(upperThreshold != null ? rs.getDouble("upper_tax_threshold") : null);

        taxSettings.setActive(rs.getBoolean("active"));
        taxSettings.setCreatedAt(rs.getTimestamp("created_at"));
        return taxSettings;
    };

    @Override
    public TaxSettings findById(Long id) {
        String sql = "SELECT * FROM tax_settings WHERE id = ?";

        try {
            return jdbcTemplate.queryForObject(sql, taxSettingsRowMapper, id);
        } catch (Exception e) {
            return null;
        }
    }
}