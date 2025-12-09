<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Quản lý sách</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f4f4f4; }
        h2 { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        table, th, td { border: 1px solid #ccc; }
        th, td { padding: 10px; }
        th { background: #17a2b8; color: white; }
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-add { background: #28a745; color: white; }
        .btn-edit { background: #ffc107; }
        .btn-delete { background: #dc3545; color: white; }
    </style>
</head>

<body>

<h2>Quản lý sách</h2>

<form action="admin-book" method="get">
    <input type="text" name="keyword" placeholder="Tìm theo tên hoặc tác giả" size="40">
    <button class="btn">Tìm kiếm</button>
</form>

<br>

<button class="btn btn-add" onclick="document.getElementById('addForm').style.display='block'">+ Thêm sách</button>

<br><br>

<table>
    <tr>
        <th>ID</th>
        <th>Tên sách</th>
        <th>Tác giả</th>
        <th>Giá</th>
        <th>Số lượng</th>
        <th>Ảnh bìa</th>
        <th>Hành động</th>
    </tr>

    <c:forEach var="b" items="${bookList}">
        <tr>
            <td>${b.id}</td>
            <td>${b.title}</td>
            <td>${b.author}</td>
            <td>${b.price}</td>
            <td>${b.quantity}</td>
            <td><img src="${b.image}" width="60"></td>
            <td>
                <button class="btn btn-edit" onclick="location.href='admin-book?action=edit&id=${b.id}'">Sửa</button>
                <button class="btn btn-delete" onclick="location.href='admin-book?action=delete&id=${b.id}'">Xóa</button>
            </td>
        </tr>
    </c:forEach>

</table>

<!-- form thêm sách -->
<div id="addForm" style="display:none; margin-top:20px;">
    <h3>Thêm sách</h3>
    <form action="admin-book" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">

        <label>Tên sách:</label><br>
        <input type="text" name="title" required><br><br>

        <label>Tác giả:</label><br>
        <input type="text" name="author" required><br><br>

        <label>Giá:</label><br>
        <input type="number" name="price" required><br><br>

        <label>Số lượng:</label><br>
        <input type="number" name="quantity" required><br><br>

        <label>Mô tả:</label><br>
        <textarea name="description" rows="4" cols="40"></textarea><br><br>

        <label>Ảnh bìa:</label><br>
        <input type="file" name="image"><br><br>

        <button class="btn btn-add">Thêm</button>
    </form>
</div>

</body>
</html>
