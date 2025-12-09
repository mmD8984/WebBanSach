/**
 * Shopping Cart Management
 * Handles all cart operations using localStorage
 * In production, this data will be stored on server via CartServlet
 */

class ShoppingCart {
    constructor(storageKey = CONFIG.STORAGE_CART) {
        this.storageKey = storageKey;
        this.cart = this.loadCart();
    }

    /**
     * Load cart from storage
     */
    loadCart() {
        return getStorage(this.storageKey, []);
    }

    /**
     * Save cart to storage
     */
    saveCart() {
        saveStorage(this.storageKey, this.cart);
        this.updateCartUI();
        triggerEvent('cart:updated', { cart: this.cart });
    }

    /**
     * Add product to cart
     * @param {Object} product - Product object
     * @param {number} quantity - Quantity
     */
    addProduct(product, quantity = 1) {
        if (!product || !product.id) {
            Logger.error('Invalid product');
            return false;
        }

        quantity = Math.max(1, Math.min(quantity, product.stock || 999));

        const existingItem = this.cart.find(item => item.id === product.id);
        if (existingItem) {
            existingItem.quantity += quantity;
            existingItem.quantity = Math.min(existingItem.quantity, product.stock || 999);
        } else {
            this.cart.push({
                id: product.id,
                title: product.title,
                price: product.price,
                originalPrice: product.originalPrice,
                image: product.image,
                quantity: quantity,
                stock: product.stock || 999
            });
        }

        this.saveCart();
        showNotification('Đã thêm vào giỏ hàng', 'success');
        Logger.log('Product added to cart', product.id);
        return true;
    }

    /**
     * Remove product from cart
     * @param {number} productId - Product ID
     */
    removeProduct(productId) {
        const index = this.cart.findIndex(item => item.id === productId);
        if (index > -1) {
            const removed = this.cart.splice(index, 1)[0];
            this.saveCart();
            showNotification('Đã xóa khỏi giỏ hàng', 'success');
            Logger.log('Product removed from cart', productId);
            return true;
        }
        return false;
    }

    /**
     * Update product quantity
     * @param {number} productId - Product ID
     * @param {number} quantity - New quantity
     */
    updateQuantity(productId, quantity) {
        const item = this.cart.find(item => item.id === productId);
        if (!item) return false;

        quantity = Math.max(1, parseInt(quantity));
        quantity = Math.min(quantity, item.stock);

        item.quantity = quantity;
        this.saveCart();
        Logger.log('Cart quantity updated', productId, quantity);
        return true;
    }

    /**
     * Get cart item
     * @param {number} productId - Product ID
     */
    getItem(productId) {
        return this.cart.find(item => item.id === productId) || null;
    }

    /**
     * Get all cart items
     */
    getItems() {
        return [...this.cart];
    }

    /**
     * Get cart count
     */
    getCount() {
        return this.cart.reduce((sum, item) => sum + item.quantity, 0);
    }

    /**
     * Get cart total
     */
    getTotal() {
        return this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    }

    /**
     * Get original total (before discount)
     */
    getOriginalTotal() {
        return this.cart.reduce((sum, item) => {
            const price = item.originalPrice || item.price;
            return sum + (price * item.quantity);
        }, 0);
    }

    /**
     * Clear cart
     */
    clear() {
        this.cart = [];
        this.saveCart();
        Logger.log('Cart cleared');
    }

    /**
     * Check if cart is empty
     */
    isEmpty() {
        return this.cart.length === 0;
    }

    /**
     * Update cart UI (badges, counts, etc)
     */
    updateCartUI() {
        const count = this.getCount();
        const badges = queryAllElements('#cart-count');
        badges.forEach(badge => {
            setText(badge, count);
            if (count > 0) {
                showElement(badge.parentElement);
            } else {
                hideElement(badge.parentElement);
            }
        });
    }

    /**
     * Render cart items HTML
     */
    renderCartItems() {
        if (this.isEmpty()) {
            return `
                <div class="empty-cart">
                    <p>🛒 Giỏ hàng của bạn trống</p>
                    <a href="products.html" class="btn btn-primary">Tiếp Tục Mua Sắm</a>
                </div>
            `;
        }

        return this.cart.map(item => `
            <div class="cart-item" data-product-id="${item.id}">
                <div class="item-image">
                    <img src="${item.image}" alt="${item.title}">
                </div>
                <div class="item-info">
                    <h3 class="item-title">${item.title}</h3>
                    <p class="item-price">${formatPrice(item.price)}</p>
                </div>
                <div class="item-quantity">
                    <button class="qty-btn qty-decrease" data-product-id="${item.id}">−</button>
                    <input type="number" value="${item.quantity}" min="1" max="${item.stock}" class="qty-input" data-product-id="${item.id}">
                    <button class="qty-btn qty-increase" data-product-id="${item.id}">+</button>
                </div>
                <div class="item-total">
                    <p>${formatPrice(item.price * item.quantity)}</p>
                </div>
                <div class="item-actions">
                    <button class="btn btn-sm btn-outline" data-product-id="${item.id}">Xóa</button>
                </div>
            </div>
        `).join('');
    }

    /**
     * Export cart for checkout
     */
    getCheckoutData() {
        return {
            items: this.cart,
            subtotal: this.getTotal(),
            itemCount: this.cart.length,
            quantity: this.getCount()
        };
    }
}

