<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="common/head.jsp" %>
    <title>Lịch Sử Đơn Hàng - BookStore</title>
    <style>
        .orders-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            color: var(--text-dark);
        }
        
        .order-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .order-id {
            font-weight: bold;
            font-size: 16px;
        }
        
        .order-date {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .order-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #cce5ff; color: #004085; }
        .status-paid { background: #d4edda; color: #155724; }
        .status-shipping { background: #d1ecf1; color: #0c5460; }
        .status-delivered { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .order-body {
            padding: 20px;
        }
        
        .order-items {
            margin-bottom: 20px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-title {
            font-weight: 500;
            color: var(--text-dark);
        }
        
        .item-quantity {
            color: var(--text-muted);
            font-size: 14px;
        }
        
        .item-price {
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 2px solid #eee;
        }
        
        .order-total {
            font-size: 18px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .payment-method {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            font-size: 14px;
        }
        
        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-orders h2 {
            color: var(--text-muted);
            margin-bottom: 15px;
        }
        
        .empty-orders p {
            color: var(--text-muted);
            margin-bottom: 20px;
        }
        
        .empty-orders a {
            display: inline-block;
            padding: 12px 30px;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 600;
        }
        
        .empty-orders a:hover {
            background: #c82333;
        }
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .order-footer {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <main class="main">
        <div class="orders-container">
            <h1 class="page-title">📦 Lịch Sử Đơn Hàng</h1>
            
            <c:if test="${not empty error}">
                <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                    ${error}
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-orders">
                        <h2>🛒 Chưa có đơn hàng nào</h2>
                        <p>Bạn chưa đặt mua sản phẩm nào. Hãy khám phá và mua sắm ngay!</p>
                        <a href="${pageContext.request.contextPath}/products">Mua Sắm Ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <div class="order-id">Đơn hàng #${order.id}</div>
                                    <div class="order-date">
                                        <c:if test="${not empty order.createdAt}">
                                            ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year} 
                                            ${order.createdAt.hour}:${order.createdAt.minute < 10 ? '0' : ''}${order.createdAt.minute}
                                        </c:if>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                                    <span class="order-status status-${order.paymentStatus}">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'paid'}">✓ Đã thanh toán</c:when>
                                            <c:when test="${order.paymentStatus == 'pending'}">⏳ Chờ thanh toán</c:when>
                                            <c:when test="${order.paymentStatus == 'failed'}">✗ Thanh toán thất bại</c:when>
                                            <c:otherwise>${order.paymentStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="order-status status-${order.status}">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">Chờ xử lý</c:when>
                                            <c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
                                            <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                                            <c:when test="${order.status == 'delivered'}">Đã giao</c:when>
                                            <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                            <c:otherwise>${order.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="order-body">
                                <div class="order-items">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="order-item">
                                            <div class="item-info">
                                                <div class="item-title">${item.bookTitle}</div>
                                                <div class="item-quantity">Số lượng: ${item.quantity}</div>
                                            </div>
                                            <div class="item-price">
                                                <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/> đ
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="order-footer">
                                    <div class="payment-method">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'vnpay'}">💳 VNPAY</c:when>
                                            <c:when test="${order.paymentMethod == 'test'}">🧪 Test Payment</c:when>
                                            <c:when test="${order.paymentMethod == 'cod'}">💵 COD</c:when>
                                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                                        </c:choose>
                                        | 📍 ${order.address}
                                    </div>
                                    <div class="order-total">
                                        Tổng: <fmt:formatNumber value="${order.total}" pattern="#,###"/> đ
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <%@ include file="common/footer.jsp" %>
</body>
</html>

