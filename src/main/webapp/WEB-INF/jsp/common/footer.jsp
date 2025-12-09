<%@ page contentType="text/html; charset=UTF-8" %>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h4>Về BookStore</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">Giới thiệu</a></li>
                    <li><a href="#">Tuyển dụng</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Hỗ Trợ Khách Hàng</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                    <li><a href="#">Hướng dẫn mua hàng</a></li>
                    <li><a href="#">Chính sách đổi trả</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Theo Dõi Chúng Tôi</h4>
                <ul>
                    <li><a href="#">Facebook</a></li>
                    <li><a href="#">Instagram</a></li>
                    <li><a href="#">Twitter</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Nhận Tin Khuyến Mãi</h4>
                <form class="newsletter-form">
                    <input type="email" placeholder="Email của bạn" required>
                    <button type="submit" class="btn btn-primary">Đăng Ký</button>
                </form>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2025 BookStore. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/js/config.js"></script>
<script src="${pageContext.request.contextPath}/js/utils.js"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
<script src="${pageContext.request.contextPath}/js/carousel.js"></script>
<script src="${pageContext.request.contextPath}/js/api.js"></script>
<script src="${pageContext.request.contextPath}/js/data.js"></script>
<script src="${pageContext.request.contextPath}/js/filter.js"></script>
<script src="${pageContext.request.contextPath}/js/search.js"></script>
<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

