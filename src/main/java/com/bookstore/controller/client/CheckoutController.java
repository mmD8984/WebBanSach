package com.bookstore.controller.client;

import com.bookstore.dao.CartDAO;
import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Cart;
import com.bookstore.model.CartItem;
import com.bookstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private CartDAO cartDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        cartDAO = new CartDAO(conn);
        orderDAO = new OrderDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            req.getSession().setAttribute("redirectAfterLogin", req.getContextPath() + "/checkout");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy cart items
        Cart cart = cartDAO.findByUserId(userId);
        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        List<CartItem> items = cartDAO.getCartItems(cart.getId());
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal total = cartDAO.getCartTotal(cart.getId());

        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.setAttribute("itemCount", items.size());

        req.getRequestDispatcher("/pages/client/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin form
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");
        String note = req.getParameter("note");

        // Validation
        if (fullName == null || fullName.isBlank() ||
            phone == null || phone.isBlank() ||
            address == null || address.isBlank()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            doGet(req, resp);
            return;
        }

        // Lấy cart
        Cart cart = cartDAO.findByUserId(userId);
        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        List<CartItem> items = cartDAO.getCartItems(cart.getId());
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal total = cartDAO.getCartTotal(cart.getId());

        // Tạo order
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(total);
        order.setStatus("pending");
        order.setShippingAddress(address + " - " + fullName + " - " + phone);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "cod");
        order.setPaymentStatus("pending");
        order.setNote(note);

        // Tạo mã đơn hàng
        String orderCode = "ORD" + System.currentTimeMillis();
        order.setOrderCode(orderCode);

        boolean success = orderDAO.insert(order);

        if (success) {
            // Clear cart
            cartDAO.clearCart(cart.getId());

            req.getSession().setAttribute("lastOrderCode", orderCode);
            resp.sendRedirect(req.getContextPath() + "/order-success");
        } else {
            req.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            doGet(req, resp);
        }
    }
}
