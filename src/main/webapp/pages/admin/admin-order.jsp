<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4">

    <h2 class="mb-4">Quản lý đơn hàng</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- DANH SÁCH ĐƠN HÀNG -->
    <div class="card mb-4">
        <div class="card-header bg-dark text-white">
            Danh sách đơn hàng
        </div>
        <div class="card-body">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Thanh toán</th>
                        <th>Ngày tạo</th>
                        <th width="150px">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orderList}">
                        <tr>
                            <td>${o.id}</td>
                            <td>${o.orderCode}</td>
                            <td>${o.userName}</td>
                            <td>${o.totalAmount}</td>
                            <td>${o.status}</td>
                            <td>${o.paymentStatus}</td>
                            <td>
                                <c:if test="${o.createdAt != null}">
                                    ${o.createdAt}
                                </c:if>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/admin-order?action=edit&id=${o.id}">
                                    Xem / Sửa
                                </a>

                                <button class="btn btn-sm btn-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${o.id}">
                                    Xóa
                                </button>

                                <div class="modal fade" id="deleteModal${o.id}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                Bạn có chắc muốn xóa đơn hàng:
                                                <strong>${o.orderCode}</strong> của khách
                                                <strong>${o.userName}</strong>?
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                <a href="${pageContext.request.contextPath}/admin-order?action=delete&id=${o.id}"
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

    <!-- FORM XEM / CẬP NHẬT ĐƠN -->
    <div class="card">
        <div class="card-header bg-primary text-white">
            <c:choose>
                <c:when test="${order != null}">Chi tiết đơn hàng</c:when>
                <c:otherwise>Tạo đơn mới (demo)</c:otherwise>
            </c:choose>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin-order">

                <input type="hidden" name="action"
                       value="<c:out value='${order != null ? "update" : "create"}' />">

                <c:if test="${order != null}">
                    <input type="hidden" name="id" value="${order.id}">
                </c:if>

                <c:if test="${order != null}">
                    <div class="mb-3">
                        <label class="form-label">Mã đơn hàng</label>
                        <input type="text" class="form-control" value="${order.orderCode}" disabled>
                    </div>
                </c:if>

                <div class="mb-3">
                    <label class="form-label">ID khách hàng</label>
                    <input type="number" min="0" class="form-control" name="userId"
                           value="${order.userId}">
                    <small class="text-muted">0 hoặc trống = khách ẩn danh</small>
                </div>

                <div class="mb-3">
                    <label class="form-label">Tổng tiền</label>
                    <input type="number" step="0.01" min="0" class="form-control" name="totalAmount"
                           value="${order.totalAmount}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa chỉ giao hàng</label>
                    <textarea class="form-control" name="shippingAddress" rows="2"
                              required>${order.shippingAddress}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái đơn hàng</label>
                    <select class="form-select" name="status">
                        <c:set var="st" value="${order.status}" />
                        <option value="pending"
                            <c:if test="${st == 'pending' || order == null}">selected</c:if>>
                            Chờ xử lý
                        </option>
                        <option value="confirmed"
                            <c:if test="${st == 'confirmed'}">selected</c:if>>
                            Đã xác nhận
                        </option>
                        <option value="shipping"
                            <c:if test="${st == 'shipping'}">selected</c:if>>
                            Đang giao
                        </option>
                        <option value="delivered"
                            <c:if test="${st == 'delivered'}">selected</c:if>>
                            Đã giao
                        </option>
                        <option value="cancelled"
                            <c:if test="${st == 'cancelled'}">selected</c:if>>
                            Đã hủy
                        </option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Hình thức thanh toán</label>
                    <select class="form-select" name="paymentMethod">
                        <c:set var="pm" value="${order.paymentMethod}" />
                        <option value="cod"
                            <c:if test="${pm == 'cod' || order == null}">selected</c:if>>
                            COD
                        </option>
                        <option value="bank_transfer"
                            <c:if test="${pm == 'bank_transfer'}">selected</c:if>>
                            Chuyển khoản
                        </option>
                        <option value="vnpay"
                            <c:if test="${pm == 'vnpay'}">selected</c:if>>
                            VNPay
                        </option>
                        <option value="momo"
                            <c:if test="${pm == 'momo'}">selected</c:if>>
                            Momo
                        </option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái thanh toán</label>
                    <select class="form-select" name="paymentStatus">
                        <c:set var="ps" value="${order.paymentStatus}" />
                        <option value="pending"
                            <c:if test="${ps == 'pending' || order == null}">selected</c:if>>
                            Chờ thanh toán
                        </option>
                        <option value="paid"
                            <c:if test="${ps == 'paid'}">selected</c:if>>
                            Đã thanh toán
                        </option>
                        <option value="failed"
                            <c:if test="${ps == 'failed'}">selected</c:if>>
                            Thanh toán lỗi
                        </option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ghi chú</label>
                    <textarea class="form-control" name="note" rows="2">${order.note}</textarea>
                </div>

                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${order != null}">Cập nhật</c:when>
                        <c:otherwise>Tạo đơn (demo)</c:otherwise>
                    </c:choose>
                </button>

                <c:if test="${order != null}">
                    <a href="${pageContext.request.contextPath}/admin-order"
                       class="btn btn-secondary ms-2">Hủy</a>
                </c:if>

            </form>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
