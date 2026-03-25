package com.enomy.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.PlanRulesDao;
import com.enomy.model.PlanRules;
import com.enomy.model.TaxSettings;

@Repository
public class PlanRulesDaoImpl implements PlanRulesDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public PlanRules findActiveByPlanType(String planType) {
        String sql = """
            SELECT 
                pr.id AS pr_id,
                pr.plan_set_id,
                pr.plan_type,
                pr.min_return_rate,
                pr.max_return_rate,
                pr.monthly_fee_rate,
                pr.yearly_investment_limit,
                pr.min_monthly_required,
                pr.min_initial_required,
                pr.tax_settings_id,
                pr.active AS pr_active,
                pr.created_at AS pr_created_at,

                ts.id AS ts_id,
                ts.tax_type,
                ts.tax_free_allowance,
                ts.lower_tax_rate,
                ts.lower_tax_threshold,
                ts.upper_tax_rate,
                ts.upper_tax_threshold,
                ts.active AS ts_active,
                ts.created_at AS ts_created_at

            FROM plan_rules pr
            JOIN tax_settings ts ON pr.tax_settings_id = ts.id
            WHERE pr.plan_type = ? AND pr.active = 1
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> mapPlanRules(rs), planType);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public PlanRules findById(Long id) {
        String sql = """
            SELECT 
                pr.id AS pr_id,
                pr.plan_set_id,
                pr.plan_type,
                pr.min_return_rate,
                pr.max_return_rate,
                pr.monthly_fee_rate,
                pr.yearly_investment_limit,
                pr.min_monthly_required,
                pr.min_initial_required,
                pr.tax_settings_id,
                pr.active AS pr_active,
                pr.created_at AS pr_created_at,

                ts.id AS ts_id,
                ts.tax_type,
                ts.tax_free_allowance,
                ts.lower_tax_rate,
                ts.lower_tax_threshold,
                ts.upper_tax_rate,
                ts.upper_tax_threshold,
                ts.active AS ts_active,
                ts.created_at AS ts_created_at

