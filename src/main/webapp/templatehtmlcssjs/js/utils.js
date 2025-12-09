/**
 * Utility Functions
 * Common helper functions for the application
 */

// ==========================================
// STRING & TEXT UTILITIES
// ==========================================

/**
 * Format price with Vietnamese currency
 * @param {number} price - Price value
 * @returns {string} Formatted price (e.g., "120,000đ")
 */
function formatPrice(price) {
    if (typeof price !== 'number' || isNaN(price)) return '0đ';
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(price);
}

/**
 * Parse price string to number
 * @param {string} priceStr - Price string (e.g., "120,000đ")
 * @returns {number} Parsed price
 */
function parsePrice(priceStr) {
    if (typeof priceStr !== 'string') return 0;
    return parseInt(priceStr.replace(/[^\d]/g, '')) || 0;
}

/**
 * Truncate text to specified length
 * @param {string} text - Text to truncate
 * @param {number} length - Max length
 * @returns {string} Truncated text
 */
function truncateText(text, length = 50) {
    if (!text || text.length <= length) return text;
    return text.substring(0, length).trim() + '...';
}

/**
 * Capitalize first letter of string
 * @param {string} str - String to capitalize
 * @returns {string} Capitalized string
 */
function capitalizeFirst(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1);
}

/**
 * Generate slug from title
 * @param {string} title - Title
 * @returns {string} Slug
 */
function generateSlug(title) {
    if (!title) return '';
    return title
        .toLowerCase()
        .trim()
        .replace(/\s+/g, '-')
        .replace(/[^\w\-]/g, '')
        .replace(/\-+/g, '-');
}

// ==========================================
// VALIDATION UTILITIES
// ==========================================

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} True if valid
 */
function validateEmail(email) {
    return CONFIG.EMAIL_REGEX.test(email);
}

/**
 * Validate phone number
 * @param {string} phone - Phone to validate
 * @returns {boolean} True if valid
 */
function validatePhone(phone) {
    return CONFIG.PHONE_REGEX.test(phone.replace(/\s/g, ''));
}

/**
 * Validate credit card number
 * @param {string} cardNumber - Card number
 * @returns {boolean} True if valid
 */
function validateCardNumber(cardNumber) {
    const cleaned = cardNumber.replace(/\s/g, '');
    return CONFIG.CARD_REGEX.test(cleaned);
}

/**
 * Validate CVV
 * @param {string} cvv - CVV code
 * @returns {boolean} True if valid
 */
function validateCVV(cvv) {
    return CONFIG.CVV_REGEX.test(cvv);
}

/**
 * Validate form data
 * @param {Object} data - Form data object
 * @param {Array} rules - Validation rules
 * @returns {Object} Validation result {valid: boolean, errors: {...}}
 */
function validateForm(data, rules = {}) {
    const errors = {};

    Object.keys(rules).forEach(field => {
        const rule = rules[field];
        const value = data[field];

        // Required validation
        if (rule.required && !value) {
            errors[field] = `${rule.label || field} là bắt buộc`;
            return;
        }

        // Email validation
        if (rule.type === 'email' && value && !validateEmail(value)) {
            errors[field] = `${rule.label || field} không hợp lệ`;
            return;
        }

        // Phone validation
        if (rule.type === 'phone' && value && !validatePhone(value)) {
            errors[field] = `${rule.label || field} không hợp lệ`;
            return;
        }

        // Min length
        if (rule.minLength && value && value.length < rule.minLength) {
            errors[field] = `${rule.label || field} phải có ít nhất ${rule.minLength} ký tự`;
            return;
        }

        // Max length
        if (rule.maxLength && value && value.length > rule.maxLength) {
            errors[field] = `${rule.label || field} không được vượt quá ${rule.maxLength} ký tự`;
            return;
        }
    });

    return {
        valid: Object.keys(errors).length === 0,
        errors
    };
}

// ==========================================
// DOM UTILITIES
// ==========================================

/**
 * Safely get element by ID
 * @param {string} id - Element ID
 * @returns {HTMLElement|null} Element or null
 */
function getElement(id) {
    return document.getElementById(id) || null;
}

/**
 * Safely query element
 * @param {string} selector - CSS selector
 * @param {HTMLElement} context - Context element
 * @returns {HTMLElement|null} Element or null
 */
function queryElement(selector, context = document) {
    return context.querySelector(selector) || null;
}

