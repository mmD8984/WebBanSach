-- ==========================================
-- BOOKSTORE DATABASE SETUP
-- MySQL Script
-- ==========================================

-- Create Database
CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- ==========================================
-- USERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- CATEGORIES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    icon VARCHAR(10),
    description VARCHAR(500),
    count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- AUTHORS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- PUBLISHERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS publishers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- BOOKS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    publisher_id INT,
    category_id INT NOT NULL,
    price DECIMAL(10, 0) NOT NULL,
    original_price DECIMAL(10, 0),
    discount INT DEFAULT 0,
    pages INT,
    year INT,
    rating DECIMAL(3, 1),
    reviews INT DEFAULT 0,
    description TEXT,
    image VARCHAR(500),
    status VARCHAR(50) DEFAULT 'Còn hàng',
    format VARCHAR(50),
    size VARCHAR(50),
    stock INT DEFAULT 0,
    featured BOOLEAN DEFAULT FALSE,
    bestseller BOOLEAN DEFAULT FALSE,
    new BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    INDEX (category_id),
    INDEX (author_id),
    INDEX (publisher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- ORDERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(500) NOT NULL,
    city VARCHAR(100),
    district VARCHAR(100),
    notes TEXT,
    shipping_method VARCHAR(50),
    payment_method VARCHAR(50),
    total DECIMAL(10, 0) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX (user_id),
    INDEX (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- ORDER_ITEMS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id),
    INDEX (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- INSERT CATEGORIES
-- ==========================================
INSERT INTO categories (name, icon, description, count) VALUES
('Văn Học', '📖', 'Các tác phẩm văn học kinh điển và hiện đại', 1250),
('Sách Kinh Tế', '💼', 'Sách về kinh doanh, tài chính và quản lý', 890),
('Kỹ Năng Sống', '💪', 'Phát triển kỹ năng cá nhân và chuyên môn', 750),
('Công Nghệ', '💻', 'Sách về lập trình, web, AI và công nghệ', 620),
('Trẻ Em', '👶', 'Sách truyện và học tập cho trẻ em', 540),
('Ngoại Ngữ', '🌍', 'Sách học tiếng Anh, Trung, Nhật...', 430);

-- ==========================================
-- INSERT AUTHORS
-- ==========================================
INSERT INTO authors (name, country) VALUES
('Nguyễn Nhật Ánh', 'Việt Nam'),
('Dương Thụ', 'Việt Nam'),
('Bạch Liên', 'Việt Nam'),
('George R. R. Martin', 'Mỹ'),
('J.K. Rowling', 'Anh'),
('Paulo Coelho', 'Brazil'),
('Dale Carnegie', 'Mỹ'),
('Robert T. Kiyosaki', 'Mỹ'),
('Yuval Noah Harari', 'Israel'),
('Daniel Kahneman', 'Israel');

-- ==========================================
-- INSERT PUBLISHERS
-- ==========================================
INSERT INTO publishers (name, country) VALUES
('NXB Trẻ', 'Việt Nam'),
('NXB Lao Động', 'Việt Nam'),
('NXB Hà Nội', 'Việt Nam'),
('NXB Kim Đồng', 'Việt Nam'),
('Penguin Books', 'Anh'),
('Random House', 'Mỹ');

-- ==========================================
-- INSERT BOOKS (40 books)
-- ==========================================
INSERT INTO books (title, author_id, publisher_id, category_id, price, original_price, discount, pages, year, rating, reviews, description, image, status, format, size, stock, featured, bestseller, new) VALUES
('Thỏ Bông', 1, 1, 5, 120000, 150000, 20, 240, 2020, 4.8, 125, 'Một tác phẩm hay về tình yêu và cuộc sống của các bạn trẻ', 'https://books.google.com/books/content?id=5x_KDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 50, TRUE, FALSE, TRUE),
('Cha Giàu Cha Nghèo', 8, 2, 2, 145000, 180000, 19, 336, 2019, 4.9, 892, 'Hướng dẫn cách xây dựng tư duy tài chính và đầu tư thông minh', 'https://books.google.com/books/content?id=FVdjDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 'Còn hàng', 'Bìa cứng', '15.5 x 22.5 cm', 120, TRUE, TRUE, FALSE),
('Sapiens', 9, 5, 1, 165000, 220000, 25, 512, 2021, 4.7, 654, 'Lịch sử loài người nhìn từ một góc độ hoàn toàn mới', 'https://books.google.com/books/content?id=S5iBAwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'Còn hàng', 'Bìa mềm', '15 x 22 cm', 80, TRUE, FALSE, FALSE),
('Đắc Nhân Tâm', 7, 2, 3, 135000, 160000, 16, 288, 2020, 4.6, 445, 'Những lợi ích trong cuộc sống bằng cách thay đổi tư tưởng', 'https://books.google.com/books/content?id=ljx90QEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'Còn hàng', 'Bìa cứng', '14 x 20.5 cm', 95, FALSE, TRUE, FALSE),
('Clean Code', NULL, 6, 4, 185000, 240000, 23, 464, 2021, 4.8, 523, 'Hướng dẫn viết code sạch và dễ bảo trì', 'https://books.google.com/books/content?id=gPwfDgAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 60, FALSE, TRUE, TRUE),
('Dạy Con Thế Nào?', 1, 1, 3, 125000, 155000, 19, 256, 2021, 4.5, 234, 'Những cách dạy dỗ con em hiệu quả và khoa học', 'https://cdn.pixabay.com/photo/2018/02/08/14/36/book-3140662_640.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 75, FALSE, FALSE, TRUE),
('The Hobbit', NULL, 5, 1, 155000, 200000, 23, 380, 2020, 4.9, 789, 'Cuộc phiêu lưu đầy kỳ diệu của Bilbo Baggins', 'https://cdn.pixabay.com/photo/2017/08/14/02/28/stack-of-books-2638586_640.jpg', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 110, TRUE, FALSE, FALSE),
('Lập Trình Java Cơ Bản', NULL, 3, 4, 175000, 220000, 20, 520, 2021, 4.7, 312, 'Học lập trình Java từ cơ bản đến nâng cao', 'https://cdn.pixabay.com/photo/2013/12/20/15/17/book-231100_640.jpg', 'Còn hàng', 'Bìa mềm', '16 x 24 cm', 45, FALSE, TRUE, TRUE),
('Con Chim Xanh', 3, 4, 5, 85000, 110000, 23, 128, 2021, 4.4, 156, 'Truyện kỳ diệu dành cho các bạn nhỏ', 'https://images.pexels.com/photos/159866/books-book-pages-read-159866.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '13.5 x 19 cm', 200, FALSE, FALSE, FALSE),
('Tiếng Anh Giao Tiếp', NULL, 2, 6, 145000, 180000, 19, 304, 2020, 4.6, 267, 'Học tiếng Anh giao tiếp hàng ngày một cách hiệu quả', 'https://images.pexels.com/photos/256514/pexels-photo-256514.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '15 x 21 cm', 130, FALSE, FALSE, FALSE),
('Thất Bại Là Mẹ Của Thành Công', 4, 6, 3, 135000, 165000, 18, 272, 2021, 4.5, 189, 'Học cách vượt qua thất bại và đạt được thành công', 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 85, FALSE, FALSE, TRUE),
('Cuộc Sống Sau 50 Tuổi', 2, 1, 3, 125000, 160000, 22, 215, 2020, 4.3, 134, 'Hướng dẫn sống sẻ lành mạnh và bình yên sau 50 tuổi', 'https://images.pexels.com/photos/4439407/pexels-photo-4439407.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14.5 x 20.5 cm', 70, FALSE, FALSE, FALSE),
('Nhà Giả Kim', 6, 1, 1, 99000, 125000, 21, 256, 2020, 4.7, 543, 'Hành trình tìm kiếm kho báu nội tâm', 'https://covers.openlibrary.org/b/id/6379847-M.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 150, TRUE, TRUE, FALSE),
('Tư Duy Nhanh và Chậm', 10, 2, 3, 155000, 195000, 20, 456, 2021, 4.8, 432, 'Khám phá hai hệ thống tư duy của con người', 'https://covers.openlibrary.org/b/id/8236101-M.jpg', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 88, FALSE, TRUE, FALSE),
('Lập Trình Python', NULL, 3, 4, 198000, 250000, 21, 640, 2021, 4.9, 567, 'Hướng dẫn toàn diện lập trình Python', 'https://covers.openlibrary.org/b/id/7725341-M.jpg', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 52, TRUE, TRUE, TRUE),
('Tôi Có Thể Bảo Vệ Bản Thân Mình', NULL, 1, 3, 89000, 115000, 23, 200, 2021, 4.6, 223, 'Hướng dẫn tự vệ cho phụ nữ', 'https://covers.openlibrary.org/b/id/8439509-M.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 200, FALSE, FALSE, TRUE),
('Biết Chút Về Nhiều', NULL, 4, 1, 115000, 145000, 21, 320, 2020, 4.5, 178, 'Kiến thức tổng hợp về đa lĩnh vực', 'https://covers.openlibrary.org/b/id/8439022-M.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 95, FALSE, FALSE, FALSE),
('Kỹ Năng Quản Lý Thời Gian', NULL, 2, 3, 79000, 99000, 20, 184, 2021, 4.4, 334, 'Quản lý thời gian hiệu quả', 'https://covers.openlibrary.org/b/id/8439110-M.jpg', 'Còn hàng', 'Bìa mềm', '13.5 x 19 cm', 240, FALSE, FALSE, TRUE),
('Trí Tuệ Nhân Tạo Giải Thích', NULL, 5, 4, 210000, 270000, 22, 512, 2021, 4.8, 456, 'Hiểu biết sâu về AI và Machine Learning', 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 38, TRUE, TRUE, TRUE),
('Nước Ý Xanh', NULL, 1, 1, 135000, 168000, 20, 296, 2020, 4.7, 345, 'Tiểu thuyết lãng mạn', 'https://images.pexels.com/photos/4439407/pexels-photo-4439407.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 120, FALSE, FALSE, FALSE),
('Bộ Não Sáng Tạo', NULL, 5, 3, 165000, 210000, 21, 384, 2021, 4.6, 289, 'Khám phá sức mạnh của bộ não', 'https://cdn.pixabay.com/photo/2018/02/08/14/36/book-3140662_640.jpg', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 72, TRUE, FALSE, FALSE),
('Web Development Hiện Đại', NULL, 3, 4, 189000, 240000, 21, 528, 2021, 4.9, 612, 'Hướng dẫn phát triển web hiện đại', 'https://cdn.pixabay.com/photo/2017/08/14/02/28/stack-of-books-2638586_640.jpg', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 66, FALSE, TRUE, TRUE),
('Tiếng Anh Thương Mại', NULL, 5, 6, 128000, 160000, 20, 272, 2021, 4.5, 198, 'Tiếng Anh chuyên nghiệp cho kinh doanh', 'https://cdn.pixabay.com/photo/2013/12/20/15/17/book-231100_640.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 145, FALSE, FALSE, TRUE),
('Phân Tích Dữ Liệu Với Python', NULL, 3, 4, 195000, 250000, 22, 600, 2021, 4.8, 478, 'Phân tích dữ liệu chuyên sâu', 'https://images.pexels.com/photos/159866/books-book-pages-read-159866.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 44, TRUE, TRUE, TRUE),
('Sáng Tạo Không Giới Hạn', NULL, 1, 3, 108000, 135000, 20, 256, 2021, 4.6, 267, 'Phát triển khả năng sáng tạo', 'https://images.pexels.com/photos/256514/pexels-photo-256514.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 180, FALSE, FALSE, TRUE),
('Nơi Đó Có Nắng', 1, 1, 1, 98000, 125000, 22, 304, 2021, 4.7, 456, 'Chuyện tình yêu trong mưa', 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 156, TRUE, FALSE, TRUE),
('Hạnh Phúc Không Xa', NULL, 2, 3, 85000, 110000, 23, 192, 2020, 4.4, 189, 'Hạnh phúc trong những điều giản dị', 'https://images.pexels.com/photos/4439407/pexels-photo-4439407.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '13.5 x 19 cm', 210, FALSE, FALSE, FALSE),
('Kinh Tế Học Vi Mô', NULL, 5, 2, 189000, 240000, 21, 528, 2021, 4.8, 334, 'Kiến thức kinh tế học vi mô toàn diện', 'https://covers.openlibrary.org/b/id/6379847-M.jpg', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 68, TRUE, TRUE, FALSE),
('Nghệ Thuật Ghi Chép', NULL, 3, 3, 145000, 185000, 22, 352, 2021, 4.7, 412, 'Ghi chép thông minh để học tập hiệu quả', 'https://covers.openlibrary.org/b/id/8236101-M.jpg', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 95, FALSE, TRUE, TRUE),
('Cơn Sóng Lớn', NULL, 4, 1, 125000, 160000, 22, 288, 2020, 4.5, 267, 'Nhân học và xã hội học', 'https://covers.openlibrary.org/b/id/7725341-M.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 130, FALSE, FALSE, FALSE),
('JavaScript Tiên Tiến', NULL, 3, 4, 175000, 220000, 20, 608, 2021, 4.9, 589, 'Lập trình JavaScript nâng cao', 'https://covers.openlibrary.org/b/id/8429509-M.jpg', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 42, TRUE, TRUE, TRUE),
('Tâm Lý Học Tích Cực', NULL, 2, 3, 128000, 160000, 20, 304, 2021, 4.6, 298, 'Khám phá sức mạnh tâm lý tích cực', 'https://covers.openlibrary.org/b/id/8439022-M.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 162, FALSE, FALSE, TRUE),
('Lịch Sử Thế Giới Ngắn Gọn', NULL, 5, 1, 155000, 200000, 23, 456, 2020, 4.7, 378, 'Tóm tắt lịch sử nhân loại', 'https://covers.openlibrary.org/b/id/8439110-M.jpg', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 88, TRUE, FALSE, FALSE),
('Quản Lý Dự Án Hiệu Quả', NULL, 2, 2, 135000, 170000, 21, 272, 2021, 4.5, 223, 'Quản lý dự án chuyên nghiệp', 'https://images.pexels.com/photos/159866/books-book-pages-read-159866.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14.5 x 20.5 cm', 110, FALSE, FALSE, TRUE),
('Sức Mạnh Của Thói Quen', NULL, 1, 3, 125000, 160000, 22, 400, 2020, 4.8, 567, 'Thay đổi thói quen để thay đổi cuộc sống', 'https://images.pexels.com/photos/256514/pexels-photo-256514.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 145, TRUE, TRUE, FALSE),
('Database Thiết Kế', NULL, 3, 4, 198000, 250000, 21, 560, 2021, 4.7, 289, 'Thiết kế cơ sở dữ liệu tối ưu', 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 36, FALSE, TRUE, TRUE),
('Tiếng Pháp Cho Người Mới', NULL, 5, 6, 135000, 175000, 23, 256, 2020, 4.5, 198, 'Học tiếng Pháp từ đầu', 'https://images.pexels.com/photos/4439407/pexels-photo-4439407.jpeg?auto=compress&cs=tinysrgb&w=400&h=500&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 124, FALSE, FALSE, FALSE),
('Triết Học Phương Đông', NULL, 1, 1, 105000, 135000, 22, 320, 2021, 4.6, 245, 'Hiểu biết về triết học phương Đông', 'https://cdn.pixabay.com/photo/2018/02/08/14/36/book-3140662_640.jpg', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 176, TRUE, FALSE, TRUE),
('Bán Hàng Thuyết Phục', NULL, 2, 2, 145000, 185000, 22, 336, 2021, 4.8, 423, 'Kỹ năng bán hàng chuyên nghiệp', 'https://cdn.pixabay.com/photo/2017/08/14/02/28/stack-of-books-2638586_640.jpg', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 84, FALSE, TRUE, FALSE),
('Toán Học Thú Vị', NULL, 4, 4, 128000, 165000, 23, 384, 2020, 4.4, 167, 'Khám phá vẻ đẹp của toán học', 'https://cdn.pixabay.com/photo/2013/12/20/15/17/book-231100_640.jpg', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 67, TRUE, FALSE, FALSE);

-- ==========================================
-- CREATE INDEXES FOR PERFORMANCE
-- ==========================================
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_featured ON books(featured);
CREATE INDEX idx_books_bestseller ON books(bestseller);
CREATE INDEX idx_users_email ON users(email);

