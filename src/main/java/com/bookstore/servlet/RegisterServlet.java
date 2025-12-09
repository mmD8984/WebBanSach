package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Register Servlet
 * Handles user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if already logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Validate input
        String error = validateInput(fullname, email, password, confirmPassword, phone);
        
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if email already exists
            if (UserDAO.emailExists(email.trim())) {
                request.setAttribute("error", "Email đã được đăng ký");
                request.setAttribute("fullname", fullname);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = PasswordUtil.hash(password);
            
            // Create new user
            User newUser = new User();
            newUser.setFullname(fullname.trim());
            newUser.setEmail(email.trim());
            newUser.setPassword(hashedPassword);
            newUser.setPhone(phone.trim());
            newUser.setAddress(address != null ? address.trim() : "");
            
            // Register user
            if (UserDAO.register(newUser)) {
                // Registration successful - auto login
                User loginUser = UserDAO.verifyLogin(email.trim(), password);
                if (loginUser != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", loginUser);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    response.sendRedirect(request.getContextPath() + "/");
                } else {
                    // Fallback - redirect to login
                    response.sendRedirect(request.getContextPath() + "/login");
                }
            } else {
                request.setAttribute("error", "Lỗi khi đăng ký. Vui lòng thử lại");
                request.setAttribute("fullname", fullname);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi đăng ký: " + e.getMessage());
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Validate registration input
     */
    private String validateInput(String fullname, String email, String password, 
                                  String confirmPassword, String phone) {
        
        if (fullname == null || fullname.trim().isEmpty()) {
            return "Vui lòng nhập họ tên";
        }
        
        if (email == null || email.trim().isEmpty()) {
            return "Vui lòng nhập email";
        }
        
        // Simple email validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email không hợp lệ";
        }
        
        if (password == null || password.isEmpty()) {
            return "Vui lòng nhập mật khẩu";
        }
        
        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }
        
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            return "Vui lòng nhập số điện thoại";
        }
        
        if (!phone.matches("^[0-9]{10,11}$")) {
            return "Số điện thoại không hợp lệ";
        }
        
        return null;
    }
}

