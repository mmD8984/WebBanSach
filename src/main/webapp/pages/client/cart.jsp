<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ hàng - BookStore</title>
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

                    .page-title {
                        font-size: 32px;
                        margin-bottom: 30px;
                    }

                    .message {
                        padding: 15px 20px;
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .message.success {
                        background: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                    }

                    .cart-layout {
                        display: grid;
                        grid-template-columns: 1fr 350px;
                        gap: 30px;
                    }

                    .cart-items {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .cart-item {
                        display: grid;
                        grid-template-columns: 100px 1fr auto auto;
                        gap: 20px;
                        padding: 25px;
                        border-bottom: 1px solid #eee;
                        align-items: center;
                    }

                    .cart-item:last-child {
                        border-bottom: none;
                    }

                    .cart-item img {
                        width: 100px;
                        height: 130px;
                        object-fit: cover;
                        border-radius: 10px;
                    }

                    .item-placeholder {
                        width: 100px;
                        height: 130px;
                        border-radius: 10px;
                        background: linear-gradient(135deg, #667eea, #764ba2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 30px;
                    }

                    .item-info h3 {
                        font-size: 18px;
                        margin-bottom: 8px;
                    }

                    .item-info .price {
                        color: #e74c3c;
                        font-weight: bold;
                        font-size: 16px;
                    }

                    .quantity-control {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .quantity-control input {
                        width: 60px;
                        padding: 10px;
                        text-align: center;
                        border: 2px solid #e0e0e0;
                        border-radius: 8px;
                    }

                    .quantity-control button {
                        background: #667eea;
                        color: white;
                        border: none;
                        padding: 10px 15px;
                        border-radius: 8px;
                        cursor: pointer;
                    }

                    .item-subtotal {
                        font-size: 20px;
                        font-weight: bold;
                        color: #333;
                        min-width: 120px;
                        text-align: right;
                    }

                    .btn-remove {
                        background: #fee;
                        color: #e74c3c;
                        border: none;
                        padding: 10px 15px;
                        border-radius: 8px;
                        cursor: pointer;
                        font-size: 14px;
                    }

                    .btn-remove:hover {
                        background: #fdd;
                    }

                    /* Summary */
                    .cart-summary {
                        background: white;
                        border-radius: 15px;
                        padding: 30px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        height: fit-content;
                        position: sticky;
                        top: 100px;
                    }

                    .summary-title {
                        font-size: 22px;
                        margin-bottom: 25px;
                        padding-bottom: 15px;
                        border-bottom: 2px solid #eee;
                    }

                    .summary-row {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 15px;
                    }

                    .summary-total {
                        font-size: 24px;
                        font-weight: bold;
                        color: #e74c3c;
                        padding-top: 15px;
                        border-top: 2px solid #eee;
                        margin-top: 15px;
                    }

                    .btn-checkout {
                        display: block;
                        width: 100%;
                        padding: 18px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-align: center;
                        text-decoration: none;
                        border-radius: 10px;
                        font-size: 18px;
                        font-weight: 600;
                        margin-top: 20px;
                        border: none;
                        cursor: pointer;
                    }

                    .btn-checkout:hover {
                        opacity: 0.95;
                    }

                    .btn-continue {
                        display: block;
                        text-align: center;
                        margin-top: 15px;
                        color: #667eea;
                        text-decoration: none;
                    }

                    .empty-cart {
                        text-align: center;
                        padding: 80px 20px;
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .empty-cart h2 {
                        margin-bottom: 15px;
                        color: #666;
                    }

                    .empty-cart a {
                        display: inline-block;
                        margin-top: 20px;
                        padding: 15px 30px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-decoration: none;
                        border-radius: 10px;
                    }

                    @media (max-width: 900px) {
                        .cart-layout {
                            grid-template-columns: 1fr;
                        }

                        .cart-item {
                            grid-template-columns: 80px 1fr;
                        }

                        .quantity-control,
                        .item-subtotal {
                            grid-column: 2;
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
                    <h1 class="page-title">🛒 Giỏ hàng của bạn</h1>

                    <c:if test="${not empty sessionScope.message}">
                        <div class="message success">${sessionScope.message}</div>
                        <c:remove var="message" scope="session" />
                    </c:if>

                    <c:choose>
                        <c:when test="${empty cartItems}">
                            <div class="empty-cart">
                                <h2>😢 Giỏ hàng trống</h2>
                                <p>Bạn chưa thêm sách nào vào giỏ hàng.</p>
                                <a href="${pageContext.request.contextPath}/books">Khám phá sách ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="cart-layout">
                                <div class="cart-items">
                                    <c:forEach var="item" items="${cartItems}">
                                        <div class="cart-item">
                                            <c:choose>
                                                <c:when test="${not empty item.bookCoverImage}">
                                                    <img src="${item.bookCoverImage}" alt="${item.bookTitle}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="item-placeholder">📚</div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="item-info">
                                                <h3>${item.bookTitle}</h3>
                                                <p class="price">
                                                    <fmt:formatNumber value="${item.bookPrice}" type="currency"
                                                        currencySymbol="" maxFractionDigits="0" />₫
                                                </p>
                                            </div>

                                            <div class="quantity-control">
                                                <form method="post" action="${pageContext.request.contextPath}/cart"
                                                    style="display:flex;gap:5px;">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="itemId" value="${item.id}">
                                                    <input type="number" name="quantity" value="${item.quantity}"
                                                        min="1">
                                                    <button type="submit">Cập nhật</button>
                                                </form>
                                            </div>

                                            <div class="item-subtotal">
                                                <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                    currencySymbol="" maxFractionDigits="0" />₫
                                            </div>

                                            <a href="${pageContext.request.contextPath}/cart?action=remove&itemId=${item.id}"
                                                class="btn-remove">✕ Xóa</a>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="cart-summary">
                                    <h2 class="summary-title">Tổng đơn hàng</h2>
                                    <div class="summary-row">
                                        <span>Số lượng sách:</span>
                                        <span>${itemCount} cuốn</span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Tạm tính:</span>
                                        <span>
                                            <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol=""
                                                maxFractionDigits="0" />₫
                                        </span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Phí vận chuyển:</span>
                                        <span>Miễn phí</span>
                                    </div>
                                    <div class="summary-row summary-total">
                                        <span>Tổng cộng:</span>
                                        <span>
                                            <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol=""
                                                maxFractionDigits="0" />₫
                                        </span>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">Tiến hành
                                        thanh toán</a>
                                    <a href="${pageContext.request.contextPath}/books" class="btn-continue">← Tiếp tục
                                        mua sắm</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </body>

            </html>