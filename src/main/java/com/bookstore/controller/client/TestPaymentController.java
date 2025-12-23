package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import com.bookstore.model.User;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Test Payment Servlet
 * Handles test payment - immediately marks as paid for testing purposes
 */
@WebServlet("/api/test-payment")
public class TestPaymentController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"error\": \"Vui lòng đăng nhập\"}");
                return;
            }
            
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();
            
            // Extract order details
            String fullname = json.get("fullname").getAsString();
            String phone = json.get("phone").getAsString();
            String email = json.get("email").getAsString();
            String address = json.get("address").getAsString();
            String shippingMethod = json.has("shipping") ? json.get("shipping").getAsString() : "standard";
            String notes = json.has("notes") ? json.get("notes").getAsString() : "";
            long total = json.get("total").getAsLong();
            
            // Create order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setFullname(fullname);
            order.setPhone(phone);
            order.setEmail(email);
            order.setAddress(address);
            order.setShippingMethod(shippingMethod);
            order.setPaymentMethod("test");
            order.setTotal(total);
            order.setStatus("confirmed"); // Immediately confirmed
            order.setPaymentStatus("paid"); // Immediately paid
            order.setNotes(notes);
            
            int orderId = OrderDAO.createOrder(order);
            
            if (orderId > 0) {
                // Create order items from cart
                JsonArray items = json.getAsJsonArray("items");
                List<OrderItem> orderItems = new ArrayList<>();
                
                for (int i = 0; i < items.size(); i++) {
                    JsonObject item = items.get(i).getAsJsonObject();
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setBookId(item.get("id").getAsInt());
                    orderItem.setBookTitle(item.has("title") ? item.get("title").getAsString() : "");
                    orderItem.setQuantity(item.get("quantity").getAsInt());
                    orderItem.setPrice(item.get("price").getAsLong());
                    orderItems.add(orderItem);
                }
                
                if (!orderItems.isEmpty()) {
                    OrderDAO.createOrderItems(orderId, orderItems);
                }
                
                // Success response
                JsonObject result = new JsonObject();
                result.addProperty("success", true);
                result.addProperty("orderId", orderId);
                result.addProperty("message", "Đặt hàng thành công! (Test Payment)");
                result.addProperty("redirectUrl", request.getContextPath() + "/order-success?id=" + orderId);
                
                response.getWriter().write(result.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"error\": \"Lỗi tạo đơn hàng\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

