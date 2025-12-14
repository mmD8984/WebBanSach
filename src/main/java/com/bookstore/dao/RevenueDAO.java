package com.bookstore.dao;

import com.bookstore.model.RevenueStat;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class RevenueDAO {

    private Connection conn;

    public RevenueDAO(Connection conn) {
        this.conn = conn;
    }

    // Doanh thu theo tuần (mỗi tuần một dòng)
    public List<RevenueStat> getWeeklyRevenue() {
        List<RevenueStat> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "  to_char(date_trunc('week', created_at), 'YYYY-MM-DD') AS week_start, " +
            "  SUM(total_amount) AS total_revenue " +
            "FROM orders " +
            "WHERE payment_status = 'paid' " +
            "GROUP BY date_trunc('week', created_at) " +
            "ORDER BY date_trunc('week', created_at)";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String label = rs.getString("week_start");
                BigDecimal total = rs.getBigDecimal("total_revenue");
                list.add(new RevenueStat(label, total));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Doanh thu theo tháng (mỗi tháng một dòng)
    public List<RevenueStat> getMonthlyRevenue() {
        List<RevenueStat> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "  to_char(date_trunc('month', created_at), 'YYYY-MM') AS month, " +
            "  SUM(total_amount) AS total_revenue " +
            "FROM orders " +
            "WHERE payment_status = 'paid' " +
            "GROUP BY date_trunc('month', created_at) " +
            "ORDER BY date_trunc('month', created_at)";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String label = rs.getString("month");
                BigDecimal total = rs.getBigDecimal("total_revenue");
                list.add(new RevenueStat(label, total));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
