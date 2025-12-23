package com.bookstore.filter;

import com.bookstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Protects routes that require user login: /cart, /checkout, /vnpay/*
 */
@WebFilter(urlPatterns = {"/cart", "/checkout", "/vnpay/*", "/orders", "/api/test-payment"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user != null) {
            // User is logged in - allow access
            chain.doFilter(request, response);
        } else {
            // User is not logged in - redirect to login
            String contextPath = httpRequest.getContextPath();
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            
            // Build return URL
            String returnUrl = requestURI;
            if (queryString != null && !queryString.isEmpty()) {
                returnUrl += "?" + queryString;
            }
            // Remove context path from returnUrl
            returnUrl = returnUrl.replace(contextPath, "");
            
            // Redirect to login with return URL
            httpResponse.sendRedirect(contextPath + "/login?returnUrl=" + 
                java.net.URLEncoder.encode(returnUrl, "UTF-8"));
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}

