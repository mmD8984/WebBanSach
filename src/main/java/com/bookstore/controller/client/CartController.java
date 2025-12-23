package com.bookstore.controller.client;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for Shopping Cart Page
 * Displays the shopping cart (client-side managed with localStorage/sessionStorage)
 */
@WebServlet("/cart")
public class CartController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // The cart page is mostly client-side managed using localStorage
        // This servlet just forwards to the cart.jsp view
        
        request.getRequestDispatcher("/WEB-INF/jsp/cart.jsp").forward(request, response);
    }
}

