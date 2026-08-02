<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .register-layout { display: flex; align-items: center; justify-content: center; gap: 40px; max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        .register-hero { display: none; flex: 1; flex-direction: column; justify-content: center; }
        .register-form-wrapper { width: 100%; max-width: 500px; flex-shrink: 0; }
        @media (min-width: 900px) {
            .register-hero { display: flex; }
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="register-layout">
        <!-- Left Side: Hero -->
        <div class="register-hero">
            <h1 style="font-size: 48px; line-height: 1.15; margin-bottom: 24px;">Kết nối tài năng, <br>bứt phá <span class="gradient-text">sự nghiệp</span></h1>
            <p style="font-size: 16px; line-height: 1.6; color: var(--text-muted); margin-bottom: 40px; max-width: 90%;">Chúng tôi ở đây để giúp bạn kết nối với những cơ hội tuyệt vời nhất. Tạo hồ sơ ngay hôm nay để mang tiếng hát, âm nhạc của bạn đến gần hơn với khán giả.</p>
            
            <div class="hero-visual" style="min-height: 300px; flex: none;">
                <div class="floating-card card-1" style="top: 0; left: 0;">
                    <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 8px;">
                        <div style="width: 40px; height: 40px; background: #2563eb; color: white; display: flex; align-items: center; justify-content: center; border-radius: 8px; font-weight: bold;">C</div>
                        <div>
                            <div style="font-weight: 700; font-size: 14px;">Tuyển Ca sĩ Acoustic...</div>
                            <div style="font-size: 12px; color: var(--text-muted);">Đà Nẵng</div>
                        </div>
                        <span style="margin-left: auto; background: rgba(245,158,11,0.1); color: var(--accent); padding: 4px 8px; border-radius: 4px; font-size: 10px; font-weight: bold;">⚡ Gấp</span>
                    </div>
                    <div style="font-size: 13px; font-weight: 600; color: var(--primary);">Thỏa thuận</div>
                </div>
    
                <div class="floating-card card-2" style="top: 80px; left: 80px;">
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <div style="width: 40px; height: 40px; background: #14b8a6; color: white; display: flex; align-items: center; justify-content: center; border-radius: 50%; font-weight: bold;">H</div>
                        <div>
                            <div style="font-weight: 700; font-size: 14px;">Hoàng Trần <span style="background: rgba(37,99,235,0.1); color: var(--primary); padding: 2px 6px; border-radius: 4px; font-size: 10px; margin-left: 4px;">✦ Nổi bật</span></div>
                            <div style="font-size: 12px; color: var(--text-muted);">Guitarist</div>
                        </div>
                    </div>
                </div>
    
                <div class="floating-card card-3" style="top: 180px; left: 20px;">
                    <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 8px;">
                        <div style="width: 40px; height: 40px; background: #f59e0b; color: white; display: flex; align-items: center; justify-content: center; border-radius: 8px; font-weight: bold;">N</div>
                        <div>
                            <div style="font-weight: 700; font-size: 14px;">Nhạc công Organ</div>
                            <div style="font-size: 12px; color: var(--text-muted);">Hà Nội</div>
                        </div>
                    </div>
                    <div style="font-size: 13px; font-weight: 600; color: var(--primary);">2.000.000 VNĐ</div>
                </div>
            </div>
        </div>
        
        <!-- Right Side: Form -->
        <div class="register-form-wrapper card" style="padding: 40px;">
            <h2 style="font-size: 28px; font-weight: 800; text-align: center; margin-bottom: 8px; background: linear-gradient(135deg, #ffffff, #a5b4fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Đăng ký tài khoản</h2>
            <p style="text-align: center; color: var(--text-muted); margin-bottom: 32px; font-size: 14px;">Bắt đầu hành trình kết nối nghệ thuật và tài năng ngay hôm nay.</p>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label class="form-label">Tôi muốn đăng ký làm:</label>
                    <div style="display: flex; gap: 24px; margin-top: 8px;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 15px;">
                            <input type="radio" name="roleId" value="2" checked style="accent-color: var(--primary); width: 18px; height: 18px;">
                            Ứng viên / Nghệ sĩ (Talent)
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 15px;">
                            <input type="radio" name="roleId" value="3" style="accent-color: var(--primary); width: 18px; height: 18px;">
                            Nhà tuyển dụng / Bầu show (Employer)
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="fullName">Họ và tên đầy đủ</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Ví dụ: Nguyễn Văn A..." required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên đăng nhập độc nhất..." required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Tối thiểu 8 ký tự, 1 ký tự đặc biệt, 2 chữ số..." required pattern="^(?=(.*[0-9]){2})(?=.*[^a-zA-Z0-9]).{8,}$" title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm ít nhất 1 ký tự đặc biệt và 2 chữ số.">
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Ví dụ: name@example.com..." required>
                </div>

                <div class="form-group" style="margin-bottom: 32px;">
                    <label class="form-label" for="phone">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="Nhập số điện thoại liên lạc...">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-sm);">Đăng ký tài khoản</button>
            </form>

            <p style="text-align: center; margin-top: 24px; font-size: 14px; color: var(--text-muted);">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" style="color: var(--secondary); font-weight: 600;">Đăng nhập ngay</a>
            </p>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

</body>
</html>
