package com.bookstore.dao;

import com.bookstore.model.Cart;
import com.bookstore.model.CartItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    private Connection conn;

    public CartDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy hoặc tạo cart cho user
    public Cart getOrCreateCart(int userId) {
        Cart cart = findByUserId(userId);
        if (cart == null) {
            cart = createCart(userId);
        }
        return cart;
    }

    // Tìm cart theo user_id
    public Cart findByUserId(int userId) {
        String sql = "SELECT id, user_id, created_at FROM carts WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Cart(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getTimestamp("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tạo cart mới
    public Cart createCart(int userId) {
        String sql = "INSERT INTO carts (user_id) VALUES (?) RETURNING id, user_id, created_at";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Cart(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getTimestamp("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tất cả items trong cart với thông tin sách
    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = 
            "SELECT ci.id, ci.cart_id, ci.book_id, ci.quantity, ci.created_at, ci.updated_at, " +
            "       b.title AS book_title, b.price AS book_price, b.cover_image AS book_cover " +
            "FROM cart_items ci " +
            "JOIN books b ON ci.book_id = b.id " +
            "WHERE ci.cart_id = ? " +
            "ORDER BY ci.created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    item.setUpdatedAt(rs.getTimestamp("updated_at"));
                    item.setBookTitle(rs.getString("book_title"));
                    item.setBookPrice(rs.getBigDecimal("book_price"));
                    item.setBookCoverImage(rs.getString("book_cover"));
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    // Thêm sách vào cart (hoặc tăng số lượng nếu đã có)
    public boolean addItem(int cartId, int bookId, int quantity) {
        // Kiểm tra item đã tồn tại chưa
        CartItem existing = findCartItem(cartId, bookId);
        if (existing != null) {
            return updateItemQuantity(existing.getId(), existing.getQuantity() + quantity);
        }

        String sql = "INSERT INTO cart_items (cart_id, book_id, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm cart item theo cart_id và book_id
    public CartItem findCartItem(int cartId, int bookId) {
        String sql = "SELECT id, cart_id, book_id, quantity FROM cart_items WHERE cart_id = ? AND book_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new CartItem(
                        rs.getInt("id"),
                        rs.getInt("cart_id"),
                        rs.getInt("book_id"),
                        rs.getInt("quantity")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật số lượng item
    public boolean updateItemQuantity(int itemId, int quantity) {
        if (quantity <= 0) {
            return removeItem(itemId);
        }
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa item khỏi cart
    public boolean removeItem(int itemId) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa tất cả items trong cart (sau khi checkout)
    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm số lượng items trong cart
    public int countItems(int cartId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
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

    // Tính tổng tiền cart
    public BigDecimal getCartTotal(int cartId) {
        String sql = 
            "SELECT COALESCE(SUM(b.price * ci.quantity), 0) AS total " +
            "FROM cart_items ci " +
            "JOIN books b ON ci.book_id = b.id " +
            "WHERE ci.cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
