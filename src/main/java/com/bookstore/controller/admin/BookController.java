package com.bookstore.controller.admin;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;
import com.bookstore.service.BookService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;

@WebServlet("/admin-book")
public class BookController extends HttpServlet {

    private BookService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        BookDAO dao = new BookDAO(conn);
        service = new BookService(dao);
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
                deleteBook(req, resp);
                break;
            default: // list
                listBooks(req, resp);
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
                createBook(req, resp);
                break;
            case "update":
                updateBook(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin-book");
                break;
        }
    }

    private void listBooks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("bookList", service.getAllBooks());

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

        req.getRequestDispatcher("/pages/admin/admin-book.jsp")
           .forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Book book = service.getById(id);

        req.setAttribute("book", book);
        req.setAttribute("bookList", service.getAllBooks());

        req.getRequestDispatcher("/pages/admin/admin-book.jsp")
           .forward(req, resp);
    }

    private void deleteBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = service.delete(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa sách thành công");
        } else {
            session.setAttribute("error", "Xóa sách thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-book");
    }

    private void createBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Book b = buildBookFromRequest(req, false);

        boolean ok = service.create(b);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm sách thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-book");
        } else {
            req.setAttribute("error", "Thêm sách thất bại");
            listBooks(req, resp);
        }
    }

    private void updateBook(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Book b = buildBookFromRequest(req, true);

        boolean ok = service.update(b);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật sách thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-book");
        } else {
            req.setAttribute("error", "Cập nhật sách thất bại");
            showEditForm(req, resp);
        }
    }

    private Book buildBookFromRequest(HttpServletRequest req, boolean hasId) {
        Book b = new Book();

        if (hasId) {
            b.setId(Integer.parseInt(req.getParameter("id")));
        }

        b.setTitle(req.getParameter("title"));
        b.setDescription(req.getParameter("description"));

        String priceStr = req.getParameter("price");
        BigDecimal price = BigDecimal.ZERO;
        if (priceStr != null && !priceStr.isBlank()) {
            price = new BigDecimal(priceStr);
        }
        b.setPrice(price);

        String stockStr = req.getParameter("stockQuantity");
        int stock = 0;
        if (stockStr != null && !stockStr.isBlank()) {
            stock = Integer.parseInt(stockStr);
        }
        b.setStockQuantity(stock);

        b.setCoverImage(req.getParameter("coverImage"));

        String cateStr = req.getParameter("categoryId");
        Integer categoryId = null;
        if (cateStr != null && !cateStr.isBlank()) {
            int v = Integer.parseInt(cateStr);
            if (v != 0) categoryId = v;
        }
        b.setCategoryId(categoryId);

        String pubStr = req.getParameter("publisherId");
        Integer publisherId = null;
        if (pubStr != null && !pubStr.isBlank()) {
            int v = Integer.parseInt(pubStr);
            if (v != 0) publisherId = v;
        }
        b.setPublisherId(publisherId);

        String activeStr = req.getParameter("active");
        b.setActive("on".equals(activeStr) || "true".equalsIgnoreCase(activeStr));

        return b;
    }
}
