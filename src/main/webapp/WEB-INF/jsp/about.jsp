<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Về BookStore - Giới thiệu">
    <title>Về BookStore - Giới Thiệu</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <h1 class="page-title">Về BookStore</h1>

            <!-- About Section -->
            <section class="about-section" style="margin-bottom: 60px;">
                <div class="about-intro" style="background-color: #f9f9f9; padding: 40px; border-radius: 8px; margin-bottom: 40px;">
                    <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 16px;">Câu Chuyện Của Chúng Tôi</h2>
                    <p style="font-size: 16px; line-height: 1.8; color: #666; margin-bottom: 16px;">
                        BookStore được thành lập vào năm 2020 với mục tiêu mang tri thức đến tay mọi người. Chúng tôi tin rằng sách là cánh cửa mở ra những thế giới mới và giúp con người phát triển tư duy.
                    </p>
                    <p style="font-size: 16px; line-height: 1.8; color: #666;">
                        Ngày nay, BookStore tự hào là một trong những nhà sách trực tuyến lớn nhất với hơn 100.000 cuốn sách từ các tác giả trong và ngoài nước.
                    </p>
                </div>

                <div class="about-highlights" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px;">
                    <div class="highlight-card" style="background-color: #f0f7ff; padding: 24px; border-radius: 8px; text-align: center;">
                        <div class="highlight-icon" style="font-size: 48px; margin-bottom: 16px;">📚</div>
                        <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Sách Đa Dạng</h3>
                        <p style="color: #666; font-size: 14px;">Hơn 100.000 cuốn sách</p>
                    </div>

                    <div class="highlight-card" style="background-color: #f0fff4; padding: 24px; border-radius: 8px; text-align: center;">
                        <div class="highlight-icon" style="font-size: 48px; margin-bottom: 16px;">🚚</div>
                        <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Giao Hàng Nhanh</h3>
                        <p style="color: #666; font-size: 14px;">Miễn phí từ 100.000đ</p>
                    </div>

                    <div class="highlight-card" style="background-color: #fffaf0; padding: 24px; border-radius: 8px; text-align: center;">
                        <div class="highlight-icon" style="font-size: 48px; margin-bottom: 16px;">💬</div>
                        <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Hỗ Trợ 24/7</h3>
                        <p style="color: #666; font-size: 14px;">Sẵn sàng giúp đỡ bạn</p>
                    </div>

                    <div class="highlight-card" style="background-color: #fef0ff; padding: 24px; border-radius: 8px; text-align: center;">
                        <div class="highlight-icon" style="font-size: 48px; margin-bottom: 16px;">✓</div>
                        <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px;">Hàng Chính Hãng</h3>
                        <p style="color: #666; font-size: 14px;">Đảm bảo chất lượng</p>
                    </div>
                </div>
            </section>

            <!-- Mission & Vision -->
            <section class="mission-vision" style="margin-bottom: 60px;">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">
                    <div style="background-color: #e8f5e9; padding: 30px; border-radius: 8px;">
                        <h3 style="font-size: 20px; font-weight: bold; margin-bottom: 16px; color: #2e7d32;">🎯 Sứ Mệnh</h3>
                        <p style="font-size: 16px; line-height: 1.8; color: #666;">
                            Cung cấp sách chất lượng cao với giá tốt nhất, giúp độc giả tiếp cận kiến thức mà không gặp khó khăn về tài chính. Chúng tôi muốn trở thành cầu nối giữa tác giả và độc giả, nâng cao văn hóa đọc sách tại Việt Nam.
                        </p>
                    </div>

                    <div style="background-color: #e3f2fd; padding: 30px; border-radius: 8px;">
                        <h3 style="font-size: 20px; font-weight: bold; margin-bottom: 16px; color: #1565c0;">🌟 Tầm Nhìn</h3>
                        <p style="font-size: 16px; line-height: 1.8; color: #666;">
                            Trở thành nhà sách trực tuyến hàng đầu tại Đông Nam Á, nơi mọi người có thể tìm thấy sách yêu thích của mình và phát triển bản thân thông qua đọc sách. Mục tiêu của chúng tôi là khuyến khích tình yêu thích đọc sách từ trẻ nhỏ đến người lớn.
                        </p>
                    </div>
                </div>
            </section>

            <!-- Values -->
            <section class="values" style="margin-bottom: 60px;">
                <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 32px; text-align: center;">Giá Trị Cốt Lõi</h2>
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;">
                    <div style="border-left: 4px solid #4CAF50; padding: 20px; background-color: #f9f9f9; border-radius: 4px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #4CAF50;">Chất Lượng</h4>
                        <p style="color: #666; line-height: 1.6;">Chúng tôi chỉ bán các sách chính hãng từ các nhà xuất bản uy tín.</p>
                    </div>

                    <div style="border-left: 4px solid #2196F3; padding: 20px; background-color: #f9f9f9; border-radius: 4px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #2196F3;">Uy Tín</h4>
                        <p style="color: #666; line-height: 1.6;">Tất cả giao dịch được bảo vệ và minh bạch. Chúng tôi cam kết bảo mật thông tin khách hàng.</p>
                    </div>

                    <div style="border-left: 4px solid #ff9800; padding: 20px; background-color: #f9f9f9; border-radius: 4px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #ff9800;">Tâm Lý</h4>
                        <p style="color: #666; line-height: 1.6;">Khách hàng là trung tâm của mọi hoạt động của chúng tôi.</p>
                    </div>
                </div>
            </section>

            <!-- Statistics -->
            <section class="statistics" style="background-color: #2c3e50; color: white; padding: 60px 40px; border-radius: 8px; margin-bottom: 60px;">
                <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 40px; text-align: center;">Con Số Của BookStore</h2>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px; text-align: center;">
                    <div>
                        <div style="font-size: 48px; font-weight: bold; margin-bottom: 8px; color: #4CAF50;">100K+</div>
                        <p>Cuốn Sách</p>
                    </div>

                    <div>
                        <div style="font-size: 48px; font-weight: bold; margin-bottom: 8px; color: #2196F3;">50K+</div>
                        <p>Khách Hàng Hài Lòng</p>
                    </div>

                    <div>
                        <div style="font-size: 48px; font-weight: bold; margin-bottom: 8px; color: #ff9800;">1000+</div>
                        <p>Tác Giả & NXB</p>
                    </div>

                    <div>
                        <div style="font-size: 48px; font-weight: bold; margin-bottom: 8px; color: #e91e63;">4.8/5⭐</div>
                        <p>Đánh Giá Trung Bình</p>
                    </div>
                </div>
            </section>

            <!-- Team Section -->
            <section class="team" style="margin-bottom: 60px;">
                <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 40px; text-align: center;">Đội Ngũ Của Chúng Tôi</h2>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px;">
                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 60px; margin-bottom: 12px;">👨‍💼</div>
                        <h4 style="font-weight: bold; margin-bottom: 4px;">Nguyễn Văn A</h4>
                        <p style="color: #666; font-size: 14px;">Giám Đốc Điều Hành</p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 60px; margin-bottom: 12px;">👩‍💼</div>
                        <h4 style="font-weight: bold; margin-bottom: 4px;">Trần Thị B</h4>
                        <p style="color: #666; font-size: 14px;">Trưởng Phòng Bán Hàng</p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 60px; margin-bottom: 12px;">👨‍💻</div>
                        <h4 style="font-weight: bold; margin-bottom: 4px;">Lê Văn C</h4>
                        <p style="color: #666; font-size: 14px;">Quản Lý Kho</p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 60px; margin-bottom: 12px;">👩‍🔬</div>
                        <h4 style="font-weight: bold; margin-bottom: 4px;">Phạm Thị D</h4>
                        <p style="color: #666; font-size: 14px;">Chuyên Viên Khách Hàng</p>
                    </div>
                </div>
            </section>

            <!-- Contact CTA -->
            <section style="background-color: #e3f2fd; padding: 40px; border-radius: 8px; text-align: center;">
                <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 16px;">Có Câu Hỏi?</h2>
                <p style="font-size: 16px; color: #666; margin-bottom: 24px;">
                    Chúng tôi sẵn sàng trả lời bất kỳ câu hỏi nào của bạn. Liên hệ với chúng tôi ngay hôm nay!
                </p>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary" style="display: inline-block; padding: 12px 30px; background-color: #2196F3; color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">
                    Liên Hệ Chúng Tôi
                </a>
            </section>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
</body>
</html>

