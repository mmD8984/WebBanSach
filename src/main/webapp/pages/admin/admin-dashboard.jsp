<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f5f6fa; }
        .card-stat {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .card-stat h2 { font-weight: bold; }
        .sidebar {
            min-height: 100vh;
            background: #1e293b;	
            color: #fff;
        }
        .sidebar a {
            color: #cbd5e1;
            text-decoration: none;
            display: block;
            padding: 12px 16px;
        }
        .sidebar a:hover {
            background: #334155;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-2 sidebar p-0">
            <h5 class="text-center py-3 border-bottom">ADMIN PANEL</h5>
            <a href="${pageContext.request.contextPath}/admin-dashboard">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin-category">📂 Quản lý danh mục</a>
            <a href="${pageContext.request.contextPath}/admin-book">📦 Quản lý sách</a>
            <a href="${pageContext.request.contextPath}/admin-user">👤 Quản lý người dùng</a>
            <a href="${pageContext.request.contextPath}/admin-order">👤 Quản lý đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin-revenue">👤 Thông kê doanh thu</a>
            <a href="logout">🚪 Đăng xuất</a>
        </div>

        <!-- Main content -->
        <div class="col-10 p-4">
            <h3 class="mb-4">Tổng quan</h3>

            <div class="row g-4">
                <div class="col-md-3">
                    <div class="card card-stat p-3">
                        <p class="text-muted mb-1">Danh mục</p>
                        <h2>${totalCategories}</h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat p-3">
                        <p class="text-muted mb-1">Sản phẩm</p>
                        <h2>${totalBooks}</h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat p-3">
                        <p class="text-muted mb-1">Người dùng</p>
                        <h2>${totalUsers}</h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat p-3">
                        <p class="text-muted mb-1">Đơn hàng</p>
                        <h2>${totalOrders}</h2>
                    </div>
                </div>
            </div>

            <div class="row mt-5">
                <div class="col-md-6">
                    <div class="card card-stat p-3">
                        <h5>Sản phẩm mới nhất</h5>
                        <table class="table table-sm mt-3">
                            <thead>
                            <tr>
                                <th>Tên Sách</th>
                                <th>Giá Bán</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>${latestBookTitle}</td>
                                    <td>${latestBookPrice}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card card-stat p-3">
                        <h5>Người dùng mới</h5>
                        <table class="table table-sm mt-3">
                            <thead>
                            <tr>
                                <th>Họ và Tên</th>
                                <th>Số điện thoại</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>${latestUserName}</td>
                                    <td>${latestUserPhone}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
