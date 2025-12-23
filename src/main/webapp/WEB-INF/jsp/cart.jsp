<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Giỏ hàng - BookStore">
    <title>Giỏ Hàng - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <h1 class="page-title">Giỏ Hàng</h1>

            <div class="cart-wrapper">
                <!-- Cart Items -->
                <div class="cart-items-section">
                    <div id="empty-cart" class="empty-cart" style="display: none; text-align: center; padding: 40px 20px;">
                        <p style="font-size: 18px; margin-bottom: 20px;">🛒 Giỏ hàng của bạn trống</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Tiếp Tục Mua Sắm</a>
                    </div>

                    <div id="cart-items" class="cart-items">
                        <!-- Populated by JavaScript from localStorage -->
                    </div>

                    <!-- Cart Items Table Template (hidden) -->
                    <template id="cart-table-template">
                        <table class="cart-table" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                            <thead>
                                <tr style="border-bottom: 2px solid #ddd;">
                                    <th style="text-align: left; padding: 12px; font-weight: bold;">Sản Phẩm</th>
                                    <th style="text-align: center; padding: 12px; font-weight: bold;">Giá</th>
                                    <th style="text-align: center; padding: 12px; font-weight: bold;">Số Lượng</th>
                                    <th style="text-align: center; padding: 12px; font-weight: bold;">Thành Tiền</th>
                                    <th style="text-align: center; padding: 12px; font-weight: bold;">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody id="cart-items-tbody">
                                <!-- Rows will be inserted here -->
                            </tbody>
                        </table>
                    </template>

                    <!-- Cart Item Row Template (hidden) -->
                    <template id="cart-item-row-template">
                        <tr class="cart-item-row" data-product-id="0" style="border-bottom: 1px solid #eee;">
                            <td style="padding: 12px; display: flex; align-items: center;">
                                <img class="item-image" src="" alt="" style="width: 60px; height: 80px; object-fit: cover; margin-right: 12px;">
                                <div class="item-info">
                                    <h4 class="item-title" style="margin: 0 0 4px 0; font-size: 14px; font-weight: bold;"></h4>
                                    <p class="item-author" style="margin: 0; font-size: 12px; color: #666;"></p>
                                </div>
                            </td>
                            <td style="text-align: center; padding: 12px;">
                                <span class="item-price" style="font-weight: bold;">0đ</span>
                            </td>
                            <td style="text-align: center; padding: 12px;">
                                <div style="display: flex; align-items: center; justify-content: center; gap: 8px;">
                                    <button class="qty-btn-decrease" style="padding: 4px 8px; cursor: pointer;">−</button>
                                    <input type="number" class="item-quantity" value="1" min="1" style="width: 50px; text-align: center; border: 1px solid #ddd; padding: 4px;">
                                    <button class="qty-btn-increase" style="padding: 4px 8px; cursor: pointer;">+</button>
                                </div>
                            </td>
                            <td style="text-align: center; padding: 12px;">
                                <span class="item-total" style="font-weight: bold; color: #d32f2f;">0đ</span>
                            </td>
                            <td style="text-align: center; padding: 12px;">
                                <button class="btn-remove" style="padding: 6px 12px; background-color: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">Xóa</button>
                            </td>
                        </tr>
                    </template>
                </div>

                <!-- Cart Summary -->
                <aside class="cart-summary" style="width: 30%; padding: 20px;">
                    <div class="summary-card" style="border: 1px solid #ddd; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
                        <h2 style="margin-top: 0; font-size: 18px; font-weight: bold; margin-bottom: 16px;">Tóm Tắt Đơn Hàng</h2>
                        
                        <div class="summary-row" style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                            <span>Tổng tiền hàng:</span>
                            <span id="subtotal" style="font-weight: bold;">0đ</span>
                        </div>

                        <div class="summary-row" style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                            <span>Phí vận chuyển:</span>
                            <span id="shipping-fee" style="font-weight: bold;">0đ</span>
                        </div>

                        <div class="summary-row" style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                            <span>Giảm giá:</span>
                            <span id="discount" class="discount-amount" style="font-weight: bold; color: #d32f2f;">0đ</span>
                        </div>

                        <div class="summary-row summary-total" style="display: flex; justify-content: space-between; padding: 12px 0; border-top: 2px solid #333; border-bottom: 2px solid #333; margin: 12px 0; font-weight: bold; font-size: 16px;">
                            <span>Thành Tiền:</span>
                            <span id="total" style="color: #d32f2f;">0đ</span>
                        </div>

                        <div class="coupon-section" style="margin: 16px 0;">
                            <input type="text" id="coupon-input" placeholder="Mã khuyến mãi" class="coupon-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; margin-bottom: 8px;">
                            <button class="btn btn-sm btn-outline" id="apply-coupon" style="width: 100%; padding: 8px; cursor: pointer;">Áp Dụng</button>
                        </div>

                        <button class="btn btn-primary btn-lg" id="checkout-btn" style="width: 100%; padding: 12px; margin-bottom: 12px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
                            Thanh Toán
                        </button>

                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-lg" style="display: block; width: 100%; padding: 12px; text-align: center; text-decoration: none; border: 1px solid #ddd; border-radius: 4px; color: #333; background-color: white;">
                            Tiếp Tục Mua Sắm
                        </a>
                    </div>

                    <!-- Shipping Info -->
                    <div class="info-card" style="border: 1px solid #ddd; padding: 20px; border-radius: 8px; background-color: #f9f9f9; margin-top: 20px;">
                        <h3 style="margin-top: 0; font-size: 16px; font-weight: bold; margin-bottom: 12px;">Thông Tin Vận Chuyển</h3>
                        <p style="margin: 8px 0; font-size: 14px;">✓ Miễn phí vận chuyển cho đơn từ 100.000đ</p>
                        <p style="margin: 8px 0; font-size: 14px;">✓ Giao hàng trong 2-3 ngày</p>
                        <p style="margin: 8px 0; font-size: 14px;">✓ Hỗ trợ 24/7</p>
                    </div>
                </aside>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const FREE_SHIPPING_THRESHOLD = 100000; // 100,000 VND
        const SHIPPING_FEE = 30000; // 30,000 VND

        // Initialize cart display on page load
        document.addEventListener('DOMContentLoaded', function() {
            displayCart();
            setupEventListeners();
        });

        function displayCart() {
            // Get cart from localStorage - use same key as cart.js (bookstore_cart)
            const cartData = localStorage.getItem('bookstore_cart');
            const cart = cartData ? JSON.parse(cartData) : [];

            const emptyCartDiv = document.getElementById('empty-cart');
            const cartItemsDiv = document.getElementById('cart-items');

            if (!cart || cart.length === 0) {
                // Show empty cart message
                emptyCartDiv.style.display = 'block';
                cartItemsDiv.innerHTML = '';
                updateSummary([]);
                return;
            }

            // Hide empty cart message
            emptyCartDiv.style.display = 'none';

            // Create table
            const tableTemplate = document.getElementById('cart-table-template');
            const newTable = tableTemplate.content.cloneNode(true);
            const tbody = newTable.querySelector('#cart-items-tbody');

            // Clear previous rows
            tbody.innerHTML = '';

            // Add rows for each cart item
            cart.forEach(item => {
                const rowTemplate = document.getElementById('cart-item-row-template');
                const newRow = rowTemplate.content.cloneNode(true);
                
                newRow.querySelector('.cart-item-row').setAttribute('data-product-id', item.id);
                newRow.querySelector('.item-image').src = item.image || 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22300%22 height=%22400%22%3E%3Crect fill=%22%236366f1%22 width=%22300%22 height=%22400%22/%3E%3C/svg%3E';
                newRow.querySelector('.item-image').alt = item.title;
                newRow.querySelector('.item-title').textContent = item.title;
                newRow.querySelector('.item-author').textContent = item.author || '';
                newRow.querySelector('.item-price').textContent = formatPrice(item.price);
                newRow.querySelector('.item-quantity').value = item.quantity;
                newRow.querySelector('.item-total').textContent = formatPrice(item.price * item.quantity);

                // Add event listeners
                newRow.querySelector('.qty-btn-decrease').addEventListener('click', function() {
                    updateQuantity(item.id, Math.max(1, item.quantity - 1));
                });

                newRow.querySelector('.qty-btn-increase').addEventListener('click', function() {
                    updateQuantity(item.id, item.quantity + 1);
                });

                newRow.querySelector('.item-quantity').addEventListener('change', function() {
                    const qty = parseInt(this.value) || 1;
                    if (qty > 0) {
                        updateQuantity(item.id, qty);
                    }
                });

                newRow.querySelector('.btn-remove').addEventListener('click', function() {
                    removeFromCart(item.id);
                });

                tbody.appendChild(newRow);
            });

            cartItemsDiv.innerHTML = '';
            cartItemsDiv.appendChild(newTable);

            // Update summary
            updateSummary(cart);
        }

        function updateQuantity(productId, quantity) {
            const cartData = localStorage.getItem('bookstore_cart');
            let cart = cartData ? JSON.parse(cartData) : [];

            const item = cart.find(item => item.id === productId);
            if (item) {
                item.quantity = Math.max(1, quantity);
                localStorage.setItem('bookstore_cart', JSON.stringify(cart));
                displayCart();
                updateCartBadge();
            }
        }

        function removeFromCart(productId) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
                const cartData = localStorage.getItem('bookstore_cart');
                let cart = cartData ? JSON.parse(cartData) : [];
                
                cart = cart.filter(item => item.id !== productId);
                localStorage.setItem('bookstore_cart', JSON.stringify(cart));
                displayCart();
                updateCartBadge();
            }
        }

        function updateSummary(cart) {
            let subtotal = 0;
            cart.forEach(item => {
                subtotal += item.price * item.quantity;
            });

            let shippingFee = subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : SHIPPING_FEE;
            let discount = 0;
            let total = subtotal + shippingFee - discount;

            document.getElementById('subtotal').textContent = formatPrice(subtotal);
            document.getElementById('shipping-fee').textContent = formatPrice(shippingFee);
            document.getElementById('discount').textContent = formatPrice(discount);
            document.getElementById('total').textContent = formatPrice(total);
        }

        function setupEventListeners() {
            document.getElementById('checkout-btn').addEventListener('click', function() {
                const cartData = localStorage.getItem('bookstore_cart');
                const cart = cartData ? JSON.parse(cartData) : [];
                
                if (cart && cart.length > 0) {
                    window.location.href = contextPath + '/checkout';
                } else {
                    alert('Giỏ hàng của bạn trống');
                }
            });

            document.getElementById('apply-coupon').addEventListener('click', function() {
                alert('Tính năng mã khuyến mãi sẽ được kích hoạt sau khi tích hợp đầy đủ');
            });
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            }).format(price).replace('₫', 'đ');
        }

        function updateCartBadge() {
            const cartData = localStorage.getItem('bookstore_cart');
            const cart = cartData ? JSON.parse(cartData) : [];
            let totalItems = 0;
            cart.forEach(item => {
                totalItems += item.quantity;
            });
            document.getElementById('cart-count').textContent = totalItems;
        }

        // Update cart badge on page load
        updateCartBadge();
    </script>
</body>
</html>

