<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="common/head.jsp" %>
    <title>Đăng Ký - BookStore</title>
    <style>
        .register-container {
            max-width: 500px;
            margin: 60px auto;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h1 {
            color: var(--primary-color);
            font-size: 28px;
            margin: 0;
        }
        
        .register-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .form-group label {
            font-weight: 500;
            color: var(--text-dark);
            font-size: 14px;
        }
        
        .form-group input,
        .form-group textarea {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 4px;
            border: 1px solid #f5c6cb;
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .register-btn {
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }
        
        .register-btn:hover {
            background-color: #c82333;
        }
        
        .register-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--text-muted);
        }
        
        .register-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .register-footer a:hover {
            color: #c82333;
        }
        
        @media (max-width: 768px) {
            .register-container {
                margin: 40px 20px;
                padding: 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <main>
        <div class="register-container">
            <div class="register-header">
                <h1>Đăng Ký</h1>
                <p style="color: var(--text-muted); margin: 10px 0 0 0; font-size: 14px;">
                    Tạo tài khoản để bắt đầu mua sắm
                </p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post" class="register-form" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="fullname">Họ và Tên *</label>
                    <input 
                        type="text" 
                        id="fullname" 
                        name="fullname" 
                        value="${fullname}" 
                        placeholder="Nhập họ và tên"
                        required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        value="${email}" 
                        placeholder="Nhập email của bạn"
                        required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Mật khẩu *</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)"
                            required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận Mật khẩu *</label>
                        <input 
                            type="password" 
                            id="confirmPassword" 
                            name="confirmPassword" 
                            placeholder="Nhập lại mật khẩu"
                            required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone">Số Điện Thoại *</label>
                    <input 
                        type="tel" 
                        id="phone" 
                        name="phone" 
                        value="${phone}" 
                        placeholder="Nhập số điện thoại (10-11 số)"
                        pattern="[0-9]{10,11}"
                        required>
                </div>
                
                <div class="form-group">
                    <label for="address">Địa Chỉ</label>
                    <textarea 
                        id="address" 
                        name="address" 
                        placeholder="Nhập địa chỉ của bạn">${address}</textarea>
                </div>
                
                <button type="submit" class="register-btn">Đăng Ký</button>
            </form>
            
            <div class="register-footer">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </div>
    </main>
    
    <%@ include file="common/footer.jsp" %>
    
    <script>
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password.length < 6) {
                alert('Mật khẩu phải có ít nhất 6 ký tự');
                return false;
            }
            
            if (password !== confirmPassword) {
                alert('Mật khẩu xác nhận không khớp');
                return false;
            }
            
            const phone = document.getElementById('phone').value;
            if (!/^[0-9]{10,11}$/.test(phone)) {
                alert('Số điện thoại không hợp lệ (10-11 số)');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>

