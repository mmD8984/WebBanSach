<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4">

    <h2 class="mb-4">Quản lý sách</h2>
    
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">← Về trang chủ</a>
        <a href="${pageContext.request.contextPath}/admin-category" class="btn btn-outline-primary ms-2">Quản lý thể loại</a>
        <a href="${pageContext.request.contextPath}/admin-user" class="btn btn-outline-primary ms-2">Quản lý người dùng</a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- DANH SÁCH SÁCH -->
    <div class="card mb-4">
        <div class="card-header bg-dark text-white">
            Danh sách sách
        </div>
        <div class="card-body">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Tác giả</th>
                        <th>Thể loại</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th width="150px">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookList}">
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.title}</td>
                            <td>${b.authorName}</td>
                            <td>${b.categoryName}</td>
                            <td><fmt:formatNumber value="${b.price}" type="number"/> đ</td>
                            <td>${b.stock}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'available'}">
                                        <span class="badge bg-success">Còn hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/admin-book?action=edit&id=${b.id}">
                                    Sửa
                                </a>

                                <button class="btn btn-sm btn-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${b.id}">
                                    Xóa
                                </button>

                                <div class="modal fade" id="deleteModal${b.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                Bạn có chắc muốn xóa sách:
                                                <strong>${b.title}</strong>?
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                <a href="${pageContext.request.contextPath}/admin-book?action=delete&id=${b.id}"
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
    <div class="card">
        <div class="card-header bg-primary text-white">
            <c:choose>
                <c:when test="${book != null}">Chỉnh sửa sách</c:when>
                <c:otherwise>Thêm sách mới</c:otherwise>
            </c:choose>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin-book">

                <input type="hidden" name="action"
                       value="<c:out value='${book != null ? "update" : "create"}' />">

                <c:if test="${book != null}">
                    <input type="hidden" name="id" value="${book.id}">
                </c:if>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề *</label>
                            <input type="text" class="form-control" name="title"
                                   value="${book.title}" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Tác giả</label>
                            <select class="form-select" name="authorId">
                                <option value="">-- Chọn tác giả --</option>
                                <c:forEach var="a" items="${authorList}">
                                    <option value="${a.id}" 
                                        <c:if test="${book.authorId == a.id}">selected</c:if>>
                                        ${a.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" name="description" rows="3">${book.description}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <div class="mb-3">
                            <label class="form-label">Giá *</label>
                            <input type="number" min="0" class="form-control" name="price"
                                   value="${book.price}" required>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <label class="form-label">Giá gốc</label>
                            <input type="number" min="0" class="form-control" name="originalPrice"
                                   value="${book.originalPrice}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <label class="form-label">Tồn kho *</label>
                            <input type="number" min="0" class="form-control" name="stock"
                                   value="${book.stock}" required>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <label class="form-label">Thể loại</label>
                            <select class="form-select" name="categoryId">
                                <option value="">-- Chọn thể loại --</option>
                                <c:forEach var="c" items="${categoryList}">
                                    <option value="${c.id}" 
                                        <c:if test="${book.categoryId == c.id}">selected</c:if>>
                                        ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ảnh bìa (URL)</label>
                    <input type="text" class="form-control" name="image"
                           value="${book.image}">
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="featured"
                                   id="featuredCheck"
                                   <c:if test="${book.featured}">checked</c:if>>
                            <label class="form-check-label" for="featuredCheck">
                                Nổi bật
                            </label>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="bestseller"
                                   id="bestsellerCheck"
                                   <c:if test="${book.bestseller}">checked</c:if>>
                            <label class="form-check-label" for="bestsellerCheck">
                                Bán chạy
                            </label>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="isNew"
                                   id="newCheck"
                                   <c:if test="${book.new}">checked</c:if>>
                            <label class="form-check-label" for="newCheck">
                                Sách mới
                            </label>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${book != null}">Cập nhật</c:when>
                        <c:otherwise>Thêm mới</c:otherwise>
                    </c:choose>
                </button>

                <c:if test="${book != null}">
                    <a href="${pageContext.request.contextPath}/admin-book"
                       class="btn btn-secondary ms-2">Hủy</a>
                </c:if>
            </form>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

