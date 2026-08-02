<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài lại mật khẩu | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <main style="display: flex; align-items: center; justify-content: center;">
        <div class="card" style="width: 100%; max-width: 450px; padding: 40px;">
            <h2 style="font-size: 24px; font-weight: 800; text-align: center; margin-bottom: 8px;">Cài Lại Mật Khẩu</h2>
            <p style="text-align: center; color: var(--text-muted); margin-bottom: 32px; font-size: 14px;">Vui lòng nhập mật khẩu mới của bạn.</p>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
                <% request.removeAttribute("errorMsg"); %>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="POST">
                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="password">Mật khẩu mới</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu mới..." required pattern="^(?=(.*[0-9]){2})(?=.*[^a-zA-Z0-9]).{8,}$" title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm ít nhất 1 ký tự đặc biệt và 2 chữ số.">
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="confirmPassword">Nhập lại mật khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu..." required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-sm);">Lưu mật khẩu</button>
            </form>

            <script>
                const form = document.querySelector('form');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');

                form.addEventListener('submit', function(e) {
                    if (password.value !== confirmPassword.value) {
                        e.preventDefault();
                        alert('Mật khẩu không khớp!');
                    }
                });
            </script>
        </div>
    </main>

    <jsp:include page="footer.jsp" />

</body>
</html>
