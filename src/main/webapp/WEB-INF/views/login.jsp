<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="navbar.jsp" />

    <main style="display: flex; align-items: center; justify-content: center;">
        <div class="card" style="width: 100%; max-width: 450px; padding: 40px;">
            <h2 style="font-size: 28px; font-weight: 800; text-align: center; margin-bottom: 8px; background: linear-gradient(135deg, #ffffff, #a5b4fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Chào mừng trở lại!</h2>
            <p style="text-align: center; color: var(--text-muted); margin-bottom: 32px; font-size: 14px;">Đăng nhập để kết nối với cơ hội việc làm và các tài năng hàng đầu.</p>

            <!-- Thông báo Lỗi hoặc Thành công -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
                <% session.removeAttribute("errorMsg"); %>
            </c:if>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">${successMsg}</div>
                <% session.removeAttribute("successMsg"); %>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên đăng nhập của bạn..." required>
                </div>
                
                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
                    <div style="text-align: right; margin-top: 8px;">
                        <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: 13px; color: var(--primary); text-decoration: none;">Quên mật khẩu?</a>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-sm);">Đăng nhập</button>
            </form>

            <p style="text-align: center; margin-top: 24px; font-size: 14px; color: var(--text-muted);">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" style="color: var(--secondary); font-weight: 600;">Đăng ký ngay</a>
            </p>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

</body>
</html>
