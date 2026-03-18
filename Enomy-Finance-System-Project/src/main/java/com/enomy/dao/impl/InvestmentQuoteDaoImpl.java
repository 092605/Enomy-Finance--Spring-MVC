package com.enomy.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.InvestmentQuoteDao;
import com.enomy.model.InvestmentQuote;

@Repository
public class InvestmentQuoteDaoImpl implements InvestmentQuoteDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(InvestmentQuote investmentQuote) {
        String sql = """
            INSERT INTO investment_quotes (
                user_id,
                plan_type,
                initial_lump_sum,
                monthly_investment,
                plan_rules_id
            ) VALUES (?, ?, ?, ?, ?)
        """;

        jdbcTemplate.update(
            sql,
            investmentQuote.getUserId(),
            investmentQuote.getPlanType(),
            investmentQuote.getInitialLumpSum(),
            investmentQuote.getMonthlyInvestment(),
            investmentQuote.getPlanRulesId()
        );
    }

    @Override
    public int countByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM investment_quotes WHERE user_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    @Override
    public List<InvestmentQuote> findByUserId(Long userId) {
        String sql = """
            SELECT id, user_id, plan_type, initial_lump_sum, monthly_investment, plan_rules_id, created_at
            FROM investment_quotes
            WHERE user_id = ?
            ORDER BY created_at DESC
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            InvestmentQuote quote = new InvestmentQuote();
            quote.setId(rs.getLong("id"));
            quote.setUserId(rs.getLong("user_id"));
            quote.setPlanType(rs.getString("plan_type"));
            quote.setInitialLumpSum(rs.getDouble("initial_lump_sum"));
            quote.setMonthlyInvestment(rs.getDouble("monthly_investment"));
            quote.setPlanRulesId(rs.getLong("plan_rules_id"));
            quote.setCreatedAt(rs.getTimestamp("created_at"));
            return quote;
        }, userId);
    }

    @Override
    public InvestmentQuote findByIdAndUserId(Long id, Long userId) {
        String sql = """
            SELECT id, user_id, plan_type, initial_lump_sum, monthly_investment, plan_rules_id, created_at
            FROM investment_quotes
            WHERE id = ? AND user_id = ?
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
                InvestmentQuote quote = new InvestmentQuote();
                quote.setId(rs.getLong("id"));
                quote.setUserId(rs.getLong("user_id"));
                quote.setPlanType(rs.getString("plan_type"));
                quote.setInitialLumpSum(rs.getDouble("initial_lump_sum"));
                quote.setMonthlyInvestment(rs.getDouble("monthly_investment"));
                quote.setPlanRulesId(rs.getLong("plan_rules_id"));
                quote.setCreatedAt(rs.getTimestamp("created_at"));
                return quote;
            }, id, userId);
        } catch (Exception e) {
            return null;
        }
    }
}