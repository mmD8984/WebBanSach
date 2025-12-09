package com.bookstore.servlet;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

/**
 * Servlet for Checkout Process
 * Handles 4-step checkout: customer info -> shipping -> payment -> confirmation
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to checkout JSP (checkout page)
        request.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            if ("place_order".equals(action)) {
                // Get order data from request
                String fullname = request.getParameter("fullname");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                String district = request.getParameter("district");
                String notes = request.getParameter("notes");
                String shipping = request.getParameter("shipping");
                String payment = request.getParameter("payment");
                String cartJson = request.getParameter("cartItems");
                long total = Long.parseLong(request.getParameter("total"));
                
                // Validate required fields
                if (fullname == null || fullname.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    address == null || address.trim().isEmpty()) {
                    
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Missing required fields\"}");
                    return;
                }
                
                // Create order
                Order order = new Order();
                order.setFullname(fullname);
                order.setPhone(phone);
                order.setEmail(email);
                order.setAddress(address + ", " + district + ", " + city);
                order.setShippingMethod(shipping != null ? shipping : "standard");
                order.setPaymentMethod(payment != null ? payment : "cod");
                order.setTotal(total);
                order.setStatus("pending");
                order.setCreatedAt(LocalDateTime.now());
                
                // Save order to database
                int orderId = OrderDAO.createOrder(order);
                
                if (orderId > 0) {
                    // Success - return order ID
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": true, \"orderId\": " + orderId + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\": \"Failed to create order\"}");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try {
                response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try {
                response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}

