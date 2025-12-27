<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tất cả sách - BookStore</title>
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        background: #f5f5f5;
                    }

                    header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 15px 0;
                        position: sticky;
                        top: 0;
                        z-index: 1000;
                    }

                    .header-content {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 0 20px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .logo {
                        font-size: 24px;
                        font-weight: bold;
                        text-decoration: none;
                        color: white;
                    }

                    nav a {
                        color: white;
                        text-decoration: none;
                        margin-left: 25px;
                    }

                    .btn {
                        padding: 8px 20px;
                        border-radius: 20px;
                        text-decoration: none;
                    }

                    .btn-outline {
                        border: 2px solid white;
                        color: white;
                    }

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 30px 20px;
                    }

                    .page-header {
                        margin-bottom: 30px;
                    }

                    .page-header h1 {
                        font-size: 32px;
                        margin-bottom: 10px;
                    }

                    .filters {
                        background: white;
                        padding: 20px;
                        border-radius: 15px;
                        margin-bottom: 30px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .filters form {
                        display: flex;
                        gap: 15px;
                        flex-wrap: wrap;
                        align-items: center;
                    }

                    .filters input,
                    .filters select {
                        padding: 12px 15px;
                        border: 2px solid #e0e0e0;
                        border-radius: 10px;
                        font-size: 14px;
                    }

                    .filters input {
                        flex: 1;
                        min-width: 200px;
                    }

                    .filters select {
                        min-width: 150px;
                    }

                    .filters button {
                        padding: 12px 25px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 10px;
                        cursor: pointer;
                        font-weight: 600;
                    }

                    .filters button:hover {
                        opacity: 0.9;
                    }

                    .results-info {
                        margin-bottom: 20px;
                        color: #666;
                    }

                    .books-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                        gap: 25px;
                    }

                    .book-card {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        transition: all 0.3s;
                    }

                    .book-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
                    }

                    .book-card img {
                        width: 100%;
                        height: 280px;
                        object-fit: cover;
                    }

                    .book-placeholder {
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
                        font-size: 16px;
                        margin-bottom: 8px;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .book-info .category {
                        color: #667eea;
                        font-size: 13px;
                        margin-bottom: 8px;
                    }

                    .book-info .author {
                        color: #666;
                        font-size: 13px;
                        margin-bottom: 10px;
                    }

                    .book-info .price {
                        font-size: 20px;
                        font-weight: bold;
                        color: #e74c3c;
                    }

                    .book-actions {
                        display: flex;
                        gap: 10px;
                        margin-top: 15px;
                    }

                    .book-actions a {
                        flex: 1;
                        text-align: center;
                        padding: 10px;
                        border-radius: 8px;
                        text-decoration: none;
                        font-size: 14px;
                        font-weight: 500;
                    }

                    .btn-cart {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .btn-detail {
                        background: #f0f0f0;
                        color: #333;
                    }

                    .no-results {
                        text-align: center;
                        padding: 60px;
                        color: #666;
                    }

                    .no-results h2 {
                        margin-bottom: 15px;
                    }
                </style>
            </head>

            <body>
                <header>
                    <div class="header-content">
                        <a href="${pageContext.request.contextPath}/" class="logo">📚 BookStore</a>
                        <nav>
                            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                            <a href="${pageContext.request.contextPath}/books">Tất cả sách</a>
                            <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
                            <c:choose>
                                <c:when test="${not empty sessionScope.userId}">
                                    <a href="${pageContext.request.contextPath}/my-orders">Đơn hàng</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng
                                        xuất</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng
                                        nhập</a>
                                </c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                </header>

                <div class="container">
                    <div class="page-header">
                        <h1>📚 Tất cả sách</h1>
                    </div>

                    <div class="filters">
                        <form method="get" action="${pageContext.request.contextPath}/books">
                            <input type="text" name="q" placeholder="🔍 Tìm kiếm sách..." value="${searchQuery}">
                            <select name="category">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${selectedCategory==cat.id ? 'selected' : '' }>${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="sort">
                                <option value="">Sắp xếp</option>
                                <option value="name" ${sortBy=='name' ? 'selected' : '' }>Tên A-Z</option>
                                <option value="price_asc" ${sortBy=='price_asc' ? 'selected' : '' }>Giá thấp đến cao
                                </option>
                                <option value="price_desc" ${sortBy=='price_desc' ? 'selected' : '' }>Giá cao đến thấp
                                </option>
                            </select>
                            <button type="submit">Lọc</button>
                        </form>
                    </div>

                    <p class="results-info">Tìm thấy <strong>${totalBooks}</strong> sách</p>

                    <c:choose>
                        <c:when test="${empty books}">
                            <div class="no-results">
                                <h2>😢 Không tìm thấy sách</h2>
                                <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="books-grid">
                                <c:forEach var="book" items="${books}">
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
                                                <fmt:formatNumber value="${book.price}" type="currency"
                                                    currencySymbol="" maxFractionDigits="0" />₫
                                            </p>
                                            <div class="book-actions">
                                                <a href="${pageContext.request.contextPath}/book?id=${book.id}"
                                                    class="btn-detail">Chi tiết</a>
                                                <a href="${pageContext.request.contextPath}/cart?action=add&bookId=${book.id}"
                                                    class="btn-cart">🛒</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </body>

            </html>