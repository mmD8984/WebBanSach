package com.bookstore.servlets;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("message", "Chào mừng đến với Website Bán Sách!");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
