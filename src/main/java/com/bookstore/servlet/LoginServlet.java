package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Login Servlet
 * Handles user login and session creation
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if already logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Get return URL from query parameter (to redirect after login)
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl == null || returnUrl.isEmpty()) {
            returnUrl = request.getContextPath() + "/";
        }
        
        request.setAttribute("returnUrl", returnUrl);
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String returnUrl = request.getParameter("returnUrl");
        
        // Validate input
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu");
            request.setAttribute("returnUrl", returnUrl != null ? returnUrl : request.getContextPath() + "/");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Verify login
            User user = UserDAO.verifyLogin(email.trim(), password);
            
            if (user != null) {
                // Login successful - create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to return URL or home
                String redirectUrl = returnUrl != null && !returnUrl.isEmpty() ? 
                    returnUrl : request.getContextPath() + "/";
                response.sendRedirect(redirectUrl);
            } else {
                // Login failed
                request.setAttribute("error", "Email hoặc mật khẩu không chính xác");
                request.setAttribute("email", email);
                request.setAttribute("returnUrl", returnUrl != null ? returnUrl : request.getContextPath() + "/");
                request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi đăng nhập: " + e.getMessage());
            request.setAttribute("returnUrl", returnUrl != null ? returnUrl : request.getContextPath() + "/");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }
}

