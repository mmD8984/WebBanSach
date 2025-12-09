package com.bookstore.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for Contact Page
 * Handles contact form submissions and displays contact information
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            // TODO: In a real application, you would:
            // 1. Save to database
            // 2. Send email notification to admin
            // 3. Send confirmation email to user
            
            // For now, just show success message
            request.setAttribute("success", "Cảm ơn bạn đã gửi thông tin. Chúng tôi sẽ liên hệ với bạn sớm nhất.");
            request.getRequestDispatcher("/WEB-INF/jsp/contact.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/contact.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
}

