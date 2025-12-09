package com.bookstore.servlet;

import com.bookstore.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Check Login Servlet
 * API endpoint to check if user is logged in
 * Used by JavaScript to verify session before adding to cart
 */
@WebServlet("/api/check-login")
public class CheckLoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Check if user is in session
        HttpSession session = request.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user != null) {
            response.getWriter().write("{\"loggedIn\": true, \"userId\": " + user.getId() + "}");
        } else {
            response.getWriter().write("{\"loggedIn\": false}");
        }
    }
}

