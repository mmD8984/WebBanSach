<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Quản lý danh mục</title>
    <style>
        body { font-family: Arial; margin:20px; background:#f4f4f4; }
        table { width:100%; border-collapse:collapse; background:white; }
        th, td { padding:10px; border:1px solid #ccc; }
        th { background:#6f42c1; color:white; }
        .btn { padding:6px 12px; border:none; border-radius:4px; cursor:pointer; }
        .btn-add { background:#28a745; color:white; }
        .btn-edit { background:#ffc107; }
        .btn-delete { background:#dc3545; color:white; }
    </style>
</head>

<body>

<h2>Quản lý danh mục</h2>

<button class="btn btn-add" onclick="document.getElementById('addForm').style.display='block'">
    + Thêm danh mục
</button>

<br><br>

<table>
    <tr>
        <th>ID</th>
        <th>Tên danh mục</th>
        <th>Hành động</th>
    </tr>

    <c:forEach items="${categoryList}" var="c">
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>
            <td>
                <button class="btn btn-edit" onclick="location.href='admin-category?action=edit&id=${c.id}'">Sửa</button>
                <button class="btn btn-delete" onclick="location.href='admin-category?action=delete&id=${c.id}'">Xóa</button>
            </td>
        </tr>
    </c:forEach>

</table>

<div id="addForm" style="display:none; margin-top:20px;">
    <h3>Thêm danh mục</h3>
    <form action="admin-category" method="post">
        <input type="hidden" name="action" value="add">
        <label>Tên danh mục:</label><br>
        <input type="text" name="name" required><br><br>
        <button class="btn btn-add">Thêm</button>
    </form>
</div>

</body>
</html>
