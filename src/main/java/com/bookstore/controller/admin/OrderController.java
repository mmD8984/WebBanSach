package com.bookstore.controller.admin;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import com.bookstore.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;

@WebServlet("/admin-order")
public class OrderController extends HttpServlet {

    private OrderService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        OrderDAO dao = new OrderDAO(conn);
        service = new OrderService(dao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteOrder(req, resp);
                break;
            default: // list
                listOrders(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                createOrder(req, resp);
                break;
            case "update":
                updateOrder(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin-order");
                break;
        }
    }

    private void listOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("orderList", service.getAllOrders());

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object msg = session.getAttribute("message");
            Object err = session.getAttribute("error");
            if (msg != null) {
                req.setAttribute("message", msg);
                session.removeAttribute("message");
            }
            if (err != null) {
                req.setAttribute("error", err);
                session.removeAttribute("error");
            }
        }

        req.getRequestDispatcher("/pages/admin/admin-order.jsp")
           .forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Order order = service.getById(id);

        req.setAttribute("order", order);
        req.setAttribute("orderList", service.getAllOrders());

        req.getRequestDispatcher("/pages/admin/admin-order.jsp")
           .forward(req, resp);
    }

    private void deleteOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = service.delete(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa đơn hàng thành công");
        } else {
            session.setAttribute("error", "Xóa đơn hàng thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-order");
    }

    // Thường admin chỉ cập nhật trạng thái/thanh toán, nhưng vẫn để create/update tổng quát
    private void createOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Order o = buildOrderFromRequest(req, false);

        boolean ok = service.create(o);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm đơn hàng thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-order");
        } else {
            req.setAttribute("error", "Thêm đơn hàng thất bại");
            listOrders(req, resp);
        }
    }

    private void updateOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Order o = buildOrderFromRequest(req, true);

        boolean ok = service.update(o);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật đơn hàng thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-order");
        } else {
            req.setAttribute("error", "Cập nhật đơn hàng thất bại");
            showEditForm(req, resp);
        }
    }

    private Order buildOrderFromRequest(HttpServletRequest req, boolean hasId) {
        Order o = new Order();

        if (hasId) {
            o.setId(Integer.parseInt(req.getParameter("id")));
        }

        String userIdStr = req.getParameter("userId");
        Integer userId = null;
        if (userIdStr != null && !userIdStr.isBlank()) {
            int v = Integer.parseInt(userIdStr);
            if (v != 0) userId = v;
        }
        o.setUserId(userId);

        String totalStr = req.getParameter("totalAmount");
        BigDecimal total = BigDecimal.ZERO;
        if (totalStr != null && !totalStr.isBlank()) {
            total = new BigDecimal(totalStr);
        }
        o.setTotalAmount(total);

        o.setStatus(req.getParameter("status"));
        o.setShippingAddress(req.getParameter("shippingAddress"));
        o.setPaymentMethod(req.getParameter("paymentMethod"));
        o.setPaymentStatus(req.getParameter("paymentStatus"));
        o.setNote(req.getParameter("note"));

        // order_code được trigger sinh tự động, không set ở đây

        return o;
    }
}
