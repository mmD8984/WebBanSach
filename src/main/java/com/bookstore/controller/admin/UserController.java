package com.bookstore.controller.admin;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin-user")
public class UserController extends HttpServlet {

    private UserService service;

    @Override
    public void init() throws ServletException {
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        UserDAO dao = new UserDAO(conn);
        service = new UserService(dao);
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
                deleteUser(req, resp);
                break;
            default: // list
                listUsers(req, resp);
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
                createUser(req, resp);
                break;
            case "update":
                updateUser(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin-user");
                break;
        }
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("userList", service.getAllUsers());

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

        req.getRequestDispatcher("/pages/admin/admin-user.jsp")
           .forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        User user = service.getById(id);

        req.setAttribute("user", user);
        req.setAttribute("userList", service.getAllUsers());

        req.getRequestDispatcher("/pages/admin/admin-user.jsp")
           .forward(req, resp);
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = service.delete(id);

        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("message", "Xóa người dùng thành công");
        } else {
            session.setAttribute("error", "Xóa người dùng thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin-user");
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User u = buildUserFromRequest(req, false);

        boolean ok = service.create(u);
        if (ok) {
            req.getSession().setAttribute("message", "Thêm người dùng thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-user");
        } else {
            req.setAttribute("error", "Thêm người dùng thất bại");
            listUsers(req, resp);
        }
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User u = buildUserFromRequest(req, true);

        boolean ok = service.update(u);
        if (ok) {
            req.getSession().setAttribute("message", "Cập nhật người dùng thành công");
            resp.sendRedirect(req.getContextPath() + "/admin-user");
        } else {
            req.setAttribute("error", "Cập nhật người dùng thất bại");
            showEditForm(req, resp);
        }
    }

    private User buildUserFromRequest(HttpServletRequest req, boolean hasId) {
        User u = new User();

        if (hasId) {
            u.setId(Integer.parseInt(req.getParameter("id")));
        }

        u.setEmail(req.getParameter("email"));
        u.setFullName(req.getParameter("fullName"));
        u.setPhone(req.getParameter("phone"));
        u.setRole(req.getParameter("role"));

        String activeStr = req.getParameter("active");
        u.setActive("on".equals(activeStr) || "true".equalsIgnoreCase(activeStr));

        // Password: khi tạo mới bắt buộc nhập, khi sửa nếu để trống thì không đổi
        String password = req.getParameter("password");
        if (!hasId || (password != null && !password.isBlank())) {
            // ở đây dùng plain text hoặc tự bạn thêm hash (BCrypt, SHA-256...) trước khi set
            u.setPasswordHash(password);
        } else {
            u.setPasswordHash(null); // để DAO biết là không update cột password_hash
        }

        return u;
    }
}
