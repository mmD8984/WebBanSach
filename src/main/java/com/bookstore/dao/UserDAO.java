package com.bookstore.dao;

import com.bookstore.model.User;
import com.bookstore.util.DBConnection;
import com.bookstore.util.PasswordUtil;
import java.sql.*;

/**
 * User DAO Class
 * Handles database operations for users
 */
public class UserDAO {
    
    /**
     * Register a new user
     */
    public static boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, fullname, phone, address) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            
            int result = ps.executeUpdate();
            return result > 0;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Find user by email
     */
    public static User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Find user by ID
     */
    public static User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Check if email exists
     */
    public static boolean emailExists(String email) throws SQLException {
        return findByEmail(email) != null;
    }
    
    /**
     * Verify login (email and password)
     * Hashes password before comparison
     */
    public static User verifyLogin(String email, String password) throws SQLException {
        User user = findByEmail(email);
        if (user != null && PasswordUtil.verify(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    
    /**
     * Update user profile
     */
    public static boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE users SET fullname = ?, phone = ?, address = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt(4, user.getId());
            
            int result = ps.executeUpdate();
            return result > 0;
        } finally {
            closeResources(ps, conn);
        }
    }
    
    /**
     * Map ResultSet to User object
     */
    private static User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullname(rs.getString("fullname"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        return user;
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

