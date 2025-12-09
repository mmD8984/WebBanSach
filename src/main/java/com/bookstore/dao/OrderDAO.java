package com.bookstore.dao;

import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import com.bookstore.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Order DAO Class
 * Handles database operations for orders
 */
public class OrderDAO {
    
    /**
     * Create a new order with items
     */
    public static int createOrder(Order order, List<OrderItem> items) throws SQLException {
        int orderId = createOrder(order);
        if (orderId > 0 && items != null && !items.isEmpty()) {
            createOrderItems(orderId, items);
        }
        return orderId;
    }
    
    /**
     * Create a new order
     */
    public static int createOrder(Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, fullname, phone, email, address, shipping_method, payment_method, " +
                     "total_amount, shipping_cost, final_amount, order_status, payment_status, vnp_txn_ref, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            long shippingCost = order.getShippingMethod() != null && order.getShippingMethod().equals("express") ? 50000 : 0;
            long finalAmount = order.getTotal() + shippingCost;
            
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getFullname());
            ps.setString(3, order.getPhone());
            ps.setString(4, order.getEmail());
            ps.setString(5, order.getAddress());
            ps.setString(6, order.getShippingMethod() != null ? order.getShippingMethod() : "standard");
            ps.setString(7, order.getPaymentMethod() != null ? order.getPaymentMethod() : "vnpay");
            ps.setLong(8, order.getTotal());
            ps.setLong(9, shippingCost);
            ps.setLong(10, finalAmount);
            ps.setString(11, order.getStatus() != null ? order.getStatus() : "pending");
            ps.setString(12, order.getPaymentStatus() != null ? order.getPaymentStatus() : "pending");
            ps.setString(13, order.getVnpTxnRef());
            ps.setString(14, order.getNotes());
            
            ps.executeUpdate();
            
            // Get generated ID
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
            return -1;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Create order items
     */
    public static boolean createOrderItems(int orderId, List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, book_id, book_title, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            
            for (OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getBookId());
                ps.setString(3, item.getBookTitle() != null ? item.getBookTitle() : "");
                ps.setInt(4, item.getQuantity());
                ps.setLong(5, item.getPrice());
                ps.setLong(6, item.getPrice() * item.getQuantity());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            return results.length > 0;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Get order by ID
     */
    public static Order getOrderById(int id) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Get orders by user ID
     */
    public static List<Order> getOrdersByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return orders;
    }
    
    /**
     * Get order items
     */
    public static List<OrderItem> getOrderItems(int orderId) throws SQLException {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderItem> items = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                items.add(mapResultSetToOrderItem(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return items;
    }
    
    /**
     * Update order status
     */
    public static boolean updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Update payment status for VNPAY
     */
    public static boolean updatePaymentStatus(int orderId, String paymentStatus, String vnpTransactionNo) throws SQLException {
        String sql = "UPDATE orders SET payment_status = ?, vnp_transaction_no = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, paymentStatus);
            ps.setString(2, vnpTransactionNo);
            ps.setInt(3, orderId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Get order by VNPAY transaction reference
     */
    public static Order getOrderByVnpTxnRef(String vnpTxnRef) throws SQLException {
        String sql = "SELECT * FROM orders WHERE vnp_txn_ref = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, vnpTxnRef);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Map ResultSet to Order object
     */
    private static Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setFullname(rs.getString("fullname"));
        order.setPhone(rs.getString("phone"));
        order.setEmail(rs.getString("email"));
        order.setAddress(rs.getString("address"));
        order.setNotes(rs.getString("notes"));
        order.setShippingMethod(rs.getString("shipping_method"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setTotal(rs.getLong("total_amount"));
        order.setShippingCost(rs.getLong("shipping_cost"));
        order.setStatus(rs.getString("order_status"));
        order.setPaymentStatus(rs.getString("payment_status"));
        
        // VNPAY Fields (if columns exist)
        try {
            order.setVnpTxnRef(rs.getString("vnp_txn_ref"));
            order.setVnpTransactionNo(rs.getString("vnp_transaction_no"));
        } catch (SQLException e) {
            // Columns might not exist yet, ignore
        }
        
        // Get created_at timestamp
        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                order.setCreatedAt(ts.toLocalDateTime());
            }
        } catch (SQLException e) {
            // ignore
        }
        
        return order;
    }
    
    /**
     * Map ResultSet to OrderItem object
     */
    private static OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setBookTitle(rs.getString("book_title"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getLong("unit_price"));
        return item;
    }
    
    /**
     * Close database resources
     */
    private static void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        closeResources(ps, conn);
    }
    
    private static void closeResources(PreparedStatement ps, Connection conn) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        DBConnection.closeConnection(conn);
    }
}

