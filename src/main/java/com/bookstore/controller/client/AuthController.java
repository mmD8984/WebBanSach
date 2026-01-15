package com.bookstore.controller.client;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        userDAO = new UserDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String path = req.getServletPath();

        switch (path) {
            case "/login":
                req.getRequestDispatcher("/pages/client/login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
                break;
            case "/logout":
                doLogout(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String path = req.getServletPath();

        switch (path) {
            case "/login":
                doLogin(req, resp);
                break;
            case "/register":
                doRegister(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    private void doLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Validation
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email và mật khẩu");
            req.getRequestDispatcher("/pages/client/login.jsp").forward(req, resp);
            return;
        }

        // Authenticate
        User user = userDAO.authenticate(email.trim(), password);

        if (user == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/pages/client/login.jsp").forward(req, resp);
            return;
        }

        // Create session
        HttpSession session = req.getSession();
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userRole", user.getRole());

        // Redirect based on role
        if ("admin".equals(user.getRole()) || "staff".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
        } else {
            // Redirect to previous page or home
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                resp.sendRedirect(redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        }
    }

    private void doRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        // Validation
        if (email == null || email.isBlank() ||
            password == null || password.isBlank() ||
            fullName == null || fullName.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
            setFormAttributes(req, email, fullName, phone);
            req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            setFormAttributes(req, email, fullName, phone);
            req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            setFormAttributes(req, email, fullName, phone);
            req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
            return;
        }

        // Check email exists
        if (userDAO.emailExists(email.trim())) {
            req.setAttribute("error", "Email đã được sử dụng");
            setFormAttributes(req, email, fullName, phone);
            req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setEmail(email.trim());
        newUser.setPasswordHash(hashPassword(password));
        newUser.setFullName(fullName.trim());
        newUser.setPhone(phone != null ? phone.trim() : "");
        newUser.setRole("customer");
        newUser.setActive(true);

        boolean success = userDAO.insert(newUser);

        if (success) {
            req.getSession().setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            setFormAttributes(req, email, fullName, phone);
            req.getRequestDispatcher("/pages/client/register.jsp").forward(req, resp);
        }
    }

    private void doLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/");
    }

    private void setFormAttributes(HttpServletRequest req, String email, String fullName, String phone) {
        req.setAttribute("email", email);
        req.setAttribute("fullName", fullName);
        req.setAttribute("phone", phone);
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
