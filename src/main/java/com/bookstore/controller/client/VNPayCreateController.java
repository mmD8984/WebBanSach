package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import com.bookstore.model.User;
import com.bookstore.util.VNPayConfig;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.lang.reflect.Type;

/**
 * Servlet for Creating VNPAY Payment URL
 * Receives order information and creates payment URL to redirect to VNPAY gateway
 */
@WebServlet("/vnpay/create")
public class VNPayCreateController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("application/json");
            
            // Get order information from request
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String shippingMethod = request.getParameter("shipping");
            String orderTotal = request.getParameter("total");
            
            // Validate required fields
            if (fullname == null || fullname.isEmpty() ||
                phone == null || phone.isEmpty() ||
                email == null || email.isEmpty() ||
                address == null || address.isEmpty() ||
                orderTotal == null || orderTotal.isEmpty()) {
                
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Missing required fields\"}");
                return;
            }
            
            // Parse order amount
            long orderAmount;
            try {
                orderAmount = Long.parseLong(orderTotal);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid amount\"}");
                return;
            }
            
            // VNPAY Parameters
            String vnp_Version = VNPayConfig.vnp_Version;
            String vnp_Command = "pay";
            String vnp_TmnCode = VNPayConfig.vnp_TmnCode;
            String vnp_IpAddr = VNPayConfig.getIpAddress(request);
            String vnp_TxnRef = VNPayConfig.getRandomNumber(8);
            String vnp_OrderInfo = "Thanh toan don hang: " + fullname + " - " + phone;
            String vnp_OrderType = "other";
            String vnp_Locale = "vn";
            
            // Format amount (multiply by 100 as VNPAY requires)
            String vnp_Amount = String.valueOf(VNPayConfig.formatAmount(orderAmount));
            
            // Create current datetime for vnp_CreateDate (GMT+7)
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            
            // Set expire date (15 minutes from now)
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            
            // Build parameters map
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", vnp_Amount);
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", vnp_OrderType);
            vnp_Params.put("vnp_Locale", vnp_Locale);
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
            
            // Note: Optional billing fields removed for simplicity
            // VNPAY basic payment only requires mandatory fields
            
            // Build query string and secure hash - EXACTLY as per VNPAY sample
            String[] paymentData = VNPayConfig.buildPaymentData(vnp_Params);
            String queryUrl = paymentData[0];
            String vnp_SecureHash = paymentData[1];
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;
            
            // Get session and user info
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }
            
            // Get cart items from request
            String cartItemsJson = request.getParameter("cartItems");
            List<Map<String, Object>> cartItems = new ArrayList<>();
            if (cartItemsJson != null && !cartItemsJson.isEmpty()) {
                Gson gson = new Gson();
                Type listType = new TypeToken<List<Map<String, Object>>>(){}.getType();
                cartItems = gson.fromJson(cartItemsJson, listType);
            }
            
            // Create order in database with status "pending"
            Order order = new Order();
            order.setUserId(user.getId());
            order.setFullname(fullname);
            order.setPhone(phone);
            order.setEmail(email);
            order.setAddress(address + (city != null ? ", " + city : "") + (district != null ? ", " + district : ""));
            order.setShippingMethod(shippingMethod != null ? shippingMethod : "standard");
            order.setPaymentMethod("vnpay");
            order.setTotal(orderAmount);
            order.setStatus("pending");
            order.setPaymentStatus("pending");
            order.setVnpTxnRef(vnp_TxnRef);
            
            // Create order items list
            List<OrderItem> orderItems = new ArrayList<>();
            for (Map<String, Object> item : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setBookId(((Number) item.get("id")).intValue());
                orderItem.setBookTitle((String) item.get("title"));
                orderItem.setQuantity(((Number) item.get("quantity")).intValue());
                orderItem.setPrice(((Number) item.get("price")).longValue());
                orderItems.add(orderItem);
            }
            
            // Save order to database
            int orderId = OrderDAO.createOrder(order, orderItems);
            
            if (orderId <= 0) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to create order\"}");
                return;
            }
            
            // Store order ID in session for later
            session.setAttribute("vnp_TxnRef", vnp_TxnRef);
            session.setAttribute("pendingOrderId", orderId);
            
            // Return success response with payment URL
            response.getWriter().write("{\"success\": true, \"paymentUrl\": \"" + paymentUrl + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

