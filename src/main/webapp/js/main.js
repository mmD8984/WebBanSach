/**
 * Main Application JavaScript
 * Initializes the application and handles global event listeners
 */

// ==========================================
// UTILITY FUNCTIONS
// ==========================================

/**
 * Get context path for servlet URLs
 */
function getContextPath() {
    const path = window.location.pathname;
    if (path.includes('/webbansach/')) {
        return '/webbansach';
    }
    // For other deployment contexts
    const parts = path.split('/');
    return parts.length > 1 ? '/' + parts[1] : '';
}

// ==========================================
// PAGE INITIALIZATION
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    Logger.log('Application initialized');
    
    // Global event delegation for add-to-cart buttons
    // This prevents duplicate event handlers from multiple scripts
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.add-to-cart-btn');
        if (!btn) return;
        
        // Prevent handling if already handled
        if (e.defaultPrevented) return;
        e.preventDefault();
        e.stopImmediatePropagation();
        
        // Check if user is logged in by making API call
        checkLoginBeforeAddCart(btn);
    }, true); // Use capture phase to run first

    // Detect current page
    const path = window.location.pathname;

    // Initialize cart on all pages
    cart.updateCartUI();

    // Page-specific initialization
    if (path.includes('index.html') || path.endsWith('/') || path === '/webbansach' || path === '/webbansach/') {
        initializeHomePage();
    } else if (path.includes('products') || path.includes('products.html')) {
        initializeProductsPage();
    } else if (path.includes('product?') || path.includes('product-detail')) {
        initializeProductDetailPage();
    } else if (path.includes('checkout') || path.includes('checkout.html')) {
        initializeCheckoutPage();
    }

    // Global event handlers
    initializeGlobalHandlers();
    
    // Initialize FAQ accordion
    initializeFAQ();
});

// ==========================================
// HOME PAGE INITIALIZATION
// ==========================================

function initializeHomePage() {
    Logger.log('Initializing home page');

    // Categories carousel section
    const categoriesGrid = getElement('categories-grid');
    if (categoriesGrid) {
        const contextPath = getContextPath();
        const html = CATEGORIES_DATA.map(cat => `
            <div class="carousel-item category-item">
                <a href="${contextPath}/products?category=${cat.id}" class="category-card card">
                    <div class="category-icon">${cat.icon}</div>
                    <h3 class="category-name">${cat.name}</h3>
                    <p class="category-count">${cat.count} sách</p>
                </a>
            </div>
        `).join('');
        setHTML(categoriesGrid, html);
        
        // Initialize carousel
        setTimeout(() => {
            new Carousel(categoriesGrid.closest('.carousel'));
        }, 100);
    }

    // Featured products
    const featuredProducts = getElement('featured-products');
    if (featuredProducts) {
        const products = getFeaturedProducts();
        renderProductsGrid(products, 'featured-products');
    }

    // Bestsellers
    const bestsellersProducts = getElement('bestsellers-products');
    if (bestsellersProducts) {
        const products = getBestsellerProducts();
        renderProductsGrid(products, 'bestsellers-products');
    }
}

/**
 * Render products grid
 */
function renderProductsGrid(products, containerId) {
    const container = getElement(containerId);
    if (!container) return;

    const html = products.map(product => `
        <div class="carousel-item product-carousel-item">
            <div class="card product-card" data-product-id="${product.id}">
                <div class="product-image">
                    <img src="${product.image}" alt="${product.title}" onerror="this.src='${CONFIG.DEFAULT_IMAGE}'">
                    ${calculateDiscount(product.originalPrice, product.price) > 0 ? 
                        `<div class="product-badge">-${calculateDiscount(product.originalPrice, product.price)}%</div>` : ''}
                </div>
                <div class="product-info">
                    <h3 class="product-name">${truncateText(product.title, 40)}</h3>
                    <p class="product-author">${product.authorName}</p>
                    <div class="product-rating">
                        <span class="stars">${'⭐'.repeat(Math.round(product.rating))}</span>
                        <span class="review-count">(${product.reviews})</span>
                    </div>
                    <div class="product-price">
                        ${product.originalPrice > product.price ? 
                            `<span class="product-original-price">${formatPrice(product.originalPrice)}</span>` : ''}
                        <span class="product-sale-price">${formatPrice(product.price)}</span>
                    </div>
                    <button class="btn btn-primary btn-sm add-to-cart-btn" style="width: 100%;">
                        🛒 Thêm Vào Giỏ
                    </button>
                </div>
            </div>
        </div>
    `).join('');

    setHTML(container, html);

    // Attach event handlers
    attachProductGridHandlers(container);
    
    // Initialize carousel if parent has carousel class
    const carousel = container.closest('.carousel');
    if (carousel) {
        setTimeout(() => new Carousel(carousel), 100);
    }
}

