package com.bookstore.controller.client;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.ReviewDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/book")
public class BookDetailController extends HttpServlet {

    private BookDAO bookDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        bookDAO = new BookDAO(conn);
        reviewDAO = new ReviewDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Book book = bookDAO.findById(id);

            if (book == null || !book.isActive()) {
                resp.sendRedirect(req.getContextPath() + "/books");
                return;
            }

            // Lấy reviews của sách
            List<Review> reviews = reviewDAO.getByBookId(id);
            double avgRating = reviewDAO.getAverageRating(id);
            int reviewCount = reviewDAO.countReviews(id);

            // Lấy sách liên quan (cùng category)
            List<Book> relatedBooks = bookDAO.getAll().stream()
                .filter(b -> b.isActive() && b.getId() != id)
                .filter(b -> book.getCategoryId() != null && 
                            b.getCategoryId() != null && 
                            b.getCategoryId().equals(book.getCategoryId()))
                .limit(4)
                .toList();

            req.setAttribute("book", book);
            req.setAttribute("reviews", reviews);
            req.setAttribute("avgRating", avgRating);
            req.setAttribute("reviewCount", reviewCount);
            req.setAttribute("relatedBooks", relatedBooks);

            req.getRequestDispatcher("/pages/client/book-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/books");
        }
    }
}
