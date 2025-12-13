package com.bookstore.controller.admin;

import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Category;
import com.bookstore.service.CategoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin-category")
public class CategoryController extends HttpServlet {

    private CategoryService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        CategoryDAO dao = new CategoryDAO(conn);
        service = new CategoryService(dao);
    }

//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
//            throws ServletException, IOException {
//
//        req.setAttribute("categoryList", service.getAllCategories());
//
//        req.getRequestDispatcher("/pages/admin/admin-category.jsp")
//           .forward(req, resp);
//    }
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
                deleteCategory(req, resp);
                break;
            default: // list
                listCategories(req, resp);
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
                createCategory(req, resp);
                break;
            case "update":
                updateCategory(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin-category");
                break;
        }
    }
    
    private void listCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categoryList", service.getAllCategories());

        // lấy message/error từ session để hiển thị 1 lần rồi xóa
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

        req.getRequestDispatcher("/pages/admin/admin-category.jsp")
           .forward(req, resp);
    }
    
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Category category = service.getById(id);

        req.setAttribute("category", category);
        req.setAttribute("categoryList", service.getAllCategories());

        req.getRequestDispatcher("/pages/admin/admin-category.jsp")
           .forward(req, resp);
    }
    
    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = service.delete(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa danh mục thành công");
        } else {
            session.setAttribute("error", "Xóa danh mục thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-category");
    }
    
    private void createCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Category c = buildCategoryFromRequest(req, false);

        boolean ok = service.create(c);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm danh mục thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-category");
        } else {
            req.setAttribute("error", "Thêm danh mục thất bại");
            listCategories(req, resp);
        }
    }
    
    private void updateCategory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Category c = buildCategoryFromRequest(req, true);

        boolean ok = service.update(c);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật danh mục thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-category");
        } else {
            req.setAttribute("error", "Cập nhật danh mục thất bại");
            showEditForm(req, resp);
        }
    }
    
    private Category buildCategoryFromRequest(HttpServletRequest req, boolean hasId) {
        Category c = new Category();

        if (hasId) {
            c.setId(Integer.parseInt(req.getParameter("id")));
        }

        c.setName(req.getParameter("name"));
        c.setSlug(req.getParameter("slug"));
        c.setDescription(req.getParameter("description"));
        return c;
    }
}
