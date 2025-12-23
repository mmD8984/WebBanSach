package com.bookstore.controller.client;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CategoryDAO;
import com.bookstore.dao.AuthorDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Category;
import com.bookstore.model.Author;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Servlet for Products Page
 * Handles browsing, filtering, searching, and pagination of products
 */
@WebServlet("/products")
public class ProductController extends HttpServlet {
    private static final int PAGE_SIZE = 12;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get request parameters
            String categoryParam = request.getParameter("category");
            String minPriceParam = request.getParameter("minPrice");
            String maxPriceParam = request.getParameter("maxPrice");
            String authorParam = request.getParameter("author");
            String searchQuery = request.getParameter("search");
            String sortParam = request.getParameter("sort");
            String pageParam = request.getParameter("page");
            
            // Default page is 1
            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Parse filter parameters
            Integer categoryId = null;
            Long minPrice = null;
            Long maxPrice = null;
            Integer authorId = null;
            
            if (categoryParam != null && !categoryParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    // Invalid category ID, ignore
                }
            }
            
            if (minPriceParam != null && !minPriceParam.isEmpty()) {
                try {
                    minPrice = Long.parseLong(minPriceParam);
                } catch (NumberFormatException e) {
                    // Invalid min price, ignore
                }
            }
            
            if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
                try {
                    maxPrice = Long.parseLong(maxPriceParam);
                } catch (NumberFormatException e) {
                    // Invalid max price, ignore
                }
            }
            
            if (authorParam != null && !authorParam.isEmpty()) {
                try {
                    authorId = Integer.parseInt(authorParam);
                } catch (NumberFormatException e) {
                    // Invalid author ID, ignore
                }
            }
            
            // Get all categories for filter sidebar
            List<Category> categories = CategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
            // Get all authors for filter sidebar
            List<Author> authors = AuthorDAO.getAllAuthors();
            request.setAttribute("authors", authors);
            
            List<Book> books;
            int totalBooks;
            
            boolean hasSearch = searchQuery != null && !searchQuery.trim().isEmpty();
            boolean hasFilter = categoryId != null || minPrice != null || maxPrice != null || authorId != null;
            boolean hasSort = sortParam != null && !sortParam.isEmpty();
            
            // Determine data source
            if (hasSearch) {
                // Search query provided
                books = BookDAO.searchBooks(searchQuery.trim());
                request.setAttribute("isSearch", true);
                request.setAttribute("searchQuery", searchQuery);
            } else if (hasFilter) {
                // Filters provided
                books = BookDAO.filterBooks(categoryId, minPrice, maxPrice, authorId);
                request.setAttribute("isFilter", true);
            } else if (hasSort) {
                // Only sort - get ALL books first, then sort
                books = BookDAO.getAllBooks();
            } else {
                // No filter, search, or sort - use pagination directly from DB
                totalBooks = BookDAO.getTotalBooks();
                books = BookDAO.getPaginatedBooks(currentPage, PAGE_SIZE);
                request.setAttribute("totalPages", (int) Math.ceil((double) totalBooks / PAGE_SIZE));
            }
            
            // Apply sorting if specified (for search, filter, or sort-only cases)
            if (hasSort && (hasSearch || hasFilter || (!hasSearch && !hasFilter))) {
                books = sortBooks(books, sortParam);
            }
            
            // Apply pagination for search, filter, or sort-only results
            if (hasSearch || hasFilter || hasSort) {
                totalBooks = books.size();
                int startIndex = (currentPage - 1) * PAGE_SIZE;
                int endIndex = Math.min(startIndex + PAGE_SIZE, totalBooks);
                
                if (startIndex < totalBooks) {
                    books = books.subList(startIndex, endIndex);
                } else {
                    books.clear();
                }
                
                request.setAttribute("totalPages", (int) Math.ceil((double) totalBooks / PAGE_SIZE));
            }
            
            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", PAGE_SIZE);
            
            // Set selected filter values
            if (categoryId != null) {
                request.setAttribute("selectedCategory", categoryId);
            }
            if (minPrice != null) {
                request.setAttribute("selectedMinPrice", minPrice);
            }
            if (maxPrice != null) {
                request.setAttribute("selectedMaxPrice", maxPrice);
            }
            if (authorId != null) {
                request.setAttribute("selectedAuthor", authorId);
            }
            if (sortParam != null) {
                request.setAttribute("selectedSort", sortParam);
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/jsp/products.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu sản phẩm");
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/products.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    /**
     * Sort books based on sortParam
     */
    private List<Book> sortBooks(List<Book> books, String sortParam) {
        switch(sortParam) {
            case "price-low":
                books.sort((b1, b2) -> Long.compare(b1.getPrice(), b2.getPrice()));
                break;
            case "price-high":
                books.sort((b1, b2) -> Long.compare(b2.getPrice(), b1.getPrice()));
                break;
            case "name":
                books.sort((b1, b2) -> b1.getTitle().compareTo(b2.getTitle()));
                break;
            case "rating":
                books.sort((b1, b2) -> Double.compare(b2.getRating(), b1.getRating()));
                break;
            case "newest":
            default:
                books.sort((b1, b2) -> Integer.compare(b2.getId(), b1.getId()));
                break;
        }
        return books;
    }
}

