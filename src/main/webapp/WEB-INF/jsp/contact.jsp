<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Liên hệ - BookStore">
    <title>Liên Hệ - BookStore</title>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <h1 class="page-title">Liên Hệ Với Chúng Tôi</h1>

            <!-- Success/Error Messages -->
            <c:if test="${success != null}">
                <div style="background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px 16px; border-radius: 4px; margin-bottom: 24px;">
                    ✓ ${success}
                </div>
            </c:if>

            <c:if test="${error != null}">
                <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 12px 16px; border-radius: 4px; margin-bottom: 24px;">
                    ✗ ${error}
                </div>
            </c:if>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 60px;">
                <!-- Contact Form -->
                <div>
                    <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 24px;">Gửi Tin Nhắn Cho Chúng Tôi</h2>
                    
                    <form method="post" action="${pageContext.request.contextPath}/contact" style="display: flex; flex-direction: column; gap: 16px;">
                        <div>
                            <label for="name" style="display: block; margin-bottom: 8px; font-weight: bold;">Họ và Tên *</label>
                            <input type="text" id="name" name="name" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                        </div>

                        <div>
                            <label for="email" style="display: block; margin-bottom: 8px; font-weight: bold;">Email *</label>
                            <input type="email" id="email" name="email" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                        </div>

                        <div>
                            <label for="subject" style="display: block; margin-bottom: 8px; font-weight: bold;">Chủ Đề *</label>
                            <input type="text" id="subject" name="subject" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
                        </div>

                        <div>
                            <label for="message" style="display: block; margin-bottom: 8px; font-weight: bold;">Nội Dung *</label>
                            <textarea id="message" name="message" rows="6" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; resize: vertical;"></textarea>
                        </div>

                        <button type="submit" style="padding: 12px 24px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 16px;">
                            Gửi Tin Nhắn
                        </button>
                    </form>
                </div>

                <!-- Contact Information -->
                <div>
                    <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 24px;">Thông Tin Liên Hệ</h2>

                    <div style="background-color: #f9f9f9; padding: 24px; border-radius: 8px; margin-bottom: 20px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #333;">📍 Địa Chỉ</h4>
                        <p style="color: #666; margin: 0;">
                            Tầng 5, Tòa nhà ABC<br>
                            Đường Lê Lợi, Quận 1<br>
                            TP. Hồ Chí Minh, Việt Nam
                        </p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 24px; border-radius: 8px; margin-bottom: 20px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #333;">📞 Điện Thoại</h4>
                        <p style="color: #666; margin: 0;">
                            <a href="tel:1800-1234" style="color: #2196F3; text-decoration: none;">1800-1234</a><br>
                            <a href="tel:+84-28-12345678" style="color: #2196F3; text-decoration: none;">+84-28-12345678</a>
                        </p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 24px; border-radius: 8px; margin-bottom: 20px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #333;">📧 Email</h4>
                        <p style="color: #666; margin: 0;">
                            <a href="mailto:support@bookstore.com" style="color: #2196F3; text-decoration: none;">support@bookstore.com</a><br>
                            <a href="mailto:info@bookstore.com" style="color: #2196F3; text-decoration: none;">info@bookstore.com</a>
                        </p>
                    </div>

                    <div style="background-color: #f9f9f9; padding: 24px; border-radius: 8px;">
                        <h4 style="font-size: 16px; font-weight: bold; margin-bottom: 12px; color: #333;">⏰ Giờ Làm Việc</h4>
                        <p style="color: #666; margin: 0;">
                            Thứ Hai - Thứ Sáu: 08:00 - 17:00<br>
                            Thứ Bảy: 09:00 - 15:00<br>
                            Chủ Nhật: Đóng cửa
                        </p>
                    </div>
                </div>
            </div>

            <!-- Map Section -->
            <section style="margin-bottom: 60px;">
                <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 24px; text-align: center;">Tìm Chúng Tôi Trên Bản Đồ</h2>
                <div style="background-color: #e0e0e0; border-radius: 8px; overflow: hidden; height: 400px;">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.0370848181473!2d106.66303611525835!3d10.778850589373414!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f3b3b3b3b3d%3A0x3b3b3b3b3b3b3b3b!2sHo%20Chi%20Minh%20City!5e0!3m2!1svi!2svn!4v1234567890" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </section>

            <!-- FAQ Section -->
            <section style="margin-bottom: 60px;">
                <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 32px; text-align: center;">Câu Hỏi Thường Gặp</h2>

                <div style="max-width: 800px; margin: 0 auto;">
                    <details style="margin-bottom: 16px;">
                        <summary style="padding: 16px; background-color: #f9f9f9; border-radius: 4px; cursor: pointer; font-weight: bold; user-select: none;">
                            Các phương thức thanh toán nào mà BookStore hỗ trợ?
                        </summary>
                        <div style="padding: 16px; background-color: #fafafa; border-radius: 4px; margin-top: 8px;">
                            BookStore hỗ trợ nhiều phương thức thanh toán bao gồm: Thanh Toán Khi Nhận Hàng (COD), Chuyển Khoản Ngân Hàng, và Thẻ Tín Dụng / Debit. Bạn có thể chọn phương thức phù hợp nhất khi thanh toán.
                        </div>
                    </details>

                    <details style="margin-bottom: 16px;">
                        <summary style="padding: 16px; background-color: #f9f9f9; border-radius: 4px; cursor: pointer; font-weight: bold; user-select: none;">
                            BookStore có chính sách đổi trả không?
                        </summary>
                        <div style="padding: 16px; background-color: #fafafa; border-radius: 4px; margin-top: 8px;">
                            Có, BookStore hỗ trợ đổi trả sản phẩm trong vòng 30 ngày từ ngày nhận hàng. Sản phẩm phải còn nguyên vẹn, chưa sử dụng và còn đầy đủ bao bì original.
                        </div>
                    </details>

                    <details style="margin-bottom: 16px;">
                        <summary style="padding: 16px; background-color: #f9f9f9; border-radius: 4px; cursor: pointer; font-weight: bold; user-select: none;">
                            Mất bao lâu để nhận hàng?
                        </summary>
                        <div style="padding: 16px; background-color: #fafafa; border-radius: 4px; margin-top: 8px;">
                            Thời gian giao hàng thường từ 2-3 ngày làm việc tùy thuộc vào địa chỉ của bạn. Với dịch vụ Vận Chuyển Nhanh, hàng sẽ được giao trong 1-2 ngày. Với dịch vụ Vận Chuyển Qua Đêm, hàng sẽ được giao hôm tiếp theo.
                        </div>
                    </details>

                    <details style="margin-bottom: 16px;">
                        <summary style="padding: 16px; background-color: #f9f9f9; border-radius: 4px; cursor: pointer; font-weight: bold; user-select: none;">
                            Làm sao để theo dõi đơn hàng của tôi?
                        </summary>
                        <div style="padding: 16px; background-color: #fafafa; border-radius: 4px; margin-top: 8px;">
                            Bạn có thể theo dõi đơn hàng bằng cách sử dụng mã đơn hàng mà chúng tôi gửi cho bạn qua email. Ngoài ra, bạn cũng có thể liên hệ với chúng tôi qua số điện thoại hoặc email để nhận thông tin cập nhật.
                        </div>
                    </details>

                    <details style="margin-bottom: 16px;">
                        <summary style="padding: 16px; background-color: #f9f9f9; border-radius: 4px; cursor: pointer; font-weight: bold; user-select: none;">
                            Nếu tôi có vấn đề với sản phẩm, tôi nên làm gì?
                        </summary>
                        <div style="padding: 16px; background-color: #fafafa; border-radius: 4px; margin-top: 8px;">
                            Nếu bạn gặp vấn đề với sản phẩm, vui lòng liên hệ với chúng tôi ngay lập tức qua email support@bookstore.com hoặc gọi số điện thoại 1800-1234. Đội ngũ hỗ trợ khách hàng của chúng tôi sẽ giúp bạn giải quyết vấn đề.
                        </div>
                    </details>
                </div>
            </section>

            <!-- Social Media Links -->
            <section style="background-color: #f0f7ff; padding: 40px; border-radius: 8px; text-align: center;">
                <h2 style="font-size: 24px; font-weight: bold; margin-bottom: 24px;">Theo Dõi Chúng Tôi</h2>
                <p style="font-size: 16px; color: #666; margin-bottom: 24px;">
                    Hãy theo dõi BookStore trên các mạng xã hội để cập nhật các tin tức mới nhất, khuyến mãi và các bộ sưu tập sách mới.
                </p>
                <div style="display: flex; justify-content: center; gap: 20px;">
                    <a href="#" style="display: inline-block; width: 48px; height: 48px; background-color: #3b5998; color: white; border-radius: 50%; text-align: center; line-height: 48px; font-size: 24px; text-decoration: none;">f</a>
                    <a href="#" style="display: inline-block; width: 48px; height: 48px; background-color: #E1306C; color: white; border-radius: 50%; text-align: center; line-height: 48px; font-size: 24px; text-decoration: none;">📷</a>
                    <a href="#" style="display: inline-block; width: 48px; height: 48px; background-color: #1DA1F2; color: white; border-radius: 50%; text-align: center; line-height: 48px; font-size: 24px; text-decoration: none;">𝕏</a>
                    <a href="#" style="display: inline-block; width: 48px; height: 48px; background-color: #25D366; color: white; border-radius: 50%; text-align: center; line-height: 48px; font-size: 24px; text-decoration: none;">💬</a>
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
</body>
</html>

