<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <main style="display: flex; align-items: center; justify-content: center;">
        <div class="card" style="width: 100%; max-width: 450px; padding: 40px;">
            <h2 style="font-size: 24px; font-weight: 800; text-align: center; margin-bottom: 8px;">Quên Mật Khẩu</h2>
            <p style="text-align: center; color: var(--text-muted); margin-bottom: 32px; font-size: 14px;">Nhập email của bạn để nhận mã xác nhận.</p>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
                <% session.removeAttribute("errorMsg"); %>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="email">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Nhập email..." required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-sm);">Gửi mã xác nhận</button>
            </form>

            <p style="text-align: center; margin-top: 24px; font-size: 14px; color: var(--text-muted);">
                Quay lại <a href="${pageContext.request.contextPath}/login" style="color: var(--secondary); font-weight: 600;">Đăng nhập</a>
            </p>
        </div>
    </main>

    <jsp:include page="footer.jsp" />

</body>
</html>