/**
 * Attach product grid event handlers
 */
function attachProductGridHandlers(container) {
    const contextPath = getContextPath();
    queryAllElements('.product-card', container).forEach(card => {
        onEvent(card, 'click', function(e) {
            if (e.target.closest('.btn')) return;
            const productId = card.dataset.productId;
            window.location.href = `${contextPath}/product?id=${productId}`;
        });
    });

    // Note: Add to cart is now handled by global event delegation (above)
    // Individual event listeners removed to prevent duplicate handling
}


// ==========================================
// PRODUCT DETAIL PAGE INITIALIZATION
// ==========================================

function initializeProductDetailPage() {
    Logger.log('Initializing product detail page');

    // Get product ID from URL
    const params = new URLSearchParams(window.location.search);
    const productId = parseInt(params.get('id'));
    const contextPath = getContextPath();

    if (!productId) {
        showNotification('Sản phẩm không tồn tại', 'error');
        setTimeout(() => window.location.href = contextPath + '/products', 2000);
        return;
    }

    // Load product details
    const product = getProductById(productId);
    if (!product) {
        showNotification('Sản phẩm không tồn tại', 'error');
        setTimeout(() => window.location.href = contextPath + '/products', 2000);
        return;
    }

    displayProductDetails(product);

    // Load related products
    const relatedContainer = getElement('related-products');
    if (relatedContainer) {
        const related = getProductsByCategory(product.categoryId)
            .filter(p => p.id !== productId)
            .slice(0, 4);
        renderProductsGrid(related, 'related-products');
    }
}

/**
 * Display product details
 */
function displayProductDetails(product) {
    const discount = calculateDiscount(product.originalPrice, product.price);

    // Update page title
    document.title = `${product.title} - BookStore`;

    // Main image
    const mainImage = getElement('main-image');
    if (mainImage) {
        mainImage.src = product.image;
        mainImage.alt = product.title;
        mainImage.onerror = function() { this.src = CONFIG.DEFAULT_IMAGE; };
    }

    // Title
    setText(getElement('product-title'), product.title);

    // Breadcrumb
    setText(getElement('breadcrumb-product'), product.title);

    // Meta info
    setText(getElement('product-author'), product.authorName);
    setText(getElement('product-publisher'), product.publisherName);

    // Rating
    const ratingEl = getElement('product-rating');
    if (ratingEl) {
        setText(ratingEl, '⭐'.repeat(Math.round(product.rating)));
    }

    // Price
    setText(getElement('original-price'), formatPrice(product.originalPrice));
    setText(getElement('sale-price'), formatPrice(product.price));

    if (discount > 0) {
        setText(getElement('discount-badge'), `-${discount}%`);
        showElement(getElement('discount-badge'));
    } else {
        hideElement(getElement('discount-badge'));
    }

    // Description
    setText(getElement('product-description'), product.description);

    // Details table
    setText(getElement('detail-author'), product.authorName);
    setText(getElement('detail-publisher'), product.publisherName);
    setText(getElement('detail-year'), product.year);
    setText(getElement('detail-pages'), product.pages + ' trang');
    setText(getElement('detail-size'), product.size);
    setText(getElement('detail-format'), product.format);
    setText(getElement('detail-status'), product.status);

    // Review count
    setText(getElement('review-count'), `(${product.reviews} đánh giá)`);
}

// ==========================================
// CHECKOUT PAGE INITIALIZATION
// ==========================================

function initializeCheckoutPage() {
    Logger.log('Initializing checkout page');
    const contextPath = getContextPath();

    // Check if cart is empty
    if (cart.isEmpty()) {
        showNotification('Giỏ hàng trống, vui lòng thêm sản phẩm', 'warning');
        setTimeout(() => window.location.href = contextPath + '/cart', 2000);
        return;
    }

    // Display order summary
    displayOrderSummary();

    // Attach checkout handlers
    attachCheckoutHandlers();
}

/**
 * Display order summary in checkout
 */
function displayOrderSummary() {
    const checkoutItemsContainer = getElement('checkout-items');
    const orderSummaryContainer = getElement('order-summary');

    if (checkoutItemsContainer) {
        const html = cart.getItems().map(item => `
            <div class="summary-item">
                <span>${item.title} x ${item.quantity}</span>
                <span>${formatPrice(item.price * item.quantity)}</span>
            </div>
        `).join('');
        setHTML(checkoutItemsContainer, html);
    }

    updateCheckoutTotals();
}

/**
 * Update checkout totals
 */
