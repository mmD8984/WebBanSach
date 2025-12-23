<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Header & Navigation -->
<header class="header">
    <div class="header-top">
        <div class="container">
            <div class="header-info">
                <span class="header-phone">📞 1800-1234</span>
                <span class="header-email">📧 support@bookstore.com</span>
            </div>
        </div>
    </div>
    
    <nav class="navbar">
        <div class="container nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <span class="logo-icon">📚</span>
                    <span class="logo-text">BookStore</span>
                </a>
            </div>
            
            <div class="search-bar">
                <input type="text" id="header-search" placeholder="Tìm kiếm sách, tác giả..." class="search-input">
                <button class="search-btn">🔍</button>
            </div>
            
            <div class="nav-menu">
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">Giới thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                </ul>
            </div>
            
            <div class="nav-actions">
                <button class="icon-btn" id="menu-toggle">☰</button>
                <a href="${pageContext.request.contextPath}/cart" class="cart-link">
                    <span class="cart-icon">🛒</span>
                    <span class="cart-badge" id="cart-count">0</span>
                </a>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary">Đăng Nhập</a>
                </c:if>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-outline" style="margin-left: 8px;" title="Lịch sử đơn hàng">📦 Đơn Hàng</a>
                    <span style="color: var(--text-dark); margin-left: 8px;">${sessionScope.user.fullname}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline" style="margin-left: 8px;">Đăng Xuất</a>
                </c:if>
            </div>
        </div>
    </nav>
</header>

