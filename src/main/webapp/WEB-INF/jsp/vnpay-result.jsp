<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Kết quả thanh toán VNPAY">
    <title>Kết Quả Thanh Toán - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
    <style>
        .payment-result {
            max-width: 600px;
            margin: 60px auto;
            padding: 40px;
            border-radius: 8px;
            text-align: center;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
        }
        .result-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        .result-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #333;
        }
        .result-success {
            color: #4CAF50;
        }
        .result-failure {
            color: #f44336;
        }
        .result-info {
            background-color: white;
            padding: 20px;
            border-radius: 6px;
            margin: 20px 0;
            text-align: left;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: bold;
            color: #666;
        }
        .info-value {
            color: #333;
            text-align: right;
        }
        .amount {
            font-size: 24px;
            font-weight: bold;
            color: #d32f2f;
        }
        .button-group {
            margin-top: 30px;
        }
        .button-group a, .button-group button {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            font-size: 16px;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-outline {
            background-color: white;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-outline:hover {
            background-color: #f5f5f5;
        }
        .error-box {
            background-color: #ffebee;
            border: 1px solid #f44336;
            padding: 16px;
            border-radius: 4px;
            color: #c62828;
            margin: 20px 0;
        }
        .warning-box {
            background-color: #fff3e0;
            border: 1px solid #ff9800;
            padding: 16px;
            border-radius: 4px;
            color: #e65100;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <c:choose>
                <c:when test="${payment_success && !order_not_found}">
                    <!-- Success Result - This should redirect, but show fallback -->
                    <div class="payment-result">
                        <div class="result-icon result-success">✓</div>
                        <div class="result-title result-success">Thanh Toán Thành Công!</div>
                        
                        <div class="result-info">
                            <div class="info-row">
                                <span class="info-label">Mã Giao Dịch:</span>
                                <span class="info-value">${vnp_TxnRef}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số Tham Chiếu:</span>
                                <span class="info-value">${vnp_TransactionNo}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số Tiền:</span>
                                <span class="info-value amount"><fmt:formatNumber value="${vnp_Amount}" pattern="#,###"/>đ</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Thời Gian:</span>
                                <span class="info-value">
                                    <c:if test="${not empty vnp_PayDate}">
                                        ${vnp_PayDate.substring(0,4)}-${vnp_PayDate.substring(4,6)}-${vnp_PayDate.substring(6,8)}
                                        ${vnp_PayDate.substring(8,10)}:${vnp_PayDate.substring(10,12)}:${vnp_PayDate.substring(12,14)}
                                    </c:if>
                                </span>
                            </div>
                            <c:if test="${not empty vnp_OrderInfo}">
                                <div class="info-row">
                                    <span class="info-label">Thông Tin:</span>
                                    <span class="info-value">${vnp_OrderInfo}</span>
                                </div>
                            </c:if>
                        </div>

                        <p style="color: #666; margin: 20px 0; line-height: 1.6;">
                            Cảm ơn bạn đã mua sắm tại BookStore! <br>
                            Đơn hàng của bạn đã được xác nhận và sẽ được xử lý sớm.
                        </p>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/orders" class="btn-primary">📦 Xem Đơn Hàng</a>
                            <a href="${pageContext.request.contextPath}/products" class="btn-outline">Tiếp Tục Mua Sắm</a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${payment_success && order_not_found}">
                    <!-- Payment success but order not found in DB -->
                    <div class="payment-result">
                        <div class="result-icon" style="color: #ff9800;">⚠</div>
                        <div class="result-title" style="color: #ff9800;">Thanh Toán Thành Công - Đang Xử Lý</div>
                        
                        <div class="warning-box">
                            <strong>Lưu ý:</strong> Thanh toán của bạn đã thành công nhưng đơn hàng chưa được ghi nhận trong hệ thống.
                            Vui lòng liên hệ với chúng tôi để được hỗ trợ.
                        </div>
                        
                        <div class="result-info">
                            <div class="info-row">
                                <span class="info-label">Mã Giao Dịch:</span>
                                <span class="info-value">${vnp_TxnRef}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số Tiền:</span>
                                <span class="info-value amount"><fmt:formatNumber value="${vnp_Amount}" pattern="#,###"/>đ</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Thời Gian:</span>
                                <span class="info-value">
                                    <c:if test="${not empty vnp_PayDate}">
                                        ${vnp_PayDate.substring(0,4)}-${vnp_PayDate.substring(4,6)}-${vnp_PayDate.substring(6,8)}
                                        ${vnp_PayDate.substring(8,10)}:${vnp_PayDate.substring(10,12)}:${vnp_PayDate.substring(12,14)}
                                    </c:if>
                                </span>
                            </div>
                        </div>

                        <p style="color: #666; margin: 20px 0; line-height: 1.6;">
                            <strong>Hotline: 1800-1234 | Email: support@bookstore.com</strong>
                        </p>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/" class="btn-primary">Về Trang Chủ</a>
                            <a href="${pageContext.request.contextPath}/products" class="btn-outline">Tiếp Tục Mua Sắm</a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${vnp_ResponseCode != null && vnp_ResponseCode != '00'}">
                    <!-- Failure Result -->
                    <div class="payment-result">
                        <div class="result-icon result-failure">✗</div>
                        <div class="result-title result-failure">Thanh Toán Không Thành Công</div>
                        
                        <div class="error-box">
                            <strong>Lỗi:</strong> 
                            <c:choose>
                                <c:when test="${vnp_ResponseCode == '07'}">Trừ tiền thành công nhưng giao dịch đang được xử lý</c:when>
                                <c:when test="${vnp_ResponseCode == '09'}">Thẻ/Tài khoản chưa đăng ký InternetBanking</c:when>
                                <c:when test="${vnp_ResponseCode == '10'}">Xác thực thông tin sai quá 3 lần</c:when>
                                <c:when test="${vnp_ResponseCode == '11'}">Đã hết thời gian chờ thanh toán</c:when>
                                <c:when test="${vnp_ResponseCode == '12'}">Thẻ/Tài khoản bị khóa</c:when>
                                <c:when test="${vnp_ResponseCode == '13'}">Nhập sai mật khẩu OTP</c:when>
                                <c:when test="${vnp_ResponseCode == '24'}">Bạn đã hủy giao dịch</c:when>
                                <c:when test="${vnp_ResponseCode == '51'}">Tài khoản không đủ số dư</c:when>
                                <c:when test="${vnp_ResponseCode == '65'}">Tài khoản đã vượt quá hạn mức giao dịch</c:when>
                                <c:when test="${vnp_ResponseCode == '75'}">Ngân hàng đang bảo trì</c:when>
                                <c:otherwise>Giao dịch không thành công (Mã lỗi: ${vnp_ResponseCode})</c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${not empty vnp_TxnRef}">
                            <div class="result-info">
                                <div class="info-row">
                                    <span class="info-label">Mã Giao Dịch:</span>
                                    <span class="info-value">${vnp_TxnRef}</span>
                                </div>
                                <c:if test="${not empty vnp_Amount}">
                                    <div class="info-row">
                                        <span class="info-label">Số Tiền:</span>
                                        <span class="info-value"><fmt:formatNumber value="${vnp_Amount}" pattern="#,###"/>đ</span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                        <p style="color: #666; margin: 20px 0; line-height: 1.6;">
                            Vui lòng thử lại hoặc liên hệ với chúng tôi để được hỗ trợ. <br>
                            <strong>Hotline: 1900 6868 | Email: support@bookstore.vn</strong>
                        </p>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/checkout" class="btn-primary">Thử Lại</a>
                            <a href="${pageContext.request.contextPath}/" class="btn-outline">Về Trang Chủ</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Unknown Result -->
                    <div class="payment-result">
                        <div class="result-icon result-failure">?</div>
                        <div class="result-title">Không Rõ Kết Quả Thanh Toán</div>
                        
                        <c:if test="${not empty error}">
                            <div class="error-box">
                                <strong>Lỗi:</strong> ${error}
                            </div>
                        </c:if>

                        <c:if test="${checksum_valid == false}">
                            <div class="warning-box">
                                <strong>Cảnh Báo:</strong> Chữ ký không hợp lệ. Dữ liệu có thể đã bị thay đổi.
                            </div>
                        </c:if>

                        <p style="color: #666; margin: 20px 0; line-height: 1.6;">
                            Không thể xác định kết quả thanh toán của bạn. <br>
                            Vui lòng liên hệ với chúng tôi để được hỗ trợ. <br>
                            <strong>Hotline: 1900 6868 | Email: support@bookstore.vn</strong>
                        </p>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/" class="btn-primary">Về Trang Chủ</a>
                            <a href="${pageContext.request.contextPath}/products" class="btn-outline">Tiếp Tục Mua Sắm</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
</body>
</html>

