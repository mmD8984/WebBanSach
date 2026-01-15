package com.bookstore.dao;

import com.bookstore.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    private Connection conn;

    public ReviewDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy reviews của một cuốn sách (chỉ lấy đã approved)
    public List<Review> getByBookId(int bookId) {
        List<Review> list = new ArrayList<>();
        String sql = 
            "SELECT r.id, r.user_id, r.book_id, r.rating, r.comment, r.is_approved, r.created_at, " +
            "       u.full_name AS user_name " +
            "FROM reviews r " +
            "JOIN users u ON r.user_id = u.id " +
            "WHERE r.book_id = ? AND r.is_approved = true " +
            "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setBookId(rs.getInt("book_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setApproved(rs.getBoolean("is_approved"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setUserName(rs.getString("user_name"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Kiểm tra user đã review sách này chưa
    public boolean hasUserReviewed(int userId, int bookId) {
        String sql = "SELECT 1 FROM reviews WHERE user_id = ? AND book_id = ?";
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

    // Thêm review mới
    public boolean insert(Review r) {
        String sql = "INSERT INTO reviews (user_id, book_id, rating, comment, is_approved) VALUES (?, ?, ?, ?, false)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getBookId());
            ps.setInt(3, r.getRating());
            ps.setString(4, r.getComment());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tính rating trung bình của sách
    public double getAverageRating(int bookId) {
        String sql = "SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE book_id = ? AND is_approved = true";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số reviews của sách
    public int countReviews(int bookId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE book_id = ? AND is_approved = true";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
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