function updateCheckoutTotals() {
    const subtotal = cart.getTotal();
    const shippingMethod = queryElement('input[name="shipping"]:checked')?.value || 'standard';
    
    let shippingCost = 0;
    if (shippingMethod === 'express') {
        shippingCost = CONFIG.SHIPPING_COST_EXPRESS;
    } else if (shippingMethod === 'overnight') {
        shippingCost = CONFIG.SHIPPING_COST_OVERNIGHT;
    }

    const total = subtotal + shippingCost;

    setText(getElement('checkout-total'), formatPrice(total));
}

/**
 * Attach checkout event handlers
 */
function attachCheckoutHandlers() {
    // Step navigation
    const nextStep1 = getElement('next-step-1');
    if (nextStep1) {
        onEvent(nextStep1, 'click', function() {
            if (validateCustomerForm()) {
                goToStep(2);
            }
        });
    }

    const backStep2 = getElement('back-step-2');
    if (backStep2) {
        onEvent(backStep2, 'click', () => goToStep(1));
    }

    const nextStep2 = getElement('next-step-2');
    if (nextStep2) {
        onEvent(nextStep2, 'click', () => goToStep(3));
    }

    const backStep3 = getElement('back-step-3');
    if (backStep3) {
        onEvent(backStep3, 'click', () => goToStep(2));
    }

    const nextStep3 = getElement('next-step-3');
    if (nextStep3) {
        onEvent(nextStep3, 'click', () => {
            if (validatePaymentForm()) {
                goToStep(4);
            }
        });
    }

    const backStep4 = getElement('back-step-4');
    if (backStep4) {
        onEvent(backStep4, 'click', () => goToStep(3));
    }

    const placeOrderBtn = getElement('place-order');
    if (placeOrderBtn) {
        onEvent(placeOrderBtn, 'click', placeOrder);
    }

    // Payment method change
    queryAllElements('input[name="payment"]').forEach(radio => {
        onEvent(radio, 'change', function() {
            const cardDetails = getElement('card-details');
            if (this.value === 'card') {
                showElement(cardDetails);
            } else {
                hideElement(cardDetails);
            }
        });
    });

    // Shipping method change
    queryAllElements('input[name="shipping"]').forEach(radio => {
        onEvent(radio, 'change', updateCheckoutTotals);
    });
}

/**
 * Go to checkout step
 */
function goToStep(stepNumber) {
    // Hide all steps
    for (let i = 1; i <= 4; i++) {
        hideElement(getElement(`step-${i}`));
    }

    // Show current step
    showElement(getElement(`step-${stepNumber}`));

    // Update step indicators
    queryAllElements('.step').forEach((step, index) => {
        if (index + 1 <= stepNumber) {
            addClass(step, 'active');
        } else {
            removeClass(step, 'active');
        }
    });
}

/**
 * Validate customer form
 */
function validateCustomerForm() {
    const rules = {
        fullname: { required: true, label: 'Họ và tên' },
        phone: { required: true, type: 'phone', label: 'Số điện thoại' },
        email: { required: true, type: 'email', label: 'Email' },
        address: { required: true, label: 'Địa chỉ' },
        city: { required: true, label: 'Thành phố' },
        district: { required: true, label: 'Quận/Huyện' }
    };

    const formData = {
        fullname: getElement('fullname')?.value,
        phone: getElement('phone')?.value,
        email: getElement('email')?.value,
        address: getElement('address')?.value,
        city: getElement('city')?.value,
        district: getElement('district')?.value
    };

    const validation = validateForm(formData, rules);

    if (!validation.valid) {
        Object.entries(validation.errors).forEach(([field, message]) => {
            showNotification(message, 'error');
        });
        return false;
    }

    return true;
}

/**
 * Validate payment form
 */
function validatePaymentForm() {
    const paymentMethod = queryElement('input[name="payment"]:checked')?.value;

    if (paymentMethod === 'card') {
        const cardNumber = getElement('card-number')?.value;
        const cardExpiry = getElement('card-expiry')?.value;
        const cardCvv = getElement('card-cvv')?.value;

        if (!validateCardNumber(cardNumber)) {
            showNotification('Số thẻ không hợp lệ', 'error');
            return false;
        }

        if (!validateCVV(cardCvv)) {
            showNotification('CVV không hợp lệ', 'error');
            return false;
        }
    }

    return true;
}

/**
 * Place order
 */
