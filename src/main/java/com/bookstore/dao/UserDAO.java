package com.bookstore.dao;

import com.bookstore.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public List<User> getAll() {
        List<User> list = new ArrayList<>();

        String sql = "SELECT id, email, password_hash, full_name, phone, role, is_active " +
                     "FROM users ORDER BY id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getBoolean("is_active")
                );
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public User findById(int id) {
        String sql = "SELECT id, email, password_hash, full_name, phone, role, is_active " +
                     "FROM users WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("role"),
                            rs.getBoolean("is_active")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(User u) {
        String sql = "INSERT INTO users (email, password_hash, full_name, phone, role, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getPasswordHash());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getRole());
            ps.setBoolean(6, u.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(User u) {
        String sql = "UPDATE users SET email = ?, full_name = ?, phone = ?, role = ?, " +
                     "is_active = ? " +
                     (u.getPasswordHash() != null && !u.getPasswordHash().isBlank()
                        ? ", password_hash = ? "
                        : "") +
                     "WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, u.getEmail());
            ps.setString(idx++, u.getFullName());
            ps.setString(idx++, u.getPhone());
            ps.setString(idx++, u.getRole());
            ps.setBoolean(idx++, u.isActive());

            if (u.getPasswordHash() != null && !u.getPasswordHash().isBlank()) {
                ps.setString(idx++, u.getPasswordHash());
            }

            ps.setInt(idx, u.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm user theo email
    public User findByEmail(String email) {
        String sql = "SELECT id, email, password_hash, full_name, phone, role, is_active " +
                     "FROM users WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("role"),
                            rs.getBoolean("is_active")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Xác thực user với email và password (hash SHA-256)
    public User authenticate(String email, String password) {
        User user = findByEmail(email);
        if (user == null) return null;
        if (!user.isActive()) return null;

        // Hash password input với SHA-256
        String hashedInput = hashPassword(password);
        if (hashedInput != null && hashedInput.equals(user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    // Kiểm tra email đã tồn tại chưa
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hash password với SHA-256
    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
