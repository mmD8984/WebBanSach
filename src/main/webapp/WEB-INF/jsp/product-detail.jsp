<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Chi tiết sản phẩm - BookStore">
    <title>${product.title} - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
    <style>
        .pd-wrapper { display: grid; grid-template-columns: 380px 1fr; gap: 40px; margin: 24px 0; }
        @media (max-width: 900px) { .pd-wrapper { grid-template-columns: 1fr; } }
        .pd-gallery { position: sticky; top: 90px; }
        .pd-gallery .img-box { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-radius: 16px; padding: 20px; min-height: 400px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .pd-gallery .img-box img { max-width: 100%; max-height: 360px; object-fit: contain; border-radius: 8px; }
        .pd-info { padding: 0; }
        .pd-title { font-size: 26px; font-weight: 700; color: #1a1a2e; margin: 0 0 16px; line-height: 1.3; }
        .pd-meta { display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 16px; padding: 14px 18px; background: #f8f9fa; border-radius: 10px; font-size: 14px; }
        .pd-meta span { color: #495057; }
        .pd-meta strong { color: #212529; }
        .pd-rating { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
        .pd-rating .stars { font-size: 18px; color: #ffc107; letter-spacing: 1px; }
        .pd-rating .stars .empty { color: #dee2e6; }
        .pd-rating .score { font-weight: 700; color: #212529; }
        .pd-rating .count { font-size: 13px; color: #868e96; }
        .pd-price { display: flex; align-items: center; gap: 14px; padding: 18px 22px; background: linear-gradient(135deg, #fff5f5 0%, #fff 100%); border: 2px solid #ffe3e3; border-radius: 12px; margin-bottom: 20px; }
        .pd-price .current { font-size: 28px; font-weight: 800; color: #e03131; }
        .pd-price .original { font-size: 16px; color: #868e96; text-decoration: line-through; }
        .pd-price .badge { background: #e03131; color: #fff; padding: 5px 10px; border-radius: 16px; font-size: 13px; font-weight: 700; }
        .pd-desc { margin-bottom: 20px; }
        .pd-desc h4 { font-size: 15px; font-weight: 600; color: #495057; margin: 0 0 10px; }
        .pd-desc p { font-size: 14px; line-height: 1.7; color: #495057; margin: 0; }
        .pd-details { margin-bottom: 20px; }
        .pd-details h4 { font-size: 15px; font-weight: 600; color: #495057; margin: 0 0 12px; }
        .pd-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .pd-grid .item { display: flex; justify-content: space-between; padding: 10px 14px; background: #f8f9fa; border-radius: 8px; font-size: 13px; }
        .pd-grid .item .lbl { color: #868e96; }
        .pd-grid .item .val { font-weight: 600; color: #212529; }
        .pd-purchase { padding: 20px; background: #fff; border: 1px solid #e9ecef; border-radius: 14px; box-shadow: 0 2px 10px rgba(0,0,0,0.04); }
        .pd-qty { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; }
        .pd-qty label { font-size: 14px; font-weight: 600; color: #495057; }
        .pd-qty .controls { display: flex; border: 2px solid #e9ecef; border-radius: 8px; overflow: hidden; }
        .pd-qty .qbtn { width: 36px; height: 36px; border: none; background: #f8f9fa; font-size: 16px; cursor: pointer; }
        .pd-qty .qbtn:hover { background: #e9ecef; }
        .pd-qty .qinput { width: 50px; height: 36px; border: none; text-align: center; font-size: 15px; font-weight: 600; }
        .pd-qty .stock { font-size: 12px; color: #40c057; }
        .pd-btns { display: flex; gap: 10px; margin-bottom: 16px; }
        .pd-btns .btn-cart { flex: 2; padding: 14px; background: linear-gradient(135deg, #228be6 0%, #1c7ed6 100%); color: #fff; border: none; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .pd-btns .btn-cart:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(34,139,230,0.35); }
        .pd-btns .btn-wish { flex: 1; padding: 14px; background: #fff; color: #e03131; border: 2px solid #ffe3e3; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; }
        .pd-btns .btn-wish:hover { background: #fff5f5; }
        .pd-benefits { display: flex; flex-direction: column; gap: 8px; }
        .pd-benefits .item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #495057; }
        .pd-benefits .icon { width: 22px; height: 22px; background: #d3f9d8; color: #2f9e44; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 11px; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <!-- Breadcrumb -->
            <nav style="margin: 20px 0; font-size: 14px; color: #868e96;">
                <a href="${pageContext.request.contextPath}/" style="color: #228be6; text-decoration: none;">Trang chủ</a>
                <span style="margin: 0 8px;">›</span>
                <a href="${pageContext.request.contextPath}/products" style="color: #228be6; text-decoration: none;">Sản phẩm</a>
                <span style="margin: 0 8px;">›</span>
                <span style="color: #495057;">${product != null ? product.title : 'Chi tiết sách'}</span>
            </nav>

            <!-- Error Message -->
            <c:if test="${error != null}">
                <div style="padding: 20px; margin: 20px 0; background: #fff5f5; color: #c92a2a; border: 1px solid #ffe3e3; border-radius: 12px;">
                    <strong>⚠️ ${error}</strong>
                    <a href="${pageContext.request.contextPath}/products" style="display: block; margin-top: 10px; color: #228be6; text-decoration: none;">← Quay lại danh sách sản phẩm</a>
                </div>
            </c:if>

            <!-- Product Detail Section -->
            <c:if test="${product != null}">
                <div class="pd-wrapper">
                    <!-- Left: Image -->
                    <div class="pd-gallery">
                        <div class="img-box" style="position: relative;">
                            <img id="main-image" src="${product.image}" alt="${product.title}"
                                onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22280%22 height=%22380%22%3E%3Crect fill=%22%236366f1%22 width=%22280%22 height=%22380%22/%3E%3Ctext x=%22140%22 y=%22190%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2240%22%3E📚%3C/text%3E%3C/svg%3E'">
                            <c:if test="${product.discount > 0}">
                                <span style="position: absolute; top: 16px; left: 16px; background: #e03131; color: #fff; padding: 6px 12px; border-radius: 16px; font-weight: 700; font-size: 13px;">-${product.discount}%</span>
                            </c:if>
                        </div>
                    </div>

                    <!-- Right: Info -->
                    <div class="pd-info">
                        <h1 id="product-title" class="pd-title">${product.title}</h1>
                        
                        <!-- Meta -->
                        <div class="pd-meta">
                            <span>Tác giả: <strong id="product-author">${product.authorName}</strong></span>
                            <span style="color: #dee2e6;">|</span>
                            <span>NXB: <strong>${product.publisherName}</strong></span>
                            <span style="color: #dee2e6;">|</span>
                            <span>Năm: <strong>${product.year}</strong></span>
                        </div>

                        <!-- Rating -->
                        <div class="pd-rating">
                            <span class="stars">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${i <= product.rating}">★</c:when>
                                        <c:otherwise><span class="empty">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span class="score">${product.rating}/5</span>
                            <span class="count">(${product.reviews} đánh giá)</span>
                        </div>

                        <!-- Price -->
                        <div class="pd-price">
                            <span id="sale-price" class="current"><fmt:formatNumber value="${product.price}" pattern="#,###"/>đ</span>
                            <c:if test="${product.originalPrice > product.price}">
                                <span class="original"><fmt:formatNumber value="${product.originalPrice}" pattern="#,###"/>đ</span>
                            </c:if>
                            <c:if test="${product.discount > 0}">
                                <span class="badge">Giảm ${product.discount}%</span>
                            </c:if>
                        </div>

                        <!-- Description -->
                        <div class="pd-desc">
                            <h4>📝 Mô Tả Sách</h4>
                            <p>${product.description}</p>
                        </div>

                        <!-- Details Grid -->
                        <div class="pd-details">
                            <h4>📋 Thông Tin Chi Tiết</h4>
                            <div class="pd-grid">
                                <div class="item"><span class="lbl">Số trang</span><span class="val">${product.pages} trang</span></div>
                                <div class="item"><span class="lbl">Kích thước</span><span class="val">${product.size}</span></div>
                                <div class="item"><span class="lbl">Hình thức</span><span class="val">${product.format}</span></div>
                                <div class="item"><span class="lbl">Tình trạng</span><span class="val" style="color: #40c057;">✓ ${product.status}</span></div>
                            </div>
                        </div>

                        <!-- Purchase Box -->
                        <div class="pd-purchase">
                            <div class="pd-qty">
                                <label>Số lượng:</label>
                                <div class="controls">
                                    <button class="qbtn" id="qty-decrease">−</button>
                                    <input type="number" id="quantity" value="1" min="1" max="${product.stock}" class="qinput">
                                    <button class="qbtn" id="qty-increase">+</button>
                                </div>
                                <span class="stock">✓ Còn ${product.stock} sản phẩm</span>
                            </div>

                            <div class="pd-btns">
                                <button class="btn-cart" id="add-to-cart-btn">🛒 Thêm Vào Giỏ Hàng</button>
                                <button class="btn-wish" id="add-to-wishlist-btn">❤️</button>
                            </div>

                            <div class="pd-benefits">
                                <div class="item"><span class="icon">✓</span><span>Miễn phí vận chuyển cho đơn từ 100.000đ</span></div>
                                <div class="item"><span class="icon">✓</span><span>Sách chính hãng 100%</span></div>
                                <div class="item"><span class="icon">✓</span><span>Đổi trả miễn phí trong 30 ngày</span></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Related Products Section -->
                <c:if test="${not empty relatedProducts}">
                    <section style="margin: 50px 0 30px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
                            <h2 style="font-size: 22px; font-weight: 700; color: #212529; margin: 0;">📚 Sách Liên Quan</h2>
                            <a href="${pageContext.request.contextPath}/products?category=${product.categoryId}" style="font-size: 14px; color: #228be6; text-decoration: none;">Xem tất cả →</a>
                        </div>
                        <div class="products-grid">
                            <c:forEach var="book" items="${relatedProducts}">
                                <div class="product-card" data-product-id="${book.id}">
                                    <div class="product-image">
                                        <img src="${book.image}" alt="${book.title}" 
                                            onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22300%22 height=%22400%22%3E%3Crect fill=%22%236366f1%22 width=%22300%22 height=%22400%22/%3E%3C/svg%3E'">
                                        <c:if test="${book.discount > 0}">
                                            <div class="product-badge">-${book.discount}%</div>
                                        </c:if>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-name">
                                            <a href="${pageContext.request.contextPath}/product?id=${book.id}">${book.title}</a>
                                        </h3>
                                        <p class="product-author">${book.authorName}</p>
                                        <div class="product-rating">
                                            <span class="stars">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${i <= book.rating}">★</c:when>
                                                        <c:otherwise>☆</c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                            <span class="rating-value">${book.rating}</span>
                                        </div>
                                        <div class="product-price">
                                            <span class="product-original-price"><fmt:formatNumber value="${book.originalPrice}" pattern="#,###"/>đ</span>
                                            <span class="product-sale-price"><fmt:formatNumber value="${book.price}" pattern="#,###"/>đ</span>
                                        </div>
                                        <button class="btn btn-primary btn-sm add-to-cart-btn" style="width: 100%; margin-top: 8px;">🛒 Thêm Vào Giỏ</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>
            </c:if>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const currentProductId = <c:if test="${product != null}">${product.id}</c:if><c:if test="${product == null}">null</c:if>;

        // Quantity control
        document.getElementById('qty-decrease')?.addEventListener('click', function() {
            const qtyInput = document.getElementById('quantity');
            if (parseInt(qtyInput.value) > 1) {
                qtyInput.value = parseInt(qtyInput.value) - 1;
            }
        });

        document.getElementById('qty-increase')?.addEventListener('click', function() {
            const qtyInput = document.getElementById('quantity');
            const maxStock = parseInt(qtyInput.getAttribute('max'));
            if (parseInt(qtyInput.value) < maxStock) {
                qtyInput.value = parseInt(qtyInput.value) + 1;
            }
        });

        // Add to cart
        document.getElementById('add-to-cart-btn')?.addEventListener('click', function() {
            const quantity = parseInt(document.getElementById('quantity').value) || 1;
            
            const productTitle = document.getElementById('product-title')?.textContent || '';
            const productImage = document.getElementById('main-image')?.src || '';
            const productAuthor = document.getElementById('product-author')?.textContent || '';
            const productPrice = document.getElementById('sale-price')?.textContent || '0đ';
            const priceValue = parseInt(productPrice.replace(/\D/g, '')) || 0;
            
            const product = {
                id: currentProductId,
                title: productTitle,
                price: priceValue,
                image: productImage,
                author: productAuthor,
                stock: 999
            };

            // Check login first
            fetch(contextPath + '/api/check-login')
                .then(res => res.json())
                .then(data => {
                    if (!data.loggedIn) {
                        const returnUrl = encodeURIComponent(window.location.pathname + window.location.search);
                        window.location.href = contextPath + '/login?returnUrl=' + returnUrl;
                        return;
                    }
                    if (typeof cart !== 'undefined' && cart.addProduct) {
                        cart.addProduct(product, quantity);
                    } else {
                        alert('Lỗi: Giỏ hàng chưa sẵn sàng.');
                    }
                })
                .catch(() => {
                    if (typeof cart !== 'undefined' && cart.addProduct) {
                        cart.addProduct(product, quantity);
                    }
                });
        });

        // Add to wishlist
        document.getElementById('add-to-wishlist-btn')?.addEventListener('click', function() {
            alert('Tính năng yêu thích sẽ được kích hoạt sớm!');
        });

        // Related products click
        document.querySelectorAll('.product-card').forEach(card => {
            card.addEventListener('click', function(e) {
                if (e.target.closest('.btn') || e.target.closest('.add-to-cart-btn')) return;
                const id = this.getAttribute('data-product-id');
                if (id) window.location.href = contextPath + '/product?id=' + id;
            });
        });
    </script>
</body>
</html>

