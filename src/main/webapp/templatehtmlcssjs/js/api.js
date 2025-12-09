/**
 * API Layer
 * Handles all API calls and data fetching
 * Currently mocks data - replace with real API calls to Servlet endpoints
 * 
 * Future Java Integration:
 * - Replace mock functions with fetch() to Servlet endpoints
 * - Example: fetch('/api/products/list') -> ProductServlet
 * - Handle JSON response and error responses
 */

class API {
    constructor(baseUrl = CONFIG.API_BASE_URL) {
        this.baseUrl = baseUrl;
        this.timeout = CONFIG.API_TIMEOUT;
    }

    /**
     * Make HTTP request
     * @param {string} endpoint - API endpoint
     * @param {Object} options - Request options
     * @returns {Promise<Object>} Response data
     */
    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const config = {
            method: options.method || 'GET',
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        };

        if (options.body) {
            config.body = JSON.stringify(options.body);
        }

        try {
            const response = await Promise.race([
                fetch(url, config),
                new Promise((_, reject) =>
                    setTimeout(() => reject(new Error('Request timeout')), this.timeout)
                )
            ]);

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            return await response.json();
        } catch (error) {
            Logger.error('API request failed', error);
            throw error;
        }
    }

    // ==========================================
    // PRODUCTS ENDPOINTS
    // ==========================================

    /**
     * Get all products
     * JSP Integration: <% request.getParameter("page") %>
     */
    async getProducts(params = {}) {
        // Mock - Replace with: return this.request('/products/list', { params });
        Logger.log('API: getProducts', params);
        return getProducts();
    }

    /**
     * Get product by ID
     * JSP Integration: ProductDetailServlet
     */
    async getProductById(id) {
        // Mock - Replace with: return this.request(`/products/${id}`);
        Logger.log('API: getProductById', id);
        return getProductById(id);
    }

    /**
     * Search products
     * JSP Integration: SearchServlet
     */
    async searchProducts(query, params = {}) {
        // Mock - Replace with: return this.request('/products/search', { params: { q: query, ...params } });
        Logger.log('API: searchProducts', query, params);
        const results = getProducts().filter(p =>
            p.title.toLowerCase().includes(query.toLowerCase()) ||
            p.authorName.toLowerCase().includes(query.toLowerCase())
        );
        return results;
    }

    /**
     * Get products by category
     * JSP Integration: CategoryServlet
     */
    async getProductsByCategory(categoryId, params = {}) {
        // Mock - Replace with: return this.request(`/products/category/${categoryId}`, { params });
        Logger.log('API: getProductsByCategory', categoryId, params);
        return getProductsByCategory(categoryId);
    }

    /**
     * Filter products
     * JSP Integration: FilterServlet
     */
    async filterProducts(filters = {}) {
        // Mock - Replace with: return this.request('/products/filter', { body: filters });
        Logger.log('API: filterProducts', filters);
        let results = getProducts();

        if (filters.categoryId) {
            results = results.filter(p => p.categoryId === filters.categoryId);
        }

        if (filters.authorId) {
            results = results.filter(p => p.authorId === filters.authorId);
        }

        if (filters.publisherId) {
            results = results.filter(p => p.publisherId === filters.publisherId);
        }

        if (filters.minPrice !== undefined) {
            results = results.filter(p => p.price >= filters.minPrice);
        }

        if (filters.maxPrice !== undefined) {
            results = results.filter(p => p.price <= filters.maxPrice);
        }

        if (filters.sort) {
            results = this.sortProducts(results, filters.sort);
        }

        return results;
    }

    // ==========================================
    // CATEGORY ENDPOINTS
    // ==========================================

    /**
     * Get all categories
     * JSP Integration: CategoryServlet
     */
    async getCategories() {
        // Mock - Replace with: return this.request('/categories/list');
        Logger.log('API: getCategories');
        return CATEGORIES_DATA;
    }

    // ==========================================
    // CART ENDPOINTS
    // ==========================================

    /**
     * Add to cart
     * JSP Integration: CartServlet - POST /cart/add
     */
    async addToCart(product, quantity = 1) {
        // Mock - Replace with:
        // return this.request('/cart/add', {
        //   method: 'POST',
        //   body: { productId: product.id, quantity }
        // });
        Logger.log('API: addToCart', product.id, quantity);
        return { success: true, message: 'Đã thêm vào giỏ hàng' };
    }

    /**
     * Remove from cart
     * JSP Integration: CartServlet - POST /cart/remove
     */
    async removeFromCart(productId) {
        // Mock - Replace with:
        // return this.request(`/cart/remove/${productId}`, { method: 'POST' });
        Logger.log('API: removeFromCart', productId);
        return { success: true, message: 'Đã xóa khỏi giỏ hàng' };
    }

    /**
     * Update cart quantity
     * JSP Integration: CartServlet - POST /cart/update
     */
    async updateCartQuantity(productId, quantity) {
        // Mock - Replace with:
        // return this.request(`/cart/update/${productId}`, {
        //   method: 'POST',
        //   body: { quantity }
        // });
        Logger.log('API: updateCartQuantity', productId, quantity);
        return { success: true, message: 'Đã cập nhật' };
    }

    /**
     * Clear cart
     * JSP Integration: CartServlet - POST /cart/clear
     */
    async clearCart() {
        // Mock - Replace with: return this.request('/cart/clear', { method: 'POST' });
        Logger.log('API: clearCart');
        return { success: true, message: 'Giỏ hàng đã được xóa' };
    }

    // ==========================================
    // ORDER ENDPOINTS
    // ==========================================

    /**
     * Place order
     * JSP Integration: OrderServlet - POST /orders/create
     */
    async placeOrder(orderData) {
        // Mock - Replace with:
        // return this.request('/orders/create', {
        //   method: 'POST',
        //   body: orderData
        // });
        Logger.log('API: placeOrder', orderData);
        return {
            success: true,
            orderId: Math.floor(Math.random() * 1000000),
            message: 'Đơn hàng đã được tạo thành công'
        };
    }

    /**
     * Get order details
     * JSP Integration: OrderServlet - GET /orders/{id}
     */
    async getOrder(orderId) {
        // Mock - Replace with: return this.request(`/orders/${orderId}`);
        Logger.log('API: getOrder', orderId);
        return { orderId, status: 'pending' };
    }

    /**
     * Get user orders
     * JSP Integration: OrderServlet - GET /orders/user
     */
    async getUserOrders(userId) {
        // Mock - Replace with: return this.request(`/orders/user/${userId}`);
        Logger.log('API: getUserOrders', userId);
        return [];
    }

    // ==========================================
    // USER ENDPOINTS
    // ==========================================

    /**
     * Register user
     * JSP Integration: UserServlet - POST /auth/register
     */
    async registerUser(userData) {
        // Mock - Replace with:
        // return this.request('/auth/register', {
        //   method: 'POST',
        //   body: userData
        // });
        Logger.log('API: registerUser', userData);
        return { success: true, userId: 1, message: 'Đăng ký thành công' };
    }

    /**
     * Login user
     * JSP Integration: UserServlet - POST /auth/login
     */
    async loginUser(credentials) {
        // Mock - Replace with:
        // return this.request('/auth/login', {
        //   method: 'POST',
        //   body: credentials
        // });
        Logger.log('API: loginUser', credentials);
        return { success: true, userId: 1, token: 'mock_token' };
    }

    /**
     * Get user profile
     * JSP Integration: UserServlet - GET /auth/profile
     */
    async getUserProfile() {
        // Mock - Replace with: return this.request('/auth/profile');
        Logger.log('API: getUserProfile');
        return { userId: 1, email: 'user@example.com', name: 'John Doe' };
    }

    /**
     * Update user profile
     * JSP Integration: UserServlet - PUT /auth/profile
     */
    async updateUserProfile(userData) {
        // Mock - Replace with:
        // return this.request('/auth/profile', {
        //   method: 'PUT',
        //   body: userData
        // });
        Logger.log('API: updateUserProfile', userData);
        return { success: true, message: 'Cập nhật hồ sơ thành công' };
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================

    /**
     * Sort products
     */
    sortProducts(products, sortBy) {
        const sorted = [...products];
        switch (sortBy) {
            case 'price-low':
                return sorted.sort((a, b) => a.price - b.price);
            case 'price-high':
                return sorted.sort((a, b) => b.price - a.price);
            case 'name':
                return sorted.sort((a, b) => a.title.localeCompare(b.title));
            case 'rating':
                return sorted.sort((a, b) => b.rating - a.rating);
            case 'newest':
            default:
                return sorted.sort((a, b) => b.id - a.id);
        }
    }
}

// Create global API instance
const api = new API();

