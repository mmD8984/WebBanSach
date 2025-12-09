package com.bookstore.dao;

import com.bookstore.model.Author;
import com.bookstore.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Author DAO Class
 * Handles database operations for authors
 */
public class AuthorDAO {
    
    /**
     * Get all authors
     */
    public static List<Author> getAllAuthors() throws SQLException {
        String sql = "SELECT * FROM authors ORDER BY id";
        List<Author> authors = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return authors;
    }
    
    /**
     * Get author by ID
     */
    public static Author getAuthorById(int id) throws SQLException {
        String sql = "SELECT * FROM authors WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAuthor(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Map ResultSet to Author object
     */
    private static Author mapResultSetToAuthor(ResultSet rs) throws SQLException {
        Author author = new Author();
        author.setId(rs.getInt("id"));
        author.setName(rs.getString("name"));
        author.setCountry(rs.getString("country"));
        return author;
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