            FROM plan_rules pr
            JOIN tax_settings ts ON pr.tax_settings_id = ts.id
            WHERE pr.id = ?
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> mapPlanRules(rs), id);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public List<PlanRules> findActivePlanSet() {
        String sql = """
            SELECT 
                pr.id AS pr_id,
                pr.plan_set_id,
                pr.plan_type,
                pr.min_return_rate,
                pr.max_return_rate,
                pr.monthly_fee_rate,
                pr.yearly_investment_limit,
                pr.min_monthly_required,
                pr.min_initial_required,
                pr.tax_settings_id,
                pr.active AS pr_active,
                pr.created_at AS pr_created_at,

                ts.id AS ts_id,
                ts.tax_type,
                ts.tax_free_allowance,
                ts.lower_tax_rate,
                ts.lower_tax_threshold,
                ts.upper_tax_rate,
                ts.upper_tax_threshold,
                ts.active AS ts_active,
                ts.created_at AS ts_created_at

            FROM plan_rules pr
            JOIN tax_settings ts ON pr.tax_settings_id = ts.id
            WHERE pr.active = 1
            ORDER BY 
                CASE pr.plan_type
                    WHEN 'BASIC' THEN 1
                    WHEN 'PLUS' THEN 2
                    WHEN 'MANAGED' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> mapPlanRules(rs));
    }

    @Override
    public List<PlanRules> findAllPlanRulesOrdered() {
        String sql = """
            SELECT 
                pr.id AS pr_id,
                pr.plan_set_id,
                pr.plan_type,
                pr.min_return_rate,
                pr.max_return_rate,
                pr.monthly_fee_rate,
                pr.yearly_investment_limit,
                pr.min_monthly_required,
                pr.min_initial_required,
                pr.tax_settings_id,
                pr.active AS pr_active,
                pr.created_at AS pr_created_at,

                ts.id AS ts_id,
                ts.tax_type,
                ts.tax_free_allowance,
                ts.lower_tax_rate,
                ts.lower_tax_threshold,
                ts.upper_tax_rate,
                ts.upper_tax_threshold,
                ts.active AS ts_active,
                ts.created_at AS ts_created_at

            FROM plan_rules pr
            JOIN tax_settings ts ON pr.tax_settings_id = ts.id
            ORDER BY pr.plan_set_id DESC,
                CASE pr.plan_type
                    WHEN 'BASIC' THEN 1
                    WHEN 'PLUS' THEN 2
                    WHEN 'MANAGED' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> mapPlanRules(rs));
    }

    @Override
    public Long getNextPlanSetId() {
        String sql = "SELECT COALESCE(MAX(plan_set_id), 0) + 1 FROM plan_rules";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }

    @Override
    public void deactivateAllPlanRules() {
        String sql = "UPDATE plan_rules SET active = 0";
        jdbcTemplate.update(sql);
    }

    @Override
    public void insertPlanRule(PlanRules planRules) {
        String sql = """
            INSERT INTO plan_rules (
                plan_set_id,
                plan_type,
                min_return_rate,
                max_return_rate,
                monthly_fee_rate,
                yearly_investment_limit,
                min_monthly_required,
                min_initial_required,
                tax_settings_id,
                active,
                created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        """;

        jdbcTemplate.update(sql,
            planRules.getPlanSetId(),
            planRules.getPlanType(),
            planRules.getMinReturnRate(),
            planRules.getMaxReturnRate(),
            planRules.getMonthlyFeeRate(),
            planRules.getYearlyInvestmentLimit(),
            planRules.getMinMonthlyRequired(),
            planRules.getMinInitialRequired(),
            planRules.getTaxSettingsId(),
            planRules.isActive()
        );
    }

    private PlanRules mapPlanRules(ResultSet rs) throws SQLException {
        PlanRules planRules = new PlanRules();
        planRules.setId(rs.getLong("pr_id"));
        planRules.setPlanSetId(rs.getLong("plan_set_id"));
        planRules.setPlanType(rs.getString("plan_type"));
        planRules.setMinReturnRate(rs.getDouble("min_return_rate"));
        planRules.setMaxReturnRate(rs.getDouble("max_return_rate"));
        planRules.setMonthlyFeeRate(rs.getDouble("monthly_fee_rate"));

        Object yearlyLimit = rs.getObject("yearly_investment_limit");
        planRules.setYearlyInvestmentLimit(yearlyLimit != null ? rs.getDouble("yearly_investment_limit") : null);

        planRules.setMinMonthlyRequired(rs.getDouble("min_monthly_required"));
        planRules.setMinInitialRequired(rs.getDouble("min_initial_required"));
        planRules.setTaxSettingsId(rs.getLong("tax_settings_id"));
        planRules.setActive(rs.getBoolean("pr_active"));
        planRules.setCreatedAt(rs.getTimestamp("pr_created_at"));

        TaxSettings taxSettings = new TaxSettings();
        taxSettings.setId(rs.getLong("ts_id"));
        taxSettings.setTaxType(rs.getString("tax_type"));
        taxSettings.setTaxFreeAllowance(rs.getDouble("tax_free_allowance"));
        taxSettings.setLowerTaxRate(rs.getDouble("lower_tax_rate"));

        Object lowerThreshold = rs.getObject("lower_tax_threshold");
        taxSettings.setLowerTaxThreshold(lowerThreshold != null ? rs.getDouble("lower_tax_threshold") : null);

        taxSettings.setUpperTaxRate(rs.getDouble("upper_tax_rate"));

        Object upperThreshold = rs.getObject("upper_tax_threshold");
        taxSettings.setUpperTaxThreshold(upperThreshold != null ? rs.getDouble("upper_tax_threshold") : null);

        taxSettings.setActive(rs.getBoolean("ts_active"));
        taxSettings.setCreatedAt(rs.getTimestamp("ts_created_at"));

        planRules.setTaxSettings(taxSettings);

        return planRules;
    }
    
    
    @Override
    public List<PlanRules> findByPlanSetId(Long planSetId) {
        String sql = """
            SELECT 
                pr.id AS pr_id,
                pr.plan_set_id,
                pr.plan_type,
                pr.min_return_rate,
                pr.max_return_rate,
                pr.monthly_fee_rate,
                pr.yearly_investment_limit,
                pr.min_monthly_required,
                pr.min_initial_required,
                pr.tax_settings_id,
                pr.active AS pr_active,
                pr.created_at AS pr_created_at,

                ts.id AS ts_id,
                ts.tax_type,
                ts.tax_free_allowance,
                ts.lower_tax_rate,
                ts.lower_tax_threshold,
                ts.upper_tax_rate,
                ts.upper_tax_threshold,
                ts.active AS ts_active,
                ts.created_at AS ts_created_at

            FROM plan_rules pr
            JOIN tax_settings ts ON pr.tax_settings_id = ts.id
            WHERE pr.plan_set_id = ?
            ORDER BY 
                CASE pr.plan_type
                    WHEN 'BASIC' THEN 1
                    WHEN 'PLUS' THEN 2
                    WHEN 'MANAGED' THEN 3
                    ELSE 4
                END
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> mapPlanRules(rs), planSetId);
    }
}