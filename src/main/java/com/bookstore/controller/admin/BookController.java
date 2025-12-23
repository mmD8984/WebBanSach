package com.bookstore.controller.admin;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.dao.AuthorDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Category;
import com.bookstore.model.Author;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Admin Book Controller
 * Handles CRUD operations for books in admin panel
 */
@WebServlet("/admin-book")
public class BookController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteBook(req, resp);
                    break;
                default:
                    listBooks(req, resp);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                listBooks(req, resp);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "create":
                    createBook(req, resp);
                    break;
                case "update":
                    updateBook(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin-book");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                listBooks(req, resp);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }

    private void listBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        
        List<Book> books = BookDAO.getAllBooks();
        List<Category> categories = CategoryDAO.getAllCategories();
        List<Author> authors = AuthorDAO.getAllAuthors();
        
        req.setAttribute("bookList", books);
        req.setAttribute("categoryList", categories);
        req.setAttribute("authorList", authors);

        // Check for flash messages
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

        req.getRequestDispatcher("/pages/admin/admin-book.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        
        int id = Integer.parseInt(req.getParameter("id"));
        Book book = BookDAO.getBookById(id);

        req.setAttribute("book", book);
        
        List<Book> books = BookDAO.getAllBooks();
        List<Category> categories = CategoryDAO.getAllCategories();
        List<Author> authors = AuthorDAO.getAllAuthors();
        
        req.setAttribute("bookList", books);
        req.setAttribute("categoryList", categories);
        req.setAttribute("authorList", authors);

        req.getRequestDispatcher("/pages/admin/admin-book.jsp").forward(req, resp);
    }

    private void deleteBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = BookDAO.deleteBook(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa sách thành công");
        } else {
            session.setAttribute("error", "Xóa sách thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-book");
    }

    private void createBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException, SQLException {
        
        Book book = buildBookFromRequest(req);

        boolean ok = BookDAO.insertBook(book);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm sách thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-book");
        } else {
            req.setAttribute("error", "Thêm sách thất bại");
            listBooks(req, resp);
        }
    }

    private void updateBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException, SQLException {
        
        Book book = buildBookFromRequest(req);
        book.setId(Integer.parseInt(req.getParameter("id")));

        boolean ok = BookDAO.updateBook(book);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật sách thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-book");
        } else {
            req.setAttribute("error", "Cập nhật sách thất bại");
            showEditForm(req, resp);
        }
    }

    private Book buildBookFromRequest(HttpServletRequest req) {
        Book book = new Book();

        book.setTitle(req.getParameter("title"));
        book.setDescription(req.getParameter("description"));

        // Parse price
        String priceStr = req.getParameter("price");
        if (priceStr != null && !priceStr.isBlank()) {
            book.setPrice(Long.parseLong(priceStr));
        }

        // Parse original price
        String originalPriceStr = req.getParameter("originalPrice");
        if (originalPriceStr != null && !originalPriceStr.isBlank()) {
            book.setOriginalPrice(Long.parseLong(originalPriceStr));
        }

        // Parse stock
        String stockStr = req.getParameter("stock");
        if (stockStr != null && !stockStr.isBlank()) {
            book.setStock(Integer.parseInt(stockStr));
        }

        book.setImage(req.getParameter("image"));

        // Parse category ID
        String categoryStr = req.getParameter("categoryId");
        if (categoryStr != null && !categoryStr.isBlank()) {
            book.setCategoryId(Integer.parseInt(categoryStr));
        }

        // Parse author ID
        String authorStr = req.getParameter("authorId");
        if (authorStr != null && !authorStr.isBlank()) {
            book.setAuthorId(Integer.parseInt(authorStr));
        }

        // Parse flags
        book.setFeatured("on".equals(req.getParameter("featured")));
        book.setBestseller("on".equals(req.getParameter("bestseller")));
        book.setNew("on".equals(req.getParameter("isNew")));
        
        // Set status based on stock
        book.setStatus(book.getStock() > 0 ? "available" : "out_of_stock");

        return book;
    }
}
