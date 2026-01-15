package com.bookstore.controller.client;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(urlPatterns = {"", "/"})
public class HomeController extends HttpServlet {

    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        bookDAO = new BookDAO(conn);
        categoryDAO = new CategoryDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Lấy danh sách sách (giới hạn 8 cho trang chủ)
        List<Book> allBooks = bookDAO.getAll();
        List<Book> featuredBooks = allBooks.stream()
            .filter(Book::isActive)
            .limit(8)
            .toList();

        // Lấy danh sách categories
        List<Category> categories = categoryDAO.getAll();

        req.setAttribute("featuredBooks", featuredBooks);
        req.setAttribute("categories", categories);
        req.setAttribute("totalBooks", allBooks.size());

        req.getRequestDispatcher("/pages/client/home.jsp").forward(req, resp);
    }
}
