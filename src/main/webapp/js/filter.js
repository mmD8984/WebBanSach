/**
 * Product Filtering
 * Handles filtering products by category, price, author, etc.
 * 
 * JSP Integration: Replace with servlet-based filtering
 * - Send filter parameters to FilterServlet
 * - Handle filtered results display
 */

class ProductFilter {
    constructor() {
        this.filters = {
            categories: [],
            authors: [],
            publishers: [],
            priceMin: 0,
            priceMax: CONFIG.MAX_PRICE
        };
        this.filteredResults = [];
    }

    /**
     * Apply filters
     * @param {Object} newFilters - Filter parameters
     * @returns {Array} Filtered products
     */
    async applyFilters(newFilters = {}) {
        Object.assign(this.filters, newFilters);
        Logger.log('Applying filters:', this.filters);

        try {
            this.filteredResults = await api.filterProducts(this.filters);
            return this.filteredResults;
        } catch (error) {
            Logger.error('Filter error:', error);
            return [];
        }
    }

    /**
     * Filter by category
     */
    filterByCategory(categoryId) {
        const index = this.filters.categories.indexOf(categoryId);
        if (index > -1) {
            this.filters.categories.splice(index, 1);
        } else {
            this.filters.categories.push(categoryId);
        }
        return this.applyFilters();
    }

    /**
     * Filter by author
     */
    filterByAuthor(authorId) {
        const index = this.filters.authors.indexOf(authorId);
        if (index > -1) {
            this.filters.authors.splice(index, 1);
        } else {
            this.filters.authors.push(authorId);
        }
        return this.applyFilters();
    }

    /**
     * Filter by publisher
     */
    filterByPublisher(publisherId) {
        const index = this.filters.publishers.indexOf(publisherId);
        if (index > -1) {
            this.filters.publishers.splice(index, 1);
        } else {
            this.filters.publishers.push(publisherId);
        }
        return this.applyFilters();
    }

    /**
     * Filter by price range
     */
    filterByPrice(minPrice, maxPrice) {
        this.filters.priceMin = Math.max(0, parseInt(minPrice) || 0);
        this.filters.priceMax = Math.min(CONFIG.MAX_PRICE, parseInt(maxPrice) || CONFIG.MAX_PRICE);
        return this.applyFilters();
    }

    /**
     * Clear all filters
     */
    clearFilters() {
        this.filters = {
            categories: [],
            authors: [],
            publishers: [],
            priceMin: 0,
            priceMax: CONFIG.MAX_PRICE
        };
        this.filteredResults = getProducts();
        return this.filteredResults;
    }

    /**
     * Get filtered results
     */
    getResults() {
        return this.filteredResults;
    }

    /**
     * Get active filters count
     */
    getActiveFiltersCount() {
        let count = 0;
        if (this.filters.categories.length > 0) count++;
        if (this.filters.authors.length > 0) count++;
        if (this.filters.publishers.length > 0) count++;
        if (this.filters.priceMin > 0 || this.filters.priceMax < CONFIG.MAX_PRICE) count++;
        return count;
    }
}

// Create global filter instance
const filter = new ProductFilter();

// ==========================================
// FILTER PAGE EVENT HANDLERS
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    initializeFilters();
});

function initializeFilters() {
    // Initialize category filter
    const categoryFilter = getElement('category-filter');
    if (categoryFilter) {
        renderCategoryOptions();
    }

    // Initialize author filter
    const authorFilter = getElement('author-filter');
    if (authorFilter) {
        renderAuthorOptions();
    }

    // Initialize publisher filter
    const publisherFilter = getElement('publisher-filter');
    if (publisherFilter) {
        renderPublisherOptions();
    }

    // Price filter button
    const applyPriceBtn = getElement('apply-price-filter');
    if (applyPriceBtn) {
        onEvent(applyPriceBtn, 'click', applyPriceFilter);
    }

    // Clear filters button
    const clearFiltersBtn = getElement('clear-filters');
    if (clearFiltersBtn) {
        onEvent(clearFiltersBtn, 'click', clearAllFilters);
    }
}

/**
 * Render category filter options
 */
function renderCategoryOptions() {
    const container = getElement('category-filter');
    if (!container) return;

    const categories = CATEGORIES_DATA;
    const html = categories.map(cat => `
        <label class="filter-checkbox">
            <input type="checkbox" value="${cat.id}" class="category-checkbox">
            <span>${cat.name} (${cat.count})</span>
        </label>
    `).join('');

    setHTML(container, html);

    // Attach event listeners
    queryAllElements('.category-checkbox').forEach(checkbox => {
        onEvent(checkbox, 'change', function() {
            applyFilters();
        });
    });
}

