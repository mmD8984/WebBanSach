<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="common/head.jsp" %>
    <title>Đăng Nhập - BookStore</title>
    <style>
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header h1 {
            color: var(--primary-color);
            font-size: 28px;
            margin: 0;
        }
        
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .form-group label {
            font-weight: 500;
            color: var(--text-dark);
            font-size: 14px;
        }
        
        .form-group input {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
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
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            border: 1px solid #c3e6cb;
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .login-btn {
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
        
        .login-btn:hover {
            background-color: #c82333;
        }
        
        .login-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--text-muted);
        }
        
        .login-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .login-footer a:hover {
            color: #c82333;
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <main>
        <div class="login-container">
            <div class="login-header">
                <h1>Đăng Nhập</h1>
                <p style="color: var(--text-muted); margin: 10px 0 0 0; font-size: 14px;">
                    Đăng nhập để tiếp tục mua sắm
                </p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        value="${email}" 
                        placeholder="Nhập email của bạn"
                        required>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        placeholder="Nhập mật khẩu"
                        required>
                </div>
                
                <input type="hidden" name="returnUrl" value="${not empty returnUrl ? returnUrl : pageContext.request.contextPath}">
                
                <button type="submit" class="login-btn">Đăng Nhập</button>
            </form>
            
            <div class="login-footer">
                Chưa có tài khoản? 
                <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </div>
    </main>
    
    <%@ include file="common/footer.jsp" %>
</body>
</html>

