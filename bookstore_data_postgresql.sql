-- =====================================================
-- DATABASE SCHEMA WEBSITE BÁN SÁCH - POSTGRESQL
-- COMPLETE MOCK DATA
-- Password for all users: 1 (SHA-256 hash)
-- =====================================================

-- =====================================================
-- 1. BẢNG USERS (Khách hàng & Admin)
-- =====================================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('customer', 'admin', 'staff')) DEFAULT 'customer',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. BẢNG CATEGORIES (Danh mục sách)
-- =====================================================
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. BẢNG AUTHORS (Tác giả)
-- =====================================================
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. BẢNG PUBLISHERS (Nhà xuất bản)
-- =====================================================
CREATE TABLE publishers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. BẢNG BOOKS (Sách)
-- =====================================================
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    cover_image VARCHAR(500),
    category_id INTEGER,
    publisher_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. BẢNG ORDERS (Đơn hàng)
-- =====================================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE,
    user_id INTEGER,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'shipping', 'delivered', 'cancelled')) DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    payment_method VARCHAR(20) CHECK (payment_method IN ('cod', 'bank_transfer', 'vnpay', 'momo')) DEFAULT 'cod',
    payment_status VARCHAR(20) CHECK (payment_status IN ('pending', 'paid', 'failed')) DEFAULT 'pending',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- FOREIGN KEY CONSTRAINTS
-- =====================================================

ALTER TABLE books 
ADD CONSTRAINT fk_books_category 
FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

ALTER TABLE books 
ADD CONSTRAINT fk_books_publisher 
FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE SET NULL;

ALTER TABLE orders 
ADD CONSTRAINT fk_orders_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- =====================================================
-- 8. BẢNG CHI TIẾT (Junction Tables)
-- =====================================================

CREATE TABLE book_authors (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT
);

-- =====================================================
-- 9. BẢNG USER FEATURES
-- =====================================================

CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    cart_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE(cart_id, book_id)
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT,
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE(user_id, book_id)
);

