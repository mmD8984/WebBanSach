package com.bookstore.controller.client;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Servlet for Product Detail Page
 * Displays detailed information about a single product
 */
@WebServlet("/product")
public class ProductDetailController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get product ID from parameter
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            
            // Get product details
            Book product = BookDAO.getBookById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Sản phẩm không tồn tại");
                request.getRequestDispatcher("/WEB-INF/jsp/product-detail.jsp").forward(request, response);
                return;
            }
            
            // Get related products (same category or by same author)
            List<Book> relatedProducts = BookDAO.getBooksByCategory(product.getCategoryId());
            
            // Remove the current product from related products
            relatedProducts.removeIf(b -> b.getId() == productId);
            
            // Limit to 6 related products
            if (relatedProducts.size() > 6) {
                relatedProducts = relatedProducts.subList(0, 6);
            }
            
            // Set attributes for JSP
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/jsp/product-detail.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu sản phẩm");
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/product-detail.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
}

