package com.bookstore.controller.client;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(urlPatterns = {"/my-orders", "/order-success"})
public class ClientOrderController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        orderDAO = new OrderDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String path = req.getServletPath();

        if ("/order-success".equals(path)) {
            showOrderSuccess(req, resp);
        } else {
            showMyOrders(req, resp);
        }
    }

    private void showOrderSuccess(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String orderCode = (String) req.getSession().getAttribute("lastOrderCode");
        req.setAttribute("orderCode", orderCode);
        req.getSession().removeAttribute("lastOrderCode");

        req.getRequestDispatcher("/pages/client/order-success.jsp").forward(req, resp);
    }

    private void showMyOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            req.getSession().setAttribute("redirectAfterLogin", req.getContextPath() + "/my-orders");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Order> orders = orderDAO.getByUserId(userId);
        req.setAttribute("orders", orders);

        req.getRequestDispatcher("/pages/client/my-orders.jsp").forward(req, resp);
    }
}
