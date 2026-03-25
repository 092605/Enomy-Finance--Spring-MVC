package com.enomy.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.ConversionRuleSetDao;
import com.enomy.model.ConversionRuleSet;

@Repository
public class ConversionRuleSetDaoImpl implements ConversionRuleSetDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public ConversionRuleSet findActiveRuleSet() {
        String sql = """
            SELECT id, rule_name, description, active, created_at, updated_at
            FROM conversion_rule_set
            WHERE active = 1
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
                ConversionRuleSet ruleSet = new ConversionRuleSet();
                ruleSet.setId(rs.getLong("id"));
                ruleSet.setRuleName(rs.getString("rule_name"));
                ruleSet.setDescription(rs.getString("description"));
                ruleSet.setActive(rs.getBoolean("active"));
                ruleSet.setCreatedAt(rs.getTimestamp("created_at"));
                ruleSet.setUpdatedAt(rs.getTimestamp("updated_at"));
                return ruleSet;
            });
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void save(ConversionRuleSet ruleSet) {
        String sql = """
            INSERT INTO conversion_rule_set (
                rule_name,
                description,
                active
            ) VALUES (?, ?, ?)
        """;

        jdbcTemplate.update(
            sql,
            ruleSet.getRuleName(),
            ruleSet.getDescription(),
            ruleSet.getActive()
        );
    }

    @Override
    public void deactivateAllRuleSets() {
        String sql = "UPDATE conversion_rule_set SET active = 0";
        jdbcTemplate.update(sql);
    }
}