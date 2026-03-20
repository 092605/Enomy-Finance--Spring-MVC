package com.enomy.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.ConversionFeeRuleDao;
import com.enomy.model.ConversionFeeRule;

@Repository
public class ConversionFeeRuleDaoImpl implements ConversionFeeRuleDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(ConversionFeeRule feeRule) {
        String sql = """
            INSERT INTO conversion_fee_rule (
                rule_set_id,
                min_amount,
                max_amount,
                fee_rate
            ) VALUES (?, ?, ?, ?)
        """;

        jdbcTemplate.update(
            sql,
            feeRule.getRuleSetId(),
            feeRule.getMinAmount(),
            feeRule.getMaxAmount(),
            feeRule.getFeeRate()
        );
    }

    @Override
    public List<ConversionFeeRule> findByRuleSetId(Long ruleSetId) {
        String sql = """
            SELECT id, rule_set_id, min_amount, max_amount, fee_rate, created_at, updated_at
            FROM conversion_fee_rule
            WHERE rule_set_id = ?
            ORDER BY min_amount ASC
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            ConversionFeeRule rule = new ConversionFeeRule();
            rule.setId(rs.getLong("id"));
            rule.setRuleSetId(rs.getLong("rule_set_id"));
            rule.setMinAmount(rs.getDouble("min_amount"));
            rule.setMaxAmount(rs.getDouble("max_amount"));
            rule.setFeeRate(rs.getDouble("fee_rate"));
            rule.setCreatedAt(rs.getTimestamp("created_at"));
            rule.setUpdatedAt(rs.getTimestamp("updated_at"));
            return rule;
        }, ruleSetId);
    }

    @Override
    public ConversionFeeRule findMatchingFeeRule(Long ruleSetId, Double amount) {
        String sql = """
            SELECT id, rule_set_id, min_amount, max_amount, fee_rate, created_at, updated_at
            FROM conversion_fee_rule
            WHERE rule_set_id = ?
              AND ? >= min_amount
              AND ? <= max_amount
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
                ConversionFeeRule rule = new ConversionFeeRule();
                rule.setId(rs.getLong("id"));
                rule.setRuleSetId(rs.getLong("rule_set_id"));
                rule.setMinAmount(rs.getDouble("min_amount"));
                rule.setMaxAmount(rs.getDouble("max_amount"));
                rule.setFeeRate(rs.getDouble("fee_rate"));
                rule.setCreatedAt(rs.getTimestamp("created_at"));
                rule.setUpdatedAt(rs.getTimestamp("updated_at"));
                return rule;
            }, ruleSetId, amount, amount);
        } catch (Exception e) {
            return null;
        }
    }
}