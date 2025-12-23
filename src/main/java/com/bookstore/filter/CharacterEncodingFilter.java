package com.bookstore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Character Encoding Filter
 * Ensures all requests and responses use UTF-8 encoding
 */
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            encoding = encodingParam;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Get request URI to check if it's a static resource
        String uri = ((HttpServletRequest) request).getRequestURI();
        
        // Skip encoding filter for static resources (CSS, JS, images)
        if (uri.endsWith(".css") || uri.endsWith(".js") || 
            uri.endsWith(".jpg") || uri.endsWith(".jpeg") || 
            uri.endsWith(".png") || uri.endsWith(".gif") || 
            uri.endsWith(".svg") || uri.endsWith(".ico") ||
            uri.endsWith(".woff") || uri.endsWith(".woff2") || 
            uri.endsWith(".ttf") || uri.endsWith(".eot")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Set request encoding for dynamic content
        request.setCharacterEncoding(encoding);
        
        // Set response encoding (don't set contentType - let servlet/JSP do that)
        response.setCharacterEncoding(encoding);
        
        // Continue filter chain
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

