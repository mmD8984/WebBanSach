<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng nhập - BookStore</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 20px;
                }

                .login-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                    overflow: hidden;
                    width: 100%;
                    max-width: 400px;
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

                .login-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 40px 30px;
                    text-align: center;
                }

                .login-header h1 {
                    font-size: 28px;
                    margin-bottom: 10px;
                }

                .login-header p {
                    opacity: 0.9;
                }

                .login-form {
                    padding: 40px 30px;
                }

                .form-group {
                    margin-bottom: 25px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    color: #333;
                    font-weight: 600;
                }

                .form-group input {
                    width: 100%;
                    padding: 15px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 16px;
                    transition: border-color 0.3s, box-shadow 0.3s;
                }

                .form-group input:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
                }

                .btn-login {
                    width: 100%;
                    padding: 15px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 18px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .btn-login:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
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

                .message.success {
                    background: #efe;
                    color: #060;
                    border: 1px solid #cfc;
                }

                .links {
                    text-align: center;
                    margin-top: 25px;
                    padding-top: 25px;
                    border-top: 1px solid #eee;
                }

                .links a {
                    color: #667eea;
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
            </style>
        </head>

        <body>
            <div class="login-container">
                <div class="login-header">
                    <h1>📚 BookStore</h1>
                    <p>Chào mừng bạn quay trở lại</p>
                </div>

                <div class="login-form">
                    <c:if test="${not empty error}">
                        <div class="message error">${error}</div>
                    </c:if>
                    <c:if test="${not empty sessionScope.message}">
                        <div class="message success">${sessionScope.message}</div>
                        <c:remove var="message" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.loginMessage}">
                        <div class="message" style="background:#fff3cd;color:#856404;border:1px solid #ffc107;">
                            ${sessionScope.loginMessage}</div>
                        <c:remove var="loginMessage" scope="session" />
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/login">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${email}" placeholder="your@email.com"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" placeholder="••••••••" required>
                        </div>

                        <button type="submit" class="btn-login">Đăng nhập</button>
                    </form>

                    <div class="links">
                        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
                    </div>

                    <a href="${pageContext.request.contextPath}/" class="back-home">← Về trang chủ</a>
                </div>
            </div>
        </body>

        </html>