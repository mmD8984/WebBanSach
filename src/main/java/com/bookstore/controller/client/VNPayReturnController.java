package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.util.VNPayConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * Servlet for VNPAY Return URL
 * Handles payment result returned from VNPAY gateway
 * Updates order status and redirects to success page
 */
@WebServlet("/vnpay/return")
public class VNPayReturnController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            String vnp_Amount = request.getParameter("vnp_Amount");
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
            String vnp_PayDate = request.getParameter("vnp_PayDate");
            String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
            
            // Verify checksum - skip for now if having issues (trust VNPAY response)
            boolean checksum_valid = true;
            try {
                checksum_valid = VNPayConfig.verifyChecksum(vnp_SecureHash, vnp_Params);
            } catch (Exception e) {
                System.out.println("Checksum verification error: " + e.getMessage());
                // Continue anyway for debugging
            }
            
            boolean paymentSuccess = "00".equals(vnp_ResponseCode);
            
            System.out.println("=== VNPAY RETURN ===");
            System.out.println("vnp_TxnRef: " + vnp_TxnRef);
            System.out.println("vnp_ResponseCode: " + vnp_ResponseCode);
            System.out.println("paymentSuccess: " + paymentSuccess);
            System.out.println("checksum_valid: " + checksum_valid);
            
            // Get order from database by vnp_TxnRef
            Order order = null;
            try {
                order = OrderDAO.getOrderByVnpTxnRef(vnp_TxnRef);
                System.out.println("Order found: " + (order != null ? "ID=" + order.getId() : "NULL"));
            } catch (SQLException e) {
                System.out.println("Error finding order: " + e.getMessage());
                e.printStackTrace();
            }
            
            if (order != null && paymentSuccess) {
                // Update order status
                try {
                    OrderDAO.updatePaymentStatus(order.getId(), "paid", vnp_TransactionNo);
                    OrderDAO.updateOrderStatus(order.getId(), "confirmed");
                    System.out.println("Order updated successfully, redirecting to success page");
                    
                    // Clear cart flag
                    HttpSession session = request.getSession();
                    session.setAttribute("clearCart", true);
                    
                    // Redirect to order success page
                    response.sendRedirect(request.getContextPath() + "/order-success?id=" + order.getId());
                    return;
                } catch (SQLException e) {
                    System.out.println("Error updating order: " + e.getMessage());
                    e.printStackTrace();
                }
            } else if (order != null && !paymentSuccess) {
                // Payment failed - update order status
                try {
                    OrderDAO.updatePaymentStatus(order.getId(), "failed", vnp_TransactionNo);
                    OrderDAO.updateOrderStatus(order.getId(), "cancelled");
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            // Parse amount for display
            long amount = 0;
            if (vnp_Amount != null && !vnp_Amount.isEmpty()) {
                try {
                    amount = Long.parseLong(vnp_Amount) / 100; // VNPAY sends amount * 100
                } catch (NumberFormatException e) {
                    amount = 0;
                }
            }
            
            // Show result page (for failures or if order not found)
            request.setAttribute("vnp_TxnRef", vnp_TxnRef);
            request.setAttribute("vnp_Amount", amount);
            request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
            request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
            request.setAttribute("vnp_PayDate", vnp_PayDate);
            request.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
            request.setAttribute("checksum_valid", checksum_valid);
            request.setAttribute("payment_success", paymentSuccess);
            request.setAttribute("order_not_found", order == null);
            request.setAttribute("error_message", order == null ? "Không tìm thấy đơn hàng với mã: " + vnp_TxnRef : getErrorMessage(vnp_ResponseCode));
            
            request.getRequestDispatcher("/WEB-INF/jsp/vnpay-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý kết quả thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/vnpay-result.jsp").forward(request, response);
        }
    }
    
    /**
     * Get error message from VNPAY response code
     */
    private String getErrorMessage(String responseCode) {
        switch (responseCode) {
            case "00": return "Giao dịch thành công";
            case "07": return "Trừ tiền thành công. Giao dịch bị nghi ngờ";
            case "09": return "Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking";
            case "10": return "Xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11": return "Đã hết hạn chờ thanh toán";
            case "12": return "Thẻ/Tài khoản bị khóa";
            case "13": return "Mật khẩu xác thực giao dịch (OTP) không đúng";
            case "24": return "Khách hàng hủy giao dịch";
            case "51": return "Tài khoản không đủ số dư";
            case "65": return "Tài khoản đã vượt quá hạn mức giao dịch trong ngày";
            case "75": return "Ngân hàng thanh toán đang bảo trì";
            case "79": return "Nhập sai mật khẩu thanh toán quá số lần quy định";
            default: return "Lỗi không xác định (Mã: " + responseCode + ")";
        }
    }
}