/**
 * Render author filter options
 */
function renderAuthorOptions() {
    const container = getElement('author-filter');
    if (!container) return;

    const authors = getUniqueAuthors().slice(0, CONFIG.AUTHOR_LIMIT);
    const html = authors.map(author => `
        <label class="filter-checkbox">
            <input type="checkbox" value="${author.id}" class="author-checkbox">
            <span>${author.name}</span>
        </label>
    `).join('');

    setHTML(container, html);

    // Attach event listeners
    queryAllElements('.author-checkbox').forEach(checkbox => {
        onEvent(checkbox, 'change', function() {
            applyFilters();
        });
    });
}

/**
 * Render publisher filter options
 */
function renderPublisherOptions() {
    const container = getElement('publisher-filter');
    if (!container) return;

    const publishers = getUniquePublishers().slice(0, CONFIG.PUBLISHER_LIMIT);
    const html = publishers.map(pub => `
        <label class="filter-checkbox">
            <input type="checkbox" value="${pub.id}" class="publisher-checkbox">
            <span>${pub.name}</span>
        </label>
    `).join('');

    setHTML(container, html);

    // Attach event listeners
    queryAllElements('.publisher-checkbox').forEach(checkbox => {
        onEvent(checkbox, 'change', function() {
            applyFilters();
        });
    });
}

/**
 * Apply price filter
 */
function applyPriceFilter() {
    const minPrice = parseInt(getElement('price-min')?.value || 0);
    const maxPrice = parseInt(getElement('price-max')?.value || CONFIG.MAX_PRICE);

    if (minPrice > maxPrice) {
        showNotification('Giá tối thiểu không được lớn hơn giá tối đa', 'warning');
        return;
    }

    filter.filterByPrice(minPrice, maxPrice);
    applyFilters();
}

/**
 * Apply all filters
 */
async function applyFilters() {
    // Get selected categories
    const selectedCategories = Array.from(queryAllElements('.category-checkbox:checked'))
        .map(el => parseInt(el.value));

    // Get selected authors
    const selectedAuthors = Array.from(queryAllElements('.author-checkbox:checked'))
        .map(el => parseInt(el.value));

    // Get selected publishers
    const selectedPublishers = Array.from(queryAllElements('.publisher-checkbox:checked'))
        .map(el => parseInt(el.value));

    // Get price range
    const minPrice = parseInt(getElement('price-min')?.value || 0);
    const maxPrice = parseInt(getElement('price-max')?.value || CONFIG.MAX_PRICE);

    // Apply filters
    let results = getProducts();

    // Filter by category
    if (selectedCategories.length > 0) {
        results = results.filter(p => selectedCategories.includes(p.categoryId));
    }

    // Filter by author
    if (selectedAuthors.length > 0) {
        results = results.filter(p => selectedAuthors.includes(p.authorId));
    }

    // Filter by publisher
    if (selectedPublishers.length > 0) {
        results = results.filter(p => selectedPublishers.includes(p.publisherId));
    }

    // Filter by price
    results = results.filter(p => p.price >= minPrice && p.price <= maxPrice);

    filter.filteredResults = results;

    // Render results
    displayFilteredProducts(results);

    Logger.log('Filters applied, results:', results.length);
}

/**
 * Display filtered products
 */
function displayFilteredProducts(products) {
    const productsGrid = getElement('products-grid');
    const contextPath = getContextPath();
    if (!productsGrid) return;

    if (products.length === 0) {
        setHTML(productsGrid, `
            <div class="no-results">
                <p>Không tìm thấy sản phẩm phù hợp với bộ lọc của bạn</p>
            </div>
        `);
        return;
    }

    const html = products.map(product => `
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
                <button class="btn btn-primary btn-sm add-to-cart-btn" data-product-id="${product.id}" style="width: 100%;">
                    🛒 Thêm Vào Giỏ
                </button>
            </div>
        </div>
    `).join('');

    setHTML(productsGrid, html);

    // Attach event handlers
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
 * Clear all filters
 */
function clearAllFilters() {
    // Clear checkbox values
    queryAllElements('.category-checkbox, .author-checkbox, .publisher-checkbox').forEach(el => {
        el.checked = false;
    });

    // Clear price inputs
    const priceMinEl = getElement('price-min');
    const priceMaxEl = getElement('price-max');
    if (priceMinEl) priceMinEl.value = '';
    if (priceMaxEl) priceMaxEl.value = '';

    filter.clearFilters();
    displayFilteredProducts(getProducts());
    showNotification('Đã xóa bộ lọc', 'info');
}

// ==========================================
// EXPORT FOR MODULE USAGE
// ==========================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ProductFilter, filter };
}

