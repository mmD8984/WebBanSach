# 🚀 Quick Start Guide

## 1️⃣ Mở Website

```bash
# Cách dễ nhất - Mở file trực tiếp
1. Tìm file "index.html" trong folder
2. Double-click để mở
3. Xong! Website sẽ load

# Hoặc dùng server (tốt hơn)
python -m http.server 8000
# Vào http://localhost:8000
```

## 2️⃣ Khám Phá Trang Web

### 🏠 Trang Chủ (index.html)
- Xem **3 carousel ngang** (danh mục, sách bán chạy, yêu thích)
- Click ❮ hoặc ❯ để scroll
- Swipe trên mobile
- Kích vào sách để xem chi tiết

### 📖 Danh Sách Sách (products.html)
- **Sidebar Filters**: Lọc theo danh mục, giá, tác giả
- **Search**: Tìm kiếm real-time
- **Sort**: Sắp xếp theo giá/tên/rating
- **Grid**: 12 sách trên 1 trang (paginated)

### 🛒 Thêm Vào Giỏ
1. Kích "🛒 Thêm Vào Giỏ" trên sách
2. Badge cart sẽ cập nhật
3. Vào cart.html để xem giỏ

### 💳 Thanh Toán
1. Từ cart.html → Kích "Tiếp Tục"
2. Điền thông tin (4 bước)
3. Review order → Confirm

### 📚 Khác
- **about.html** - Giới thiệu công ty + stats
- **contact.html** - Liên hệ + FAQ (click để mở/đóng)

## 3️⃣ Responsive Design

Thử trên các kích thước:
- 💻 **Desktop** (1920px) - 4-5 items/row
- 📱 **Tablet** (768px) - 2-3 items/row
- 📱 **Mobile** (375px) - 1-2 items/row

**Test:** Bấm F12 → Ctrl+Shift+M (Chrome) → Kéo kích thước

## 4️⃣ Các Tính Năng

✅ **40 Sản Phẩm** - Real images, đầy đủ metadata
✅ **Carousel** - Smooth scroll ngang
✅ **Search** - Tìm kiếm real-time
✅ **Filter** - 3 loại filter
✅ **Cart** - localStorage persistence
✅ **Checkout** - 4-step form
✅ **About** - Company info + stats
✅ **Contact** - Form + FAQ accordion
✅ **Mobile** - Fully responsive
✅ **Fast** - 60 FPS animations

## 5️⃣ Tùy Chỉnh

### Đổi Màu
```css
/* css/main.css - line 1-50 :root section */
--primary-color: #your-color;
```

### Thêm Sách
```javascript
// js/data.js - line ~1107 PRODUCTS_DATA
{
    id: 41,
    title: 'New Book',
    price: 150000,
    // ... copy fields from another product
}
```

### Đổi Layout
```css
/* css/carousel.css */
/* Adjust flex basis để thay đổi số item visible */
```

## 6️⃣ Các File Quan Trọng

```
index.html          → Trang chủ (carousel)
products.html       → Danh sách (filter + search)
product-detail.html → Chi tiết sách
cart.html           → Giỏ hàng
checkout.html       → Thanh toán 4 bước
about.html          → Giới thiệu
contact.html        → Liên hệ + FAQ

js/data.js          → 40 sản phẩm + images
js/carousel.js      → Carousel logic
js/main.js          → Main app logic
js/filter.js        → Filter logic
js/search.js        → Search logic
js/pagination.js    → Pagination logic

css/main.css        → CSS variables + base
css/components.css  → Components styling
css/carousel.css    → Carousel styling
css/pages.css       → Page-specific styling
css/responsive.css  → Media queries
```

## 7️⃣ Không Hoạt Động?

### Ảnh không load
- ✅ **Fixed!** Link ảnh đã update từ Google Books API, Open Library
- Tất cả link hoạt động tốt

### Lỗi trong Console
- F12 → Console
- Nếu có error → Report lỗi
- Bình thường sẽ không có lỗi

### Carousel không scroll
- Refresh trang (F5)
- Thử resize window
- Kiểm tra browser console (F12)

## 8️⃣ Demo Data

### Sản Phẩm
- **40 cuốn sách** từ 6 thể loại
- Giá: 79.000đ - 210.000đ
- Rating: 4.3 - 4.9 sao
- Real images từ Google Books API

### Danh Mục
1. 📖 Văn Học - 1250 sách
2. 💼 Kinh Tế - 890 sách
3. 💪 Kỹ Năng - 750 sách
4. 💻 Công Nghệ - 620 sách
5. 👶 Trẻ Em - 540 sách
6. 🌍 Ngoại Ngữ - 430 sách

## 9️⃣ Next Steps

1. ✅ Mở index.html
2. ✅ Thử scroll carousels
3. ✅ Tìm kiếm sách
4. ✅ Thêm vào giỏ
5. ✅ Xem chi tiết
6. ✅ Checkout
7. ✅ Test mobile (resize)
8. ✅ Customize (màu, thêm sách)
9. ✅ Deploy lên server

## 🎉 Ready!

**Mở index.html bây giờ! 🚀**

```bash
start index.html    # Windows
open index.html     # Mac
xdg-open index.html # Linux
```

---

**Questions? Xem README.md để chi tiết hơn!**
