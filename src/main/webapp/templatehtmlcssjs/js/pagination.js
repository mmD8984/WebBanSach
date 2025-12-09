/**
 * Pagination
 * Handles pagination of products on listing pages
 */

class Pagination {
    constructor(totalItems = 0, itemsPerPage = CONFIG.ITEMS_PER_PAGE) {
        this.totalItems = totalItems;
        this.itemsPerPage = itemsPerPage;
        this.currentPage = 1;
        this.totalPages = Math.ceil(totalItems / itemsPerPage) || 1;
    }

    /**
     * Set total items
     */
    setTotalItems(total) {
        this.totalItems = total;
        this.totalPages = Math.ceil(total / this.itemsPerPage) || 1;
        this.currentPage = 1; // Reset to first page
    }

    /**
     * Get current page
     */
    getCurrentPage() {
        return this.currentPage;
    }

    /**
     * Set current page
     */
    setCurrentPage(page) {
        this.currentPage = Math.max(1, Math.min(page, this.totalPages));
    }

    /**
     * Go to next page
     */
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            return true;
        }
        return false;
    }

    /**
     * Go to previous page
     */
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            return true;
        }
        return false;
    }

    /**
     * Get offset for database queries
     */
    getOffset() {
        return (this.currentPage - 1) * this.itemsPerPage;
    }

    /**
     * Get paginated items
     */
    getPaginatedItems(items) {
        const offset = this.getOffset();
        return items.slice(offset, offset + this.itemsPerPage);
    }

    /**
     * Get pagination range
     */
    getPageRange() {
        const pages = [];
        const range = CONFIG.PAGINATION_SIZE;
        const half = Math.floor(range / 2);

        let start = Math.max(1, this.currentPage - half);
        let end = Math.min(this.totalPages, start + range - 1);

        // Adjust start if near end
        if (end - start < range - 1) {
            start = Math.max(1, end - range + 1);
        }

        for (let i = start; i <= end; i++) {
            pages.push(i);
        }

        return {
            pages,
            showFirst: start > 1,
            showLast: end < this.totalPages,
            start,
            end
        };
    }

    /**
     * Get pagination info
     */
    getInfo() {
        return {
            currentPage: this.currentPage,
            totalPages: this.totalPages,
            totalItems: this.totalItems,
            itemsPerPage: this.itemsPerPage,
            offset: this.getOffset(),
            hasNextPage: this.currentPage < this.totalPages,
            hasPreviousPage: this.currentPage > 1
        };
    }

    /**
     * Render pagination HTML
     */
    render() {
        const info = this.getInfo();
        const range = this.getPageRange();

        if (this.totalPages <= 1) {
            return ''; // Don't show pagination if only one page
        }

        let html = '<div class="pagination">';

        // Previous button
        if (info.hasPreviousPage) {
            html += `<button class="pagination-item" data-page="${this.currentPage - 1}">← Trước</button>`;
        } else {
            html += '<button class="pagination-item disabled" disabled>← Trước</button>';
        }

        // First page button
        if (range.showFirst) {
            html += `<button class="pagination-item" data-page="1">1</button>`;
            if (range.start > 2) {
                html += '<button class="pagination-item disabled" disabled>...</button>';
            }
        }

        // Page numbers
        range.pages.forEach(page => {
            if (page === this.currentPage) {
                html += `<button class="pagination-item active" data-page="${page}">${page}</button>`;
            } else {
                html += `<button class="pagination-item" data-page="${page}">${page}</button>`;
            }
        });

        // Last page button
        if (range.showLast) {
            if (range.end < this.totalPages - 1) {
                html += '<button class="pagination-item disabled" disabled>...</button>';
            }
            html += `<button class="pagination-item" data-page="${this.totalPages}">${this.totalPages}</button>`;
        }

        // Next button
        if (info.hasNextPage) {
            html += `<button class="pagination-item" data-page="${this.currentPage + 1}">Tiếp →</button>`;
        } else {
            html += '<button class="pagination-item disabled" disabled>Tiếp →</button>';
        }

        html += '</div>';

        return html;
    }
}

// Create global pagination instance
const pagination = new Pagination();

// ==========================================
// PAGINATION PAGE EVENT HANDLERS
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    // Attach pagination event handlers
    attachPaginationHandlers();
});

function attachPaginationHandlers() {
    const paginationContainer = getElement('pagination');
    if (!paginationContainer) return;

    onEvent(paginationContainer, 'click', function(e) {
        const button = e.target.closest('.pagination-item');
        if (!button || button.disabled) return;

        const page = parseInt(button.dataset.page);
        if (page && page !== pagination.currentPage) {
            pagination.setCurrentPage(page);
            displayPaginatedProducts();
            
            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    });
}

/**
 * Display paginated products
 */
function displayPaginatedProducts() {
    let products;

    // Get current filtered/searched results or all products
    if (search.currentQuery) {
        products = search.getResults();
    } else if (filter.filteredResults.length > 0) {
        products = filter.filteredResults;
    } else {
        products = getProducts();
    }

    // Update pagination
    pagination.setTotalItems(products.length);

    // Get paginated items
    const paginatedItems = pagination.getPaginatedItems(products);

    // Render products
    const productsGrid = getElement('products-grid');
    if (productsGrid) {
        const html = paginatedItems.map(product => `
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

        // Attach product card handlers
        attachProductCardHandlers();
    }

    // Render pagination
    const paginationContainer = getElement('pagination');
    if (paginationContainer) {
        setHTML(paginationContainer, pagination.render());
        attachPaginationHandlers();
    }
}

/**
 * Attach product card event handlers
 */
function attachProductCardHandlers() {
    queryAllElements('.product-card').forEach(card => {
        onEvent(card, 'click', function(e) {
            if (e.target.closest('.btn')) return;
            const productId = card.dataset.productId;
            window.location.href = `product-detail.html?id=${productId}`;
        });
    });

    queryAllElements('.add-to-cart-btn').forEach(btn => {
        onEvent(btn, 'click', function(e) {
            e.stopPropagation();
            const productId = parseInt(btn.dataset.productId);
            const product = getProductById(productId);
            if (product) {
                cart.addProduct(product, 1);
            }
        });
    });
}

/**
 * Initialize products page with pagination
 */
function initializeProductsPage() {
    const products = getProducts();
    pagination.setTotalItems(products.length);
    displayPaginatedProducts();
}

// ==========================================
// EXPORT FOR MODULE USAGE
// ==========================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { Pagination, pagination };
}

