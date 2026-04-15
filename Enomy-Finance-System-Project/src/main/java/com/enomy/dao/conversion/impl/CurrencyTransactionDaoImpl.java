package com.enomy.dao.conversion.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.enomy.dao.conversion.CurrencyTransactionDao;
import com.enomy.dto.conversion.AdminCurrencyTransactionHistoryRowDTO;
import com.enomy.model.conversion.CurrencyTransaction;

@Repository
public class CurrencyTransactionDaoImpl implements CurrencyTransactionDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(CurrencyTransaction transaction) {
    	String sql = """
    		    INSERT INTO currency_transaction (
    		        transaction_number,
    		        user_id,
    		        transaction_type,
    		        base_currency,
    		        target_currency,
    		        input_amount,
    		        exchange_rate_used,
    		        converted_amount,
    		        fee_rate_applied,
    		        fee_value,
    		        final_amount,
    		        rule_set_id,
    		        status,
    		        created_at
    		    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    		""";

    	jdbcTemplate.update(sql,
    		    transaction.getTransactionNumber(),
    		    transaction.getUserId(),
    		    transaction.getTransactionType(),
    		    transaction.getBaseCurrency(),
    		    transaction.getTargetCurrency(),
    		    transaction.getInputAmount(),
    		    transaction.getExchangeRateUsed(),
    		    transaction.getConvertedAmount(),
    		    transaction.getFeeRateApplied(),
    		    transaction.getFeeValue(),
    		    transaction.getFinalAmount(),
    		    transaction.getRuleSetId(),
    		    transaction.getStatus(),
    		    transaction.getCreatedAt() 
    		);
    }

    @Override
    public List<CurrencyTransaction> findByUserId(Long userId) {
        String sql = """
            SELECT id, transaction_number, user_id, transaction_type, base_currency, target_currency,
                   input_amount, exchange_rate_used, converted_amount, fee_rate_applied, fee_value,
                   final_amount, rule_set_id, status, created_at
            FROM currency_transaction
            WHERE user_id = ?
            ORDER BY created_at DESC
        """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> mapTransaction(rs), userId);
    }

    @Override
    public CurrencyTransaction findByTransactionNumberAndUserId(String transactionNumber, Long userId) {
        String sql = """
            SELECT id, transaction_number, user_id, transaction_type, base_currency, target_currency,
                   input_amount, exchange_rate_used, converted_amount, fee_rate_applied, fee_value,
                   final_amount, rule_set_id, status, created_at
            FROM currency_transaction
            WHERE transaction_number = ? AND user_id = ?
            LIMIT 1
        """;

        try {
            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> mapTransaction(rs), transactionNumber, userId);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public int countByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM currency_transaction WHERE user_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    @Override
    public List<CurrencyTransaction> findFilteredTransactions(String baseCurrency,
                                                              String targetCurrency,
                                                              String dateFrom,
                                                              String dateTo,
                                                              String search) {

        StringBuilder sql = new StringBuilder("""
            SELECT id, transaction_number, user_id, transaction_type, base_currency, target_currency,
                   input_amount, exchange_rate_used, converted_amount, fee_rate_applied, fee_value,
                   final_amount, rule_set_id, status, created_at
            FROM currency_transaction
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (baseCurrency != null && !baseCurrency.isBlank()) {
            sql.append(" AND base_currency = ?");
            params.add(baseCurrency);
        }

        if (targetCurrency != null && !targetCurrency.isBlank()) {
            sql.append(" AND target_currency = ?");
            params.add(targetCurrency);
        }

        if (dateFrom != null && !dateFrom.isBlank()) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(dateFrom);
        }

        if (dateTo != null && !dateTo.isBlank()) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(dateTo);
        }

        if (search != null && !search.isBlank()) {
            sql.append(" AND (CAST(user_id AS CHAR) LIKE ? OR transaction_number LIKE ?)");
            String keyword = "%" + search.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY created_at DESC");

        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> mapTransaction(rs), params.toArray());
    }

    // =========================
    // ADMIN TRANSACTION HISTORY
    // SAFE NEW METHOD
    // =========================
    @Override
    public List<AdminCurrencyTransactionHistoryRowDTO> findAdminTransactionHistory(String baseCurrency,
                                                                                   String targetCurrency,
                                                                                   String transactionType,
                                                                                   String dateFrom,
                                                                                   String dateTo,
                                                                                   String search) {

        StringBuilder sql = new StringBuilder("""
            SELECT
                ct.transaction_number,
                ct.user_id,
                u.full_name,
                ct.transaction_type,
                ct.base_currency,
                ct.target_currency,
                ct.input_amount,
                ct.final_amount,
                ct.status,
                ct.created_at
            FROM currency_transaction ct
            INNER JOIN users u ON ct.user_id = u.id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (baseCurrency != null && !baseCurrency.isBlank()) {
            sql.append(" AND ct.base_currency = ?");
            params.add(baseCurrency.trim());
        }

        if (targetCurrency != null && !targetCurrency.isBlank()) {
            sql.append(" AND ct.target_currency = ?");
            params.add(targetCurrency.trim());
        }

        if (transactionType != null && !transactionType.isBlank()) {
            sql.append(" AND ct.transaction_type = ?");
            params.add(transactionType.trim());
        }

        if (dateFrom != null && !dateFrom.isBlank()) {
            sql.append(" AND DATE(ct.created_at) >= ?");
            params.add(dateFrom.trim());
        }

        if (dateTo != null && !dateTo.isBlank()) {
            sql.append(" AND DATE(ct.created_at) <= ?");
            params.add(dateTo.trim());
        }

        if (search != null && !search.isBlank()) {
            String keyword = search.trim();

            // ✅ CASE 1: Only digits → USER ID EXACT MATCH
            if (keyword.matches("\\d+")) {
                sql.append(" AND ct.user_id = ?");
                params.add(Long.valueOf(keyword));

            // ✅ CASE 2: Starts with CC- → TRANSACTION NUMBER
            } else if (keyword.toLowerCase().startsWith("cc-")) {
                sql.append(" AND LOWER(ct.transaction_number) LIKE ?");
                params.add("%" + keyword.toLowerCase() + "%");

            // ✅ CASE 3: Otherwise → USER NAME
            } else {
                sql.append(" AND LOWER(u.full_name) LIKE ?");
                params.add("%" + keyword.toLowerCase() + "%");
            }
        }

        sql.append(" ORDER BY ct.created_at DESC");

        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> {
            AdminCurrencyTransactionHistoryRowDTO row = new AdminCurrencyTransactionHistoryRowDTO();

            row.setTransactionNumber(rs.getString("transaction_number"));
            row.setUserId(rs.getLong("user_id"));
            row.setUserName(rs.getString("full_name"));
            row.setTransactionType(rs.getString("transaction_type"));
            row.setBaseCurrency(rs.getString("base_currency"));
            row.setTargetCurrency(rs.getString("target_currency"));
            row.setInputAmount(rs.getDouble("input_amount"));
            row.setFinalAmount(rs.getDouble("final_amount"));
            row.setStatus(rs.getString("status"));
            row.setCreatedAt(rs.getTimestamp("created_at"));

            return row;
        }, params.toArray());
    }

    private CurrencyTransaction mapTransaction(java.sql.ResultSet rs) throws java.sql.SQLException {
        CurrencyTransaction transaction = new CurrencyTransaction();
        transaction.setId(rs.getLong("id"));
        transaction.setTransactionNumber(rs.getString("transaction_number"));
        transaction.setUserId(rs.getLong("user_id"));
        transaction.setTransactionType(rs.getString("transaction_type"));
        transaction.setBaseCurrency(rs.getString("base_currency"));
        transaction.setTargetCurrency(rs.getString("target_currency"));
        transaction.setInputAmount(rs.getDouble("input_amount"));
        transaction.setExchangeRateUsed(rs.getDouble("exchange_rate_used"));
        transaction.setConvertedAmount(rs.getDouble("converted_amount"));
        transaction.setFeeRateApplied(rs.getDouble("fee_rate_applied"));
        transaction.setFeeValue(rs.getDouble("fee_value"));
        transaction.setFinalAmount(rs.getDouble("final_amount"));
        transaction.setRuleSetId(rs.getLong("rule_set_id"));
        transaction.setStatus(rs.getString("status"));
        transaction.setCreatedAt(rs.getObject("created_at", java.time.LocalDateTime.class)
                .atZone(java.time.ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli() == 0 ? null :
                new java.util.Date(
                    rs.getObject("created_at", java.time.LocalDateTime.class)
                      .atZone(java.time.ZoneId.systemDefault())
                      .toInstant()
                      .toEpochMilli()
                )
        );
        return transaction;
    }
}