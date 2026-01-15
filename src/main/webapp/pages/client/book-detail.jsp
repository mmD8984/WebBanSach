<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${book.title} - BookStore</title>
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

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 30px 20px;
                    }

                    .breadcrumb {
                        margin-bottom: 20px;
                        color: #666;
                    }

                    .breadcrumb a {
                        color: #667eea;
                        text-decoration: none;
                    }

                    .book-detail {
                        background: white;
                        border-radius: 20px;
                        padding: 40px;
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                        display: grid;
                        grid-template-columns: 350px 1fr;
                        gap: 50px;
                    }

                    .book-image img {
                        width: 100%;
                        border-radius: 15px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                    }

                    .book-placeholder {
                        width: 100%;
                        height: 450px;
                        border-radius: 15px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 100px;
                    }

                    .book-content h1 {
                        font-size: 32px;
                        margin-bottom: 15px;
                    }

                    .book-meta {
                        display: flex;
                        gap: 20px;
                        margin-bottom: 20px;
                        color: #666;
                        font-size: 15px;
                    }

                    .book-meta span {
                        display: flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .book-rating {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        margin-bottom: 20px;
                    }

                    .stars {
                        color: #f1c40f;
                        font-size: 22px;
                    }

                    .rating-text {
                        color: #666;
                    }

                    .book-price {
                        font-size: 36px;
                        font-weight: bold;
                        color: #e74c3c;
                        margin-bottom: 25px;
                        padding: 20px;
                        background: linear-gradient(135deg, #fff5f5, #ffe0e0);
                        border-radius: 15px;
                        display: inline-block;
                    }

                    .book-description {
                        color: #555;
                        line-height: 1.8;
                        margin-bottom: 30px;
                    }

                    .stock-info {
                        margin-bottom: 25px;
                        font-size: 16px;
                    }

                    .in-stock {
                        color: #27ae60;
                    }

                    .out-stock {
                        color: #e74c3c;
                    }

                    .add-to-cart {
                        display: flex;
                        gap: 15px;
                        align-items: center;
                        padding: 25px 0;
                        border-top: 1px solid #eee;
                    }

                    .quantity-input {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .quantity-input input {
                        width: 60px;
                        padding: 12px;
                        text-align: center;
                        border: 2px solid #e0e0e0;
                        border-radius: 10px;
                        font-size: 16px;
                    }

                    .btn-add-cart {
                        padding: 15px 40px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 10px;
                        font-size: 18px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: transform 0.2s;
                    }

                    .btn-add-cart:hover {
                        transform: translateY(-2px);
                    }

                    .btn-wishlist {
                        padding: 15px 25px;
                        background: #f0f0f0;
                        border: none;
                        border-radius: 10px;
                        font-size: 18px;
                        cursor: pointer;
                    }

                    /* Reviews */
                    .reviews-section {
                        margin-top: 50px;
                    }

                    .section-title {
                        font-size: 24px;
                        margin-bottom: 25px;
                        padding-bottom: 15px;
                        border-bottom: 2px solid #eee;
                    }

                    .review-item {
                        background: white;
                        padding: 25px;
                        border-radius: 15px;
                        margin-bottom: 20px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                    }

                    .review-header {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 15px;
                    }

                    .reviewer-name {
                        font-weight: 600;
                        color: #333;
                    }

                    .review-date {
                        color: #999;
                        font-size: 14px;
                    }

                    .review-rating {
                        color: #f1c40f;
                        margin-bottom: 10px;
                    }

                    .review-comment {
                        color: #555;
                        line-height: 1.6;
                    }

                    /* Related Books */
                    .related-section {
                        margin-top: 50px;
                    }

                    .related-grid {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 25px;
                    }

                    .related-card {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                        transition: all 0.3s;
                    }

                    .related-card:hover {
                        transform: translateY(-5px);
                    }

                    .related-card img {
                        width: 100%;
                        height: 200px;
                        object-fit: cover;
                    }

                    .related-card .card-info {
                        padding: 15px;
                    }

                    .related-card h4 {
                        font-size: 14px;
                        margin-bottom: 8px;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .related-card .price {
                        color: #e74c3c;
                        font-weight: bold;
                    }

                    @media (max-width: 900px) {
                        .book-detail {
                            grid-template-columns: 1fr;
                        }

                        .related-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }
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
                        </nav>
                    </div>
                </header>

                <div class="container">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
                        <a href="${pageContext.request.contextPath}/books">Sách</a> &gt;
                        <span>${book.title}</span>
                    </div>

                    <div class="book-detail">
                        <div class="book-image">
                            <c:choose>
                                <c:when test="${not empty book.coverImage}">
                                    <img src="${book.coverImage}" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="book-placeholder">📚</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="book-content">
                            <h1>${book.title}</h1>

                            <div class="book-meta">
                                <span>📂 ${book.categoryName}</span>
                                <span>✍️ ${book.authorNames}</span>
                                <span>🏢 ${book.publisherName}</span>
                            </div>

                            <div class="book-rating">
                                <span class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= avgRating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                <span class="rating-text">
                                    <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />/5 (${reviewCount}
                                    đánh giá)
                                </span>
                            </div>

                            <div class="book-price">
                                <fmt:formatNumber value="${book.price}" type="currency" currencySymbol=""
                                    maxFractionDigits="0" />₫
                            </div>

                            <p class="book-description">${book.description}</p>

                            <div class="stock-info">
                                <c:choose>
                                    <c:when test="${book.stockQuantity > 0}">
                                        <span class="in-stock">✓ Còn hàng (${book.stockQuantity} cuốn)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="out-stock">✗ Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="add-to-cart">
                                <form action="${pageContext.request.contextPath}/cart" method="get"
                                    style="display:flex;gap:15px;align-items:center;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="bookId" value="${book.id}">
                                    <div class="quantity-input">
                                        <label>Số lượng:</label>
                                        <input type="number" name="quantity" value="1" min="1"
                                            max="${book.stockQuantity}">
                                    </div>
                                    <button type="submit" class="btn-add-cart" ${book.stockQuantity <=0 ? 'disabled'
                                        : '' }>
                                        🛒 Thêm vào giỏ
                                    </button>
                                </form>
                                <button class="btn-wishlist">❤️</button>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews -->
                    <div class="reviews-section">
                        <h2 class="section-title">💬 Đánh giá (${reviewCount})</h2>
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <p style="color:#666;">Chưa có đánh giá nào cho sách này.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="review" items="${reviews}">
                                    <div class="review-item">
                                        <div class="review-header">
                                            <span class="reviewer-name">👤 ${review.userName}</span>
                                            <span class="review-date">
                                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                            </span>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                        </div>
                                        <p class="review-comment">${review.comment}</p>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Related Books -->
                    <c:if test="${not empty relatedBooks}">
                        <div class="related-section">
                            <h2 class="section-title">📚 Sách liên quan</h2>
                            <div class="related-grid">
                                <c:forEach var="rb" items="${relatedBooks}">
                                    <a href="${pageContext.request.contextPath}/book?id=${rb.id}" class="related-card"
                                        style="text-decoration:none;color:inherit;">
                                        <c:choose>
                                            <c:when test="${not empty rb.coverImage}">
                                                <img src="${rb.coverImage}" alt="${rb.title}">
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    style="height:200px;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;color:white;font-size:40px;">
                                                    📚</div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="card-info">
                                            <h4>${rb.title}</h4>
                                            <p class="price">
                                                <fmt:formatNumber value="${rb.price}" type="currency" currencySymbol=""
                                                    maxFractionDigits="0" />₫
                                            </p>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </body>

            </html>