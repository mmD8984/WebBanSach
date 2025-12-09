<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đơn hàng thành công - BookStore">
    <title>Đơn Hàng Thành Công - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <div style="text-align: center; padding: 60px 20px;">
                <!-- Success Icon -->
                <div style="font-size: 80px; margin-bottom: 20px;">✓</div>

                <h1 style="font-size: 32px; font-weight: bold; margin-bottom: 16px; color: #4CAF50;">Đặt Hàng Thành Công!</h1>
                
                <p style="font-size: 18px; color: #666; margin-bottom: 16px;">
                    Cảm ơn bạn đã mua sắm tại BookStore. Đơn hàng của bạn đã được tiếp nhận.
                </p>

                <c:set var="displayOrderId" value="${not empty order ? order.id : (not empty param.id ? param.id : param.orderId)}" />
                <c:if test="${not empty displayOrderId}">
                    <div style="background-color: #f0f7ff; border: 2px solid #2196F3; border-radius: 8px; padding: 20px; margin: 30px 0; display: inline-block; min-width: 300px;">
                        <p style="margin: 0 0 12px 0; font-size: 14px; color: #666;">Mã đơn hàng của bạn:</p>
                        <p style="margin: 0; font-size: 28px; font-weight: bold; color: #2196F3;">#${displayOrderId}</p>
                    </div>
                </c:if>

                <div style="margin: 40px 0;">
                    <h2 style="font-size: 20px; font-weight: bold; margin-bottom: 20px;">Tiếp theo?</h2>
                    
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; max-width: 900px; margin: 0 auto;">
                        <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px;">
                            <div style="font-size: 40px; margin-bottom: 12px;">📦</div>
                            <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Theo Dõi Đơn Hàng</h3>
                            <p style="font-size: 14px; color: #666;">Bạn sẽ nhận được email xác nhận và cập nhật theo dõi.</p>
                        </div>

                        <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px;">
                            <div style="font-size: 40px; margin-bottom: 12px;">🚚</div>
                            <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Giao Hàng Nhanh</h3>
                            <p style="font-size: 14px; color: #666;">Chúng tôi sẽ giao hàng đến bạn trong 2-3 ngày.</p>
                        </div>

                        <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px;">
                            <div style="font-size: 40px; margin-bottom: 12px;">💬</div>
                            <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Hỗ Trợ 24/7</h3>
                            <p style="font-size: 14px; color: #666;">Liên hệ với chúng tôi nếu bạn có câu hỏi.</p>
                        </div>
                    </div>
                </div>

                <div style="margin: 40px 0;">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary" style="display: inline-block; padding: 12px 30px; background-color: #2196F3; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-right: 12px;">
                        📦 Xem Đơn Hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline" style="display: inline-block; padding: 12px 30px; background-color: white; color: #333; text-decoration: none; border: 1px solid #ddd; border-radius: 4px; font-weight: bold; margin-right: 12px;">
                        Về Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline" style="display: inline-block; padding: 12px 30px; background-color: white; color: #333; text-decoration: none; border: 1px solid #ddd; border-radius: 4px; font-weight: bold;">
                        Tiếp Tục Mua Sắm
                    </a>
                </div>

                <!-- Order Summary -->
                <div style="margin-top: 40px; background-color: #f9f9f9; padding: 30px; border-radius: 8px; max-width: 800px; margin-left: auto; margin-right: auto; text-align: left;">
                    <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 20px; text-align: center;">Thông Tin Đơn Hàng</h3>
                    
                    <!-- Order Details -->
                    <div style="display: grid; grid-template-columns: 150px 1fr; gap: 12px; row-gap: 12px; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd;">
                        <strong>Mã Đơn Hàng:</strong>
                        <span><c:if test="${not empty displayOrderId}">#${displayOrderId}</c:if><c:if test="${empty displayOrderId}">Đang xử lý</c:if></span>

                        <strong>Trạng Thái:</strong>
                        <span style="color: #4CAF50; font-weight: bold;">
                            <c:choose>
                                <c:when test="${not empty order && order.paymentStatus == 'paid'}">Đã Thanh Toán ✓</c:when>
                                <c:otherwise>Chờ Xác Nhận</c:otherwise>
                            </c:choose>
                        </span>

                        <strong>Ngày Đặt:</strong>
                        <span>
                            <%@ page import="java.text.SimpleDateFormat" %>
                            <%@ page import="java.util.Date" %>
                            <% 
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                out.print(sdf.format(new Date()));
                            %>
                        </span>

                        <strong>Liên Hệ:</strong>
                        <span>
                            support@bookstore.com<br>
                            📞 1800-1234
                        </span>
                    </div>

                    <!-- Order Items -->
                    <c:if test="${not empty order && not empty order.items}">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px;">📚 Chi Tiết Sản Phẩm:</h4>
                        <table style="width: 100%; border-collapse: collapse; margin-bottom: 16px;">
                            <thead>
                                <tr style="background-color: #e8f4f8; border-bottom: 2px solid #2196F3;">
                                    <th style="padding: 10px; text-align: left; font-weight: bold;">Sản Phẩm</th>
                                    <th style="padding: 10px; text-align: center; font-weight: bold;">Số Lượng</th>
                                    <th style="padding: 10px; text-align: right; font-weight: bold;">Giá</th>
                                    <th style="padding: 10px; text-align: right; font-weight: bold;">Thành Tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr style="border-bottom: 1px solid #ddd;">
                                        <td style="padding: 12px; text-align: left;">${item.bookTitle}</td>
                                        <td style="padding: 12px; text-align: center;">${item.quantity}</td>
                                        <td style="padding: 12px; text-align: right;">
                                            <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>đ
                                        </td>
                                        <td style="padding: 12px; text-align: right; font-weight: bold;">
                                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,###"/>đ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Order Summary Totals -->
                        <div style="display: grid; grid-template-columns: 1fr auto; gap: 20px; padding-top: 16px; border-top: 2px solid #ddd;">
                            <div></div>
                            <div style="min-width: 250px;">
                                <div style="display: grid; grid-template-columns: 1fr auto; gap: 12px; margin-bottom: 8px;">
                                    <span>Tổng tiền:</span>
                                    <span><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</span>
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr auto; gap: 12px; margin-bottom: 8px;">
                                    <span>Vận chuyển:</span>
                                    <span><fmt:formatNumber value="${not empty order.shippingCost ? order.shippingCost : 0}" pattern="#,###"/>đ</span>
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr auto; gap: 12px; padding-top: 8px; border-top: 1px solid #ddd; font-size: 16px; font-weight: bold; color: #4CAF50;">
                                    <span>Thành Tiền:</span>
                                    <span><fmt:formatNumber value="${order.totalAmount + (not empty order.shippingCost ? order.shippingCost : 0)}" pattern="#,###"/>đ</span>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Address -->
                        <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid #ddd;">
                            <h4 style="font-size: 14px; font-weight: bold; margin-bottom: 8px;">📍 Địa Chỉ Giao Hàng:</h4>
                            <p style="margin: 0; color: #666;">
                                <strong>${order.fullname}</strong><br>
                                ${order.address}<br>
                                📞 ${order.phone}
                            </p>
                        </div>
                    </c:if>
                </div>

                <!-- FAQ Section -->
                <div style="margin-top: 40px; max-width: 600px; margin-left: auto; margin-right: auto; text-align: left;">
                    <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 16px; text-align: center;">Câu Hỏi Thường Gặp</h3>

                    <details style="margin-bottom: 12px;">
                        <summary style="padding: 12px; background-color: #f0f0f0; border-radius: 4px; cursor: pointer; font-weight: bold;">
                            Khi nào tôi sẽ nhận được đơn hàng?
                        </summary>
                        <div style="padding: 12px; background-color: #f9f9f9; margin-top: 8px; border-radius: 4px;">
                            Thường thì đơn hàng sẽ được giao trong 2-3 ngày làm việc. Bạn sẽ nhận được email cập nhật trạng thái.
                        </div>
                    </details>

                    <details style="margin-bottom: 12px;">
                        <summary style="padding: 12px; background-color: #f0f0f0; border-radius: 4px; cursor: pointer; font-weight: bold;">
                            Tôi có thể hủy đơn hàng không?
                        </summary>
                        <div style="padding: 12px; background-color: #f9f9f9; margin-top: 8px; border-radius: 4px;">
                            Bạn có thể hủy đơn hàng trong vòng 24 giờ đầu tiên. Vui lòng liên hệ với chúng tôi qua email hoặc hotline.
                        </div>
                    </details>

                    <details style="margin-bottom: 12px;">
                        <summary style="padding: 12px; background-color: #f0f0f0; border-radius: 4px; cursor: pointer; font-weight: bold;">
                            Chính sách đổi trả như thế nào?
                        </summary>
                        <div style="padding: 12px; background-color: #f9f9f9; margin-top: 8px; border-radius: 4px;">
                            Chúng tôi hỗ trợ đổi trả trong vòng 30 ngày từ ngày nhận hàng. Sản phẩm phải còn nguyên vẹn, chưa sử dụng.
                        </div>
                    </details>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
</body>
</html>

