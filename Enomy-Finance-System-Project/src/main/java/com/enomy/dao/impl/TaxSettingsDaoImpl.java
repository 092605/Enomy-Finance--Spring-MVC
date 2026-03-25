package com.enomy.dao.impl;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.enomy.dao.TaxSettingsDao;
import com.enomy.model.TaxSettings;

@Repository
public class TaxSettingsDaoImpl implements TaxSettingsDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // This maps one tax_settings row into the TaxSettings model.
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
        taxSettings.setTaxSetId(rs.getLong("tax_set_id"));

        return taxSettings;
    };

    // This finds one tax row by its individual id.
    @Override
    public TaxSettings findById(Long id) {
        String sql = "SELECT * FROM tax_settings WHERE id = ?";

        try {
            return jdbcTemplate.queryForObject(sql, taxSettingsRowMapper, id);
        } catch (Exception e) {
            return null;
        }
    }

    // This keeps backward-compatible lookup for one active tax row if needed.
    @Override
    public TaxSettings findActiveTaxSettings() {
        String sql = "SELECT * FROM tax_settings WHERE active = 1 LIMIT 1";

        try {
            return jdbcTemplate.queryForObject(sql, taxSettingsRowMapper);
        } catch (Exception e) {
            return null;
        }
    }

    // This gets all tax rows ordered by tax set and tax type for history use.
    @Override
    public List<TaxSettings> findAllTaxSettingsOrdered() {
        String sql = """
            SELECT * 
            FROM tax_settings
            ORDER BY tax_set_id DESC,
                CASE tax_type
                    WHEN 'NONE' THEN 1
                    WHEN 'FLAT' THEN 2
                    WHEN 'PROGRESSIVE' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, taxSettingsRowMapper);
    }

    // This sets all tax rows to inactive before activating a different set.
    @Override
    public void deactivateAllTaxSettings() {
        String sql = "UPDATE tax_settings SET active = 0";
        jdbcTemplate.update(sql);
    }

    // This activates one tax row by its id for backward compatibility.
    @Override
    public void activateTaxSettingsById(Long id) {
        String sql = "UPDATE tax_settings SET active = 1 WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    // This inserts one tax row and returns its generated id.
    @Override
    public Long insertTaxSettings(TaxSettings taxSettings) {
        String sql = """
            INSERT INTO tax_settings (
                tax_type,
                tax_free_allowance,
                lower_tax_rate,
                lower_tax_threshold,
                upper_tax_rate,
                upper_tax_threshold,
                active,
                created_at,
                tax_set_id
            ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?)
        """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, taxSettings.getTaxType());
            ps.setDouble(2, taxSettings.getTaxFreeAllowance());
            ps.setDouble(3, taxSettings.getLowerTaxRate());

            if (taxSettings.getLowerTaxThreshold() != null) {
                ps.setDouble(4, taxSettings.getLowerTaxThreshold());
            } else {
                ps.setNull(4, java.sql.Types.DOUBLE);
            }

            ps.setDouble(5, taxSettings.getUpperTaxRate());

            if (taxSettings.getUpperTaxThreshold() != null) {
                ps.setDouble(6, taxSettings.getUpperTaxThreshold());
            } else {
                ps.setNull(6, java.sql.Types.DOUBLE);
            }

            ps.setBoolean(7, taxSettings.isActive());
            ps.setLong(8, taxSettings.getTaxSetId());

            return ps;
        }, keyHolder);

        return keyHolder.getKey().longValue();
    }

    // This gets all 3 rows belonging to the currently active tax set.
    @Override
    public List<TaxSettings> findActiveTaxSet() {
        String sql = """
            SELECT * 
            FROM tax_settings
            WHERE tax_set_id = (
                SELECT tax_set_id
                FROM tax_settings
                WHERE active = 1
                LIMIT 1
            )
            ORDER BY
                CASE tax_type
                    WHEN 'NONE' THEN 1
                    WHEN 'FLAT' THEN 2
                    WHEN 'PROGRESSIVE' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, taxSettingsRowMapper);
    }

    // This gets all 3 rows belonging to a specific tax set version.
    @Override
    public List<TaxSettings> findByTaxSetId(Long taxSetId) {
        String sql = """
            SELECT *
            FROM tax_settings
            WHERE tax_set_id = ?
            ORDER BY
                CASE tax_type
                    WHEN 'NONE' THEN 1
                    WHEN 'FLAT' THEN 2
                    WHEN 'PROGRESSIVE' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, taxSettingsRowMapper, taxSetId);
    }

    // This gets the next tax_set_id value for a new grouped tax set.
    @Override
    public Long getNextTaxSetId() {
        String sql = "SELECT COALESCE(MAX(tax_set_id), 0) + 1 FROM tax_settings";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }

    // This activates all rows under the same tax set id.
    @Override
    public void activateTaxSettingsBySetId(Long taxSetId) {
        String sql = "UPDATE tax_settings SET active = 1 WHERE tax_set_id = ?";
        jdbcTemplate.update(sql, taxSetId);
    }
}