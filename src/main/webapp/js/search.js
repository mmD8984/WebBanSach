/**
 * Search Functionality
 * Handles product search on the products page
 * 
 * JSP Integration: Replace with servlet-based search
 * - Send query to SearchServlet
 * - Handle search results pagination
 */

class ProductSearch {
    constructor() {
        this.searchResults = [];
        this.currentQuery = '';
    }

    /**
     * Search products
     * @param {string} query - Search query
     * @param {Object} options - Search options
     * @returns {Promise<Array>} Search results
     */
    async search(query, options = {}) {
        if (!query || query.length < 2) {
            return [];
        }

        this.currentQuery = query;
        Logger.log('Searching for:', query);

        try {
            // In production, this would call API.searchProducts(query, options)
            const results = await this.performSearch(query);
            this.searchResults = results;
            return results;
        } catch (error) {
            Logger.error('Search error:', error);
            showNotification('Lỗi tìm kiếm', 'error');
            return [];
        }
    }

    /**
     * Perform search algorithm
     * @param {string} query - Search query
     * @returns {Array} Results
     */
    performSearch(query) {
        const lowerQuery = query.toLowerCase().trim();
        const products = getProducts();

        return products.filter(product => {
            // Search in title
            if (product.title.toLowerCase().includes(lowerQuery)) {
                return true;
            }

            // Search in author
            if (product.authorName && product.authorName.toLowerCase().includes(lowerQuery)) {
                return true;
            }

            // Search in publisher
            if (product.publisherName && product.publisherName.toLowerCase().includes(lowerQuery)) {
                return true;
            }

            // Search in description
            if (product.description && product.description.toLowerCase().includes(lowerQuery)) {
                return true;
            }

            return false;
        });
    }

    /**
     * Get search results
     */
    getResults() {
        return this.searchResults;
    }

    /**
     * Clear search
     */
    clear() {
        this.searchResults = [];
        this.currentQuery = '';
    }
}

// Create global search instance
const search = new ProductSearch();

// ==========================================
// SEARCH PAGE EVENT HANDLERS
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    // Header search
    const headerSearch = getElement('header-search');
    if (headerSearch) {
        const searchBtn = queryElement('.search-btn');
        
        onEvent(headerSearch, 'keyup', debounce(function(e) {
            if (e.key === 'Enter') {
                performHeaderSearch();
            }
        }, 300));

        if (searchBtn) {
            onEvent(searchBtn, 'click', performHeaderSearch);
        }
    }

    // Products page search
    const productSearch = getElement('product-search');
    if (productSearch) {
        onEvent(productSearch, 'keyup', debounce(function(e) {
            const query = e.target.value;
            if (query.length >= 2) {
                performProductsPageSearch(query);
            } else if (query.length === 0) {
                resetProductsDisplay();
            }
        }, 300));
    }

    // Sort select
    const sortSelect = getElement('sort-select');
    if (sortSelect) {
        onEvent(sortSelect, 'change', function() {
            applySort(this.value);
        });
    }
});

/**
 * Perform header search
 */
function performHeaderSearch() {
    const searchInput = getElement('header-search');
    const query = searchInput?.value.trim();
    const contextPath = getContextPath();

    if (query && query.length >= 2) {
        // Redirect to products page with search query
        window.location.href = `${contextPath}/products?search=${encodeURIComponent(query)}`;
    }
}

/**
 * Perform search on products page
 */
async function performProductsPageSearch(query) {
    const results = await search.search(query);
    const productsGrid = getElement('products-grid');

    if (results.length === 0) {
        setHTML(productsGrid, `
            <div class="no-results">
                <p>Không tìm thấy sản phẩm phù hợp với "${query}"</p>
            </div>
        `);
        return;
    }

    // Render results
    renderProducts(results);
}

/**
 * Reset products display
 */
function resetProductsDisplay() {
    const productsGrid = getElement('products-grid');
    const products = getProducts();
    renderProducts(products);
}

/**
 * Apply sorting
 */
async function applySort(sortBy) {
    let products;

    if (search.currentQuery) {
        products = search.getResults();
    } else {
        products = getProducts();
    }

    // Sort products
    const sorted = api.sortProducts(products, sortBy);
    renderProducts(sorted);
}

/**
 * Render products on page
 */
function renderProducts(products) {
    const productsGrid = getElement('products-grid');
    const contextPath = getContextPath();
    if (!productsGrid) return;

    if (products.length === 0) {
        setHTML(productsGrid, '<p class="text-center">Không có sản phẩm</p>');
        return;
    }

    const html = products.map(product => renderProductCard(product)).join('');
    setHTML(productsGrid, html);

    // Attach click handlers
    queryAllElements('.product-card').forEach(card => {
        onEvent(card, 'click', function(e) {
            if (e.target.closest('.btn')) return;
            const productId = card.dataset.productId;
            window.location.href = `${contextPath}/product?id=${productId}`;
        });
    });

    // Note: Add to cart is handled by global event delegation in main.js
}

/**
 * Render product card HTML
 */
function renderProductCard(product) {
    const discount = calculateDiscount(product.originalPrice, product.price);
    const rating = '⭐'.repeat(Math.round(product.rating));

    return `
        <div class="card product-card" data-product-id="${product.id}">
            <div class="product-image">
                <img src="${product.image}" alt="${product.title}" onerror="this.src='${CONFIG.DEFAULT_IMAGE}'">
                ${discount > 0 ? `<div class="product-badge">-${discount}%</div>` : ''}
            </div>
            <div class="product-info">
                <h3 class="product-name">${truncateText(product.title, 40)}</h3>
                <p class="product-author">${product.authorName}</p>
                <div class="product-rating">
                    <span class="stars">${rating}</span>
                    <span class="review-count">(${product.reviews})</span>
                </div>
                <div class="product-price">
                    ${product.originalPrice > product.price ? 
                        `<span class="product-original-price">${formatPrice(product.originalPrice)}</span>` : ''}
                    <span class="product-sale-price">${formatPrice(product.price)}</span>
                </div>
                <button class="btn btn-primary btn-sm" style="width: 100%;">
                    🛒 Thêm Vào Giỏ
                </button>
            </div>
        </div>
    `;
}

// ==========================================
// SEARCH SUGGESTIONS (OPTIONAL)
// ==========================================

/**
 * Get search suggestions
 */
function getSearchSuggestions(query) {
    if (!query || query.length < 2) return [];

    const products = getProducts();
    const suggestions = new Set();

    // Collect title suggestions
    products.forEach(p => {
        if (p.title.toLowerCase().includes(query.toLowerCase())) {
            suggestions.add(p.title);
        }
    });

    // Collect author suggestions
    products.forEach(p => {
        if (p.authorName.toLowerCase().includes(query.toLowerCase())) {
            suggestions.add(p.authorName);
        }
    });

    return Array.from(suggestions).slice(0, 5);
}

/**
 * Show search suggestions
 */
function showSearchSuggestions(query) {
    const suggestions = getSearchSuggestions(query);
    // TODO: Implement suggestion UI
    Logger.log('Search suggestions:', suggestions);
}

// ==========================================
// EXPORT FOR MODULE USAGE
// ==========================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ProductSearch, search };
}

