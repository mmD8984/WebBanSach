<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>BookStore - Mua Sách Online</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <!-- Hero Banner Section -->
        <section class="hero">
            <div class="hero-content">
                <h1 class="hero-title">Khám Phá Thế Giới Sách</h1>
                <p class="hero-subtitle">Hàng triệu cuốn sách chính hãng, giá tốt nhất thị trường</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">Mua Sắm Ngay</a>
            </div>
        </section>

        <!-- Categories Carousel Section -->
        <section class="categories-section">
            <div class="container">
                <h2 class="section-title">Danh Mục Sách</h2>
                <div class="carousel categories-carousel" id="categories-carousel">
                    <div class="carousel-wrapper" id="categories-grid">
                        <c:forEach var="cat" items="${categories}">
                            <div class="carousel-item category-item">
                                <a href="${pageContext.request.contextPath}/products?category=${cat.id}" class="category-card card">
                                    <div class="category-icon">${cat.icon}</div>
                                    <h3 class="category-name">${cat.name}</h3>
                                    <p class="category-count">${cat.count} sách</p>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="carousel-controls">
                        <button class="carousel-btn carousel-prev" title="Trước">❮</button>
                        <button class="carousel-btn carousel-next" title="Tiếp">❯</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Products Carousel Section -->
        <section class="featured-section">
            <div class="container">
                <h2 class="section-title">Sách Bán Chạy</h2>
                <div class="carousel products-carousel" id="featured-carousel">
                    <div class="carousel-wrapper" id="featured-products">
                        <c:forEach var="book" items="${featured}">
                            <div class="carousel-item product-carousel-item">
                                <div class="card product-card" data-product-id="${book.id}">
                                    <div class="product-image">
                                        <img src="${book.image}" alt="${book.title}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22300%22 height=%22400%22%3E%3Crect fill=%22%236366f1%22 width=%22300%22 height=%22400%22/%3E%3C/svg%3E'">
                                        <div class="product-badge">-${book.discount}%</div>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-name">${book.title}</h3>
                                        <p class="product-author">${book.authorName}</p>
                                        <div class="product-price">
                                            <span class="product-original-price"><fmt:formatNumber value="${book.originalPrice}" pattern="#,###"/>đ</span>
                                            <span class="product-sale-price"><fmt:formatNumber value="${book.price}" pattern="#,###"/>đ</span>
                                        </div>
                                        <button class="btn btn-primary btn-sm add-to-cart-btn" style="width: 100%;">🛒 Thêm Vào Giỏ</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="carousel-controls">
                        <button class="carousel-btn carousel-prev" title="Trước">❮</button>
                        <button class="carousel-btn carousel-next" title="Tiếp">❯</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Promotions Section -->
        <section class="promotions-section">
            <div class="container">
                <h2 class="section-title">Khuyến Mãi Đặc Biệt</h2>
                <div class="promo-cards">
                    <div class="promo-card" style="padding: var(--spacing-lg); border-radius: var(--border-radius-lg); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1)); border: 1px solid var(--border-color);">
                        <h3>Mua 2 Tặng 1</h3>
                        <p>Áp dụng cho tất cả sách trong danh mục</p>
                    </div>
                    <div class="promo-card" style="padding: var(--spacing-lg); border-radius: var(--border-radius-lg); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1)); border: 1px solid var(--border-color);">
                        <h3>Miễn Phí Vận Chuyển</h3>
                        <p>Với đơn hàng từ 100.000đ</p>
                    </div>
                    <div class="promo-card" style="padding: var(--spacing-lg); border-radius: var(--border-radius-lg); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1)); border: 1px solid var(--border-color);">
                        <h3>Hoàn Tiền 10%</h3>
                        <p>Khi mua bằng thẻ tín dụng</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Best Sellers Carousel Section -->
        <section class="bestsellers-section">
            <div class="container">
                <h2 class="section-title">Những Cuốn Sách Yêu Thích</h2>
                <div class="carousel products-carousel" id="bestsellers-carousel">
                    <div class="carousel-wrapper" id="bestsellers-products">
                        <c:forEach var="book" items="${bestsellers}">
                            <div class="carousel-item product-carousel-item">
                                <div class="card product-card" data-product-id="${book.id}">
                                    <div class="product-image">
                                        <img src="${book.image}" alt="${book.title}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22300%22 height=%22400%22%3E%3Crect fill=%22%236366f1%22 width=%22300%22 height=%22400%22/%3E%3C/svg%3E'">
                                        <div class="product-badge">-${book.discount}%</div>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-name">${book.title}</h3>
                                        <p class="product-author">${book.authorName}</p>
                                        <div class="product-price">
                                            <span class="product-original-price"><fmt:formatNumber value="${book.originalPrice}" pattern="#,###"/>đ</span>
                                            <span class="product-sale-price"><fmt:formatNumber value="${book.price}" pattern="#,###"/>đ</span>
                                        </div>
                                        <button class="btn btn-primary btn-sm add-to-cart-btn" style="width: 100%;">🛒 Thêm Vào Giỏ</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="carousel-controls">
                        <button class="carousel-btn carousel-prev" title="Trước">❮</button>
                        <button class="carousel-btn carousel-next" title="Tiếp">❯</button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
    <script>
        // Initialize cart event handlers on featured and bestseller products
        document.addEventListener('DOMContentLoaded', function() {
            const contextPath = '${pageContext.request.contextPath}';
            
            // Featured products carousel
            initializeFeaturedCarousel(contextPath);
            
            // Bestsellers carousel
            initializeBestsellersCarousel(contextPath);
        });

        function initializeFeaturedCarousel(contextPath) {
            const featuredContainer = document.getElementById('featured-products');
            if (!featuredContainer) return;

            featuredContainer.querySelectorAll('.product-card').forEach(card => {
                const productId = card.dataset.productId;
                const productTitle = card.querySelector('.product-name').textContent;
                const productPrice = card.querySelector('.product-sale-price').textContent;
                const productImage = card.querySelector('img').src;
                const productAuthor = card.querySelector('.product-author').textContent;

                // Click on card to go to product detail (not on buttons)
                card.addEventListener('click', function(e) {
                    if (!e.target.closest('.btn')) {
                        window.location.href = contextPath + '/product?id=' + productId;
                    }
                });
                // Note: Add to cart is handled by global event delegation in main.js
            });

            // Initialize carousel
            const carousel = featuredContainer.closest('.carousel');
            if (carousel) {
                setTimeout(() => new Carousel(carousel), 100);
            }
        }

        function initializeBestsellersCarousel(contextPath) {
            const bestsellersContainer = document.getElementById('bestsellers-products');
            if (!bestsellersContainer) return;

            bestsellersContainer.querySelectorAll('.product-card').forEach(card => {
                const productId = card.dataset.productId;
                
                // Click on card to go to product detail (not on buttons)
                card.addEventListener('click', function(e) {
                    if (!e.target.closest('.btn')) {
                        window.location.href = contextPath + '/product?id=' + productId;
                    }
                });
                // Note: Add to cart is handled by global event delegation in main.js
            });

            // Initialize carousel
            const carousel = bestsellersContainer.closest('.carousel');
            if (carousel) {
                setTimeout(() => new Carousel(carousel), 100);
            }
        }
        
        // Note: Add to cart functionality is handled by global event delegation in main.js
    </script>
</body>
</html>

