<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Danh sách sách - Mua sách online">
    <title>Danh Sách Sách - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container products-page-container">
            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span> / </span>
                <span>Sản phẩm</span>
            </div>

            <div class="products-wrapper">
                <!-- Sidebar Filters -->
                <aside class="sidebar-filters">
                    <div class="filter-card">
                        <h3 class="filter-title">🔍 Lọc Sản Phẩm</h3>
                        
                        <!-- Category Filter -->
                        <div class="filter-group">
                            <label class="filter-label">Thể Loại</label>
                            <div class="filter-options" id="category-filter">
                                <c:forEach var="cat" items="${categories}">
                                    <label class="filter-checkbox">
                                        <input type="checkbox" name="category" value="${cat.id}" 
                                            <c:if test="${selectedCategory == cat.id}">checked</c:if>>
                                        <span>${cat.name}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Price Filter -->
                        <div class="filter-group">
                            <label class="filter-label">Giá (đ)</label>
                            <div class="price-filter">
                                <input type="number" id="price-min" placeholder="Từ" class="filter-input" 
                                    value="<c:if test="${selectedMinPrice != null}">${selectedMinPrice}</c:if>">
                                <input type="number" id="price-max" placeholder="Đến" class="filter-input"
                                    value="<c:if test="${selectedMaxPrice != null}">${selectedMaxPrice}</c:if>">
                                <button class="btn btn-sm btn-primary" id="apply-price-filter" style="width: 100%; margin-top: 8px;">Áp Dụng</button>
                            </div>
                        </div>

                        <!-- Author Filter -->
                        <div class="filter-group">
                            <label class="filter-label">Tác Giả</label>
                            <div class="filter-options" id="author-filter">
                                <c:forEach var="author" items="${authors}">
                                    <label class="filter-checkbox">
                                        <input type="checkbox" name="author" value="${author.id}"
                                            <c:if test="${selectedAuthor == author.id}">checked</c:if>>
                                        <span>${author.name}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Clear Filters -->
                        <button class="btn btn-outline" id="clear-filters" style="width: 100%; margin-top: 10px;">Xóa Bộ Lọc</button>
                    </div>
                </aside>

                <!-- Products Section -->
                <section class="products-section">
                    <!-- Search & Sort Bar -->
                    <div class="products-toolbar">
                        <div class="search-wrapper">
                            <form method="get" action="${pageContext.request.contextPath}/products" style="display: flex; width: 100%;">
                                <input type="text" id="product-search" name="search" placeholder="🔍 Tìm kiếm sách..." class="search-input"
                                    value="<c:if test="${searchQuery != null}">${searchQuery}</c:if>">
                                <button type="submit" class="btn btn-primary" style="margin-left: 5px;">Tìm</button>
                            </form>
                        </div>
                        
                        <div class="sort-wrapper">
                            <label for="sort-select">Sắp xếp:</label>
                            <select id="sort-select" class="sort-select" onchange="applySorting(this.value)">
                                <option value="">-- Chọn --</option>
                                <option value="newest" <c:if test="${selectedSort == 'newest'}">selected</c:if>>Mới Nhất</option>
                                <option value="price-low" <c:if test="${selectedSort == 'price-low'}">selected</c:if>>Giá Thấp Đến Cao</option>
                                <option value="price-high" <c:if test="${selectedSort == 'price-high'}">selected</c:if>>Giá Cao Đến Thấp</option>
                                <option value="name" <c:if test="${selectedSort == 'name'}">selected</c:if>>Tên (A-Z)</option>
                                <option value="rating" <c:if test="${selectedSort == 'rating'}">selected</c:if>>Đánh Giá Cao Nhất</option>
                            </select>
                        </div>
                    </div>

                    <!-- Error or No Results Message -->
                    <c:if test="${error != null}">
                        <div class="alert alert-danger" style="padding: 15px; margin: 20px 0; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 4px;">
                            ${error}
                        </div>
                    </c:if>

                    <c:if test="${empty books}">
                        <div class="alert alert-info" style="padding: 15px; margin: 20px 0; background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; border-radius: 4px;">
                            Không tìm thấy sản phẩm phù hợp.
                        </div>
                    </c:if>

                    <!-- Products Grid -->
                    <c:if test="${not empty books}">
                        <div class="products-grid" id="products-grid">
                            <c:forEach var="book" items="${books}">
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
                                            <span class="review-count">(${book.reviews} đánh giá)</span>
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
                    </c:if>

                    <!-- Pagination -->
                    <c:if test="${not empty books and totalPages > 1}">
                        <div class="pagination" id="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/products?page=1<c:if test="${searchQuery != null}">&search=${searchQuery}</c:if><c:if test="${selectedCategory != null}">&category=${selectedCategory}</c:if><c:if test="${selectedMinPrice != null}">&minPrice=${selectedMinPrice}</c:if><c:if test="${selectedMaxPrice != null}">&maxPrice=${selectedMaxPrice}</c:if><c:if test="${selectedAuthor != null}">&author=${selectedAuthor}</c:if><c:if test="${selectedSort != null}">&sort=${selectedSort}</c:if>" class="pagination-btn">« Đầu</a>
                                <a href="${pageContext.request.contextPath}/products?page=${currentPage - 1}<c:if test="${searchQuery != null}">&search=${searchQuery}</c:if><c:if test="${selectedCategory != null}">&category=${selectedCategory}</c:if><c:if test="${selectedMinPrice != null}">&minPrice=${selectedMinPrice}</c:if><c:if test="${selectedMaxPrice != null}">&maxPrice=${selectedMaxPrice}</c:if><c:if test="${selectedAuthor != null}">&author=${selectedAuthor}</c:if><c:if test="${selectedSort != null}">&sort=${selectedSort}</c:if>" class="pagination-btn">‹ Trước</a>
                            </c:if>

                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${p == currentPage}">
                                        <span class="pagination-btn active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/products?page=${p}<c:if test="${searchQuery != null}">&search=${searchQuery}</c:if><c:if test="${selectedCategory != null}">&category=${selectedCategory}</c:if><c:if test="${selectedMinPrice != null}">&minPrice=${selectedMinPrice}</c:if><c:if test="${selectedMaxPrice != null}">&maxPrice=${selectedMaxPrice}</c:if><c:if test="${selectedAuthor != null}">&author=${selectedAuthor}</c:if><c:if test="${selectedSort != null}">&sort=${selectedSort}</c:if>" class="pagination-btn">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/products?page=${currentPage + 1}<c:if test="${searchQuery != null}">&search=${searchQuery}</c:if><c:if test="${selectedCategory != null}">&category=${selectedCategory}</c:if><c:if test="${selectedMinPrice != null}">&minPrice=${selectedMinPrice}</c:if><c:if test="${selectedMaxPrice != null}">&maxPrice=${selectedMaxPrice}</c:if><c:if test="${selectedAuthor != null}">&author=${selectedAuthor}</c:if><c:if test="${selectedSort != null}">&sort=${selectedSort}</c:if>" class="pagination-btn">Sau ›</a>
                                <a href="${pageContext.request.contextPath}/products?page=${totalPages}<c:if test="${searchQuery != null}">&search=${searchQuery}</c:if><c:if test="${selectedCategory != null}">&category=${selectedCategory}</c:if><c:if test="${selectedMinPrice != null}">&minPrice=${selectedMinPrice}</c:if><c:if test="${selectedMaxPrice != null}">&maxPrice=${selectedMaxPrice}</c:if><c:if test="${selectedAuthor != null}">&author=${selectedAuthor}</c:if><c:if test="${selectedSort != null}">&sort=${selectedSort}</c:if>" class="pagination-btn">Cuối »</a>
                            </c:if>
                        </div>
                    </c:if>
                </section>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        // Apply filters
        document.getElementById('apply-price-filter').addEventListener('click', function() {
            const minPrice = document.getElementById('price-min').value;
            const maxPrice = document.getElementById('price-max').value;
            const selectedCategory = document.querySelector('input[name="category"]:checked');
            const selectedAuthor = document.querySelector('input[name="author"]:checked');
            
            let url = contextPath + '/products?';
            
            if (selectedCategory) {
                url += 'category=' + selectedCategory.value + '&';
            }
            if (minPrice) {
                url += 'minPrice=' + minPrice + '&';
            }
            if (maxPrice) {
                url += 'maxPrice=' + maxPrice + '&';
            }
            if (selectedAuthor) {
                url += 'author=' + selectedAuthor.value;
            }
            
            window.location.href = url;
        });

        // Category filter change
        document.querySelectorAll('input[name="category"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const url = contextPath + '/products?category=' + this.value;
                window.location.href = url;
            });
        });

        // Author filter change
        document.querySelectorAll('input[name="author"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const url = contextPath + '/products?author=' + this.value;
                window.location.href = url;
            });
        });

        // Clear filters
        document.getElementById('clear-filters').addEventListener('click', function() {
            window.location.href = contextPath + '/products';
        });

        // Apply sorting
        function applySorting(sortValue) {
            if (!sortValue) return;
            
            let url = contextPath + '/products?sort=' + sortValue;
            const urlParams = new URLSearchParams(window.location.search);
            
            if (urlParams.has('search')) {
                url += '&search=' + urlParams.get('search');
            }
            if (urlParams.has('category')) {
                url += '&category=' + urlParams.get('category');
            }
            if (urlParams.has('author')) {
                url += '&author=' + urlParams.get('author');
            }
            if (urlParams.has('minPrice')) {
                url += '&minPrice=' + urlParams.get('minPrice');
            }
            if (urlParams.has('maxPrice')) {
                url += '&maxPrice=' + urlParams.get('maxPrice');
            }
            
            window.location.href = url;
        }

        // Add to cart button
        document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const card = this.closest('.product-card');
                const productId = card.getAttribute('data-product-id');
                const productTitle = card.querySelector('.product-name').textContent;
                const productPrice = card.querySelector('.product-sale-price').textContent;
                const productImage = card.querySelector('img').src;
                const productAuthor = card.querySelector('.product-author').textContent;

                addProductToCart(parseInt(productId), productTitle, productPrice, productImage, productAuthor);
            });
        });

        // Product card click to detail
        document.querySelectorAll('.product-card').forEach(card => {
            card.addEventListener('click', function(e) {
                if (e.target.closest('.btn')) return;
                const productId = this.getAttribute('data-product-id');
                window.location.href = contextPath + '/product?id=' + productId;
            });
        });

        function addProductToCart(productId, title, price, image, author) {
            // Parse price from formatted string (e.g., "145.000đ" -> 145000)
            const priceValue = parseInt(price.replace(/\D/g, '')) || 0;
            
            const product = {
                id: productId,
                title: title || 'Sản phẩm',
                price: priceValue,
                image: image || '',
                author: author || '',
                stock: 999
            };

            // Check if cart is initialized
            if (typeof cart === 'undefined') {
                console.error('Cart not defined');
                alert('Lỗi: Giỏ hàng chưa sẵn sàng. Vui lòng tải lại trang.');
                return;
            }
            
            if (!cart || typeof cart.addProduct !== 'function') {
                console.error('Cart.addProduct is not a function', cart);
                alert('Lỗi: Không thể thêm vào giỏ hàng. Vui lòng tải lại trang.');
                return;
            }
            
            cart.addProduct(product, 1);
        }
    </script>
</body>
</html>

