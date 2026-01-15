<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt hàng thành công - BookStore</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 20px;
                }

                .success-card {
                    background: white;
                    border-radius: 20px;
                    padding: 50px;
                    text-align: center;
                    max-width: 500px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
                    animation: bounceIn 0.6s ease;
                }

                @keyframes bounceIn {
                    0% {
                        opacity: 0;
                        transform: scale(0.8);
                    }

                    50% {
                        transform: scale(1.05);
                    }

                    100% {
                        opacity: 1;
                        transform: scale(1);
                    }
                }

                .success-icon {
                    font-size: 80px;
                    margin-bottom: 20px;
                }

                .success-card h1 {
                    font-size: 28px;
                    color: #27ae60;
                    margin-bottom: 15px;
                }

                .success-card p {
                    color: #666;
                    margin-bottom: 10px;
                }

                .order-code {
                    background: #f0f9f4;
                    padding: 15px 25px;
                    border-radius: 10px;
                    font-size: 20px;
                    font-weight: bold;
                    color: #27ae60;
                    margin: 20px 0;
                    display: inline-block;
                }

                .btn-group {
                    display: flex;
                    gap: 15px;
                    justify-content: center;
                    margin-top: 30px;
                }

                .btn {
                    padding: 15px 30px;
                    border-radius: 10px;
                    text-decoration: none;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                .btn-outline {
                    border: 2px solid #667eea;
                    color: #667eea;
                }

                .btn:hover {
                    transform: translateY(-2px);
                }
            </style>
        </head>

        <body>
            <div class="success-card">
                <div class="success-icon">✅</div>
                <h1>Đặt hàng thành công!</h1>
                <p>Cảm ơn bạn đã mua hàng tại BookStore</p>

                <c:if test="${not empty orderCode}">
                    <p>Mã đơn hàng của bạn:</p>
                    <div class="order-code">${orderCode}</div>
                </c:if>

                <p>Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng.</p>

                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-primary">Xem đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline">Về trang chủ</a>
                </div>
            </div>
        </body>

        </html>