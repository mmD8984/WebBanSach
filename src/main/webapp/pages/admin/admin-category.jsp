<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý danh mục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container py-4">

    <h2 class="mb-4">Quản lý danh mục</h2>

    <!-- THÔNG BÁO -->
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- DANH SÁCH DANH MỤC -->
    <div class="card">
        <div class="card-header bg-dark text-white">
            Danh sách danh mục
        </div>
        <div class="card-body">

            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Slug</th>
                        <th>Mô tả</th>
                        <th width="150px">Hành động</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="item" items="${categoryList}">
                        <tr>
                            <td>${item.id}</td>
                            <td>${item.name}</td>
                            <td>${item.slug}</td>
                            <td>${item.description}</td>
                            <td>
                                <a class="btn btn-sm btn-primary"
                                   href="/WebBanSach/admin-category?action=edit&id=${item.id}">
                                    Sửa
                                </a>

                                <!-- Button mở modal xóa -->
                                <button class="btn btn-sm btn-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${item.id}">
                                    Xóa
                                </button>

                                <!-- Modal xác nhận xóa -->
                                <div class="modal fade" id="deleteModal${item.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                Bạn có chắc muốn xóa danh mục:
                                                <strong>${item.name}</strong>?
                                            </div>

                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>

                                                <a href="/WebBanSach/admin-category?action=delete&id=${item.id}"
                                                   class="btn btn-danger">Xóa</a>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>

            </table>
        </div>
    </div>
    
    <!-- FORM THÊM / SỬA -->
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            <c:choose>
                <c:when test="${category != null}">
                    Chỉnh sửa danh mục
                </c:when>
                <c:otherwise>
                    Thêm danh mục mới
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card-body">
            <form method="post" action="/WebBanSach/admin-category">

                <input type="hidden" name="action"
                       value="<c:out value='${category != null ? "update" : "create"}' />">

                <c:if test="${category != null}">
                    <input type="hidden" name="id" value="${category.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Tên danh mục</label>
                    <input type="text" class="form-control" name="name"
                           value="${category.name}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Slug</label>
                    <input type="text" class="form-control" name="slug"
                           value="${category.slug}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" name="description" rows="3">${category.description}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Danh mục cha</label>
                    <select class="form-select" name="parentId">
                        <option value="0">Không có</option>

                        <c:forEach var="c" items="${categoryList}">
                            <option value="${c.id}"
                                    <c:if test="${category.parentId == c.id}">selected</c:if>>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${category != null}">Cập nhật</c:when>
                        <c:otherwise>Thêm mới</c:otherwise>
                    </c:choose>
                </button>

                <c:if test="${category != null}">
                    <a href="/WebBanSach/admin-category" class="btn btn-secondary ms-2">Hủy</a>
                </c:if>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