CREATE TABLE wishlists (
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES
-- =====================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_publisher ON books(publisher_id);
CREATE INDEX idx_books_active ON books(is_active) WHERE is_active = true;
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_reviews_book ON reviews(book_id);
CREATE INDEX idx_reviews_approved ON reviews(is_approved) WHERE is_approved = true;
CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX idx_wishlists_user ON wishlists(user_id);

-- =====================================================
-- TRIGGERS & FUNCTIONS
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_books_updated_at 
    BEFORE UPDATE ON books 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cart_items_updated_at 
    BEFORE UPDATE ON cart_items 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION generate_order_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_code := 'ORD' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(NEW.id::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_order_code
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION generate_order_code();

-- =====================================================
-- INSERT DATA
-- =====================================================

-- Categories
INSERT INTO categories (id, name, slug, description) VALUES
(1, 'Tiểu thuyết', 'tieu-thuyet', 'Sách tiểu thuyết, văn học'),
(2, 'Kinh tế', 'kinh-te', 'Sách quản trị, tài chính, kinh doanh'),
(3, 'Công nghệ', 'cong-nghe', 'Sách lập trình, IT, phần mềm'),
(4, 'Kỹ năng sống', 'ky-nang-song', 'Sách phát triển bản thân'),
(5, 'Thiếu nhi', 'thieu-nhi', 'Sách thiếu nhi'),
(6, 'Tâm lý', 'tam-ly', 'Sách tâm lý học'),
(7, 'Khoa học', 'khoa-hoc', 'Sách khoa học nghiên cứu'),
(8, 'Lịch sử', 'lich-su', 'Sách lịch sử Việt Nam và thế giới'),
(9, 'Giáo dục', 'giao-duc', 'Sách giáo dục & học thuật'),
(10, 'Ngoại ngữ', 'ngoai-ngu', 'Sách học ngoại ngữ');

SELECT setval('categories_id_seq', 10);

-- Authors
INSERT INTO authors (id, name, bio) VALUES
(1, 'Nguyễn Nhật Ánh', 'Nhà văn thiếu nhi nổi tiếng'),
(2, 'J.K. Rowling', 'Tác giả Harry Potter'),
(3, 'George Orwell', 'Tác giả 1984 và Animal Farm'),
(4, 'J.R.R. Tolkien', 'Tác giả Chúa Nhẫn'),
(5, 'Haruki Murakami', 'Nhà văn Nhật Bản'),
(6, 'Paulo Coelho', 'Tác giả Nhà Giả Kim'),
(7, 'Walter Isaacson', 'Nhà viết tiểu sử nổi tiếng'),
(8, 'Stephen King', 'Ông hoàng truyện kinh dị'),
(9, 'Dan Brown', 'Tác giả Mật Mã Da Vinci'),
(10, 'Yuval Noah Harari', 'Học giả nổi tiếng với Sapiens'),
(11, 'Dale Carnegie', 'Tác giả Đắc Nhân Tâm'),
(12, 'Napoleon Hill', 'Tác giả Think and Grow Rich'),
(13, 'Brian Tracy', 'Chuyên gia phát triển bản thân'),
(14, 'Adam Grant', 'Nhà tâm lý học nổi tiếng'),
(15, 'Robin Sharma', 'Tác giả Nhà Sư Bán Chiếc Ferrari'),
(16, 'Mark Manson', 'Tác giả Nghệ Thuật Bất Chấp'),
(17, 'James Clear', 'Tác giả Atomic Habits'),
(18, 'Eric Evans', 'Tác giả Domain-Driven Design'),
(19, 'Robert C. Martin', 'Tác giả Clean Code'),
(20, 'Andrew Hunt', 'Tác giả Pragmatic Programmer');

SELECT setval('authors_id_seq', 20);

-- Publishers
INSERT INTO publishers (id, name, address) VALUES
(1, 'NXB Trẻ', 'HCM'),
(2, 'NXB Kim Đồng', 'Hà Nội'),
(3, 'NXB Lao Động', 'Hà Nội'),
(4, 'NXB Giáo Dục', 'Hà Nội'),
(5, 'Penguin Books', 'USA'),
(6, 'HarperCollins', 'USA'),
(7, 'Macmillan', 'USA'),
(8, 'Hachette', 'France'),
(9, 'Simon & Schuster', 'USA'),
(10, 'Random House', 'USA'),
(11, 'Bloomsbury', 'UK'),
(12, 'Scholastic', 'USA'),
(13, 'O''Reilly Media', 'USA'),
(14, 'Packt Publishing', 'UK'),
(15, 'Springer', 'Germany'),
(16, 'Apress', 'USA'),
(17, 'Wiley', 'USA'),
(18, 'MIT Press', 'USA'),
(19, 'Oxford Press', 'UK'),
(20, 'Cambridge Press', 'UK');

SELECT setval('publishers_id_seq', 20);

-- Books
INSERT INTO books (id, title, description, price, stock_quantity, category_id, publisher_id, cover_image) VALUES
(1, 'Dế Mèn Phiêu Lưu Ký', 'Tác phẩm nổi tiếng', 85000, 120, 1, 1, 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400'),
(2, 'Harry Potter and the Sorcerer''s Stone', 'Phần 1 Harry Potter', 150000, 90, 5, 12, 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400'),
(3, '1984', 'Tiểu thuyết phản địa đàng', 130000, 75, 1, 11, 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400'),
(4, 'The Hobbit', 'Phiêu lưu giả tưởng', 180000, 60, 1, 11, 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400'),
(5, 'Norwegian Wood', 'Tác phẩm Murakami', 145000, 100, 1, 5, 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400'),
(6, 'The Alchemist', 'Nhà Giả Kim', 160000, 140, 4, 9, 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?w=400'),
(7, 'Steve Jobs', 'Tiểu sử Steve Jobs', 220000, 85, 2, 5, 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400'),
(8, 'The Shining', 'Tiểu thuyết kinh dị', 175000, 60, 1, 10, 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400'),
(9, 'The Da Vinci Code', 'Tiểu thuyết trinh thám', 165000, 95, 1, 5, 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400'),
(10, 'Sapiens', 'Lược sử loài người', 200000, 130, 7, 17, 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
(11, 'Đắc Nhân Tâm', 'Sách kỹ năng sống nổi tiếng', 90000, 150, 4, 3, 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400'),
(12, 'Think and Grow Rich', 'Sách kinh tế kinh điển', 120000, 80, 2, 9, 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=400'),
(13, 'Atomic Habits', 'Thay đổi thói quen', 175000, 110, 4, 9, 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400'),
(14, 'Clean Code', 'Sách lập trình kinh điển', 320000, 50, 3, 13, 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400'),
(15, 'Pragmatic Programmer', 'Sách lập trình', 350000, 40, 3, 20, 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400'),
(16, 'Domain-Driven Design', 'Thiết kế miền', 450000, 35, 3, 13, 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400'),
(17, 'The Psychology of Money', 'Nghệ thuật tài chính', 195000, 90, 2, 10, 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400'),
(18, 'The Power of Habit', 'Sức mạnh thói quen', 140000, 100, 4, 9, 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400'),
(19, 'The 5AM Club', 'Thói quen thành công', 180000, 70, 4, 15, 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=400'),
(20, 'The Subtle Art of Not Giving a F*ck', 'Nghệ thuật Bất chấp', 165000, 80, 4, 10, 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400');

SELECT setval('books_id_seq', 20);

-- Book Authors
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 17), (14, 19), (15, 20),
(16, 18), (17, 12), (18, 17), (19, 15), (20, 16);

-- Users (password = '1', SHA-256 hash = '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b')
INSERT INTO users (id, email, password_hash, full_name, phone, role) VALUES
(1, 'admin@bookstore.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Admin', '0900000000', 'admin'),
(2, 'staff@bookstore.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Nhân viên', '0900000001', 'staff'),
(3, 'user1@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Nguyễn Văn A', '0901234567', 'customer'),
(4, 'user2@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Trần Thị B', '0912345678', 'customer'),
(5, 'user3@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Lê Văn C', '0923456789', 'customer'),
(6, 'user4@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Phạm Thị D', '0934567890', 'customer'),
(7, 'user5@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Hoàng Văn E', '0945678901', 'customer'),
(8, 'user6@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Vũ Thị F', '0956789012', 'customer'),
(9, 'user7@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Đỗ Văn G', '0967890123', 'customer'),
(10, 'user8@test.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Bùi Thị H', '0978901234', 'customer');

SELECT setval('users_id_seq', 10);

-- Orders
INSERT INTO orders (id, user_id, total_amount, status, shipping_address, payment_method, payment_status, note) VALUES
(1, 3, 415000, 'delivered', '123 Nguyễn Huệ, Q1, TP.HCM', 'cod', 'paid', 'Giao giờ hành chính'),
(2, 4, 320000, 'confirmed', '456 Lê Lợi, Q3, TP.HCM', 'vnpay', 'paid', NULL),
(3, 5, 180000, 'pending', '789 Trần Hưng Đạo, Hà Nội', 'cod', 'pending', NULL),
(4, 6, 550000, 'shipping', '321 Nguyễn Trãi, Đà Nẵng', 'momo', 'paid', 'Gọi trước khi giao'),
(5, 7, 260000, 'cancelled', '654 Phan Đình Phùng, Cần Thơ', 'cod', 'failed', 'Khách hủy đơn'),
(6, 8, 700000, 'delivered', '987 Phú Mỹ Hưng, Q7, TP.HCM', 'bank_transfer', 'paid', NULL),
(7, 9, 210000, 'pending', '147 Đại lộ Bình Dương', 'cod', 'pending', NULL),
(8, 10, 480000, 'confirmed', '258 Quốc lộ 1, Biên Hòa', 'vnpay', 'paid', NULL),
(9, 3, 150000, 'delivered', '369 Lạch Tray, Hải Phòng', 'cod', 'paid', NULL),
(10, 4, 330000, 'shipping', '741 Trần Phú, Nha Trang', 'momo', 'paid', 'Giao buổi tối');

SELECT setval('orders_id_seq', 10);

-- Order Items
INSERT INTO order_items (order_id, book_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 85000, 85000),
(1, 14, 1, 320000, 320000),
(2, 11, 2, 90000, 180000),
(2, 12, 1, 120000, 120000),
(3, 19, 1, 180000, 180000),
(4, 17, 1, 195000, 195000),
(4, 13, 2, 175000, 350000),
(5, 20, 1, 165000, 165000),
(6, 16, 1, 450000, 450000),
(7, 6, 1, 160000, 160000),
(8, 14, 1, 320000, 320000),
(8, 11, 1, 90000, 90000),
(9, 1, 1, 85000, 85000),
(10, 6, 2, 160000, 320000);

-- Carts
INSERT INTO carts (id, user_id) VALUES
(1, 3), (2, 4), (3, 5), (4, 6), (5, 7);

SELECT setval('carts_id_seq', 5);

-- Cart Items
INSERT INTO cart_items (cart_id, book_id, quantity) VALUES
(1, 2, 1), (1, 5, 2),
(2, 10, 1), (2, 15, 1),
(3, 3, 1),
(4, 7, 1), (4, 8, 1), (4, 9, 1),
(5, 11, 3);

-- Reviews
INSERT INTO reviews (user_id, book_id, rating, comment, is_approved) VALUES
(3, 1, 5, 'Sách rất hay, đọc rất cuốn!', true),
(3, 6, 4, 'Câu chuyện ý nghĩa, đáng để đọc', true),
(4, 2, 5, 'Harry Potter kinh điển!', true),
(4, 11, 5, 'Sách thay đổi cuộc đời tôi', true),
(5, 14, 5, 'Must read cho developer', true),
(5, 15, 4, 'Rất hữu ích cho lập trình viên', true),
(6, 3, 5, '1984 là tác phẩm vĩ đại', true),
(6, 10, 5, 'Sapiens mở mang tầm mắt', true),
(7, 4, 4, 'The Hobbit rất thú vị', true),
(8, 13, 5, 'Atomic Habits rất thực tế', true),
(9, 12, 4, 'Sách kinh điển về làm giàu', true),
(10, 5, 5, 'Murakami viết quá hay', true);

-- Wishlists
INSERT INTO wishlists (user_id, book_id) VALUES
(3, 4), (3, 7), (3, 10),
(4, 5), (4, 8),
(5, 1), (5, 6), (5, 9),
(6, 2), (6, 3),
(7, 11), (7, 12), (7, 13),
(8, 14), (8, 15),
(9, 16), (9, 17),
(10, 18), (10, 19), (10, 20);

-- =====================================================
-- VERIFY DATA
-- =====================================================
-- SELECT COUNT(*) FROM users;      -- 10
-- SELECT COUNT(*) FROM categories; -- 10
-- SELECT COUNT(*) FROM authors;    -- 20
-- SELECT COUNT(*) FROM publishers; -- 20
-- SELECT COUNT(*) FROM books;      -- 20
-- SELECT COUNT(*) FROM orders;     -- 10
-- SELECT COUNT(*) FROM order_items;-- 14
-- SELECT COUNT(*) FROM carts;      -- 5
-- SELECT COUNT(*) FROM cart_items; -- 9
-- SELECT COUNT(*) FROM reviews;    -- 12
-- SELECT COUNT(*) FROM wishlists;  -- 20
