package com.bookstore.controller.client;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/account")
public class AccountController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        userDAO = new UserDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = userDAO.findById(userId);
        req.setAttribute("user", user);

        req.getRequestDispatcher("/pages/client/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("update".equals(action)) {
            updateProfile(req, resp, userId);
        } else if ("password".equals(action)) {
            changePassword(req, resp, userId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/account");
        }
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {
        
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        if (fullName == null || fullName.isBlank()) {
            req.setAttribute("error", "Họ tên không được để trống");
            doGet(req, resp);
            return;
        }

        User user = userDAO.findById(userId);
        user.setFullName(fullName.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setPasswordHash(null); // Không cập nhật password

        boolean success = userDAO.update(user);

        if (success) {
            // Cập nhật session
            req.getSession().setAttribute("userName", user.getFullName());
            req.getSession().setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            req.getSession().setAttribute("error", "Cập nhật thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {
        
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validation
        if (currentPassword == null || currentPassword.isBlank() ||
            newPassword == null || newPassword.isBlank()) {
            req.getSession().setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.getSession().setAttribute("error", "Mật khẩu mới không khớp");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        if (newPassword.length() < 6) {
            req.getSession().setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        // Verify current password
        User user = userDAO.findById(userId);
        String hashedCurrent = hashPassword(currentPassword);
        
        if (!hashedCurrent.equals(user.getPasswordHash())) {
            req.getSession().setAttribute("error", "Mật khẩu hiện tại không đúng");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        // Update password
        user.setPasswordHash(hashPassword(newPassword));
        boolean success = userDAO.update(user);

        if (success) {
            req.getSession().setAttribute("message", "Đổi mật khẩu thành công!");
        } else {
            req.getSession().setAttribute("error", "Đổi mật khẩu thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

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
