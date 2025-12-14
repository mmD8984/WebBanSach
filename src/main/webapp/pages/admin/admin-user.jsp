<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4">

    <h2 class="mb-4">Quản lý người dùng</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- DANH SÁCH USERS -->
    <div class="card mb-4">
        <div class="card-header bg-dark text-white">
            Danh sách người dùng
        </div>
        <div class="card-body">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Email</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th width="150px">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${userList}">
                        <tr>
                            <td>${u.id}</td>
                            <td>${u.email}</td>
                            <td>${u.fullName}</td>
                            <td>${u.phone}</td>
                            <td>${u.role}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.active}">Hoạt động</c:when>
                                    <c:otherwise>Khóa</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/admin-user?action=edit&id=${u.id}">
                                    Sửa
                                </a>

                                <button class="btn btn-sm btn-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${u.id}">
                                    Xóa
                                </button>

                                <div class="modal fade" id="deleteModal${u.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                Bạn có chắc muốn xóa người dùng:
                                                <strong>${u.fullName}</strong> (${u.email})?
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                <a href="${pageContext.request.contextPath}/admin-user?action=delete&id=${u.id}"
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
                <c:when test="${user != null}">Chỉnh sửa người dùng</c:when>
                <c:otherwise>Thêm người dùng mới</c:otherwise>
            </c:choose>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin-user">

                <input type="hidden" name="action"
                       value="<c:out value='${user != null ? "update" : "create"}' />">

                <c:if test="${user != null}">
                    <input type="hidden" name="id" value="${user.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email"
                           value="${user.email}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" class="form-control" name="fullName"
                           value="${user.fullName}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" name="phone"
                           value="${user.phone}">
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Mật khẩu
                        <c:if test="${user != null}">
                            <small class="text-muted">(để trống nếu không đổi)</small>
                        </c:if>
                    </label>
                    <input type="password" class="form-control" name="password"
                           <c:if test="${user == null}">required</c:if>>
                </div>

                <div class="mb-3">
                    <label class="form-label">Vai trò</label>
                    <select class="form-select" name="role">
                        <option value="customer"
                            <c:if test="${user.role == 'customer' || user == null}">selected</c:if>>
                            Khách hàng
                        </option>
                        <option value="staff"
                            <c:if test="${user.role == 'staff'}">selected</c:if>>
                            Nhân viên
                        </option>
                        <option value="admin"
                            <c:if test="${user.role == 'admin'}">selected</c:if>>
                            Quản trị
                        </option>
                    </select>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="active"
                           id="activeCheck"
                           <c:if test="${user == null || user.active}">checked</c:if>>
                    <label class="form-check-label" for="activeCheck">
                        Hoạt động
                    </label>
                </div>

                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${user != null}">Cập nhật</c:when>
                        <c:otherwise>Thêm mới</c:otherwise>
                    </c:choose>
                </button>

                <c:if test="${user != null}">
                    <a href="${pageContext.request.contextPath}/admin-user"
                       class="btn btn-secondary ms-2">Hủy</a>
                </c:if>

            </form>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
