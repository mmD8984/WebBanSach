<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê doanh thu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">


<div class="container-fluid p-0">
    <div class="row g-0">
        <div class="col-12 col-md-9 col-lg-10 p-4">

            <h2 class="mb-4">Thống kê doanh thu</h2>

            <div class="row g-4">
                <!-- Doanh thu theo tuần -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            Doanh thu theo tuần
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-bordered table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tuần (ngày bắt đầu)</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="w" items="${weeklyRevenue}">
                                        <tr>
                                            <td>${w.label}</td>
                                            <td>${w.total}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty weeklyRevenue}">
                                        <tr>
                                            <td colspan="2" class="text-center text-muted">
                                                Chưa có dữ liệu
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Doanh thu theo tháng -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            Doanh thu theo tháng
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-bordered table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tháng</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${monthlyRevenue}">
                                        <tr>
                                            <td>${m.label}</td>
                                            <td>${m.total}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty monthlyRevenue}">
                                        <tr>
                                            <td colspan="2" class="text-center text-muted">
                                                Chưa có dữ liệu
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
