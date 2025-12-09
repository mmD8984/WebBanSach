<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Quản lý người dùng</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f4f4f4; }
        h2 { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        table, th, td { border: 1px solid #ccc; }
        th, td { padding: 10px; text-align: left; }
        th { background: #007bff; color: white; }
        .btn { padding: 6px 12px; border: none; cursor: pointer; border-radius: 4px; }
        .btn-add { background: #28a745; color: white; }
        .btn-edit { background: #ffc107; }
        .btn-delete { background: #dc3545; color: white; }
        .search-box { margin-bottom: 20px; }
    </style>
</head>

<body>

<h2>Quản lý người dùng</h2>

<div class="search-box">
    <form action="admin-user" method="get">
        <input type="text" name="keyword" placeholder="Tìm theo username hoặc email" size="40">
        <button class="btn">Tìm kiếm</button>
    </form>
</div>

<button class="btn btn-add" onclick="document.getElementById('addForm').style.display='block'">
    + Thêm người dùng
</button>

<br><br>

<table>
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Vai trò</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>

    <c:forEach var="u" items="${userList}">
        <tr>
            <td>${u.id}</td>
            <td>${u.username}</td>
            <td>${u.email}</td>
            <td>${u.role}</td>
            <td>
                <c:choose>
                    <c:when test="${u.active}">Hoạt động</c:when>
                    <c:otherwise>Khóa</c:otherwise>
                </c:choose>
            </td>
            <td>
                <button class="btn btn-edit" onclick="location.href='admin-user?action=edit&id=${u.id}'">Sửa</button>
                <button class="btn btn-delete" onclick="location.href='admin-user?action=delete&id=${u.id}'">Xóa</button>
            </td>
        </tr>
    </c:forEach>
</table>

<!-- Form thêm người dùng -->
<div id="addForm" style="display:none; margin-top: 20px;">
    <h3>Thêm người dùng</h3>
    <form action="admin-user" method="post">
        <input type="hidden" name="action" value="add">

        <label>Username:</label><br>
        <input type="text" name="username" required><br><br>

        <label>Email:</label><br>
        <input type="email" name="email" required><br><br>

        <label>Mật khẩu:</label><br>
        <input type="password" name="password" required><br><br>

        <label>Vai trò:</label><br>
        <select name="role">
            <option value="USER">USER</option>
            <option value="ADMIN">ADMIN</option>
        </select><br><br>

        <button class="btn btn-add">Thêm</button>
    </form>
</div>

</body>
</html>
