/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : webbansach

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 07/12/2025 11:47:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of authors
-- ----------------------------
INSERT INTO `authors` VALUES (1, 'Nguyễn Nhật Ánh', 'Việt Nam');
INSERT INTO `authors` VALUES (2, 'Dương Thụ', 'Việt Nam');
INSERT INTO `authors` VALUES (3, 'Bạch Liên', 'Việt Nam');
INSERT INTO `authors` VALUES (4, 'George R. R. Martin', 'Mỹ');
INSERT INTO `authors` VALUES (5, 'J.K. Rowling', 'Anh');
INSERT INTO `authors` VALUES (6, 'Paulo Coelho', 'Brazil');
INSERT INTO `authors` VALUES (7, 'Dale Carnegie', 'Mỹ');
INSERT INTO `authors` VALUES (8, 'Robert T. Kiyosaki', 'Mỹ');
INSERT INTO `authors` VALUES (9, 'Haruki Murakami', 'Nhật Bản');
INSERT INTO `authors` VALUES (10, 'Stephen King', 'Mỹ');
INSERT INTO `authors` VALUES (11, 'Agatha Christie', 'Anh');
INSERT INTO `authors` VALUES (12, 'Gabriel García Márquez', 'Colombia');
INSERT INTO `authors` VALUES (13, 'Ernest Hemingway', 'Mỹ');
INSERT INTO `authors` VALUES (14, 'Dan Brown', 'Mỹ');
INSERT INTO `authors` VALUES (15, 'Malcolm Gladwell', 'Canada');

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author_id` int NULL DEFAULT NULL,
  `author_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `publisher_id` int NULL DEFAULT NULL,
  `publisher_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `category_id` int NOT NULL,
  `price` bigint NOT NULL,
  `original_price` bigint NULL DEFAULT NULL,
  `discount` int NULL DEFAULT 0,
  `pages` int NULL DEFAULT NULL,
  `year` int NULL DEFAULT NULL,
  `rating` double NULL DEFAULT 0,
  `reviews` int NULL DEFAULT 0,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Còn hàng',
  `format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `size` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `stock` int NULL DEFAULT 0,
  `featured` tinyint(1) NULL DEFAULT 0,
  `bestseller` tinyint(1) NULL DEFAULT 0,
  `is_new` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  INDEX `publisher_id`(`publisher_id` ASC) USING BTREE,
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `books_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `books_ibfk_3` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES (1, 'Thỏ Bông', 1, 'Nguyễn Nhật Ánh', 1, 'NXB Trẻ', 5, 120000, 150000, 20, 240, 2020, 4.8, 125, 'Một tác phẩm hay về tình yêu và cuộc sống của các bạn trẻ', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 50, 1, 0, 1);
INSERT INTO `books` VALUES (2, 'Cha Giàu Cha Nghèo', 8, 'Robert T. Kiyosaki', 2, 'NXB Lao Động', 2, 145000, 180000, 19, 336, 2019, 4.9, 892, 'Hướng dẫn cách xây dựng tư duy tài chính và đầu tư thông minh', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 22.5 cm', 120, 1, 1, 0);
INSERT INTO `books` VALUES (3, 'Sapiens', NULL, 'Yuval Noah Harari', 5, 'Penguin Books', 1, 165000, 220000, 25, 512, 2021, 4.7, 654, 'Lịch sử loài người nhìn từ một góc độ hoàn toàn mới', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '15 x 22 cm', 80, 1, 0, 0);
INSERT INTO `books` VALUES (4, 'Đắc Nhân Tâm', 7, 'Dale Carnegie', 2, 'NXB Lao Động', 3, 135000, 160000, 16, 288, 2020, 4.6, 445, 'Những lợi ích trong cuộc sống bằng cách thay đổi tư tưởng', 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14 x 20.5 cm', 95, 0, 1, 0);
INSERT INTO `books` VALUES (5, 'Clean Code', NULL, 'Robert C. Martin', 6, 'Random House', 4, 185000, 240000, 23, 464, 2021, 4.8, 523, 'Hướng dẫn viết code sạch và dễ bảo trì', 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 60, 0, 1, 1);
INSERT INTO `books` VALUES (6, 'Dạy Con Thế Nào?', 1, 'Nguyễn Nhật Ánh', 1, 'NXB Trẻ', 3, 125000, 155000, 19, 256, 2021, 4.5, 234, 'Những cách dạy dỗ con em hiệu quả và khoa học', 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 75, 0, 0, 1);
INSERT INTO `books` VALUES (7, 'The Hobbit', NULL, 'J.R.R. Tolkien', 5, 'Penguin Books', 1, 155000, 200000, 23, 380, 2020, 4.9, 789, 'Cuộc phiêu lưu đầy kỳ diệu của Bilbo Baggins', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 110, 1, 0, 0);
INSERT INTO `books` VALUES (8, 'Lập Trình Java Cơ Bản', NULL, 'Trần Minh Tuấn', 3, 'NXB Hà Nội', 4, 175000, 220000, 20, 520, 2021, 4.7, 312, 'Học lập trình Java từ cơ bản đến nâng cao', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '16 x 24 cm', 45, 0, 1, 1);
INSERT INTO `books` VALUES (9, 'Con Chim Xanh', 3, 'Bạch Liên', 4, 'NXB Kim Đồng', 5, 85000, 110000, 23, 128, 2021, 4.4, 156, 'Truyện kỳ diệu dành cho các bạn nhỏ', 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '13.5 x 19 cm', 200, 0, 0, 0);
INSERT INTO `books` VALUES (10, 'Tiếng Anh Giao Tiếp', NULL, 'Phạm Thị Mai', 2, 'NXB Lao Động', 6, 145000, 180000, 19, 304, 2020, 4.6, 267, 'Học tiếng Anh giao tiếp hàng ngày một cách hiệu quả', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '15 x 21 cm', 130, 0, 0, 0);
INSERT INTO `books` VALUES (11, 'Thất Bại Là Mẹ Của Thành Công', 4, 'George R. R. Martin', 6, 'Random House', 3, 135000, 165000, 18, 272, 2021, 4.5, 189, 'Học cách vượt qua thất bại và đạt được thành công', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 85, 0, 0, 1);
INSERT INTO `books` VALUES (12, 'Cuộc Sống Sau 50 Tuổi', 2, 'Dương Thụ', 1, 'NXB Trẻ', 3, 125000, 160000, 22, 215, 2020, 4.3, 134, 'Hướng dẫn sống sẻ lành mạnh và bình yên sau 50 tuổi', 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14.5 x 20.5 cm', 70, 0, 0, 0);
INSERT INTO `books` VALUES (13, 'Nhà Giả Kim', NULL, 'Paulo Coelho', 1, 'NXB Trẻ', 1, 99000, 125000, 21, 256, 2020, 4.7, 543, 'Hành trình tìm kiếm kho báu nội tâm', 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 150, 1, 1, 0);
INSERT INTO `books` VALUES (14, 'Tư Duy Nhanh và Chậm', NULL, 'Daniel Kahneman', 2, 'NXB Lao Động', 3, 155000, 195000, 20, 456, 2021, 4.8, 432, 'Khám phá hai hệ thống tư duy của con người', 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 88, 0, 1, 0);
INSERT INTO `books` VALUES (15, 'Lập Trình Python', NULL, 'Mark Lutz', 3, 'NXB Hà Nội', 4, 198000, 250000, 21, 640, 2021, 4.9, 567, 'Hướng dẫn toàn diện lập trình Python', 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 52, 1, 1, 1);
INSERT INTO `books` VALUES (16, 'Tôi Có Thể Bảo Vệ Bản Thân Mình', NULL, 'Lê Việt Hà', 1, 'NXB Trẻ', 3, 89000, 115000, 23, 200, 2021, 4.6, 223, 'Hướng dẫn tự vệ cho phụ nữ', 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 200, 0, 0, 1);
INSERT INTO `books` VALUES (17, 'Biết Chút Về Nhiều', NULL, 'Lê Minh', 4, 'NXB Kim Đồng', 1, 115000, 145000, 21, 320, 2020, 4.5, 178, 'Kiến thức tổng hợp về đa lĩnh vực', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 95, 0, 0, 0);
INSERT INTO `books` VALUES (18, 'Kỹ Năng Quản Lý Thời Gian', NULL, 'Nguyễn Dung', 2, 'NXB Lao Động', 3, 79000, 99000, 20, 184, 2021, 4.4, 334, 'Quản lý thời gian hiệu quả', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '13.5 x 19 cm', 240, 0, 0, 1);
INSERT INTO `books` VALUES (19, 'Trí Tuệ Nhân Tạo Giải Thích', NULL, 'Sebastian Thrun', 5, 'Penguin Books', 4, 210000, 270000, 22, 512, 2021, 4.8, 456, 'Hiểu biết sâu về AI và Machine Learning', 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 38, 1, 1, 1);
INSERT INTO `books` VALUES (20, 'Nước Ý Xanh', NULL, 'Đặng Vũ Minh', 1, 'NXB Trẻ', 1, 135000, 168000, 20, 296, 2020, 4.7, 345, 'Tiểu thuyết lãng mạn', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 120, 0, 0, 0);
INSERT INTO `books` VALUES (21, 'Bộ Não Sáng Tạo', NULL, 'David Eagleman', 5, 'Penguin Books', 3, 165000, 210000, 21, 384, 2021, 4.6, 289, 'Khám phá sức mạnh của bộ não', 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 72, 1, 0, 0);
INSERT INTO `books` VALUES (22, 'Web Development Hiện Đại', NULL, 'Kyle Simpson', 3, 'NXB Hà Nội', 4, 189000, 240000, 21, 528, 2021, 4.9, 612, 'Hướng dẫn phát triển web hiện đại', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 66, 0, 1, 1);
INSERT INTO `books` VALUES (23, 'Tiếng Anh Thương Mại', NULL, 'John Smith', 5, 'Penguin Books', 6, 128000, 160000, 20, 272, 2021, 4.5, 198, 'Tiếng Anh chuyên nghiệp cho kinh doanh', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 145, 0, 0, 1);
INSERT INTO `books` VALUES (24, 'Phân Tích Dữ Liệu Với Python', NULL, 'Wes McKinney', 3, 'NXB Hà Nội', 4, 195000, 250000, 22, 600, 2021, 4.8, 478, 'Phân tích dữ liệu chuyên sâu', 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 44, 1, 1, 1);
INSERT INTO `books` VALUES (25, 'Sáng Tạo Không Giới Hạn', NULL, 'Lê Huy Toàn', 1, 'NXB Trẻ', 3, 108000, 135000, 20, 256, 2021, 4.6, 267, 'Phát triển khả năng sáng tạo', 'https://images.unsplash.com/photo-1491841573634-28140fc7ced7?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 180, 0, 0, 1);
INSERT INTO `books` VALUES (26, 'Nơi Đó Có Nắng', 1, 'Nguyễn Nhật Ánh', 1, 'NXB Trẻ', 1, 98000, 125000, 22, 304, 2021, 4.7, 456, 'Chuyện tình yêu trong mưa', 'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 156, 1, 0, 1);
INSERT INTO `books` VALUES (27, 'Hạnh Phúc Không Xa', NULL, 'Trương Thảo', 2, 'NXB Lao Động', 3, 85000, 110000, 23, 192, 2020, 4.4, 189, 'Hạnh phúc trong những điều giản dị', 'https://images.unsplash.com/photo-1509266272358-7701da638078?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '13.5 x 19 cm', 210, 0, 0, 0);
INSERT INTO `books` VALUES (28, 'Kinh Tế Học Vi Mô', NULL, 'Paul Krugman', 5, 'Penguin Books', 2, 189000, 240000, 21, 528, 2021, 4.8, 334, 'Kiến thức kinh tế học vi mô toàn diện', 'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 68, 1, 1, 0);
INSERT INTO `books` VALUES (29, 'Nghệ Thuật Ghi Chép', NULL, 'Sönke Ahrens', 3, 'NXB Hà Nội', 3, 145000, 185000, 22, 352, 2021, 4.7, 412, 'Ghi chép thông minh để học tập hiệu quả', 'https://images.unsplash.com/photo-1526243741027-444d633d7365?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 95, 0, 1, 1);
INSERT INTO `books` VALUES (30, 'Cơn Sóng Lớn', NULL, 'Margaret Mead', 4, 'NXB Kim Đồng', 1, 125000, 160000, 22, 288, 2020, 4.5, 267, 'Nhân học và xã hội học', 'https://images.unsplash.com/photo-1513001900722-370f803f498d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 130, 0, 0, 0);
INSERT INTO `books` VALUES (31, 'JavaScript Tiên Tiến', NULL, 'Nicholas C. Zakas', 3, 'NXB Hà Nội', 4, 175000, 220000, 20, 608, 2021, 4.9, 589, 'Lập trình JavaScript nâng cao', 'https://images.unsplash.com/photo-1519791883288-dc8bd696e667?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 42, 1, 1, 1);
INSERT INTO `books` VALUES (32, 'Tâm Lý Học Tích Cực', NULL, 'Barbara L. Fredrickson', 2, 'NXB Lao Động', 3, 128000, 160000, 20, 304, 2021, 4.6, 298, 'Khám phá sức mạnh tâm lý tích cực', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 162, 0, 0, 1);
INSERT INTO `books` VALUES (33, 'Lịch Sử Thế Giới Ngắn Gọn', NULL, 'Chris Harman', 5, 'Penguin Books', 1, 155000, 200000, 23, 456, 2020, 4.7, 378, 'Tóm tắt lịch sử nhân loại', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 88, 1, 0, 0);
INSERT INTO `books` VALUES (34, 'Quản Lý Dự Án Hiệu Quả', NULL, 'David Cohen', 2, 'NXB Lao Động', 2, 135000, 170000, 21, 272, 2021, 4.5, 223, 'Quản lý dự án chuyên nghiệp', 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14.5 x 20.5 cm', 110, 0, 0, 1);
INSERT INTO `books` VALUES (35, 'Sức Mạnh Của Thói Quen', NULL, 'Charles Duhigg', 1, 'NXB Trẻ', 3, 125000, 160000, 22, 400, 2020, 4.8, 567, 'Thay đổi thói quen để thay đổi cuộc sống', 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 145, 1, 1, 0);
INSERT INTO `books` VALUES (36, 'Database Thiết Kế', NULL, 'C.J. Date', 3, 'NXB Hà Nội', 4, 198000, 250000, 21, 560, 2021, 4.7, 289, 'Thiết kế cơ sở dữ liệu tối ưu', 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 36, 0, 1, 1);
INSERT INTO `books` VALUES (37, 'Tiếng Pháp Cho Người Mới', NULL, 'Michel Thomas', 5, 'Penguin Books', 6, 135000, 175000, 23, 256, 2020, 4.5, 198, 'Học tiếng Pháp từ đầu', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 124, 0, 0, 0);
INSERT INTO `books` VALUES (38, 'Triết Học Phương Đông', NULL, 'Alan Watts', 1, 'NXB Trẻ', 1, 105000, 135000, 22, 320, 2021, 4.6, 245, 'Hiểu biết về triết học phương Đông', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 176, 1, 0, 1);
INSERT INTO `books` VALUES (39, 'Bán Hàng Thuyết Phục', NULL, 'Robert Cialdini', 2, 'NXB Lao Động', 2, 145000, 185000, 22, 336, 2021, 4.8, 423, 'Kỹ năng bán hàng chuyên nghiệp', 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 84, 0, 1, 0);
INSERT INTO `books` VALUES (40, 'Toán Học Thú Vị', NULL, 'Edward Frenkel', 4, 'NXB Kim Đồng', 4, 128000, 165000, 23, 384, 2020, 4.4, 167, 'Khám phá vẻ đẹp của toán học', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 67, 1, 0, 0);
INSERT INTO `books` VALUES (41, 'Rừng Na Uy', 9, 'Haruki Murakami', 1, 'NXB Trẻ', 1, 125000, 155000, 19, 432, 2022, 4.8, 678, 'Câu chuyện tình yêu đẹp buồn và sâu lắng của Toru Watanabe', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 21 cm', 85, 1, 1, 1);
INSERT INTO `books` VALUES (42, 'Kafka Bên Bờ Biển', 9, 'Haruki Murakami', 5, 'Penguin Books', 1, 145000, 185000, 22, 505, 2021, 4.7, 534, 'Hành trình tìm kiếm bản ngã kỳ lạ của cậu bé 15 tuổi', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 65, 1, 0, 1);
INSERT INTO `books` VALUES (43, 'Trăm Năm Cô Đơn', 12, 'Gabriel García Márquez', 6, 'Random House', 1, 175000, 220000, 20, 528, 2020, 4.9, 892, 'Siêu phẩm văn học hiện thực huyền ảo về gia tộc Buendía', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15.5 x 23 cm', 45, 1, 1, 0);
INSERT INTO `books` VALUES (44, 'Ông Già và Biển Cả', 13, 'Ernest Hemingway', 5, 'Penguin Books', 1, 89000, 115000, 23, 127, 2021, 4.6, 445, 'Cuộc chiến đấu giữa con người và thiên nhiên hoang dã', 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '13 x 19 cm', 150, 0, 1, 0);
INSERT INTO `books` VALUES (45, 'IT - Chú Hề Ma Quái', 10, 'Stephen King', 6, 'Random House', 1, 195000, 250000, 22, 1138, 2022, 4.8, 723, 'Kiệt tác kinh dị về nỗi sợ hãi tuổi thơ', 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 55, 1, 1, 1);
INSERT INTO `books` VALUES (46, 'Outliers - Những Kẻ Xuất Chúng', 15, 'Malcolm Gladwell', 2, 'NXB Lao Động', 2, 135000, 170000, 21, 309, 2021, 4.7, 567, 'Khám phá bí mật thành công của những người xuất chúng', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14.5 x 21 cm', 95, 1, 1, 0);
INSERT INTO `books` VALUES (47, 'Điểm Bùng Phát', 15, 'Malcolm Gladwell', 2, 'NXB Lao Động', 2, 128000, 160000, 20, 280, 2020, 4.6, 423, 'Làm thế nào những thay đổi nhỏ tạo ra khác biệt lớn', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20.5 cm', 88, 0, 1, 0);
INSERT INTO `books` VALUES (48, 'Nghĩ Giàu Làm Giàu', NULL, 'Napoleon Hill', 2, 'NXB Lao Động', 2, 115000, 145000, 21, 320, 2019, 4.8, 1234, 'Triết lý làm giàu bất hủ từ thế kỷ 20', 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 180, 1, 1, 0);
INSERT INTO `books` VALUES (49, 'Từ Tốt Đến Vĩ Đại', NULL, 'Jim Collins', 5, 'Penguin Books', 2, 165000, 210000, 21, 400, 2021, 4.7, 389, 'Nghiên cứu về các công ty chuyển mình thành vĩ đại', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '15 x 22 cm', 72, 0, 1, 1);
INSERT INTO `books` VALUES (50, 'Chiến Lược Đại Dương Xanh', NULL, 'W. Chan Kim', 6, 'Random House', 2, 155000, 195000, 21, 352, 2020, 4.6, 298, 'Tạo ra thị trường không cạnh tranh', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '15.5 x 23 cm', 65, 1, 0, 0);
INSERT INTO `books` VALUES (51, '7 Thói Quen Hiệu Quả', NULL, 'Stephen Covey', 1, 'NXB Trẻ', 3, 145000, 185000, 22, 432, 2021, 4.9, 876, 'Những nguyên tắc sống và làm việc hiệu quả', 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 120, 1, 1, 0);
INSERT INTO `books` VALUES (52, 'Đừng Bao Giờ Đi Ăn Một Mình', NULL, 'Keith Ferrazzi', 2, 'NXB Lao Động', 3, 118000, 150000, 21, 368, 2020, 4.5, 345, 'Nghệ thuật xây dựng mối quan hệ', 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 95, 0, 0, 1);
INSERT INTO `books` VALUES (53, 'Cách Đọc Sách Hiệu Quả', NULL, 'Mortimer Adler', 3, 'NXB Hà Nội', 3, 98000, 125000, 22, 288, 2021, 4.6, 267, 'Phương pháp đọc sách thông minh và ghi nhớ lâu', 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '13.5 x 19 cm', 145, 0, 1, 0);
INSERT INTO `books` VALUES (54, 'Tối Giản - Less Is More', NULL, 'Fumio Sasaki', 1, 'NXB Trẻ', 3, 108000, 138000, 22, 256, 2022, 4.7, 456, 'Sống đơn giản và hạnh phúc hơn', 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '14 x 20 cm', 200, 1, 0, 1);
INSERT INTO `books` VALUES (55, 'Sức Mạnh Của Tập Trung', NULL, 'Cal Newport', 5, 'Penguin Books', 3, 135000, 170000, 21, 304, 2021, 4.8, 523, 'Làm việc sâu trong thế giới xao nhãng', 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '14.5 x 21 cm', 78, 1, 1, 0);
INSERT INTO `books` VALUES (56, 'The Pragmatic Programmer', NULL, 'David Thomas', 6, 'Random House', 4, 225000, 285000, 21, 544, 2022, 4.9, 678, 'Từ người học việc đến bậc thầy lập trình', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 45, 1, 1, 1);
INSERT INTO `books` VALUES (57, 'Design Patterns', NULL, 'Gang of Four', 3, 'NXB Hà Nội', 4, 245000, 310000, 21, 395, 2021, 4.8, 567, 'Mẫu thiết kế hướng đối tượng tái sử dụng', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '16 x 24 cm', 38, 0, 1, 0);
INSERT INTO `books` VALUES (58, 'Cracking The Coding Interview', NULL, 'Gayle McDowell', 5, 'Penguin Books', 4, 275000, 350000, 21, 687, 2022, 4.9, 892, '189 câu hỏi phỏng vấn lập trình', 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '17 x 24 cm', 52, 1, 1, 1);
INSERT INTO `books` VALUES (59, 'Mật Mã Da Vinci', 14, 'Dan Brown', 6, 'Random House', 1, 155000, 195000, 21, 489, 2020, 4.7, 723, 'Cuộc săn tìm bí mật ngàn năm', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa mềm', '15 x 22 cm', 110, 1, 1, 0);
INSERT INTO `books` VALUES (60, 'Hoàng Tử Bé', NULL, 'Antoine de Saint-Exupéry', 4, 'NXB Kim Đồng', 5, 75000, 98000, 23, 96, 2021, 4.9, 1456, 'Câu chuyện triết lý đầy ý nghĩa về tình bạn và tình yêu', 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&h=600&fit=crop', 'Còn hàng', 'Bìa cứng', '13.5 x 19 cm', 250, 1, 1, 0);

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `count` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Văn Học', '📖', 'Các tác phẩm văn học kinh điển và hiện đại', 1250);
INSERT INTO `categories` VALUES (2, 'Sách Kinh Tế', '💼', 'Sách về kinh doanh, tài chính và quản lý', 890);
INSERT INTO `categories` VALUES (3, 'Kỹ Năng Sống', '💪', 'Phát triển kỹ năng cá nhân và chuyên môn', 750);
INSERT INTO `categories` VALUES (4, 'Công Nghệ', '💻', 'Sách về lập trình, web, AI và công nghệ', 620);
INSERT INTO `categories` VALUES (5, 'Trẻ Em', '👶', 'Sách truyện và học tập cho trẻ em', 540);
INSERT INTO `categories` VALUES (6, 'Ngoại Ngữ', '🌍', 'Sách học tiếng Anh, Trung, Nhật...', 430);

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `book_id` int NOT NULL,
  `book_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` bigint NOT NULL,
  `total_price` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id` ASC) USING BTREE,
  INDEX `book_id`(`book_id` ASC) USING BTREE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 1, 'Thá» BÃ´ng', 1, 120000, 120000, '2025-12-06 22:07:30');
