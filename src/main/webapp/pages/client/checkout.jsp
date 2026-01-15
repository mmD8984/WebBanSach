<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thanh toán - BookStore</title>
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

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 30px 20px;
                    }

                    .page-title {
                        font-size: 32px;
                        margin-bottom: 30px;
                    }

                    .checkout-layout {
                        display: grid;
                        grid-template-columns: 1fr 400px;
                        gap: 30px;
                    }

                    .checkout-form {
                        background: white;
                        border-radius: 15px;
                        padding: 30px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .form-title {
                        font-size: 20px;
                        margin-bottom: 25px;
                        padding-bottom: 15px;
                        border-bottom: 2px solid #eee;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        font-weight: 600;
                        color: #333;
                    }

                    .form-group input,
                    .form-group textarea,
                    .form-group select {
                        width: 100%;
                        padding: 14px;
                        border: 2px solid #e0e0e0;
                        border-radius: 10px;
                        font-size: 16px;
                    }

                    .form-group input:focus,
                    .form-group textarea:focus {
                        outline: none;
                        border-color: #667eea;
                    }

                    .form-group textarea {
                        min-height: 100px;
                        resize: vertical;
                    }

                    .payment-methods {
                        display: flex;
                        gap: 15px;
                        flex-wrap: wrap;
                    }

                    .payment-option {
                        flex: 1;
                        min-width: 150px;
                        padding: 20px;
                        border: 2px solid #e0e0e0;
                        border-radius: 10px;
                        cursor: pointer;
                        text-align: center;
                        transition: all 0.3s;
                    }

                    .payment-option:hover {
                        border-color: #667eea;
                    }

                    .payment-option input {
                        display: none;
                    }

                    .payment-option input:checked+.payment-content {
                        color: #667eea;
                    }

                    .payment-option input:checked~.payment-content,
                    .payment-option:has(input:checked) {
                        border-color: #667eea;
                        background: #f8f9ff;
                    }

                    .payment-icon {
                        font-size: 30px;
                        margin-bottom: 8px;
                    }

                    .order-summary {
                        background: white;
                        border-radius: 15px;
                        padding: 30px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        height: fit-content;
                        position: sticky;
                        top: 100px;
                    }

                    .summary-title {
                        font-size: 20px;
                        margin-bottom: 20px;
                    }

                    .summary-items {
                        max-height: 300px;
                        overflow-y: auto;
                        margin-bottom: 20px;
                    }

                    .summary-item {
                        display: flex;
                        gap: 15px;
                        padding: 15px 0;
                        border-bottom: 1px solid #eee;
                    }

                    .summary-item img {
                        width: 60px;
                        height: 80px;
                        object-fit: cover;
                        border-radius: 8px;
                    }

                    .item-placeholder-sm {
                        width: 60px;
                        height: 80px;
                        border-radius: 8px;
                        background: linear-gradient(135deg, #667eea, #764ba2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 20px;
                    }

                    .item-info-sm h4 {
                        font-size: 14px;
                        margin-bottom: 5px;
                    }

                    .item-info-sm .qty {
                        color: #666;
                        font-size: 13px;
                    }

                    .item-info-sm .price {
                        color: #e74c3c;
                        font-weight: bold;
                    }

                    .summary-row {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 10px;
                    }

                    .summary-total {
                        font-size: 22px;
                        font-weight: bold;
                        color: #e74c3c;
                        padding-top: 15px;
                        border-top: 2px solid #eee;
                        margin-top: 15px;
                    }

                    .btn-order {
                        width: 100%;
                        padding: 18px;
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        color: white;
                        border: none;
                        border-radius: 10px;
                        font-size: 18px;
                        font-weight: 600;
                        cursor: pointer;
                        margin-top: 20px;
                    }

                    .btn-order:hover {
                        opacity: 0.95;
                    }

                    .error {
                        background: #fee;
                        color: #c00;
                        padding: 15px;
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    @media (max-width: 900px) {
                        .checkout-layout {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <header>
                    <div class="header-content">
                        <a href="${pageContext.request.contextPath}/" class="logo">📚 BookStore</a>
                    </div>
                </header>

                <div class="container">
                    <h1 class="page-title">💳 Thanh toán</h1>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/checkout">
                        <div class="checkout-layout">
                            <div class="checkout-form">
                                <h2 class="form-title">📦 Thông tin giao hàng</h2>

                                <div class="form-group">
                                    <label for="fullName">Họ và tên *</label>
                                    <input type="text" id="fullName" name="fullName" value="${sessionScope.userName}"
                                        required>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Số điện thoại *</label>
                                    <input type="tel" id="phone" name="phone" required placeholder="0901234567">
                                </div>

                                <div class="form-group">
                                    <label for="address">Địa chỉ giao hàng *</label>
                                    <textarea id="address" name="address" required
                                        placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="note">Ghi chú</label>
                                    <textarea id="note" name="note"
                                        placeholder="Ghi chú cho đơn hàng (không bắt buộc)"></textarea>
                                </div>

                                <h2 class="form-title">💰 Phương thức thanh toán</h2>
                                <div class="payment-methods">
                                    <label class="payment-option">
                                        <input type="radio" name="paymentMethod" value="cod" checked>
                                        <div class="payment-content">
                                            <div class="payment-icon">💵</div>
                                            <div>Tiền mặt (COD)</div>
                                        </div>
                                    </label>
                                    <label class="payment-option">
                                        <input type="radio" name="paymentMethod" value="bank_transfer">
                                        <div class="payment-content">
                                            <div class="payment-icon">🏦</div>
                                            <div>Chuyển khoản</div>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div class="order-summary">
                                <h2 class="summary-title">🛒 Đơn hàng (${itemCount} sản phẩm)</h2>

                                <div class="summary-items">
                                    <c:forEach var="item" items="${cartItems}">
                                        <div class="summary-item">
                                            <c:choose>
                                                <c:when test="${not empty item.bookCoverImage}">
                                                    <img src="${item.bookCoverImage}" alt="${item.bookTitle}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="item-placeholder-sm">📚</div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="item-info-sm">
                                                <h4>${item.bookTitle}</h4>
                                                <p class="qty">x${item.quantity}</p>
                                                <p class="price">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                        currencySymbol="" maxFractionDigits="0" />₫
                                                </p>
                                            </div>
                                        </div>
                                    </c:forEach>
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

                                <button type="submit" class="btn-order">✓ Đặt hàng</button>
                            </div>
                        </div>
                    </form>
                </div>
            </body>

            </html>