<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Quản lý đơn hàng</title>
    <style>
        body { font-family: Arial; margin:20px; background:#f4f4f4; }
        table { width:100%; border-collapse:collapse; background:white; }
        th, td { border:1px solid #ddd; padding:10px; }
        th { background:#fd7e14; color:white; }
        .btn { padding:6px 12px; border:none; border-radius:4px; cursor:pointer; }
        .btn-view { background:#17a2b8; color:white; }
        .btn-update { background:#28a745; color:white; }
    </style>
</head>

<body>

<h2>Quản lý đơn hàng</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Người mua</th>
        <th>Tổng tiền</th>
        <th>Ngày đặt</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>

    <c:forEach var="o" items="${orderList}">
        <tr>
            <td>${o.id}</td>
            <td>${o.username}</td>
            <td>${o.totalAmount}</td>
            <td>${o.orderDate}</td>
            <td>${o.status}</td>
            <td>
                <button class="btn btn-view" onclick="location.href='admin-order?action=view&id=${o.id}'">Xem</button>
                <button class="btn btn-update" onclick="location.href='admin-order?action=update&id=${o.id}'">Cập nhật</button>
            </td>
        </tr>
    </c:forEach>

</table>

</body>
</html>
