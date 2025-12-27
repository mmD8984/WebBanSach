package com.bookstore.dao;

import com.bookstore.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    private Connection conn;

    public WishlistDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy wishlist của user với thông tin sách
    public List<Book> getWishlistBooks(int userId) {
        List<Book> list = new ArrayList<>();
        String sql = 
            "SELECT b.id, b.title, b.price, b.cover_image, b.is_active, " +
            "       c.name AS category_name " +
            "FROM wishlists w " +
            "JOIN books b ON w.book_id = b.id " +
            "LEFT JOIN categories c ON b.category_id = c.id " +
            "WHERE w.user_id = ? " +
            "ORDER BY w.created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = new Book();
                    b.setId(rs.getInt("id"));
                    b.setTitle(rs.getString("title"));
                    b.setPrice(rs.getBigDecimal("price"));
                    b.setCoverImage(rs.getString("cover_image"));
                    b.setActive(rs.getBoolean("is_active"));
                    b.setCategoryName(rs.getString("category_name"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Kiểm tra sách có trong wishlist không
    public boolean isInWishlist(int userId, int bookId) {
        String sql = "SELECT 1 FROM wishlists WHERE user_id = ? AND book_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm sách vào wishlist
    public boolean add(int userId, int bookId) {
        if (isInWishlist(userId, bookId)) {
            return true; // Đã có rồi
        }
        String sql = "INSERT INTO wishlists (user_id, book_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa sách khỏi wishlist
    public boolean remove(int userId, int bookId) {
        String sql = "DELETE FROM wishlists WHERE user_id = ? AND book_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Toggle wishlist (thêm nếu chưa có, xóa nếu đã có)
    public boolean toggle(int userId, int bookId) {
        if (isInWishlist(userId, bookId)) {
            return remove(userId, bookId);
        } else {
            return add(userId, bookId);
        }
    }

    // Đếm số sách trong wishlist
    public int count(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
