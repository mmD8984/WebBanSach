package com.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    private Connection conn;

    public DashboardDAO(Connection conn) {
        this.conn = conn;
    }

    public long totalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalActiveUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_active = true";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalActiveBooks() {
        String sql = "SELECT COUNT(*) FROM books WHERE is_active = true";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public long totalCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }
    
    public String[] getLatestBookInfo() {
        String sql = "SELECT title, price FROM books ORDER BY created_at DESC, id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String title = rs.getString("title");
                String price = rs.getBigDecimal("price").toString();
                return new String[]{title, price};
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String[] getLatestUserInfo() {
        String sql = "SELECT full_name, phone FROM users ORDER BY created_at DESC, id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String name = rs.getString("full_name");
                String phone = rs.getString("phone");
                return new String[]{name, phone};
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
