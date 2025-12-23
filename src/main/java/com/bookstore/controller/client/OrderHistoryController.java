package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import com.bookstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Order History Servlet
 * Displays user's order history
 */
@WebServlet("/orders")
public class OrderHistoryController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=/orders");
            return;
        }
        
        try {
            // Get all orders for this user
            List<Order> orders = OrderDAO.getOrdersByUserId(user.getId());
            
            // Get order items for each order
            for (Order order : orders) {
                List<OrderItem> items = OrderDAO.getOrderItems(order.getId());
                order.setItems(items);
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/jsp/order-history.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải lịch sử đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/order-history.jsp").forward(request, response);
        }
    }
}

