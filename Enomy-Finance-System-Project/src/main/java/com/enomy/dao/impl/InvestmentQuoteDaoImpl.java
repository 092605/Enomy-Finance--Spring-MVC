package com.enomy.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.InvestmentQuoteDao;
import com.enomy.dto.AdminInvestmentQuoteHistoryRowDTO;
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

    // =========================
    // ADMIN TRANSACTION HISTORY
    // SAFE NEW METHOD
    // =========================
    @Override
    public List<AdminInvestmentQuoteHistoryRowDTO> findAdminInvestmentQuoteHistory(String planType,
                                                                                    String dateFrom,
                                                                                    String dateTo,
                                                                                    String search) {

        StringBuilder sql = new StringBuilder("""
            SELECT
                iq.id,
                iq.user_id,
                u.full_name,
                iq.plan_type,
                iq.initial_lump_sum,
                iq.monthly_investment,
                iq.plan_rules_id,
                iq.created_at
            FROM investment_quotes iq
            INNER JOIN users u ON iq.user_id = u.id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (planType != null && !planType.isBlank()) {
            sql.append(" AND iq.plan_type = ?");
            params.add(planType.trim());
        }

        if (dateFrom != null && !dateFrom.isBlank()) {
            sql.append(" AND DATE(iq.created_at) >= ?");
            params.add(dateFrom.trim());
        }

        if (dateTo != null && !dateTo.isBlank()) {
            sql.append(" AND DATE(iq.created_at) <= ?");
            params.add(dateTo.trim());
        }

        if (search != null && !search.isBlank()) {
            String keyword = search.trim();

            // Only digits = exact user id
            if (keyword.matches("\\d+")) {
                sql.append(" AND iq.user_id = ?");
                params.add(Long.valueOf(keyword));

            // Otherwise = user name search
            } else {
                sql.append(" AND LOWER(u.full_name) LIKE ?");
                params.add("%" + keyword.toLowerCase() + "%");
            }
        }

        sql.append(" ORDER BY iq.created_at DESC");

        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> {
            AdminInvestmentQuoteHistoryRowDTO row = new AdminInvestmentQuoteHistoryRowDTO();

            row.setQuoteId(rs.getLong("id"));
            row.setUserId(rs.getLong("user_id"));
            row.setUserName(rs.getString("full_name"));
            row.setPlanType(rs.getString("plan_type"));
            row.setInitialLumpSum(rs.getDouble("initial_lump_sum"));
            row.setMonthlyInvestment(rs.getDouble("monthly_investment"));
            row.setPlanRuleId(rs.getLong("plan_rules_id"));
            row.setCreatedAt(rs.getTimestamp("created_at"));

            return row;
        }, params.toArray());
    }
}