async function placeOrder() {
    const contextPath = getContextPath();
    const orderData = {
        customer: {
            fullname: getElement('fullname')?.value,
            email: getElement('email')?.value,
            phone: getElement('phone')?.value,
            address: getElement('address')?.value,
            city: getElement('city')?.value,
            district: getElement('district')?.value,
            notes: getElement('notes')?.value
        },
        shipping: queryElement('input[name="shipping"]:checked')?.value || 'standard',
        payment: queryElement('input[name="payment"]:checked')?.value || 'cod',
        items: cart.getItems(),
        total: cart.getTotal()
    };

    setLoading(getElement('place-order'), true, 'Đang xử lý...');

    try {
        const result = await api.placeOrder(orderData);
        
        if (result.success) {
            showNotification('Đơn hàng đã được tạo thành công', 'success');
            cart.clear();
            setTimeout(() => {
                window.location.href = `${contextPath}/order-success?orderId=${result.orderId}`;
            }, 2000);
        } else {
            showNotification('Lỗi khi tạo đơn hàng', 'error');
        }
    } catch (error) {
        Logger.error('Order placement error:', error);
        showNotification('Lỗi khi tạo đơn hàng', 'error');
    } finally {
        setLoading(getElement('place-order'), false);
    }
}

// ==========================================
// GLOBAL EVENT HANDLERS
// ==========================================

function initializeGlobalHandlers() {
    // Mobile menu toggle
    const menuToggle = getElement('menu-toggle');
    if (menuToggle) {
        onEvent(menuToggle, 'click', function() {
            const navMenu = queryElement('.nav-menu');
            if (navMenu) {
                toggleClass(navMenu, 'active');
            }
        });
    }

    // Smooth scroll for anchor links
    queryAllElements('a[href^="#"]').forEach(link => {
        onEvent(link, 'click', function(e) {
            const target = queryElement(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // Update cart on storage change (for multi-tab sync)
    onEvent(window, 'storage', function(e) {
        if (e.key === CONFIG.STORAGE_CART) {
            cart.loadCart();
            cart.updateCartUI();
        }
    });

    // Log cart updates
    document.addEventListener('cart:updated', function(e) {
        Logger.log('Cart updated:', e.detail);
    });
}

// ==========================================
// ERROR HANDLING
// ==========================================

window.addEventListener('error', function(event) {
    Logger.error('Global error:', event.error);
    showNotification('Đã xảy ra lỗi, vui lòng thử lại', 'error');
});

window.addEventListener('unhandledrejection', function(event) {
    Logger.error('Unhandled promise rejection:', event.reason);
});

Logger.log('Application ready');

// ==========================================
// FAQ ACCORDION
// ==========================================

/**
 * Initialize FAQ accordion
 */
function initializeFAQ() {
    const faqItems = document.querySelectorAll('.faq-item');
    
    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        if (!question) return;
        
        question.addEventListener('click', () => {
            // Close other items
            faqItems.forEach(otherItem => {
                if (otherItem !== item) {
                    otherItem.classList.remove('active');
                }
            });
            
            // Toggle current item
            item.classList.toggle('active');
        });
    });
}

// ==========================================
// AUTHENTICATION & AUTHORIZATION
// ==========================================

/**
 * Check if user is logged in before adding to cart
 * @param {HTMLElement} btn - Add to cart button
 */
function checkLoginBeforeAddCart(btn) {
    // Check if user is logged in by looking for user info in page
    // If not logged in, redirect to login page
    const contextPath = getContextPath() || '/webbansach_war';
    const currentUrl = window.location.pathname + window.location.search;
    
    // Make a simple check - if we can access session user via servlet
    // For now, we'll assume if add-to-cart is clicked without session, 
    // the filter will catch it on checkout. But for UX, we check with a beacon.
    
    fetch(contextPath + '/api/check-login', {
        method: 'GET',
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        if (data.loggedIn) {
            // User is logged in - proceed with add to cart
            const card = btn.closest('.product-card');
            const productId = parseInt(card.dataset.productId || card.getAttribute('data-product-id'));
            const product = getProductById(productId);
            if (product && typeof cart !== 'undefined' && cart.addProduct) {
                cart.addProduct(product, 1);
            }
        } else {
            // User is not logged in - redirect to login
            const returnUrl = encodeURIComponent(currentUrl);
            window.location.href = contextPath + '/login?returnUrl=' + returnUrl;
        }
    })
    .catch(error => {
        Logger.error('Error checking login status', error);
        // On error, allow adding to cart (graceful degradation)
        // Filter will protect checkout/cart anyway
        const card = btn.closest('.product-card');
        const productId = parseInt(card.dataset.productId || card.getAttribute('data-product-id'));
        const product = getProductById(productId);
        if (product && typeof cart !== 'undefined' && cart.addProduct) {
            cart.addProduct(product, 1);
        }
    });
}

