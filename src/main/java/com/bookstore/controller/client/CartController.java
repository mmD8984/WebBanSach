package com.bookstore.controller.client;

import com.bookstore.dao.CartDAO;
import com.bookstore.model.Cart;
import com.bookstore.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        cartDAO = new CartDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addToCart(req, resp);
            return;
        } else if ("remove".equals(action)) {
            removeFromCart(req, resp);
            return;
        }

        // Default: show cart
        showCart(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");

        if ("update".equals(action)) {
            updateQuantity(req, resp);
        } else if ("clear".equals(action)) {
            clearCart(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private void showCart(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        List<CartItem> items = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        if (userId != null) {
            Cart cart = cartDAO.findByUserId(userId);
            if (cart != null) {
                items = cartDAO.getCartItems(cart.getId());
                total = cartDAO.getCartTotal(cart.getId());
            }
        } else {
            // Session-based cart for guests
            @SuppressWarnings("unchecked")
            List<CartItem> sessionCart = (List<CartItem>) req.getSession().getAttribute("guestCart");
            if (sessionCart != null) {
                items = sessionCart;
                for (CartItem item : items) {
                    total = total.add(item.getSubtotal());
                }
            }
        }

        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.setAttribute("itemCount", items.size());

        req.getRequestDispatcher("/pages/client/cart.jsp").forward(req, resp);
    }

    private void addToCart(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        String bookIdStr = req.getParameter("bookId");
        String quantityStr = req.getParameter("quantity");

        if (bookIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        int quantity = 1;
        if (quantityStr != null && !quantityStr.isBlank()) {
            quantity = Integer.parseInt(quantityStr);
        }

        Integer userId = (Integer) req.getSession().getAttribute("userId");

        if (userId == null) {
            // Chưa đăng nhập - redirect to login với thông báo thân thiện
            req.getSession().setAttribute("redirectAfterLogin", 
                req.getContextPath() + "/cart?action=add&bookId=" + bookId + "&quantity=" + quantity);
            req.getSession().setAttribute("loginMessage", "Vui lòng đăng nhập để thêm sách vào giỏ hàng");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Logged in user - save to DB
        Cart cart = cartDAO.getOrCreateCart(userId);
        cartDAO.addItem(cart.getId(), bookId, quantity);

        req.getSession().setAttribute("message", "Đã thêm sách vào giỏ hàng!");
        resp.sendRedirect(req.getContextPath() + "/cart");
    }


    private void removeFromCart(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        String itemIdStr = req.getParameter("itemId");
        if (itemIdStr != null) {
            int itemId = Integer.parseInt(itemIdStr);
            cartDAO.removeItem(itemId);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void updateQuantity(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        String itemIdStr = req.getParameter("itemId");
        String quantityStr = req.getParameter("quantity");

        if (itemIdStr != null && quantityStr != null) {
            int itemId = Integer.parseInt(itemIdStr);
            int quantity = Integer.parseInt(quantityStr);
            cartDAO.updateItemQuantity(itemId, quantity);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void clearCart(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId != null) {
            Cart cart = cartDAO.findByUserId(userId);
            if (cart != null) {
                cartDAO.clearCart(cart.getId());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
