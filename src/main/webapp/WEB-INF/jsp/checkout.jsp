<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Thanh toán - BookStore">
    <title>Thanh Toán - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <h1 class="page-title">Thanh Toán</h1>

            <!-- Checkout Steps -->
            <div class="checkout-steps" style="display: flex; justify-content: space-around; margin-bottom: 40px; padding: 20px 0; border-bottom: 2px solid #ddd;">
                <div class="step active" style="text-align: center; flex: 1;">
                    <div style="width: 40px; height: 40px; background-color: #4CAF50; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold;">1</div>
                    <span style="font-size: 14px;">Thông Tin</span>
                </div>
                <div class="step" style="text-align: center; flex: 1;">
                    <div style="width: 40px; height: 40px; background-color: #ddd; color: #666; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold;">2</div>
                    <span style="font-size: 14px;">Vận Chuyển</span>
                </div>
                <div class="step" style="text-align: center; flex: 1;">
                    <div style="width: 40px; height: 40px; background-color: #ddd; color: #666; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold;">3</div>
                    <span style="font-size: 14px;">Thanh Toán</span>
                </div>
                <div class="step" style="text-align: center; flex: 1;">
                    <div style="width: 40px; height: 40px; background-color: #ddd; color: #666; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold;">4</div>
                    <span style="font-size: 14px;">Xác Nhận</span>
                </div>
            </div>

            <div class="checkout-wrapper" style="display: flex; gap: 30px;">
                <!-- Checkout Form -->
                <div class="checkout-form" style="flex: 1;">
                    <!-- Step 1: Customer Info -->
                    <section class="checkout-section" id="step-1" style="border: 1px solid #ddd; padding: 20px; border-radius: 8px;">
                        <h2 style="margin-top: 0; font-size: 20px; font-weight: bold; margin-bottom: 20px;">Thông Tin Khách Hàng</h2>
                        <form id="customer-form" class="form">
                            <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="fullname" style="display: block; margin-bottom: 8px; font-weight: bold;">Họ và Tên *</label>
                                    <input type="text" id="fullname" name="fullname" value="${not empty sessionScope.user ? sessionScope.user.fullname : ''}" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                </div>
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="phone" style="display: block; margin-bottom: 8px; font-weight: bold;">Số Điện Thoại *</label>
                                    <input type="tel" id="phone" name="phone" value="${not empty sessionScope.user ? sessionScope.user.phone : ''}" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="email" style="display: block; margin-bottom: 8px; font-weight: bold;">Email *</label>
                                <input type="email" id="email" name="email" value="${not empty sessionScope.user ? sessionScope.user.email : ''}" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="address" style="display: block; margin-bottom: 8px; font-weight: bold;">Địa Chỉ *</label>
                                <input type="text" id="address" name="address" value="${not empty sessionScope.user ? sessionScope.user.address : ''}" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                            </div>

                            <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="city" style="display: block; margin-bottom: 8px; font-weight: bold;">Thành Phố *</label>
                                    <input type="text" id="city" name="city" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                </div>
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="district" style="display: block; margin-bottom: 8px; font-weight: bold;">Quận/Huyện *</label>
                                    <input type="text" id="district" name="district" required class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="notes" style="display: block; margin-bottom: 8px; font-weight: bold;">Ghi Chú (Không bắt buộc)</label>
                                <textarea id="notes" name="notes" rows="4" class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;"></textarea>
                            </div>

                            <button type="button" class="btn btn-primary" id="next-step-1" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Tiếp Tục</button>
                        </form>
                    </section>

                    <!-- Step 2: Shipping -->
                    <section class="checkout-section" id="step-2" style="display:none; border: 1px solid #ddd; padding: 20px; border-radius: 8px;">
                        <h2 style="margin-top: 0; font-size: 20px; font-weight: bold; margin-bottom: 20px;">Phương Thức Vận Chuyển</h2>
                        <form id="shipping-form" class="form">
                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; margin-bottom: 12px;">
                                    <input type="radio" name="shipping" value="standard" checked style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Vận Chuyển Tiêu Chuẩn</strong> - 3-5 ngày (Miễn phí)
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; margin-bottom: 12px;">
                                    <input type="radio" name="shipping" value="express" style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Vận Chuyển Nhanh</strong> - 1-2 ngày (50.000đ)
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; margin-bottom: 12px;">
                                    <input type="radio" name="shipping" value="overnight" style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Vận Chuyển Qua Đêm</strong> - Hôm sau (100.000đ)
                                    </span>
                                </label>
                            </div>

                            <div class="form-buttons" style="display: flex; gap: 12px; margin-top: 20px;">
                                <button type="button" class="btn btn-outline" id="back-step-2" style="flex: 1; padding: 10px 20px; background-color: white; color: #333; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;">Quay Lại</button>
                                <button type="button" class="btn btn-primary" id="next-step-2" style="flex: 1; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Tiếp Tục</button>
                            </div>
                        </form>
                    </section>

                    <!-- Step 3: Payment -->
                    <section class="checkout-section" id="step-3" style="display:none; border: 1px solid #ddd; padding: 20px; border-radius: 8px;">
                        <h2 style="margin-top: 0; font-size: 20px; font-weight: bold; margin-bottom: 20px;">Phương Thức Thanh Toán</h2>
                        <form id="payment-form" class="form">
                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: not-allowed; margin-bottom: 12px; opacity: 0.6; background-color: #f5f5f5;">
                                    <input type="radio" name="payment" value="cod" disabled style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Thanh Toán Khi Nhận Hàng</strong> (COD) <span style="color: #999; margin-left: 8px; font-size: 12px;">(Đang phát triển)</span>
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: not-allowed; margin-bottom: 12px; opacity: 0.6; background-color: #f5f5f5;">
                                    <input type="radio" name="payment" value="transfer" disabled style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Chuyển Khoản Ngân Hàng</strong> <span style="color: #999; margin-left: 8px; font-size: 12px;">(Đang phát triển)</span>
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #ddd; border-radius: 4px; cursor: not-allowed; margin-bottom: 12px; opacity: 0.6; background-color: #f5f5f5;">
                                    <input type="radio" name="payment" value="card" disabled style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong>Thẻ Tín Dụng / Debit</strong> <span style="color: #999; margin-left: 8px; font-size: 12px;">(Đang phát triển)</span>
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 1px solid #4CAF50; border-radius: 4px; cursor: pointer; margin-bottom: 12px; background-color: #f0f8f0;">
                                    <input type="radio" name="payment" value="vnpay" style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong style="color: #4CAF50;">✓ VNPAY</strong> - Thanh toán qua cổng VNPAY (Khả dụng)
                                    </span>
                                </label>
                            </div>

                            <div class="radio-group" style="margin-bottom: 16px;">
                                <label class="radio-option" style="display: flex; align-items: center; padding: 12px; border: 2px solid #2196F3; border-radius: 4px; cursor: pointer; margin-bottom: 12px; background-color: #e3f2fd;">
                                    <input type="radio" name="payment" value="test" checked style="margin-right: 12px;">
                                    <span class="radio-label">
                                        <strong style="color: #2196F3;">🧪 TEST</strong> - Thanh toán thành công ngay (Dành cho test)
                                    </span>
                                </label>
                            </div>

                            <div id="card-details" style="display:none; padding: 16px; background-color: #f9f9f9; border-radius: 4px; margin-bottom: 16px;">
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="card-number" style="display: block; margin-bottom: 8px; font-weight: bold;">Số Thẻ</label>
                                    <input type="text" id="card-number" placeholder="1234 5678 9012 3456" class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                </div>
                                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                    <div class="form-group">
                                        <label for="card-expiry" style="display: block; margin-bottom: 8px; font-weight: bold;">Ngày Hết Hạn</label>
                                        <input type="text" id="card-expiry" placeholder="MM/YY" class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                    </div>
                                    <div class="form-group">
                                        <label for="card-cvv" style="display: block; margin-bottom: 8px; font-weight: bold;">CVV</label>
                                        <input type="text" id="card-cvv" placeholder="123" class="form-input" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                                    </div>
                                </div>
                            </div>

                            <div class="form-buttons" style="display: flex; gap: 12px; margin-top: 20px;">
                                <button type="button" class="btn btn-outline" id="back-step-3" style="flex: 1; padding: 10px 20px; background-color: white; color: #333; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;">Quay Lại</button>
                                <button type="button" class="btn btn-primary" id="next-step-3" style="flex: 1; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Tiếp Tục</button>
                            </div>
                        </form>
                    </section>

                    <!-- Step 4: Confirmation -->
                    <section class="checkout-section" id="step-4" style="display:none; border: 1px solid #ddd; padding: 20px; border-radius: 8px;">
                        <h2 style="margin-top: 0; font-size: 20px; font-weight: bold; margin-bottom: 20px;">Xác Nhận Đơn Hàng</h2>
                        <div class="order-summary" id="order-summary">
                            <!-- Populated by JavaScript -->
                        </div>

                        <div class="form-buttons" style="display: flex; gap: 12px; margin-top: 20px;">
                            <button type="button" class="btn btn-outline" id="back-step-4" style="flex: 1; padding: 10px 20px; background-color: white; color: #333; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;">Quay Lại</button>
                            <button type="button" class="btn btn-primary btn-lg" id="place-order" style="flex: 1; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Đặt Hàng</button>
                        </div>
                    </section>
                </div>

                <!-- Order Summary Sidebar -->
                <aside class="checkout-summary" style="width: 30%; padding: 20px;">
                    <div class="summary-card" style="border: 1px solid #ddd; padding: 20px; border-radius: 8px; background-color: #f9f9f9; position: sticky; top: 20px;">
                        <h3 style="margin-top: 0; font-size: 18px; font-weight: bold; margin-bottom: 16px;">Tóm Tắt Đơn Hàng</h3>
                        <div id="checkout-items" class="order-items" style="max-height: 400px; overflow-y: auto; margin-bottom: 16px; padding-bottom: 16px; border-bottom: 1px solid #ddd;">
                            <!-- Populated by JavaScript -->
                        </div>

                        <div class="summary-row" style="display: flex; justify-content: space-between; padding: 8px 0; margin-bottom: 8px;">
                            <span>Tổng tiền:</span>
                            <span id="checkout-subtotal" style="font-weight: bold;">0đ</span>
                        </div>

                        <div class="summary-row" style="display: flex; justify-content: space-between; padding: 8px 0; margin-bottom: 8px;">
                            <span>Vận chuyển:</span>
                            <span id="checkout-shipping" style="font-weight: bold;">0đ</span>
                        </div>

                        <div class="summary-row summary-total" style="display: flex; justify-content: space-between; padding: 12px 0; border-top: 2px solid #333; border-bottom: 2px solid #333; margin: 12px 0; font-weight: bold; font-size: 16px;">
                            <span>Thành Tiền:</span>
                            <span id="checkout-total" style="color: #d32f2f;">0đ</span>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let currentStep = 1;
        let checkoutData = {};
        const FREE_SHIPPING_THRESHOLD = 100000;
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadCartToCheckout();
            setupEventListeners();
        });

        function loadCartToCheckout() {
            console.log('loadCartToCheckout called');
            
            const cartData = localStorage.getItem('bookstore_cart');
            console.log('Cart data from localStorage:', cartData);
            
            const cart = cartData ? JSON.parse(cartData) : [];
            console.log('Parsed cart:', cart);
            console.log('Cart length:', cart.length);
            
            if (!cart || !Array.isArray(cart) || cart.length === 0) {
                alert('Giỏ hàng của bạn trống. Quay lại để thêm sản phẩm.');
                window.location.href = contextPath + '/cart';
                return;
            }

            // Display cart items in checkout sidebar
            const checkoutItemsDiv = document.getElementById('checkout-items');
            if (!checkoutItemsDiv) {
                console.error('checkout-items element not found!');
                return;
            }
            
            checkoutItemsDiv.innerHTML = '';

            let subtotal = 0;
            cart.forEach((item, index) => {
                console.log('Item ' + index + ':', item);
                
                const itemDiv = document.createElement('div');
                itemDiv.style.cssText = 'padding: 8px 0; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; margin-bottom: 8px;';
                const itemTotal = item.price * item.quantity;
                itemDiv.innerHTML = 
                    '<div style="flex: 1;">' +
                        '<div style="font-size: 14px; font-weight: bold;">' + (item.title || 'Unknown') + '</div>' +
                        '<div style="font-size: 12px; color: #666;">x' + (item.quantity || 1) + '</div>' +
                    '</div>' +
                    '<div style="font-weight: bold;">' + formatPrice(itemTotal) + '</div>';
                checkoutItemsDiv.appendChild(itemDiv);
                subtotal += itemTotal;
            });

            console.log('All items processed. Total subtotal:', subtotal);

            // Store cart for later
            checkoutData.cartItems = cart;
            updateCheckoutSummary(subtotal);
        }

        function updateCheckoutSummary(subtotal) {
            let shippingMethod = document.querySelector('input[name="shipping"]:checked');
            let shippingFee = 0;

            if (shippingMethod) {
                if (shippingMethod.value === 'express') {
                    shippingFee = 50000;
                } else if (shippingMethod.value === 'overnight') {
                    shippingFee = 100000;
                } else if (shippingMethod.value === 'standard' && subtotal < FREE_SHIPPING_THRESHOLD) {
                    shippingFee = 30000;
                }
            }

            let total = subtotal + shippingFee;

            document.getElementById('checkout-subtotal').textContent = formatPrice(subtotal);
            document.getElementById('checkout-shipping').textContent = formatPrice(shippingFee);
            document.getElementById('checkout-total').textContent = formatPrice(total);

            checkoutData.subtotal = subtotal;
            checkoutData.shipping = shippingFee;
            checkoutData.total = total;
        }

        function setupEventListeners() {
            // Step 1: Next button
            document.getElementById('next-step-1').addEventListener('click', function() {
                if (validateStep1()) {
                    checkoutData.fullname = document.getElementById('fullname').value;
                    checkoutData.phone = document.getElementById('phone').value;
                    checkoutData.email = document.getElementById('email').value;
                    checkoutData.address = document.getElementById('address').value;
                    checkoutData.city = document.getElementById('city').value;
                    checkoutData.district = document.getElementById('district').value;
                    checkoutData.notes = document.getElementById('notes').value;
                    goToStep(2);
                }
            });

            // Step 2: Back and Next
            document.getElementById('back-step-2').addEventListener('click', function() { goToStep(1); });
            document.getElementById('next-step-2').addEventListener('click', function() {
                checkoutData.shipping = document.querySelector('input[name="shipping"]:checked').value;
                updateCheckoutSummary(checkoutData.subtotal);
                goToStep(3);
            });

            // Step 3: Back and Next
            document.getElementById('back-step-3').addEventListener('click', function() { goToStep(2); });
            document.getElementById('next-step-3').addEventListener('click', function() {
                checkoutData.payment = document.querySelector('input[name="payment"]:checked').value;
                populateConfirmation();
                goToStep(4);
            });

            // Step 4: Back and Place Order
            document.getElementById('back-step-4').addEventListener('click', function() { goToStep(3); });
            document.getElementById('place-order').addEventListener('click', function() { placeOrder(); });

            // Payment method change
            document.querySelectorAll('input[name="payment"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    const cardDetails = document.getElementById('card-details');
                    cardDetails.style.display = this.value === 'card' ? 'block' : 'none';
                });
            });

            // Shipping method change
            document.querySelectorAll('input[name="shipping"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    updateCheckoutSummary(checkoutData.subtotal);
                });
            });
        }

        function validateStep1() {
            const fullname = document.getElementById('fullname').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const email = document.getElementById('email').value.trim();
            const address = document.getElementById('address').value.trim();
            const city = document.getElementById('city').value.trim();
            const district = document.getElementById('district').value.trim();

            if (!fullname || !phone || !email || !address || !city || !district) {
                alert('Vui lòng điền đủ thông tin bắt buộc');
                return false;
            }

            if (!email.includes('@')) {
                alert('Email không hợp lệ');
                return false;
            }

            return true;
        }

        function populateConfirmation() {
            const summaryDiv = document.getElementById('order-summary');
            summaryDiv.innerHTML = 
                '<div style="background-color: #f9f9f9; padding: 16px; border-radius: 8px; margin-bottom: 16px;">' +
                    '<h3 style="margin-top: 0; font-size: 16px; font-weight: bold; margin-bottom: 12px;">Thông Tin Giao Hàng</h3>' +
                    '<p style="margin: 4px 0;"><strong>Họ tên:</strong> ' + (checkoutData.fullname || '') + '</p>' +
                    '<p style="margin: 4px 0;"><strong>Số điện thoại:</strong> ' + (checkoutData.phone || '') + '</p>' +
                    '<p style="margin: 4px 0;"><strong>Email:</strong> ' + (checkoutData.email || '') + '</p>' +
                    '<p style="margin: 4px 0;"><strong>Địa chỉ:</strong> ' + (checkoutData.address || '') + ', ' + (checkoutData.district || '') + ', ' + (checkoutData.city || '') + '</p>' +
                '</div>' +
                '<div style="background-color: #f9f9f9; padding: 16px; border-radius: 8px; margin-bottom: 16px;">' +
                    '<h3 style="margin-top: 0; font-size: 16px; font-weight: bold; margin-bottom: 12px;">Phương Thức Vận Chuyển</h3>' +
                    '<p style="margin: 4px 0;"><strong>' + (getShippingName(checkoutData.shipping) || '') + '</strong></p>' +
                '</div>' +
                '<div style="background-color: #f9f9f9; padding: 16px; border-radius: 8px;">' +
                    '<h3 style="margin-top: 0; font-size: 16px; font-weight: bold; margin-bottom: 12px;">Phương Thức Thanh Toán</h3>' +
                    '<p style="margin: 4px 0;"><strong>' + (getPaymentName(checkoutData.payment) || '') + '</strong></p>' +
                '</div>';
        }

        function goToStep(step) {
            // Hide all steps
            for (let i = 1; i <= 4; i++) {
                document.getElementById('step-' + i).style.display = 'none';
            }

            // Show current step
            document.getElementById('step-' + step).style.display = 'block';
            currentStep = step;

            // Update step indicator
            document.querySelectorAll('.step').forEach(el => el.classList.remove('active'));
            
            // Update step colors
            const steps = document.querySelectorAll('.step > div:first-child');
            for (let i = 0; i < steps.length; i++) {
                if (i + 1 <= step) {
                    steps[i].style.backgroundColor = '#4CAF50';
                    steps[i].style.color = 'white';
                } else {
                    steps[i].style.backgroundColor = '#ddd';
                    steps[i].style.color = '#666';
                }
            }
        }

        function placeOrder() {
            // Check if TEST payment is selected
            if (checkoutData.payment === 'test') {
                // Create order with test payment - immediately marked as paid
                const testPaymentData = {
                    fullname: checkoutData.fullname,
                    phone: checkoutData.phone,
                    email: checkoutData.email,
                    address: checkoutData.address + ', ' + checkoutData.district + ', ' + checkoutData.city,
                    shipping: checkoutData.shipping,
                    notes: checkoutData.notes || '',
                    total: checkoutData.total,
                    items: checkoutData.cartItems
                };

                fetch(contextPath + '/api/test-payment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(testPaymentData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Clear cart and redirect to success page
                        localStorage.removeItem('bookstore_cart');
                        window.location.href = data.redirectUrl || (contextPath + '/order-success?id=' + data.orderId);
                    } else {
                        alert('Lỗi: ' + (data.error || 'Không thể tạo đơn hàng'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra: ' + error);
                });
                return;
            }
            
            // Check if VNPAY is selected
            if (checkoutData.payment === 'vnpay') {
                // Create VNPAY payment URL using URLSearchParams (compatible with servlet)
                const vnpayData = new URLSearchParams();
                vnpayData.append('fullname', checkoutData.fullname);
                vnpayData.append('phone', checkoutData.phone);
                vnpayData.append('email', checkoutData.email);
                vnpayData.append('address', checkoutData.address);
                vnpayData.append('city', checkoutData.city);
                vnpayData.append('district', checkoutData.district);
                vnpayData.append('shipping', checkoutData.shipping);
                vnpayData.append('total', checkoutData.total);
                vnpayData.append('cartItems', JSON.stringify(checkoutData.cartItems));

                fetch(contextPath + '/vnpay/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: vnpayData.toString()
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Clear cart and redirect to VNPAY
                        localStorage.removeItem('bookstore_cart');
                        window.location.href = data.paymentUrl;
                    } else {
                        alert('Lỗi: ' + (data.error || 'Không thể tạo URL thanh toán'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra: ' + error);
                });
                return;
            }

            // For COD, Transfer, Card - create order normally
            const formData = new URLSearchParams();
            formData.append('action', 'place_order');
            formData.append('fullname', checkoutData.fullname);
            formData.append('phone', checkoutData.phone);
            formData.append('email', checkoutData.email);
            formData.append('address', checkoutData.address);
            formData.append('city', checkoutData.city);
            formData.append('district', checkoutData.district);
            formData.append('notes', checkoutData.notes || '');
            formData.append('shipping', checkoutData.shipping);
            formData.append('payment', checkoutData.payment);
            formData.append('cartItems', JSON.stringify(checkoutData.cartItems));
            formData.append('total', checkoutData.total);

            fetch(contextPath + '/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    localStorage.removeItem('bookstore_cart');
                    window.location.href = contextPath + '/order-success?orderId=' + data.orderId;
                } else {
                    alert('Lỗi: ' + (data.error || 'Không thể tạo đơn hàng'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra: ' + error);
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

        function getShippingName(value) {
            switch(value) {
                case 'express': return 'Vận Chuyển Nhanh (1-2 ngày) - 50.000đ';
                case 'overnight': return 'Vận Chuyển Qua Đêm (Hôm sau) - 100.000đ';
                default: return 'Vận Chuyển Tiêu Chuẩn (3-5 ngày) - Miễn phí';
            }
        }

        function getPaymentName(value) {
            switch(value) {
                case 'transfer': return 'Chuyển Khoản Ngân Hàng';
                case 'card': return 'Thẻ Tín Dụng / Debit';
                case 'vnpay': return 'VNPAY';
                case 'test': return '🧪 Test Payment (Thanh toán ngay)';
                default: return 'Thanh Toán Khi Nhận Hàng (COD)';
            }
        }
    </script>
</body>
</html>