// Create global cart instance
const cart = new ShoppingCart();

// ==========================================
// CART PAGE EVENT HANDLERS
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    // Update cart UI on page load
    cart.updateCartUI();

    // Cart page specific handlers
    if (window.location.pathname.includes('cart.html')) {
        initializeCartPage();
    }
});

function initializeCartPage() {
    // Render cart items
    const cartItemsContainer = getElement('cart-items');
    const emptyCartDiv = getElement('empty-cart');

    if (cartItemsContainer) {
        if (cart.isEmpty()) {
            showElement(emptyCartDiv);
            hideElement(cartItemsContainer);
        } else {
            hideElement(emptyCartDiv);
            setHTML(cartItemsContainer, cart.renderCartItems());
            
            // Attach event handlers to cart items
            attachCartItemHandlers();
        }
    }

    // Update cart summary
    updateCartSummary();

    // Checkout button
    const checkoutBtn = getElement('checkout-btn');
    if (checkoutBtn) {
        onEvent(checkoutBtn, 'click', function() {
            if (!cart.isEmpty()) {
                window.location.href = 'checkout.html';
            }
        });
    }

    // Apply coupon
    const applyCouponBtn = getElement('apply-coupon');
    if (applyCouponBtn) {
        onEvent(applyCouponBtn, 'click', function() {
            const couponInput = getElement('coupon-input');
            const code = couponInput.value.trim();
            if (code) {
                showNotification('Mã khuyến mãi không hợp lệ', 'warning');
                couponInput.value = '';
            }
        });
    }
}

function attachCartItemHandlers() {
    // Remove buttons
    queryAllElements('.cart-item .btn').forEach(btn => {
        onEvent(btn, 'click', function(e) {
            e.preventDefault();
            const productId = parseInt(btn.dataset.productId);
            if (cart.removeProduct(productId)) {
                // Re-render cart
                initializeCartPage();
            }
        });
    });

    // Quantity decrease buttons
    queryAllElements('.qty-decrease').forEach(btn => {
        onEvent(btn, 'click', function() {
            const productId = parseInt(btn.dataset.productId);
            const item = cart.getItem(productId);
            if (item && item.quantity > 1) {
                cart.updateQuantity(productId, item.quantity - 1);
                attachCartItemHandlers();
                updateCartSummary();
            }
        });
    });

    // Quantity increase buttons
    queryAllElements('.qty-increase').forEach(btn => {
        onEvent(btn, 'click', function() {
            const productId = parseInt(btn.dataset.productId);
            const item = cart.getItem(productId);
            if (item && item.quantity < item.stock) {
                cart.updateQuantity(productId, item.quantity + 1);
                attachCartItemHandlers();
                updateCartSummary();
            }
        });
    });

    // Quantity input fields
    queryAllElements('.qty-input').forEach(input => {
        onEvent(input, 'change', function() {
            const productId = parseInt(input.dataset.productId);
            const quantity = Math.max(1, parseInt(input.value) || 1);
            cart.updateQuantity(productId, quantity);
            updateCartSummary();
        });
    });
}

function updateCartSummary() {
    const subtotal = cart.getTotal();
    const shippingFee = subtotal >= CONFIG.FREE_SHIPPING_THRESHOLD ? 0 : 30000;
    const total = subtotal + shippingFee;

    const subtotalEl = getElement('subtotal');
    const shippingEl = getElement('shipping-fee');
    const totalEl = getElement('total');

    if (subtotalEl) setText(subtotalEl, formatPrice(subtotal));
    if (shippingEl) setText(shippingEl, formatPrice(shippingFee));
    if (totalEl) setText(totalEl, formatPrice(total));
}

// ==========================================
// ADD TO CART FROM PRODUCT PAGE
// ==========================================

/**
 * Handle add to cart button click
 * @param {number} productId - Product ID
 */
function addToCartFromPage(productId) {
    const product = getProductById(productId);
    if (product) {
        const quantity = parseInt(getElement('quantity')?.value || 1);
        cart.addProduct(product, quantity);
    }
}

/**
 * Setup add to cart handlers on product page
 */
function setupAddToCartHandlers() {
    const addToCartBtn = getElement('add-to-cart-btn');
    if (addToCartBtn) {
        onEvent(addToCartBtn, 'click', function() {
            const productId = parseInt(new URLSearchParams(window.location.search).get('id') || 
                             queryElement('[data-product-id]')?.dataset.productId);
            if (productId) {
                addToCartFromPage(productId);
            }
        });
    }

    // Quantity controls on detail page
    const qtyDecreaseBtn = getElement('qty-decrease');
    const qtyIncreaseBtn = getElement('qty-increase');
    const quantityInput = getElement('quantity');

    if (qtyDecreaseBtn) {
        onEvent(qtyDecreaseBtn, 'click', function() {
            const current = parseInt(quantityInput.value) || 1;
            if (current > 1) quantityInput.value = current - 1;
        });
    }

    if (qtyIncreaseBtn) {
        onEvent(qtyIncreaseBtn, 'click', function() {
            const current = parseInt(quantityInput.value) || 1;
            quantityInput.value = current + 1;
        });
    }
}

// Setup handlers when DOM is ready
document.addEventListener('DOMContentLoaded', setupAddToCartHandlers);

