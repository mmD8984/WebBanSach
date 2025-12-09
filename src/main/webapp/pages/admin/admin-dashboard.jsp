<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Thống kê doanh thu</title>
    <style>
        body { font-family: Arial; margin:20px; background:#f4f4f4; }
        table { width: 50%; border-collapse: collapse; background:white; }
        th, td { border:1px solid #ddd; padding:10px; }
        th { background:#20c997; color:white; }
        form { margin-bottom:20px; }
    </style>
</head>

<body>

<h2>Thống kê doanh thu</h2>

<form action="admin-dashboard" method="get">
    <label>Từ ngày:</label>
    <input type="date" name="start">

    <label>Đến ngày:</label>
    <input type="date" name="end">

    <button>Xem thống kê</button>
</form>

<h3>Kết quả:</h3>

<table>
    <tr>
        <th>Ngày</th>
        <th>Doanh thu</th>
        <th>Số đơn</th>
    </tr>

    <c:forEach var="stat" items="${stats}">
        <tr>
            <td>${stat.date}</td>
            <td>${stat.revenue}</td>
            <td>${stat.orders}</td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
