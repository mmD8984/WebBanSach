package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Category;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Home Page Servlet
 * Displays featured products, categories, and bestsellers
 */
@WebServlet("/")
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get categories
            List<Category> categories = CategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
            // Get featured products
            List<Book> featured = BookDAO.getFeaturedBooks();
            request.setAttribute("featured", featured);
            
            // Get bestseller products
            List<Book> bestsellers = BookDAO.getBestsellerBooks();
            request.setAttribute("bestsellers", bestsellers);
            
            // Get new products
            List<Book> newBooks = BookDAO.getNewBooks();
            request.setAttribute("newBooks", newBooks);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu");
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/home.jsp").forward(request, response);
    }
}