/**
 * Query all elements
 * @param {string} selector - CSS selector
 * @param {HTMLElement} context - Context element
 * @returns {NodeList} Elements
 */
function queryAllElements(selector, context = document) {
    return context.querySelectorAll(selector);
}

/**
 * Add class to element
 * @param {HTMLElement} el - Element
 * @param {string} className - Class name
 */
function addClass(el, className) {
    if (el) el.classList.add(className);
}

/**
 * Remove class from element
 * @param {HTMLElement} el - Element
 * @param {string} className - Class name
 */
function removeClass(el, className) {
    if (el) el.classList.remove(className);
}

/**
 * Toggle class on element
 * @param {HTMLElement} el - Element
 * @param {string} className - Class name
 */
function toggleClass(el, className) {
    if (el) el.classList.toggle(className);
}

/**
 * Check if element has class
 * @param {HTMLElement} el - Element
 * @param {string} className - Class name
 * @returns {boolean} True if has class
 */
function hasClass(el, className) {
    return el ? el.classList.contains(className) : false;
}

/**
 * Show element
 * @param {HTMLElement} el - Element
 */
function showElement(el) {
    if (el) el.style.display = '';
}

/**
 * Hide element
 * @param {HTMLElement} el - Element
 */
function hideElement(el) {
    if (el) el.style.display = 'none';
}

/**
 * Toggle element visibility
 * @param {HTMLElement} el - Element
 */
function toggleElement(el) {
    if (el) {
        el.style.display = el.style.display === 'none' ? '' : 'none';
    }
}

/**
 * Clear element content
 * @param {HTMLElement} el - Element
 */
function clearElement(el) {
    if (el) el.innerHTML = '';
}

/**
 * Set element HTML
 * @param {HTMLElement} el - Element
 * @param {string} html - HTML content
 */
function setHTML(el, html) {
    if (el) el.innerHTML = html;
}

/**
 * Set element text
 * @param {HTMLElement} el - Element
 * @param {string} text - Text content
 */
function setText(el, text) {
    if (el) el.textContent = text;
}

// ==========================================
// EVENT UTILITIES
// ==========================================

/**
 * Debounce function execution
 * @param {Function} func - Function to debounce
 * @param {number} delay - Delay in ms
 * @returns {Function} Debounced function
 */
function debounce(func, delay = CONFIG.DEBOUNCE_DELAY) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func(...args), delay);
    };
}

/**
 * Throttle function execution
 * @param {Function} func - Function to throttle
 * @param {number} delay - Delay in ms
 * @returns {Function} Throttled function
 */
function throttle(func, delay = CONFIG.THROTTLE_DELAY) {
    let lastRun = 0;
    return function(...args) {
        const now = Date.now();
        if (now - lastRun >= delay) {
            func(...args);
            lastRun = now;
        }
    };
}

/**
 * Add event listener with automatic cleanup
 * @param {HTMLElement} el - Element
 * @param {string} event - Event name
 * @param {Function} handler - Event handler
 * @returns {Function} Unsubscribe function
 */
function onEvent(el, event, handler) {
    if (el) {
        el.addEventListener(event, handler);
        return () => el.removeEventListener(event, handler);
    }
    return () => {};
}

/**
 * Trigger custom event
 * @param {string} eventName - Event name
 * @param {Object} detail - Event detail
 */
function triggerEvent(eventName, detail = {}) {
    const event = new CustomEvent(eventName, { detail });
    document.dispatchEvent(event);
}

// ==========================================
// STORAGE UTILITIES
// ==========================================

/**
 * Save to localStorage
 * @param {string} key - Storage key
 * @param {*} value - Value to save
 */
function saveStorage(key, value) {
    try {
        localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
        Logger.error('Error saving to storage', e);
    }
}

/**
 * Get from localStorage
 * @param {string} key - Storage key
 * @param {*} defaultValue - Default value if not found
 * @returns {*} Stored value or default
 */
function getStorage(key, defaultValue = null) {
    try {
        const item = localStorage.getItem(key);
        return item ? JSON.parse(item) : defaultValue;
    } catch (e) {
        Logger.error('Error reading from storage', e);
        return defaultValue;
    }
}

/**
 * Remove from localStorage
 * @param {string} key - Storage key
 */
function removeStorage(key) {
    try {
        localStorage.removeItem(key);
    } catch (e) {
        Logger.error('Error removing from storage', e);
    }
}

/**
 * Clear all localStorage
 */
