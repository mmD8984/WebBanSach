package com.bookstore.dao;

import com.bookstore.model.Book;
import com.bookstore.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Book DAO Class
 * Handles database operations for books
 */
public class BookDAO {
    
    /**
     * Get all books
     */
    public static List<Book> getAllBooks() throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "ORDER BY b.id";
        return executeQuery(sql);
    }
    
    /**
     * Get book by ID
     */
    public static Book getBookById(int id) throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
            return null;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Get books by category
     */
    public static List<Book> getBooksByCategory(int categoryId) throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.category_id = ? ORDER BY b.id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return books;
    }
    
    /**
     * Get featured books
     */
    public static List<Book> getFeaturedBooks() throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.featured = TRUE ORDER BY b.rating DESC LIMIT 6";
        return executeQuery(sql);
    }
    
    /**
     * Get bestseller books
     */
    public static List<Book> getBestsellerBooks() throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.bestseller = TRUE ORDER BY b.reviews DESC LIMIT 6";
        return executeQuery(sql);
    }
    
    /**
     * Get new books
     */
    public static List<Book> getNewBooks() throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.is_new = TRUE ORDER BY b.id DESC LIMIT 6";
        return executeQuery(sql);
    }
    
    /**
     * Search books by title or author
     */
    public static List<Book> searchBooks(String query) throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.title LIKE ? OR a.name LIKE ? ORDER BY b.id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return books;
    }
    
    /**
     * Filter books by category, price range, and author
     */
    public static List<Book> filterBooks(Integer categoryId, Long minPrice, Long maxPrice, Integer authorId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
            "LEFT JOIN authors a ON b.author_id = a.id " +
            "LEFT JOIN publishers p ON b.publisher_id = p.id " +
            "WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        
        if (categoryId != null) {
            sql.append(" AND b.category_id = ?");
            params.add(categoryId);
        }
        
        if (minPrice != null) {
            sql.append(" AND b.price >= ?");
            params.add(minPrice);
        }
        
        if (maxPrice != null) {
            sql.append(" AND b.price <= ?");
            params.add(maxPrice);
        }
        
        if (authorId != null) {
            sql.append(" AND b.author_id = ?");
            params.add(authorId);
        }
        
        sql.append(" ORDER BY b.id");
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return books;
    }
    
    /**
     * Get paginated books
     */
    public static List<Book> getPaginatedBooks(int page, int pageSize) throws SQLException {
        String sql = "SELECT b.*, a.name as author_name, p.name as publisher_name FROM books b " +
                     "LEFT JOIN authors a ON b.author_id = a.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "ORDER BY b.id LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return books;
    }
    
    /**
     * Get total number of books
     */
    public static int getTotalBooks() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM books";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Map ResultSet to Book object
     */
    private static Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthorId(rs.getInt("author_id"));
        
        // Handle author name from aliased column or fallback
        try {
            String authorName = rs.getString("author_name");
            book.setAuthorName(authorName);
        } catch (SQLException e) {
            book.setAuthorName(null);
        }
        
        book.setPublisherId(rs.getInt("publisher_id"));
        
        // Handle publisher name from aliased column or fallback
        try {
            String publisherName = rs.getString("publisher_name");
            book.setPublisherName(publisherName);
        } catch (SQLException e) {
            book.setPublisherName(null);
        }
        
        book.setCategoryId(rs.getInt("category_id"));
        book.setPrice(rs.getLong("price"));
        book.setOriginalPrice(rs.getLong("original_price"));
        book.setDiscount(rs.getInt("discount"));
        book.setPages(rs.getInt("pages"));
        book.setYear(rs.getInt("year"));
        book.setRating(rs.getDouble("rating"));
        book.setReviews(rs.getInt("reviews"));
        book.setDescription(rs.getString("description"));
        book.setImage(rs.getString("image"));
        book.setStatus(rs.getString("status"));
        book.setFormat(rs.getString("format"));
        book.setSize(rs.getString("size"));
        book.setStock(rs.getInt("stock"));
        book.setFeatured(rs.getBoolean("featured"));
        book.setBestseller(rs.getBoolean("bestseller"));
        book.setNew(rs.getBoolean("is_new"));
        return book;
    }
    
    /**
     * Execute query and return list of books
     */
    private static List<Book> executeQuery(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return books;
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

