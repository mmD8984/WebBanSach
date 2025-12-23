package com.bookstore.controller.admin;

import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Admin Category Controller
 * Handles CRUD operations for categories in admin panel
 */
@WebServlet("/admin-category")
public class CategoryController extends HttpServlet {

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
                    deleteCategory(req, resp);
                    break;
                default:
                    listCategories(req, resp);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                listCategories(req, resp);
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
                    createCategory(req, resp);
                    break;
                case "update":
                    updateCategory(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin-category");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                listCategories(req, resp);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }

    private void listCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        
        List<Category> categories = CategoryDAO.getAllCategories();
        req.setAttribute("categoryList", categories);

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

        req.getRequestDispatcher("/pages/admin/admin-category.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        
        int id = Integer.parseInt(req.getParameter("id"));
        Category category = CategoryDAO.getCategoryById(id);

        req.setAttribute("category", category);
        
        List<Category> categories = CategoryDAO.getAllCategories();
        req.setAttribute("categoryList", categories);

        req.getRequestDispatcher("/pages/admin/admin-category.jsp").forward(req, resp);
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = CategoryDAO.deleteCategory(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa thể loại thành công");
        } else {
            session.setAttribute("error", "Xóa thể loại thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-category");
    }

    private void createCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException, SQLException {
        
        Category category = buildCategoryFromRequest(req);

        boolean ok = CategoryDAO.insertCategory(category);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm thể loại thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-category");
        } else {
            req.setAttribute("error", "Thêm thể loại thất bại");
            listCategories(req, resp);
        }
    }

    private void updateCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException, SQLException {
        
        Category category = buildCategoryFromRequest(req);
        category.setId(Integer.parseInt(req.getParameter("id")));

        boolean ok = CategoryDAO.updateCategory(category);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật thể loại thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-category");
        } else {
            req.setAttribute("error", "Cập nhật thể loại thất bại");
            showEditForm(req, resp);
        }
    }

    private Category buildCategoryFromRequest(HttpServletRequest req) {
        Category category = new Category();
        category.setName(req.getParameter("name"));
        category.setDescription(req.getParameter("description"));
        category.setIcon(req.getParameter("icon"));
        return category;
    }
}
