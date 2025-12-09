package com.bookstore.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility
 * Handles MySQL database connection
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/webbansach";
    private static final String USER = "root";
    private static final String PASSWORD = "ga123456.";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Failed to connect to database!");
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * Close database connection
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Failed to close connection!");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test database connection
     */
    public static void testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("Database connection successful!");
            }
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
    }
}

