/**
 * Configuration & Constants
 * Global configuration for the bookstore application
 */

const CONFIG = {
    // API Configuration
    // Default: use webbansach_war context path
    API_BASE_URL: 'http://localhost:8080/webbansach_war/api',
    API_TIMEOUT: 30000,

    // Storage Keys
    STORAGE_CART: 'bookstore_cart',
    STORAGE_WISHLIST: 'bookstore_wishlist',
    STORAGE_USER: 'bookstore_user',
    STORAGE_RECENT: 'bookstore_recent',

    // Pagination
    ITEMS_PER_PAGE: 12,
    PAGINATION_SIZE: 5,

    // Product
    DEFAULT_IMAGE: 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="300" height="400"%3E%3Crect fill="%23f1f5f9" width="300" height="400"/%3E%3Ctext x="50%25" y="50%25" font-size="24" fill="%2394a3b8" text-anchor="middle" dominant-baseline="middle"%3ENo Image%3C/text%3E%3C/svg%3E',
    MIN_PRICE: 0,
    MAX_PRICE: 1000000,

    // Shipping
    FREE_SHIPPING_THRESHOLD: 100000,
    SHIPPING_COST_STANDARD: 0,
    SHIPPING_COST_EXPRESS: 50000,
    SHIPPING_COST_OVERNIGHT: 100000,

    // Discount
    DISCOUNT_MULTIPLIER: 0.1,

    // Currency
    CURRENCY: 'đ',
    CURRENCY_CODE: 'VND',

    // Categories
    CATEGORIES: [
        { id: 1, name: 'Văn Học', icon: '📖' },
        { id: 2, name: 'Sách Kinh Tế', icon: '💼' },
        { id: 3, name: 'Kỹ Năng Sống', icon: '💪' },
        { id: 4, name: 'Công Nghệ', icon: '💻' },
        { id: 5, name: 'Trẻ Em', icon: '👶' },
        { id: 6, name: 'Ngoại Ngữ', icon: '🌍' },
    ],

    // Filter Limits
    AUTHOR_LIMIT: 10,
    PUBLISHER_LIMIT: 10,

    // Validation
    EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    PHONE_REGEX: /^(\+84|0)[0-9]{9,10}$/,
    CARD_REGEX: /^[0-9]{13,19}$/,
    CVV_REGEX: /^[0-9]{3,4}$/,

    // Timeouts (in milliseconds)
    NOTIFICATION_TIMEOUT: 3000,
    DEBOUNCE_DELAY: 300,
    THROTTLE_DELAY: 100,

    // Debug
    DEBUG: false,

    // Translate function for JSP integration
    // Will be replaced with JSTL/i18n in production
    t: function(key) {
        const translations = {
            'success.add_cart': 'Đã thêm vào giỏ hàng',
            'success.remove_cart': 'Đã xóa khỏi giỏ hàng',
            'success.order_placed': 'Đặt hàng thành công',
            'error.invalid_email': 'Email không hợp lệ',
            'error.invalid_phone': 'Số điện thoại không hợp lệ',
            'error.network': 'Lỗi kết nối mạng',
            'error.server': 'Lỗi server',
        };
        return translations[key] || key;
    }
};

// Logger utility
const Logger = {
    log: function(message, data = null) {
        if (CONFIG.DEBUG) {
            console.log(`[LOG] ${message}`, data);
        }
    },
    info: function(message, data = null) {
        console.info(`[INFO] ${message}`, data);
    },
    warn: function(message, data = null) {
        console.warn(`[WARN] ${message}`, data);
    },
    error: function(message, data = null) {
        console.error(`[ERROR] ${message}`, data);
    }
};

// Export for use in modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { CONFIG, Logger };
}

