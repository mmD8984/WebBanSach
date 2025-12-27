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
import java.util.stream.Collectors;

@WebServlet("/books")
public class BookListController extends HttpServlet {

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
        
        // Lấy parameters
        String categoryIdStr = req.getParameter("category");
        String searchQuery = req.getParameter("q");
        String sortBy = req.getParameter("sort");

        // Lấy tất cả sách
        List<Book> allBooks = bookDAO.getAll().stream()
            .filter(Book::isActive)
            .collect(Collectors.toList());

        // Filter by category
        if (categoryIdStr != null && !categoryIdStr.isBlank()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                allBooks = allBooks.stream()
                    .filter(b -> b.getCategoryId() != null && b.getCategoryId() == categoryId)
                    .collect(Collectors.toList());
                req.setAttribute("selectedCategory", categoryId);
            } catch (NumberFormatException ignored) {}
        }

        // Filter by search query
        if (searchQuery != null && !searchQuery.isBlank()) {
            String query = searchQuery.toLowerCase().trim();
            allBooks = allBooks.stream()
                .filter(b -> 
                    b.getTitle().toLowerCase().contains(query) ||
                    (b.getAuthorNames() != null && b.getAuthorNames().toLowerCase().contains(query)) ||
                    (b.getDescription() != null && b.getDescription().toLowerCase().contains(query))
                )
                .collect(Collectors.toList());
            req.setAttribute("searchQuery", searchQuery);
        }

        // Sort
        if ("price_asc".equals(sortBy)) {
            allBooks.sort((a, b) -> a.getPrice().compareTo(b.getPrice()));
        } else if ("price_desc".equals(sortBy)) {
            allBooks.sort((a, b) -> b.getPrice().compareTo(a.getPrice()));
        } else if ("name".equals(sortBy)) {
            allBooks.sort((a, b) -> a.getTitle().compareToIgnoreCase(b.getTitle()));
        }
        req.setAttribute("sortBy", sortBy);

        // Lấy categories cho filter
        List<Category> categories = categoryDAO.getAll();

        req.setAttribute("books", allBooks);
        req.setAttribute("categories", categories);
        req.setAttribute("totalBooks", allBooks.size());

        req.getRequestDispatcher("/pages/client/book-list.jsp").forward(req, resp);
    }
}
