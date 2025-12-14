package com.bookstore.controller.admin;

import com.bookstore.dao.DashboardDAO;
import com.bookstore.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin-dashboard")
public class DashboardController extends HttpServlet {

    private DashboardService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        DashboardDAO dao = new DashboardDAO(conn);
        service = new DashboardService(dao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("totalUsers", service.getTotalUsers());
        req.setAttribute("activeUsers", service.getActiveUsers());

        req.setAttribute("totalBooks", service.getTotalBooks());
        req.setAttribute("activeBooks", service.getActiveBooks());

        req.setAttribute("totalOrders", service.getTotalOrders());
        req.setAttribute("pendingOrders", service.getPendingOrders());

        req.setAttribute("totalCategories", service.getTotalCategories());
        
        String[] latestBook = service.getLatestBook();
        if (latestBook != null) {
            req.setAttribute("latestBookTitle", latestBook[0]);
            req.setAttribute("latestBookPrice", latestBook[1]);
        } else {
            req.setAttribute("latestBookTitle", "Chưa có");
            req.setAttribute("latestBookPrice", "");
        }
        
        String[] latestUser = service.getLatestUser();
        if (latestUser != null) {
            req.setAttribute("latestUserName", latestUser[0]);
            req.setAttribute("latestUserPhone", latestUser[1] != null ? latestUser[1] : "Chưa cập nhật");
        } else {
            req.setAttribute("latestUserName", "Chưa có");
            req.setAttribute("latestUserPhone", "");
        }
        
        req.getRequestDispatcher("/pages/admin/admin-dashboard.jsp")
           .forward(req, resp);
    }
}
