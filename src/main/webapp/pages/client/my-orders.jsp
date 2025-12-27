<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đơn hàng của tôi - BookStore</title>
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

                    .orders-list {
                        background: white;
                        border-radius: 15px;
                        overflow: hidden;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .order-item {
                        padding: 25px;
                        border-bottom: 1px solid #eee;
                    }

                    .order-item:last-child {
                        border-bottom: none;
                    }

                    .order-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        margin-bottom: 15px;
                    }

                    .order-code {
                        font-size: 18px;
                        font-weight: bold;
                        color: #333;
                    }

                    .order-date {
                        color: #999;
                        font-size: 14px;
                    }

                    .order-status {
                        padding: 6px 15px;
                        border-radius: 20px;
                        font-size: 13px;
                        font-weight: 600;
                    }

                    .status-pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-confirmed {
                        background: #cce5ff;
                        color: #004085;
                    }

                    .status-shipping {
                        background: #d4edda;
                        color: #155724;
                    }

                    .status-delivered {
                        background: #d1ecf1;
                        color: #0c5460;
                    }

                    .status-cancelled {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .order-info {
                        display: flex;
                        gap: 30px;
                        flex-wrap: wrap;
                    }

                    .order-info-item {}

                    .order-info-item .label {
                        color: #999;
                        font-size: 13px;
                        margin-bottom: 5px;
                    }

                    .order-info-item .value {
                        font-weight: 600;
                        color: #333;
                    }

                    .order-total {
                        font-size: 20px;
                        color: #e74c3c;
                    }

                    .empty-orders {
                        text-align: center;
                        padding: 80px 20px;
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    }

                    .empty-orders h2 {
                        margin-bottom: 15px;
                        color: #666;
                    }

                    .empty-orders a {
                        display: inline-block;
                        margin-top: 20px;
                        padding: 15px 30px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-decoration: none;
                        border-radius: 10px;
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
                            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                        </nav>
                    </div>
                </header>

                <div class="container">
                    <h1 class="page-title">📦 Đơn hàng của tôi</h1>

                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="empty-orders">
                                <h2>😢 Bạn chưa có đơn hàng nào</h2>
                                <p>Hãy khám phá và mua sách ngay!</p>
                                <a href="${pageContext.request.contextPath}/books">Khám phá sách</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="orders-list">
                                <c:forEach var="order" items="${orders}">
                                    <div class="order-item">
                                        <div class="order-header">
                                            <div>
                                                <div class="order-code">🧾 ${order.orderCode}</div>
                                                <div class="order-date">
                                                    <fmt:parseDate value="${order.createdAt}"
                                                        pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>
                                            <span class="order-status status-${order.status}">
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                                    <c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
                                                    <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                                                    <c:when test="${order.status == 'delivered'}">Đã giao</c:when>
                                                    <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                                    <c:otherwise>${order.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="order-info">
                                            <div class="order-info-item">
                                                <div class="label">Địa chỉ giao hàng</div>
                                                <div class="value">${order.shippingAddress}</div>
                                            </div>
                                            <div class="order-info-item">
                                                <div class="label">Thanh toán</div>
                                                <div class="value">
                                                    <c:choose>
                                                        <c:when test="${order.paymentMethod == 'cod'}">Tiền mặt (COD)
                                                        </c:when>
                                                        <c:when test="${order.paymentMethod == 'bank_transfer'}">Chuyển
                                                            khoản</c:when>
                                                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="order-info-item">
                                                <div class="label">Tổng tiền</div>
                                                <div class="value order-total">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                        currencySymbol="" maxFractionDigits="0" />₫
                                                </div>
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