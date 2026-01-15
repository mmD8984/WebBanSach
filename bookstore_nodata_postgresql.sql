-- ----------table
-- =====================================================
-- DATABASE SCHEMA WEBSITE BÁN SÁCH - POSTGRESQL
-- =====================================================

-- =====================================================
-- 1. BẢNG USERS (Khách hàng & Admin)x
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
-- 2. BẢNG CATEGORIES (Danh mục sách)x
-- =====================================================
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. BẢNG AUTHORS (Tác giả)x
-- =====================================================
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. BẢNG PUBLISHERS (Nhà xuất bản)x
-- =====================================================
CREATE TABLE publishers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. BẢNG BOOKS (Sách)x
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
-- 6. BẢNG ORDERS (Đơn hàng)x
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

-- Books foreign keys
ALTER TABLE books 
ADD CONSTRAINT fk_books_category 
FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

ALTER TABLE books 
ADD CONSTRAINT fk_books_publisher 
FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE SET NULL;

-- Orders foreign keys
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- =====================================================
-- 8. BẢNG CHI TIẾT (Junction Tables)x
-- =====================================================

-- Book_Authors (Many-to-Many)x
CREATE TABLE book_authors (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

-- Order_Itemsx
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
-- 9. BẢNG USER FEATURESx
-- =====================================================

-- Carts (1-1 với Users)x
CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Cart_Itemsx
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

-- Reviewsx
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

-- Wishlistsx
CREATE TABLE wishlists (
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES (Performance Optimization)
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

-- Function cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers cho updated_at
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

-- Function tự động tạo order_code
CREATE OR REPLACE FUNCTION generate_order_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_code := 'ORD' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(NEW.id::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger tạo order_code sau khi INSERT
CREATE TRIGGER trigger_order_code
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION generate_order_code();

-- =====================================================
-- VIEWS (Báo cáo)
-- =====================================================

CREATE VIEW books_with_discount AS
SELECT 
    b.*, 
    c.name as category_name,
    p.name as publisher_name,
    b.price as display_price
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
LEFT JOIN publishers p ON b.publisher_id = p.id
WHERE b.is_active = true;

-- insert data

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
--==========================
--==========================
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
--===================
--===================
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
--==================
--==================
INSERT INTO books (id, title, description, price, stock_quantity, category_id, publisher_id) VALUES
(1, 'Dế Mèn Phiêu Lưu Ký', 'Tác phẩm nổi tiếng', 85000, 120, 1, 1),
(2, 'Harry Potter and the Sorcerer''s Stone', 'Phần 1 Harry Potter', 150000, 90, 5, 12),
(3, '1984', 'Tiểu thuyết phản địa đàng', 130000, 75, 1, 11),
(4, 'The Hobbit', 'Phiêu lưu giả tưởng', 180000, 60, 1, 11),
(5, 'Norwegian Wood', 'Tác phẩm Murakami', 145000, 100, 1, 5),
(6, 'The Alchemist', 'Nhà Giả Kim', 160000, 140, 4, 9),
(7, 'Steve Jobs', 'Tiểu sử Steve Jobs', 220000, 85, 2, 5),
(8, 'The Shining', 'Tiểu thuyết kinh dị', 175000, 60, 1, 10),
(9, 'The Da Vinci Code', 'Tiểu thuyết trinh thám', 165000, 95, 1, 5),
(10, 'Sapiens', 'Lược sử loài người', 200000, 130, 7, 17),

(11, 'Đắc Nhân Tâm', 'Sách kỹ năng sống nổi tiếng', 90000, 150, 4, 3),
(12, 'Think and Grow Rich', 'Sách kinh tế kinh điển', 120000, 80, 2, 9),
(13, 'Atomic Habits', 'Thay đổi thói quen', 175000, 110, 4, 9),
(14, 'Clean Code', 'Sách lập trình kinh điển', 320000, 50, 3, 13),
(15, 'Pragmatic Programmer', 'Sách lập trình', 350000, 40, 3, 20),
(16, 'Domain-Driven Design', 'Thiết kế miền', 450000, 35, 3, 13),
(17, 'The Psychology of Money', 'Nghệ thuật tài chính', 195000, 90, 2, 10),
(18, 'The Power of Habit', 'Sức mạnh thói quen', 140000, 100, 4, 9),
(19, 'The 5AM Club', 'Thói quen thành công', 180000, 70, 4, 15),
(20, 'The Subtle Art of Not Giving a F*ck', 'Nghệ thuật Bất chấp', 165000, 80, 4, 10),

(21, 'Lập Trình Java Cơ Bản', 'Sách nhập môn Java', 120000, 90, 3, 13),
(22, 'Spring Boot in Action', 'Sách Spring Boot', 250000, 60, 3, 16),
(23, 'Clean Architecture', 'Kiến trúc phần mềm', 330000, 55, 3, 13),
(24, 'Head First Design Patterns', 'Pattern giải thích dễ hiểu', 380000, 45, 3, 12),
(25, 'You Don''t Know JS', 'Hệ thống JS', 210000, 100, 3, 13),
(26, 'Cấu Trúc Dữ Liệu & Giải Thuật', 'DSA cơ bản', 150000, 110, 9, 4),
(27, 'Deep Learning', 'Sách AI hiện đại', 460000, 30, 7, 18),
(28, 'Artificial Intelligence', 'Tổng quan AI', 420000, 40, 7, 17),
(29, 'Machine Learning Cơ Bản', 'Nhập môn ML', 260000, 70, 7, 17),
(30, 'Giải Tích 1', 'Giáo trình đại học', 130000, 120, 9, 4),

(31, 'Toán Cao Cấp A1', 'Sách giáo dục đại học', 95000, 140, 9, 4),
(32, 'Lịch Sử Việt Nam', 'Tổng quan lịch sử VN', 125000, 90, 8, 3),
(33, 'Lịch Sử Thế Giới', 'Tổng quan thế giới', 150000, 80, 8, 6),
(34, 'Khủng Long - Thế Giới Tiền Sử', 'Sách thiếu nhi khoa học', 80000, 150, 5, 2),
(35, 'Truyện Cổ Grimm', 'Cổ tích nổi tiếng', 90000, 160, 5, 2),
(36, 'Học Tiếng Anh Cơ Bản', 'Sách ngoại ngữ nhập môn', 110000, 100, 10, 19),
(37, 'Tự Học TOEIC 650+', 'Ôn luyện TOEIC', 160000, 95, 10, 20),
(38, 'Ngữ Pháp Tiếng Hàn', 'Sách học tiếng Hàn', 130000, 85, 10, 20),
(39, 'Từ Vựng IELTS', 'Tài liệu luyện IELTS', 180000, 70, 10, 19),
(40, 'JLPT N3 Vocabulary', 'Tiếng Nhật N3', 150000, 75, 10, 20),

(41, 'Harry Potter and the Chamber of Secrets', 'Phần 2 HP', 160000, 85, 5, 12),
(42, 'Harry Potter and the Prisoner of Azkaban', 'Phần 3 HP', 165000, 70, 5, 12),
(43, 'Harry Potter and the Goblet of Fire', 'Phần 4 HP', 180000, 65, 5, 12),
(44, 'Harry Potter and the Order of the Phoenix', 'Phần 5 HP', 185000, 60, 5, 12),
(45, 'Harry Potter and the Half-Blood Prince', 'Phần 6 HP', 190000, 55, 5, 12),
(46, 'Harry Potter and the Deathly Hallows', 'Phần 7 HP', 200000, 50, 5, 12),
(47, 'Chạng Vạng', 'Tiểu thuyết Twilight', 140000, 100, 1, 3),
(48, 'New Moon', 'Twilight phần 2', 150000, 95, 1, 3),
(49, 'Eclipse', 'Twilight phần 3', 160000, 85, 1, 3),
(50, 'Breaking Dawn', 'Twilight phần 4', 170000, 80, 1, 3),

(51, 'Sherlock Holmes Tập 1', 'Thám tử Sherlock', 120000, 110, 1, 6),
(52, 'Sherlock Holmes Tập 2', 'Thám tử Sherlock', 125000, 100, 1, 6),
(53, 'Sherlock Holmes Tập 3', 'Thám tử Sherlock', 130000, 95, 1, 6),
(54, 'Sherlock Holmes Tập 4', 'Thám tử Sherlock', 135000, 90, 1, 6),
(55, 'Sherlock Holmes Tập 5', 'Thám tử Sherlock', 140000, 85, 1, 6),
(56, 'Sherlock Holmes Tập 6', 'Thám tử Sherlock', 145000, 80, 1, 6),
(57, 'Sherlock Holmes Tập 7', 'Thám tử Sherlock', 150000, 75, 1, 6),
(58, 'Sherlock Holmes Tập 8', 'Thám tử Sherlock', 155000, 70, 1, 6),
(59, 'Sherlock Holmes Tập 9', 'Thám tử Sherlock', 160000, 65, 1, 6),
(60, 'Sherlock Holmes Tập 10', 'Thám tử Sherlock', 165000, 60, 1, 6),

(61, 'Giải Thuật Với Python', 'Thuật toán với Python', 210000, 70, 3, 14),
(62, 'Learn Python the Hard Way', 'Python cơ bản', 180000, 90, 3, 14),
(63, 'Fluent Python', 'Python nâng cao', 350000, 40, 3, 13),
(64, 'Python Machine Learning', 'ML với Python', 320000, 50, 3, 17),
(65, 'Effective Java', 'Java nâng cao', 340000, 45, 3, 17),
(66, 'Java Concurrency in Practice', 'Lập trình đa luồng', 360000, 40, 3, 17),
(67, 'Modern Operating Systems', 'Hệ điều hành', 420000, 35, 7, 18),
(68, 'Computer Networks', 'Mạng máy tính', 380000, 60, 7, 18),
(69, 'Database System Concepts', 'CSDL nâng cao', 390000, 55, 7, 15),
(70, 'Compilers: Principles, Techniques', 'Sách compiler', 450000, 30, 7, 15),

(71, 'Kỹ Năng Giao Tiếp Hiệu Quả', 'Giao tiếp thực chiến', 90000, 150, 4, 3),
(72, 'Kỹ Năng Thuyết Trình', 'Phát triển kỹ năng', 110000, 130, 4, 3),
(73, 'Nghệ Thuật Sống Hạnh Phúc', 'Sống tích cực', 125000, 120, 4, 3),
(74, 'Tư Duy Phản Biện', 'Critical thinking', 140000, 100, 4, 3),
(75, 'Lãnh Đạo 4.0', 'Lãnh đạo hiện đại', 180000, 90, 2, 9),
(76, 'Quản Trị Chiến Lược', 'Sách kinh tế', 190000, 85, 2, 9),
(77, 'Kinh Tế Vĩ Mô', 'Giáo trình đại học', 130000, 140, 2, 4),
(78, 'Kinh Tế Vi Mô', 'Giáo trình đại học', 125000, 150, 2, 4),
(79, 'Tài Chính Doanh Nghiệp', 'Sách tài chính', 160000, 70, 2, 4),
(80, 'Kế Toán Tài Chính', 'Giáo trình kế toán', 150000, 90, 2, 4),

(81, 'Lập Trình Web Với HTML/CSS', 'Sách web cơ bản', 95000, 130, 3, 14),
(82, 'JavaScript Cơ Bản', 'JS cho người mới', 110000, 120, 3, 14),
(83, 'ReactJS Handbook', 'React cơ bản', 210000, 70, 3, 13),
(84, 'Mastering React', 'React nâng cao', 300000, 50, 3, 16),
(85, 'NodeJS In Action', 'Node thực chiến', 250000, 65, 3, 16),
(86, 'MongoDB Essentials', 'NoSQL cơ bản', 230000, 75, 3, 16),
(87, 'Docker Deep Dive', 'Sách Docker', 350000, 45, 3, 17),
(88, 'Kubernetes In Action', 'Sách Kubernetes', 420000, 40, 3, 17),
(89, 'Linux Command Line', 'Linux cơ bản', 150000, 100, 3, 12),
(90, 'Cyber Security 101', 'An toàn thông tin', 260000, 60, 3, 18),

(91, 'Truyện Tranh Doraemon Tập 1', 'Truyện tranh thiếu nhi', 35000, 200, 5, 2),
(92, 'Conan Tập 1', 'Thám tử lừng danh Conan', 35000, 190, 5, 2),
(93, 'One Piece Tập 1', 'Hải tặc mũ rơm', 35000, 180, 5, 12),
(94, 'Dragon Ball Tập 1', '7 viên ngọc rồng', 35000, 170, 5, 12),
(95, 'Shin - Cậu Bé Bút Chì Tập 1', 'Thiếu nhi Nhật', 35000, 160, 5, 2),
(96, 'Pokemon Adventures Tập 1', 'Pokemon', 35000, 150, 5, 12),
(97, 'Giáo Trình Tiếng Anh 12', 'Giáo dục phổ thông', 95000, 120, 9, 4),
(98, 'Giáo Trình Toán 12', 'Giáo dục phổ thông', 90000, 110, 9, 4),
(99, 'Giáo Trình Vật Lý 12', 'Giáo dục phổ thông', 90000, 105, 9, 4),
(100, 'Giáo Trình Hóa 12', 'Giáo dục phổ thông', 90000, 100, 9, 4);
--==================
--==================
INSERT INTO book_authors (book_id, author_id) VALUES
-- Văn học - Tiểu thuyết
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),

-- Kỹ năng sống
(11, 11),
(12, 12),
(13, 17),
(18, 17),
(19, 15),
(20, 16),

-- Công nghệ - Lập trình
(14, 19),
(15, 20),
(16, 18),
(21, 19),
(22, 18),
(23, 19),
(24, 20),
(25, 20),

-- Khoa học - AI
(27, 10),
(28, 10),
(29, 10),

-- Giáo dục
(26, 18),
(30, 18),
(31, 18),

-- Lịch sử
(32, 10),
(33, 10),

-- Thiếu nhi
(34, 1),
(35, 1),

-- Ngoại ngữ
(36, 13),
(37, 13),
(38, 13),
(39, 13),
(40, 13),

-- Harry Potter series
(41, 2),
(42, 2),
(43, 2),
(44, 2),
(45, 2),
(46, 2),

-- Twilight series
(47, 5),
(48, 5),
(49, 5),
(50, 5),

-- Sherlock Holmes
(51, 3),
(52, 3),
(53, 3),
(54, 3),
(55, 3),
(56, 3),
(57, 3),
(58, 3),
(59, 3),
(60, 3),

-- Python / Java / IT
(61, 18),
(62, 18),
(63, 18),
(64, 18),
(65, 19),
(66, 19),
(67, 10),
(68, 10),
(69, 18),
(70, 18),

-- Kỹ năng - Kinh tế
(71, 11),
(72, 11),
(73, 15),
(74, 14),
(75, 12),
(76, 12),
(77, 12),
(78, 12),
(79, 12),
(80, 12),

-- Web / DevOps
(81, 20),
(82, 20),
(83, 20),
(84, 20),
(85, 20),
(86, 18),
(87, 18),
(88, 18),
(89, 18),
(90, 18),

-- Truyện tranh - thiếu nhi
(91, 1),
(92, 1),
(93, 1),
(94, 1),
(95, 1),
(96, 1),

-- Giáo trình phổ thông
(97, 18),
(98, 18),
(99, 18),
(100, 18);
--==================
--==================
INSERT INTO users (email, password_hash, full_name, phone, role) VALUES
('user01@test.com', '$2a$10$hash01', 'Nguyễn Văn 01', '0900000001', 'customer'),
('user02@test.com', '$2a$10$hash02', 'Nguyễn Văn 02', '0900000002', 'customer'),
('user03@test.com', '$2a$10$hash03', 'Nguyễn Văn 03', '0900000003', 'customer'),
('user04@test.com', '$2a$10$hash04', 'Nguyễn Văn 04', '0900000004', 'customer'),
('user05@test.com', '$2a$10$hash05', 'Nguyễn Văn 05', '0900000005', 'customer'),
('user06@test.com', '$2a$10$hash06', 'Nguyễn Văn 06', '0900000006', 'customer'),
('user07@test.com', '$2a$10$hash07', 'Nguyễn Văn 07', '0900000007', 'customer'),
('user08@test.com', '$2a$10$hash08', 'Nguyễn Văn 08', '0900000008', 'customer'),
('user09@test.com', '$2a$10$hash09', 'Nguyễn Văn 09', '0900000009', 'customer'),
('user10@test.com', '$2a$10$hash10', 'Nguyễn Văn 10', '0900000010', 'customer'),

('user11@test.com', '$2a$10$hash11', 'Nguyễn Văn 11', '0900000011', 'customer'),
('user12@test.com', '$2a$10$hash12', 'Nguyễn Văn 12', '0900000012', 'customer'),
('user13@test.com', '$2a$10$hash13', 'Nguyễn Văn 13', '0900000013', 'customer'),
('user14@test.com', '$2a$10$hash14', 'Nguyễn Văn 14', '0900000014', 'customer'),
('user15@test.com', '$2a$10$hash15', 'Nguyễn Văn 15', '0900000015', 'customer'),
('user16@test.com', '$2a$10$hash16', 'Nguyễn Văn 16', '0900000016', 'customer'),
('user17@test.com', '$2a$10$hash17', 'Nguyễn Văn 17', '0900000017', 'customer'),
('user18@test.com', '$2a$10$hash18', 'Nguyễn Văn 18', '0900000018', 'customer'),
('user19@test.com', '$2a$10$hash19', 'Nguyễn Văn 19', '0900000019', 'customer'),
('user20@test.com', '$2a$10$hash20', 'Nguyễn Văn 20', '0900000020', 'customer'),

('user21@test.com', '$2a$10$hash21', 'Nguyễn Văn 21', '0900000021', 'customer'),
('user22@test.com', '$2a$10$hash22', 'Nguyễn Văn 22', '0900000022', 'customer'),
('user23@test.com', '$2a$10$hash23', 'Nguyễn Văn 23', '0900000023', 'customer'),
('user24@test.com', '$2a$10$hash24', 'Nguyễn Văn 24', '0900000024', 'customer'),
('user25@test.com', '$2a$10$hash25', 'Nguyễn Văn 25', '0900000025', 'customer'),
('user26@test.com', '$2a$10$hash26', 'Nguyễn Văn 26', '0900000026', 'customer'),
('user27@test.com', '$2a$10$hash27', 'Nguyễn Văn 27', '0900000027', 'customer'),
('user28@test.com', '$2a$10$hash28', 'Nguyễn Văn 28', '0900000028', 'customer'),
('user29@test.com', '$2a$10$hash29', 'Nguyễn Văn 29', '0900000029', 'customer'),
('user30@test.com', '$2a$10$hash30', 'Nguyễn Văn 30', '0900000030', 'customer'),

('user31@test.com', '$2a$10$hash31', 'Nguyễn Văn 31', '0900000031', 'customer'),
('user32@test.com', '$2a$10$hash32', 'Nguyễn Văn 32', '0900000032', 'customer'),
('user33@test.com', '$2a$10$hash33', 'Nguyễn Văn 33', '0900000033', 'customer'),
('user34@test.com', '$2a$10$hash34', 'Nguyễn Văn 34', '0900000034', 'customer'),
('user35@test.com', '$2a$10$hash35', 'Nguyễn Văn 35', '0900000035', 'customer'),
('user36@test.com', '$2a$10$hash36', 'Nguyễn Văn 36', '0900000036', 'customer'),
('user37@test.com', '$2a$10$hash37', 'Nguyễn Văn 37', '0900000037', 'customer'),
('user38@test.com', '$2a$10$hash38', 'Nguyễn Văn 38', '0900000038', 'customer'),
('user39@test.com', '$2a$10$hash39', 'Nguyễn Văn 39', '0900000039', 'customer'),
('user40@test.com', '$2a$10$hash40', 'Nguyễn Văn 40', '0900000040', 'customer'),

('user41@test.com', '$2a$10$hash41', 'Nguyễn Văn 41', '0900000041', 'customer'),
('user42@test.com', '$2a$10$hash42', 'Nguyễn Văn 42', '0900000042', 'customer'),
('user43@test.com', '$2a$10$hash43', 'Nguyễn Văn 43', '0900000043', 'customer'),
('user44@test.com', '$2a$10$hash44', 'Nguyễn Văn 44', '0900000044', 'customer'),
('user45@test.com', '$2a$10$hash45', 'Nguyễn Văn 45', '0900000045', 'customer'),
('user46@test.com', '$2a$10$hash46', 'Nguyễn Văn 46', '0900000046', 'customer'),
('user47@test.com', '$2a$10$hash47', 'Nguyễn Văn 47', '0900000047', 'customer'),
('user48@test.com', '$2a$10$hash48', 'Nguyễn Văn 48', '0900000048', 'customer'),
('user49@test.com', '$2a$10$hash49', 'Nguyễn Văn 49', '0900000049', 'customer'),
('user50@test.com', '$2a$10$hash50', 'Nguyễn Văn 50', '0900000050', 'customer');
-- ==============================
-- INSERT ORDERS
-- ==============================
INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method, payment_status, note)
VALUES
(1, 415000, 'delivered', 'Q1, TP.HCM', 'cod', 'paid', 'Giao giờ hành chính'),
(2, 320000, 'confirmed', 'Q3, TP.HCM', 'vnpay', 'paid', NULL),
(3, 180000, 'pending', 'Hà Nội', 'cod', 'pending', NULL),
(4, 550000, 'shipping', 'Đà Nẵng', 'momo', 'paid', 'Gọi trước khi giao'),
(5, 260000, 'cancelled', 'Cần Thơ', 'cod', 'failed', 'Khách hủy đơn'),

(6, 700000, 'delivered', 'Q7, TP.HCM', 'bank_transfer', 'paid', NULL),
(7, 210000, 'pending', 'Bình Dương', 'cod', 'pending', NULL),
(8, 480000, 'confirmed', 'Biên Hòa', 'vnpay', 'paid', NULL),
(9, 150000, 'delivered', 'Hải Phòng', 'cod', 'paid', NULL),
(10, 330000, 'shipping', 'Nha Trang', 'momo', 'paid', 'Giao buổi tối');
-- ==============================
-- INSERT ORDER ITEMS
-- ==============================

INSERT INTO order_items (order_id, book_id, quantity, unit_price, total_price)
VALUES
-- Order 1 (user 1)
(1, 1, 1, 85000, 85000),
(1, 14, 1, 320000, 320000),

-- Order 2 (user 2)
(2, 11, 2, 90000, 180000),
(2, 12, 1, 120000, 120000),

-- Order 3 (user 3)
(3, 19, 1, 180000, 180000),

-- Order 4 (user 4)
(4, 17, 1, 195000, 195000),
(4, 13, 2, 175000, 350000),

-- Order 5 (user 5 - cancelled)
(5, 20, 1, 165000, 165000),
(5, 71, 1, 90000, 90000),

-- Order 6 (user 6)
(6, 16, 1, 450000, 450000),
(6, 65, 1, 340000, 340000),

-- Order 7 (user 7)
(7, 21, 1, 120000, 120000),
(7, 82, 1, 110000, 110000),

-- Order 8 (user 8)
(8, 27, 1, 460000, 460000),
(8, 91, 1, 35000, 35000),

-- Order 9 (user 9)
(9, 30, 1, 130000, 130000),
(9, 34, 1, 80000, 80000),

-- Order 10 (user 10)
(10, 83, 1, 210000, 210000),
(10, 36, 1, 110000, 110000);
