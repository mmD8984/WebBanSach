<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>BookStore - Nhà sách trực tuyến</title>
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        background: #f5f5f5;
                        color: #333;
                    }

                    /* Header */
                    header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 0;
                        position: sticky;
                        top: 0;
                        z-index: 1000;
                        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
                    }

                    .header-top {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 15px 20px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .logo {
                        font-size: 28px;
                        font-weight: bold;
                        text-decoration: none;
                        color: white;
                    }

                    .logo span {
                        font-size: 24px;
                    }

                    nav {
                        display: flex;
                        gap: 30px;
                        align-items: center;
                    }

                    nav a {
                        color: white;
                        text-decoration: none;
                        font-weight: 500;
                        transition: opacity 0.3s;
                    }

                    nav a:hover {
                        opacity: 0.8;
                    }

                    .user-actions {
                        display: flex;
                        gap: 15px;
                        align-items: center;
                    }

                    .btn {
                        padding: 10px 20px;
                        border-radius: 25px;
                        text-decoration: none;
                        font-weight: 600;
                        transition: all 0.3s;
                    }

                    .btn-outline {
                        border: 2px solid white;
                        color: white;
                        background: transparent;
                    }

                    .btn-outline:hover {
                        background: white;
                        color: #667eea;
                    }

                    .btn-primary {
                        background: white;
                        color: #667eea;
                    }

                    .btn-primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 20px rgba(255, 255, 255, 0.3);
                    }

                    .user-name {
                        padding: 8px 15px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 20px;
                    }

                    /* Hero Section */
                    .hero {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 80px 20px;
                        text-align: center;
                    }

                    .hero h1 {
                        font-size: 48px;
                        margin-bottom: 20px;
                    }

                    .hero p {
                        font-size: 20px;
                        opacity: 0.9;
                        margin-bottom: 30px;
                    }

                    .hero .btn {
                        font-size: 18px;
                        padding: 15px 40px;
                    }

                    /* Main Content */
                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 40px 20px;
                    }

                    /* Categories Section */
                    .section-title {
                        font-size: 28px;
                        margin-bottom: 30px;
                        padding-bottom: 15px;
                        border-bottom: 3px solid #667eea;
                        display: inline-block;
                    }

                    .categories-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                        gap: 20px;
                        margin-bottom: 50px;
                    }

                    .category-card {
                        background: white;
                        padding: 25px;
                        border-radius: 15px;
                        text-align: center;
                        text-decoration: none;
                        color: #333;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        transition: all 0.3s;
                    }

                    .category-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
                    }

                    .category-card .icon {
                        font-size: 40px;
                        margin-bottom: 15px;
                    }

                    .category-card h3 {
                        font-size: 18px;
                    }

                    /* Books Grid */
                    .books-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                        gap: 30px;
                    }

                    .book-card {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        transition: all 0.3s;
                    }

                    .book-card:hover {
                        transform: translateY(-10px);
                        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
                    }

                    .book-card img {
                        width: 100%;
                        height: 280px;
                        object-fit: cover;
                    }

                    .book-card .book-placeholder {
                        width: 100%;
                        height: 280px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 60px;
                    }

                    .book-info {
                        padding: 20px;
                    }

                    .book-info h3 {
                        font-size: 18px;
                        margin-bottom: 8px;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .book-info .category {
                        color: #667eea;
                        font-size: 14px;
                        margin-bottom: 10px;
                    }

                    .book-info .price {
                        font-size: 22px;
                        font-weight: bold;
                        color: #e74c3c;
                    }

                    .book-info .author {
                        font-size: 14px;
                        color: #666;
                        margin-bottom: 10px;
                    }

                    .book-actions {
                        display: flex;
                        gap: 10px;
                        margin-top: 15px;
                    }

                    .book-actions .btn {
                        flex: 1;
                        text-align: center;
                        padding: 12px;
                        font-size: 14px;
                    }

                    .btn-cart {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .btn-detail {
                        background: #f0f0f0;
                        color: #333;
                    }

                    /* Footer */
                    footer {
                        background: #2c3e50;
                        color: white;
                        padding: 50px 20px;
                        margin-top: 60px;
                    }

                    .footer-content {
                        max-width: 1200px;
                        margin: 0 auto;
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 40px;
                    }

                    .footer-section h4 {
                        margin-bottom: 20px;
                        font-size: 18px;
                    }

                    .footer-section p,
                    .footer-section a {
                        color: #bdc3c7;
                        line-height: 2;
                        text-decoration: none;
                        display: block;
                    }

                    .footer-section a:hover {
                        color: white;
                    }

                    .footer-bottom {
                        text-align: center;
                        margin-top: 40px;
                        padding-top: 20px;
                        border-top: 1px solid #34495e;
                        color: #7f8c8d;
                    }
                </style>
            </head>

            <body>
                <header>
                    <div class="header-top">
                        <a href="${pageContext.request.contextPath}/" class="logo">
                            <span>📚</span> BookStore
                        </a>

                        <nav>
                            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                            <a href="${pageContext.request.contextPath}/books">Tất cả sách</a>
                            <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
                        </nav>

                        <div class="user-actions">
                            <c:choose>
                                <c:when test="${not empty sessionScope.userId}">
                                    <a href="${pageContext.request.contextPath}/account" class="user-name">👤
                                        ${sessionScope.userName}</a>
                                    <c:if
                                        test="${sessionScope.userRole == 'admin' || sessionScope.userRole == 'staff'}">
                                        <a href="${pageContext.request.contextPath}/admin-dashboard"
                                            class="btn btn-outline">Admin</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline">Đơn
                                        hàng</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary">Đăng
                                        xuất</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng
                                        nhập</a>
                                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng
                                        ký</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </header>

                <section class="hero">
                    <h1>Khám phá thế giới sách</h1>
                    <p>Hơn ${totalBooks} đầu sách đang chờ đón bạn</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">Khám phá ngay</a>
                </section>

                <div class="container">
                    <!-- Categories -->
                    <h2 class="section-title">📂 Danh mục sách</h2>
                    <div class="categories-grid">
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/books?category=${cat.id}" class="category-card">
                                <div class="icon">📖</div>
                                <h3>${cat.name}</h3>
                            </a>
                        </c:forEach>
                    </div>

                    <!-- Featured Books -->
                    <h2 class="section-title">⭐ Sách nổi bật</h2>
                    <div class="books-grid">
                        <c:forEach var="book" items="${featuredBooks}">
                            <div class="book-card">
                                <c:choose>
                                    <c:when test="${not empty book.coverImage}">
                                        <img src="${book.coverImage}" alt="${book.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-placeholder">📚</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="book-info">
                                    <h3 title="${book.title}">${book.title}</h3>
                                    <p class="category">${book.categoryName}</p>
                                    <p class="author">✍️ ${book.authorNames}</p>
                                    <p class="price">
                                        <fmt:formatNumber value="${book.price}" type="currency" currencySymbol=""
                                            maxFractionDigits="0" />₫
                                    </p>
                                    <div class="book-actions">
                                        <a href="${pageContext.request.contextPath}/book?id=${book.id}"
                                            class="btn btn-detail">Chi tiết</a>
                                        <a href="${pageContext.request.contextPath}/cart?action=add&bookId=${book.id}"
                                            class="btn btn-cart">🛒 Thêm</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <footer>
                    <div class="footer-content">
                        <div class="footer-section">
                            <h4>📚 BookStore</h4>
                            <p>Nhà sách trực tuyến hàng đầu Việt Nam với hàng nghìn đầu sách chất lượng.</p>
                        </div>
                        <div class="footer-section">
                            <h4>Liên kết</h4>
                            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                            <a href="${pageContext.request.contextPath}/books">Tất cả sách</a>
                            <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
                        </div>
                        <div class="footer-section">
                            <h4>Liên hệ</h4>
                            <p>📍 123 Đường ABC, Quận 1, TP.HCM</p>
                            <p>📞 0901 234 567</p>
                            <p>✉️ contact@bookstore.vn</p>
                        </div>
                    </div>
                    <div class="footer-bottom">
                        <p>&copy; 2024 BookStore. All rights reserved.</p>
                    </div>
                </footer>
            </body>

            </html>