package com.bookstore.controller.admin;

import com.bookstore.dao.RevenueDAO;
import com.bookstore.model.RevenueStat;
import com.bookstore.service.RevenueService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin-revenue")
public class RevenueController extends HttpServlet {

    private RevenueService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        RevenueDAO dao = new RevenueDAO(conn);
        service = new RevenueService(dao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<RevenueStat> weekly = service.getWeeklyRevenue();
        List<RevenueStat> monthly = service.getMonthlyRevenue();

        req.setAttribute("weeklyRevenue", weekly);
        req.setAttribute("monthlyRevenue", monthly);

        req.getRequestDispatcher("/pages/admin/admin-revenue.jsp")
           .forward(req, resp);
    }
}
