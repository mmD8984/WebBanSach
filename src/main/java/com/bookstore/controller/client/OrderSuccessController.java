package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Order Success Servlet
 * Displays order confirmation after successful payment
 */
@WebServlet("/order-success")
public class OrderSuccessController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = OrderDAO.getOrderById(orderId);
                
                if (order != null) {
                    // Get order items
                    List<OrderItem> items = OrderDAO.getOrderItems(orderId);
                    order.setItems(items);
                    request.setAttribute("order", order);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/order-success.jsp").forward(request, response);
    }
}

