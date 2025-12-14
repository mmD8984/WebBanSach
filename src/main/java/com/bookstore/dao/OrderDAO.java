package com.bookstore.dao;

import com.bookstore.model.Order;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Connection conn;

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy list đơn hàng + tên khách
    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();

        String sql =
            "SELECT o.id, o.order_code, o.user_id, o.total_amount, o.status, " +
            "       o.shipping_address, o.payment_method, o.payment_status, " +
            "       o.note, o.created_at, u.full_name AS user_name " +
            "FROM orders o " +
            "LEFT JOIN users u ON o.user_id = u.id " +
            "ORDER BY o.created_at DESC, o.id DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = mapRow(rs);
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Order findById(int id) {
        String sql =
            "SELECT o.id, o.order_code, o.user_id, o.total_amount, o.status, " +
            "       o.shipping_address, o.payment_method, o.payment_status, " +
            "       o.note, o.created_at, u.full_name AS user_name " +
            "FROM orders o " +
            "LEFT JOIN users u ON o.user_id = u.id " +
            "WHERE o.id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Trong admin-order thường không "insert" bằng tay (do khách tạo),
    // nhưng vẫn có thể giữ insert nếu cần.
    public boolean insert(Order o) {
        String sql =
            "INSERT INTO orders (order_code, user_id, total_amount, status, " +
            "                    shipping_address, payment_method, payment_status, note) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, o.getOrderCode());
            if (o.getUserId() == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, o.getUserId());
            }
            ps.setBigDecimal(3, o.getTotalAmount());
            ps.setString(4, o.getStatus());
            ps.setString(5, o.getShippingAddress());
            ps.setString(6, o.getPaymentMethod());
            ps.setString(7, o.getPaymentStatus());
            ps.setString(8, o.getNote());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Order o) {
        String sql =
            "UPDATE orders " +
            "SET user_id = ?, total_amount = ?, status = ?, " +
            "    shipping_address = ?, payment_method = ?, payment_status = ?, " +
            "    note = ? " +
            "WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (o.getUserId() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, o.getUserId());
            }
            ps.setBigDecimal(2, o.getTotalAmount());
            ps.setString(3, o.getStatus());
            ps.setString(4, o.getShippingAddress());
            ps.setString(5, o.getPaymentMethod());
            ps.setString(6, o.getPaymentStatus());
            ps.setString(7, o.getNote());
            ps.setInt(8, o.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String orderCode = rs.getString("order_code");
        Integer userId = (Integer) rs.getObject("user_id");
        BigDecimal totalAmount = rs.getBigDecimal("total_amount");
        String status = rs.getString("status");
        String shippingAddress = rs.getString("shipping_address");
        String paymentMethod = rs.getString("payment_method");
        String paymentStatus = rs.getString("payment_status");
        String note = rs.getString("note");

        Timestamp ts = rs.getTimestamp("created_at");
        LocalDateTime createdAt = ts != null ? ts.toLocalDateTime() : null;

        String userName = rs.getString("user_name");

        return new Order(id, orderCode, userId, totalAmount, status,
                shippingAddress, paymentMethod, paymentStatus, note,
                createdAt, userName);
    }
}
