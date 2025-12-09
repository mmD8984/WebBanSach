/**
 * Carousel/Slider Management
 * Handles horizontal scrolling carousels for products and categories
 */

class Carousel {
    constructor(container) {
        this.container = container;
        this.wrapper = container.querySelector('.carousel-wrapper');
        this.prevBtn = container.querySelector('.carousel-prev');
        this.nextBtn = container.querySelector('.carousel-next');
        this.items = this.wrapper.querySelectorAll('.carousel-item');
        
        if (!this.wrapper) return;
        
        this.itemWidth = this.items[0]?.offsetWidth || 0;
        this.gap = 32; // var(--spacing-lg)
        this.scrollAmount = this.itemWidth + this.gap;
        
        this.init();
    }
    
    init() {
        if (this.prevBtn) {
            this.prevBtn.addEventListener('click', () => this.scroll(-1));
        }
        if (this.nextBtn) {
            this.nextBtn.addEventListener('click', () => this.scroll(1));
        }
        
        this.wrapper.addEventListener('scroll', () => this.updateButtons());
        this.updateButtons();
    }
    
    scroll(direction) {
        const scrollAmount = direction > 0 
            ? this.scrollAmount 
            : -this.scrollAmount;
        
        this.wrapper.scrollBy({
            left: scrollAmount,
            behavior: 'smooth'
        });
    }
    
    updateButtons() {
        if (!this.prevBtn || !this.nextBtn) return;
        
        const scrollLeft = this.wrapper.scrollLeft;
        const scrollWidth = this.wrapper.scrollWidth;
        const clientWidth = this.wrapper.clientWidth;
        
        // Disable prev if at start
        this.prevBtn.disabled = scrollLeft <= 0;
        
        // Disable next if at end
        this.nextBtn.disabled = scrollLeft + clientWidth >= scrollWidth - 10;
    }
}

// Initialize all carousels on page load
document.addEventListener('DOMContentLoaded', function() {
    const carousels = document.querySelectorAll('.carousel');
    carousels.forEach(carousel => new Carousel(carousel));
});

/**
 * Auto-scroll carousel (optional)
 */
class AutoCarousel extends Carousel {
    constructor(container, autoPlayDelay = 5000) {
        super(container);
        this.autoPlayDelay = autoPlayDelay;
        this.autoPlayInterval = null;
        
        this.startAutoPlay();
        this.wrapper.addEventListener('mouseenter', () => this.stopAutoPlay());
        this.wrapper.addEventListener('mouseleave', () => this.startAutoPlay());
    }
    
    startAutoPlay() {
        this.autoPlayInterval = setInterval(() => {
            if (this.nextBtn && !this.nextBtn.disabled) {
                this.scroll(1);
            } else {
                this.wrapper.scrollLeft = 0;
            }
        }, this.autoPlayDelay);
    }
    
    stopAutoPlay() {
        clearInterval(this.autoPlayInterval);
    }
}

/**
 * Tab carousel - switch between different carousels
 */
class TabCarousel {
    constructor(tabsContainer, carouselsContainer) {
        this.tabs = tabsContainer.querySelectorAll('.carousel-tab');
        this.carousels = carouselsContainer.querySelectorAll('.carousel');
        
        this.init();
    }
    
    init() {
        this.tabs.forEach((tab, index) => {
            tab.addEventListener('click', () => this.switchCarousel(index));
        });
        
        // Show first carousel by default
        this.switchCarousel(0);
    }
    
    switchCarousel(index) {
        // Update active tab
        this.tabs.forEach(tab => tab.classList.remove('active'));
        this.tabs[index].classList.add('active');
        
        // Show/hide carousels
        this.carousels.forEach((carousel, i) => {
            carousel.style.display = i === index ? 'block' : 'none';
        });
    }
}

/**
 * Carousel Indicators - Dot navigation
 */
class CarouselIndicators {
    constructor(wrapper, container) {
        this.wrapper = wrapper;
        this.container = container;
        this.items = wrapper.querySelectorAll('.carousel-item');
        this.indicators = container.querySelectorAll('.carousel-dot');
        
        if (!this.indicators.length) return;
        
        this.init();
    }
    
    init() {
        this.indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => this.scrollToItem(index));
        });
        
        this.wrapper.addEventListener('scroll', () => this.updateIndicators());
    }
    
    scrollToItem(index) {
        const item = this.items[index];
        if (!item) return;
        
        item.scrollIntoView({
            behavior: 'smooth',
            block: 'nearest',
            inline: 'center'
        });
    }
    
    updateIndicators() {
        const scrollLeft = this.wrapper.scrollLeft;
        const itemWidth = this.items[0]?.offsetWidth || 0;
        const currentIndex = Math.round(scrollLeft / itemWidth);
        
        this.indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentIndex);
        });
    }
}

// Global carousel instances
window.carousels = {};

/**
 * Create carousel by ID
 */
function createCarousel(id, autoPlay = false, delay = 5000) {
    const container = document.getElementById(id);
    if (!container) return;
    
    if (autoPlay) {
        window.carousels[id] = new AutoCarousel(container, delay);
    } else {
        window.carousels[id] = new Carousel(container);
    }
}

/**
 * Scroll carousel programmatically
 */
function scrollCarousel(id, direction) {
    if (window.carousels[id]) {
        window.carousels[id].scroll(direction);
    }
}

