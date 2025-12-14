package com.bookstore.dao;

import com.bookstore.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    private Connection conn;

    public BookDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy danh sách sách + tên category + tên publisher + danh sách tác giả
    public List<Book> getAll() {
        List<Book> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "  b.id, b.title, b.description, b.price, b.stock_quantity, " +
            "  b.cover_image, b.category_id, b.publisher_id, b.is_active, " +
            "  c.name AS category_name, " +
            "  p.name AS publisher_name, " +
            "  COALESCE(string_agg(a.name, ', ' ORDER BY a.name), '') AS author_names " +
            "FROM books b " +
            "LEFT JOIN categories c ON b.category_id = c.id " +
            "LEFT JOIN publishers p ON b.publisher_id = p.id " +
            "LEFT JOIN book_authors ba ON b.id = ba.book_id " +
            "LEFT JOIN authors a ON ba.author_id = a.id " +
            "GROUP BY b.id, c.name, p.name " +
            "ORDER BY b.id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book b = new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("cover_image"),
                        (Integer) rs.getObject("category_id"),
                        (Integer) rs.getObject("publisher_id"),
                        rs.getBoolean("is_active"),
                        rs.getString("category_name"),
                        rs.getString("publisher_name"),
                        rs.getString("author_names")
                );
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Book findById(int id) {
        String sql =
            "SELECT " +
            "  b.id, b.title, b.description, b.price, b.stock_quantity, " +
            "  b.cover_image, b.category_id, b.publisher_id, b.is_active, " +
            "  c.name AS category_name, " +
            "  p.name AS publisher_name, " +
            "  COALESCE(string_agg(a.name, ', ' ORDER BY a.name), '') AS author_names " +
            "FROM books b " +
            "LEFT JOIN categories c ON b.category_id = c.id " +
            "LEFT JOIN publishers p ON b.publisher_id = p.id " +
            "LEFT JOIN book_authors ba ON b.id = ba.book_id " +
            "LEFT JOIN authors a ON ba.author_id = a.id " +
            "WHERE b.id = ? " +
            "GROUP BY b.id, c.name, p.name";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Book(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getBigDecimal("price"),
                            rs.getInt("stock_quantity"),
                            rs.getString("cover_image"),
                            (Integer) rs.getObject("category_id"),
                            (Integer) rs.getObject("publisher_id"),
                            rs.getBoolean("is_active"),
                            rs.getString("category_name"),
                            rs.getString("publisher_name"),
                            rs.getString("author_names")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Book b) {
        String sql =
            "INSERT INTO books (title, description, price, stock_quantity, " +
            "                    cover_image, category_id, publisher_id, is_active) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getCoverImage());

            if (b.getCategoryId() == null) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, b.getCategoryId());
            }

            if (b.getPublisherId() == null) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, b.getPublisherId());
            }

            ps.setBoolean(8, b.isActive());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Book b) {
        String sql =
            "UPDATE books " +
            "SET title = ?, description = ?, price = ?, stock_quantity = ?, " +
            "    cover_image = ?, category_id = ?, publisher_id = ?, is_active = ? " +
            "WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getCoverImage());

            if (b.getCategoryId() == null) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, b.getCategoryId());
            }

            if (b.getPublisherId() == null) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, b.getPublisherId());
            }

            ps.setBoolean(8, b.isActive());
            ps.setInt(9, b.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM books WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