INSERT INTO `order_items` VALUES (2, 2, 1, 'Thá» BÃ´ng', 1, 120000, 120000, '2025-12-06 22:07:30');
INSERT INTO `order_items` VALUES (3, 3, 1, 'Thá» BÃ´ng', 1, 120000, 120000, '2025-12-06 22:07:51');
INSERT INTO `order_items` VALUES (4, 4, 1, 'Thá» BÃ´ng', 1, 120000, 120000, '2025-12-06 22:07:51');
INSERT INTO `order_items` VALUES (5, 3, 2, 'Cha GiÃ u Cha NghÃ¨o', 1, 145000, 145000, '2025-12-06 22:07:51');
INSERT INTO `order_items` VALUES (6, 4, 2, 'Cha GiÃ u Cha NghÃ¨o', 1, 145000, 145000, '2025-12-06 22:07:51');
INSERT INTO `order_items` VALUES (7, 6, 2, 'Cha GiÃ u Cha NghÃ¨o', 1, 145000, 145000, '2025-12-06 22:13:03');
INSERT INTO `order_items` VALUES (8, 5, 2, 'Cha GiÃ u Cha NghÃ¨o', 1, 145000, 145000, '2025-12-06 22:13:03');
INSERT INTO `order_items` VALUES (9, 6, 3, 'Sapiens', 2, 165000, 330000, '2025-12-06 22:13:03');
INSERT INTO `order_items` VALUES (10, 5, 3, 'Sapiens', 2, 165000, 330000, '2025-12-06 22:13:03');
INSERT INTO `order_items` VALUES (11, 7, 11, 'Thất Bại Là Mẹ Của Thành Công', 3, 135000, 405000, '2025-12-07 09:14:25');
INSERT INTO `order_items` VALUES (12, 7, 10, 'Tiếng Anh Giao Tiếp', 2, 145000, 290000, '2025-12-07 09:14:25');
INSERT INTO `order_items` VALUES (13, 8, 2, 'Cha Giàu Cha Nghèo', 5, 145000, 725000, '2025-12-07 09:16:00');
INSERT INTO `order_items` VALUES (14, 8, 6, 'Dạy Con Thế Nào?', 1, 125000, 125000, '2025-12-07 09:16:00');
INSERT INTO `order_items` VALUES (15, 8, 11, 'Thất Bại Là Mẹ Của Thành Công', 1, 135000, 135000, '2025-12-07 09:16:00');
INSERT INTO `order_items` VALUES (16, 8, 10, 'Tiếng Anh Giao Tiếp', 1, 145000, 145000, '2025-12-07 09:16:00');
INSERT INTO `order_items` VALUES (17, 9, 15, 'Lập Trình Python', 1, 198000, 198000, '2025-12-07 09:24:38');
INSERT INTO `order_items` VALUES (18, 9, 31, 'JavaScript Tiên Tiến', 2, 175000, 350000, '2025-12-07 09:24:38');
INSERT INTO `order_items` VALUES (19, 9, 7, 'The Hobbit', 1, 155000, 155000, '2025-12-07 09:24:38');
INSERT INTO `order_items` VALUES (20, 10, 15, 'Lập Trình Python', 1, 198000, 198000, '2025-12-07 09:40:23');
INSERT INTO `order_items` VALUES (21, 10, 31, 'JavaScript Tiên Tiến', 2, 175000, 350000, '2025-12-07 09:40:23');
INSERT INTO `order_items` VALUES (22, 11, 7, 'The Hobbit', 3, 155000, 465000, '2025-12-07 09:42:46');
INSERT INTO `order_items` VALUES (23, 11, 1, 'Thỏ Bông', 3, 120000, 360000, '2025-12-07 09:42:46');
INSERT INTO `order_items` VALUES (24, 11, 2, 'Cha Giàu Cha Nghèo', 3, 145000, 435000, '2025-12-07 09:42:46');
INSERT INTO `order_items` VALUES (25, 13, 1, 'Thỏ Bông', 3, 120000, 360000, '2025-12-07 10:19:26');
INSERT INTO `order_items` VALUES (26, 12, 1, 'Thỏ Bông', 3, 120000, 360000, '2025-12-07 10:19:26');
INSERT INTO `order_items` VALUES (27, 12, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 10:19:26');
INSERT INTO `order_items` VALUES (28, 13, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 10:19:26');
INSERT INTO `order_items` VALUES (29, 15, 3, 'Sapiens', 2, 165000, 330000, '2025-12-07 10:37:45');
INSERT INTO `order_items` VALUES (30, 14, 3, 'Sapiens', 2, 165000, 330000, '2025-12-07 10:37:45');
INSERT INTO `order_items` VALUES (31, 14, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 10:37:45');
INSERT INTO `order_items` VALUES (32, 15, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 10:37:45');
INSERT INTO `order_items` VALUES (33, 16, 6, 'Dạy Con Thế Nào?', 2, 125000, 250000, '2025-12-07 10:38:53');
INSERT INTO `order_items` VALUES (34, 17, 6, 'Dạy Con Thế Nào?', 2, 125000, 250000, '2025-12-07 10:38:53');
INSERT INTO `order_items` VALUES (35, 19, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 11:06:13');
INSERT INTO `order_items` VALUES (36, 18, 2, 'Cha Giàu Cha Nghèo', 1, 145000, 145000, '2025-12-07 11:06:13');
INSERT INTO `order_items` VALUES (37, 19, 1, 'Thỏ Bông', 1, 120000, 120000, '2025-12-07 11:06:13');
INSERT INTO `order_items` VALUES (38, 18, 1, 'Thỏ Bông', 1, 120000, 120000, '2025-12-07 11:06:13');
INSERT INTO `order_items` VALUES (39, 21, 2, 'Cha Giàu Cha Nghèo', 2, 145000, 290000, '2025-12-07 11:46:05');
INSERT INTO `order_items` VALUES (40, 20, 2, 'Cha Giàu Cha Nghèo', 2, 145000, 290000, '2025-12-07 11:46:05');
INSERT INTO `order_items` VALUES (41, 22, 1, 'Thỏ Bông', 1, 120000, 120000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (42, 23, 1, 'Thỏ Bông', 1, 120000, 120000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (43, 22, 6, 'Dạy Con Thế Nào?', 1, 125000, 125000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (44, 23, 6, 'Dạy Con Thế Nào?', 1, 125000, 125000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (45, 22, 7, 'The Hobbit', 1, 155000, 155000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (46, 23, 7, 'The Hobbit', 1, 155000, 155000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (47, 22, 8, 'Lập Trình Java Cơ Bản', 4, 175000, 700000, '2025-12-07 11:46:38');
INSERT INTO `order_items` VALUES (48, 23, 8, 'Lập Trình Java Cơ Bản', 4, 175000, 700000, '2025-12-07 11:46:38');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `fullname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'standard',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'vnpay',
  `total_amount` bigint NOT NULL,
  `shipping_cost` bigint NULL DEFAULT 0,
  `final_amount` bigint NOT NULL,
  `order_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `payment_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `vnp_txn_ref` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `vnp_transaction_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 120000, 0, 120000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:07:30', '2025-12-06 22:07:30');
INSERT INTO `orders` VALUES (2, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 120000, 0, 120000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:07:30', '2025-12-06 22:07:30');
INSERT INTO `orders` VALUES (3, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '100000', 'test', 365000, 0, 365000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:07:51', '2025-12-06 22:07:51');
INSERT INTO `orders` VALUES (4, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '100000', 'test', 365000, 0, 365000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:07:51', '2025-12-06 22:07:51');
INSERT INTO `orders` VALUES (5, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 475000, 0, 475000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:13:03', '2025-12-06 22:13:03');
INSERT INTO `orders` VALUES (6, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 475000, 0, 475000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-06 22:13:03', '2025-12-06 22:13:03');
INSERT INTO `orders` VALUES (7, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 695000, 0, 695000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 09:14:24', '2025-12-07 09:14:24');
INSERT INTO `orders` VALUES (8, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 1130000, 0, 1130000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 09:16:00', '2025-12-07 09:16:00');
INSERT INTO `orders` VALUES (9, 1, 'van truong', '0123465789', 'shadowlizard@vregion.ru', '80b Duong15 Phuoc Binh, ahah, Ho Chi Minh Quan 9', '0', 'test', 703000, 0, 703000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 09:24:38', '2025-12-07 09:24:38');
INSERT INTO `orders` VALUES (10, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 548000, 0, 548000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 09:40:23', '2025-12-07 09:40:23');
INSERT INTO `orders` VALUES (11, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 1260000, 0, 1260000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 09:42:46', '2025-12-07 09:42:46');
INSERT INTO `orders` VALUES (12, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 505000, 0, 505000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 10:19:26', '2025-12-07 10:19:26');
INSERT INTO `orders` VALUES (13, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 505000, 0, 505000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 10:19:26', '2025-12-07 10:19:26');
INSERT INTO `orders` VALUES (14, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 475000, 0, 475000, 'pending', 'pending', '76887197', NULL, NULL, '2025-12-07 10:37:45', '2025-12-07 10:37:45');
INSERT INTO `orders` VALUES (15, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 475000, 0, 475000, 'pending', 'paid', '17957289', '15324816', NULL, '2025-12-07 10:37:45', '2025-12-07 10:38:10');
INSERT INTO `orders` VALUES (16, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 250000, 0, 250000, 'pending', 'pending', '58368599', NULL, NULL, '2025-12-07 10:38:53', '2025-12-07 10:38:53');
INSERT INTO `orders` VALUES (17, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 250000, 0, 250000, 'pending', 'paid', '46274438', '15324818', NULL, '2025-12-07 10:38:53', '2025-12-07 10:39:17');
INSERT INTO `orders` VALUES (18, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 265000, 0, 265000, 'pending', 'paid', '22039099', '15324846', NULL, '2025-12-07 11:06:13', '2025-12-07 11:06:33');
INSERT INTO `orders` VALUES (19, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '0', 'vnpay', 265000, 0, 265000, 'pending', 'pending', '95230225', NULL, NULL, '2025-12-07 11:06:13', '2025-12-07 11:06:13');
INSERT INTO `orders` VALUES (20, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 290000, 0, 290000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 11:46:05', '2025-12-07 11:46:05');
INSERT INTO `orders` VALUES (21, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, ahah, Ho Chi Minh Quan 9', '0', 'test', 290000, 0, 290000, 'confirmed', 'paid', NULL, NULL, '', '2025-12-07 11:46:05', '2025-12-07 11:46:05');
INSERT INTO `orders` VALUES (22, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '100000', 'vnpay', 1200000, 0, 1200000, 'pending', 'pending', '56565762', NULL, NULL, '2025-12-07 11:46:38', '2025-12-07 11:46:38');
INSERT INTO `orders` VALUES (23, 2, 'ga', '0123456789', 'ga@gmail.com', '123456, Ho Chi Minh Quan 9, ahah', '100000', 'vnpay', 1200000, 0, 1200000, 'pending', 'paid', '16510658', '15324879', NULL, '2025-12-07 11:46:38', '2025-12-07 11:47:23');

-- ----------------------------
-- Table structure for publishers
-- ----------------------------
DROP TABLE IF EXISTS `publishers`;
CREATE TABLE `publishers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of publishers
-- ----------------------------
INSERT INTO `publishers` VALUES (1, 'NXB Trẻ', 'Việt Nam');
INSERT INTO `publishers` VALUES (2, 'NXB Lao Động', 'Việt Nam');
INSERT INTO `publishers` VALUES (3, 'NXB Hà Nội', 'Việt Nam');
INSERT INTO `publishers` VALUES (4, 'NXB Kim Đồng', 'Việt Nam');
INSERT INTO `publishers` VALUES (5, 'Penguin Books', 'Anh');
INSERT INTO `publishers` VALUES (6, 'Random House', 'Mỹ');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fullname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'shadowlizard@vregion.ru', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'van truong', '0123465789', '80b Duong15 Phuoc Binh', '2025-12-06 21:39:40', '2025-12-06 21:39:40');
INSERT INTO `users` VALUES (2, 'ga@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'ga', '0123456789', '123456', '2025-12-07 09:15:31', '2025-12-07 09:15:31');

SET FOREIGN_KEY_CHECKS = 1;
