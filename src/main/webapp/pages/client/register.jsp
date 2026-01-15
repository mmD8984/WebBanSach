<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng ký - BookStore</title>
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

                .register-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                    overflow: hidden;
                    width: 100%;
                    max-width: 450px;
                    animation: slideUp 0.5s ease;
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .register-header {
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    color: white;
                    padding: 40px 30px;
                    text-align: center;
                }

                .register-header h1 {
                    font-size: 28px;
                    margin-bottom: 10px;
                }

                .register-header p {
                    opacity: 0.9;
                }

                .register-form {
                    padding: 40px 30px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    color: #333;
                    font-weight: 600;
                }

                .form-group label span {
                    color: #e74c3c;
                }

                .form-group input {
                    width: 100%;
                    padding: 14px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 16px;
                    transition: border-color 0.3s, box-shadow 0.3s;
                }

                .form-group input:focus {
                    outline: none;
                    border-color: #11998e;
                    box-shadow: 0 0 0 3px rgba(17, 153, 142, 0.2);
                }

                .btn-register {
                    width: 100%;
                    padding: 15px;
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 18px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .btn-register:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 30px rgba(17, 153, 142, 0.4);
                }

                .message {
                    padding: 15px;
                    border-radius: 10px;
                    margin-bottom: 20px;
                    text-align: center;
                }

                .message.error {
                    background: #fee;
                    color: #c00;
                    border: 1px solid #fcc;
                }

                .links {
                    text-align: center;
                    margin-top: 25px;
                    padding-top: 25px;
                    border-top: 1px solid #eee;
                }

                .links a {
                    color: #11998e;
                    text-decoration: none;
                    font-weight: 500;
                }

                .links a:hover {
                    text-decoration: underline;
                }

                .back-home {
                    display: block;
                    text-align: center;
                    margin-top: 20px;
                }

                .form-row {
                    display: flex;
                    gap: 15px;
                }

                .form-row .form-group {
                    flex: 1;
                }
            </style>
        </head>

        <body>
            <div class="register-container">
                <div class="register-header">
                    <h1>📚 BookStore</h1>
                    <p>Tạo tài khoản mới</p>
                </div>

                <div class="register-form">
                    <c:if test="${not empty error}">
                        <div class="message error">${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/register">
                        <div class="form-group">
                            <label for="fullName">Họ và tên <span>*</span></label>
                            <input type="text" id="fullName" name="fullName" value="${fullName}"
                                placeholder="Nguyễn Văn A" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email <span>*</span></label>
                            <input type="email" id="email" name="email" value="${email}" placeholder="your@email.com"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" value="${phone}" placeholder="0901234567">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="password">Mật khẩu <span>*</span></label>
                                <input type="password" id="password" name="password" placeholder="Ít nhất 6 ký tự"
                                    required minlength="6">
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Xác nhận <span>*</span></label>
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                    placeholder="Nhập lại mật khẩu" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-register">Đăng ký</button>
                    </form>

                    <div class="links">
                        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
                    </div>

                    <a href="${pageContext.request.contextPath}/" class="back-home">← Về trang chủ</a>
                </div>
            </div>
        </body>

        </html>