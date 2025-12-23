package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.util.VNPayConfig;
import com.google.gson.JsonObject;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * Servlet for VNPAY IPN (Instant Payment Notification)
 * Handles server-to-server callback from VNPAY to update order status
 * This is called by VNPAY server, NOT by user browser
 */
@WebServlet("/vnpay/ipn")
public class VNPayIPNController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("application/json");
            
            // Get all parameters from VNPAY
            Map<String, String> vnp_Params = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    vnp_Params.put(fieldName, fieldValue);
                }
            }
            
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            
            // Step 1: Verify checksum
            if (!VNPayConfig.verifyChecksum(vnp_SecureHash, vnp_Params)) {
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "97");
                job.addProperty("Message", "Invalid Checksum");
                response.getWriter().write(new Gson().toJson(job));
                return;
            }
            
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            String vnp_Amount = request.getParameter("vnp_Amount");
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
            
            // Step 2: Check if transaction exists in database
            // In this simple implementation, we'll assume vnp_TxnRef is the order ID
            // In production, you should lookup by vnp_TxnRef
            
            boolean checkOrderId = true; // TODO: Implement actual lookup
            if (!checkOrderId) {
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "01");
                job.addProperty("Message", "Order not Found");
                response.getWriter().write(new Gson().toJson(job));
                return;
            }
            
            // Step 3: Verify amount
            long amount = 0;
            if (vnp_Amount != null && !vnp_Amount.isEmpty()) {
                try {
                    amount = VNPayConfig.parseAmount(Long.parseLong(vnp_Amount));
                } catch (NumberFormatException e) {
                    // Invalid amount
                }
            }
            
            boolean checkAmount = true; // TODO: Implement actual amount verification
            if (!checkAmount) {
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "04");
                job.addProperty("Message", "Invalid Amount");
                response.getWriter().write(new Gson().toJson(job));
                return;
            }
            
            // Step 4: Check order status (should be pending)
            boolean checkOrderStatus = true; // TODO: Implement actual status check
            if (!checkOrderStatus) {
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "02");
                job.addProperty("Message", "Order already confirmed");
                response.getWriter().write(new Gson().toJson(job));
                return;
            }
            
            // Step 5: Update order status based on payment result
            try {
                if ("00".equals(vnp_ResponseCode)) {
                    // Payment successful - update order status to 'paid'
                    // TODO: Update order with vnp_TxnRef and vnp_TransactionNo
                    // OrderDAO.updatePaymentStatus(orderId, "paid", vnp_TransactionNo);
                    
                    JsonObject job = new JsonObject();
                    job.addProperty("RspCode", "00");
                    job.addProperty("Message", "Confirm Success");
                    response.getWriter().write(new Gson().toJson(job));
                } else {
                    // Payment failed - update order status to 'failed'
                    // TODO: Update order with failure status
                    // OrderDAO.updatePaymentStatus(orderId, "failed", vnp_TransactionNo);
                    
                    JsonObject job = new JsonObject();
                    job.addProperty("RspCode", "00");
                    job.addProperty("Message", "Confirm Success");
                    response.getWriter().write(new Gson().toJson(job));
                }
            } catch (Exception e) {
                e.printStackTrace();
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "99");
                job.addProperty("Message", "Unknow error: " + e.getMessage());
                response.getWriter().write(new Gson().toJson(job));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try {
                JsonObject job = new JsonObject();
                job.addProperty("RspCode", "99");
                job.addProperty("Message", "Unknow error");
                response.getWriter().write(new Gson().toJson(job));
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}