function clearStorage() {
    try {
        localStorage.clear();
    } catch (e) {
        Logger.error('Error clearing storage', e);
    }
}

// ==========================================
// ARRAY & OBJECT UTILITIES
// ==========================================

/**
 * Unique values from array
 * @param {Array} arr - Array
 * @param {string} key - Property key (optional)
 * @returns {Array} Unique array
 */
function unique(arr, key = null) {
    if (key) {
        return [...new Map(arr.map(item => [item[key], item])).values()];
    }
    return [...new Set(arr)];
}

/**
 * Group array by key
 * @param {Array} arr - Array
 * @param {string} key - Grouping key
 * @returns {Object} Grouped object
 */
function groupBy(arr, key) {
    return arr.reduce((acc, item) => {
        const group = item[key];
        if (!acc[group]) acc[group] = [];
        acc[group].push(item);
        return acc;
    }, {});
}

/**
 * Sort array by property
 * @param {Array} arr - Array
 * @param {string} key - Property key
 * @param {string} order - 'asc' or 'desc'
 * @returns {Array} Sorted array
 */
function sortBy(arr, key, order = 'asc') {
    return arr.sort((a, b) => {
        const aVal = a[key];
        const bVal = b[key];
        const comparison = aVal > bVal ? 1 : aVal < bVal ? -1 : 0;
        return order === 'desc' ? -comparison : comparison;
    });
}

// ==========================================
// NOTIFICATION UTILITIES
// ==========================================

/**
 * Show notification message
 * @param {string} message - Message text
 * @param {string} type - 'success', 'error', 'warning', 'info'
 * @param {number} timeout - Timeout in ms
 */
function showNotification(message, type = 'info', timeout = CONFIG.NOTIFICATION_TIMEOUT) {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type}`;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, timeout);
}

/**
 * Show loading state
 * @param {HTMLElement} el - Element
 * @param {boolean} isLoading - Loading state
 * @param {string} loadingText - Loading text
 */
function setLoading(el, isLoading = true, loadingText = 'Đang tải...') {
    if (!el) return;

    if (isLoading) {
        el.disabled = true;
        el.dataset.originalText = el.textContent;
        el.textContent = loadingText;
        el.classList.add('is-loading');
    } else {
        el.disabled = false;
        el.textContent = el.dataset.originalText || 'Lưu';
        el.classList.remove('is-loading');
    }
}

// ==========================================
// DATE UTILITIES
// ==========================================

/**
 * Format date
 * @param {Date|number} date - Date object or timestamp
 * @param {string} format - Date format (vi-VN)
 * @returns {string} Formatted date
 */
function formatDate(date, format = 'dd/MM/yyyy') {
    const d = new Date(date);
    return new Intl.DateTimeFormat('vi-VN').format(d);
}

/**
 * Get time ago string
 * @param {Date|number} date - Date
 * @returns {string} Time ago string (e.g., "2 hours ago")
 */
function timeAgo(date) {
    const seconds = Math.floor((new Date() - new Date(date)) / 1000);
    let interval = seconds / 31536000;
    if (interval > 1) return Math.floor(interval) + ' năm trước';
    interval = seconds / 2592000;
    if (interval > 1) return Math.floor(interval) + ' tháng trước';
    interval = seconds / 86400;
    if (interval > 1) return Math.floor(interval) + ' ngày trước';
    interval = seconds / 3600;
    if (interval > 1) return Math.floor(interval) + ' giờ trước';
    interval = seconds / 60;
    if (interval > 1) return Math.floor(interval) + ' phút trước';
    return Math.floor(seconds) + ' giây trước';
}

// ==========================================
// MATH UTILITIES
// ==========================================

/**
 * Calculate discount percentage
 * @param {number} original - Original price
 * @param {number} sale - Sale price
 * @returns {number} Discount percentage
 */
function calculateDiscount(original, sale) {
    if (original <= 0) return 0;
    return Math.round(((original - sale) / original) * 100);
}

/**
 * Calculate final price with discount
 * @param {number} price - Original price
 * @param {number} discount - Discount percentage
 * @returns {number} Final price
 */
function calculateFinalPrice(price, discount) {
    return Math.round(price * (1 - discount / 100));
}

/**
 * Clamp number between min and max
 * @param {number} value - Value
 * @param {number} min - Minimum
 * @param {number} max - Maximum
 * @returns {number} Clamped value
 */
function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value));
}

