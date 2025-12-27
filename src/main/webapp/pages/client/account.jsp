<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tài khoản - BookStore</title>
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
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 30px 20px;
                }

                .page-title {
                    font-size: 32px;
                    margin-bottom: 30px;
                }

                .message {
                    padding: 15px;
                    border-radius: 10px;
                    margin-bottom: 20px;
                    text-align: center;
                }

                .message.success {
                    background: #d4edda;
                    color: #155724;
                }

                .message.error {
                    background: #f8d7da;
                    color: #721c24;
                }

                .account-layout {
                    display: grid;
                    gap: 30px;
                }

                .account-section {
                    background: white;
                    border-radius: 15px;
                    padding: 30px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                }

                .section-title {
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

                .form-group input {
                    width: 100%;
                    padding: 14px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 16px;
                }

                .form-group input:focus {
                    outline: none;
                    border-color: #667eea;
                }

                .form-group input:disabled {
                    background: #f5f5f5;
                    color: #666;
                }

                .form-row {
                    display: flex;
                    gap: 20px;
                }

                .form-row .form-group {
                    flex: 1;
                }

                .btn {
                    padding: 14px 30px;
                    border-radius: 10px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    border: none;
                    transition: all 0.3s;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                .btn-primary:hover {
                    opacity: 0.9;
                }

                .btn-warning {
                    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                    color: white;
                }

                .user-avatar {
                    width: 100px;
                    height: 100px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 40px;
                    color: white;
                    margin: 0 auto 20px;
                }

                .user-email {
                    text-align: center;
                    color: #666;
                    margin-bottom: 20px;
                }

                .user-role {
                    display: inline-block;
                    padding: 5px 15px;
                    border-radius: 15px;
                    font-size: 12px;
                    font-weight: 600;
                    text-transform: uppercase;
                }

                .role-customer {
                    background: #d4edda;
                    color: #155724;
                }

                .role-admin {
                    background: #cce5ff;
                    color: #004085;
                }

                .role-staff {
                    background: #fff3cd;
                    color: #856404;
                }

                .help-text {
                    font-size: 13px;
                    color: #999;
                    margin-top: 5px;
                }
            </style>
        </head>

        <body>
            <header>
                <div class="header-content">
                    <a href="${pageContext.request.contextPath}/" class="logo">📚 BookStore</a>
                    <nav>
                        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/books">Sách</a>
                        <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
                        <a href="${pageContext.request.contextPath}/my-orders">Đơn hàng</a>
                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </nav>
                </div>
            </header>

            <div class="container">
                <h1 class="page-title">👤 Tài khoản của tôi</h1>

                <c:if test="${not empty sessionScope.message}">
                    <div class="message success">${sessionScope.message}</div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="message error">${sessionScope.error}</div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="account-layout">
                    <!-- Profile Info -->
                    <div class="account-section">
                        <div class="user-avatar">👤</div>
                        <p class="user-email">${user.email}</p>
                        <p style="text-align:center;">
                            <span class="user-role role-${user.role}">${user.role}</span>
                        </p>
                    </div>

                    <!-- Update Profile -->
                    <div class="account-section">
                        <h2 class="section-title">📝 Thông tin cá nhân</h2>
                        <form method="post" action="${pageContext.request.contextPath}/account">
                            <input type="hidden" name="action" value="update">

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" value="${user.email}" disabled>
                                <p class="help-text">Email không thể thay đổi</p>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="fullName">Họ và tên *</label>
                                    <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="tel" id="phone" name="phone" value="${user.phone}"
                                        placeholder="0901234567">
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary">Cập nhật thông tin</button>
                        </form>
                    </div>

                    <!-- Change Password -->
                    <div class="account-section">
                        <h2 class="section-title">🔐 Đổi mật khẩu</h2>
                        <form method="post" action="${pageContext.request.contextPath}/account">
                            <input type="hidden" name="action" value="password">

                            <div class="form-group">
                                <label for="currentPassword">Mật khẩu hiện tại *</label>
                                <input type="password" id="currentPassword" name="currentPassword" required>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="newPassword">Mật khẩu mới *</label>
                                    <input type="password" id="newPassword" name="newPassword" required minlength="6">
                                    <p class="help-text">Ít nhất 6 ký tự</p>
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Xác nhận mật khẩu *</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-warning">Đổi mật khẩu</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>