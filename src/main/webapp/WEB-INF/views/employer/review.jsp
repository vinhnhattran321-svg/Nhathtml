<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá Ứng Viên | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 8px;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            font-size: 40px;
            color: rgba(255, 255, 255, 0.1);
            cursor: pointer;
            transition: color 0.2s;
            margin: 0;
            line-height: 1;
        }
        .star-rating input[type="radio"]:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #f59e0b;
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div style="margin-bottom: 24px;">
            <a href="${pageContext.request.contextPath}/employer/applicants?jobId=${app.jobId}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 8px;">
                <span>⬅️</span> Quay lại danh sách
            </a>
        </div>

        <!-- Main Panel -->
        <div class="card" style="padding: 40px; max-width: 600px; margin: 0 auto;">
            <h2 style="font-size: 24px; font-weight: 700; margin-bottom: 8px; text-align: center; color: var(--text-main);">⭐ Đánh Giá Nghệ Sĩ</h2>
            <p style="color: var(--text-muted); font-size: 15px; margin-bottom: 32px; text-align: center; line-height: 1.5;">
                Đánh giá chất lượng của nghệ sĩ <strong style="color: var(--secondary);">${candidate.fullName}</strong><br>cho show diễn <strong style="color: var(--accent);">${app.jobTitle}</strong>.
            </p>

            <form action="${pageContext.request.contextPath}/employer/review" method="POST">
                <input type="hidden" name="appId" value="${app.id}">
                
                <div class="form-group" style="text-align: center; margin-bottom: 32px;">
                    <label class="form-label" style="display: block; margin-bottom: 16px; font-size: 16px;">Vui lòng chọn số sao <span style="color: var(--color-error);">*</span></label>
                    <div class="star-rating" style="justify-content: center;">
                        <input type="radio" id="star5" name="rating" value="5" required>
                        <label for="star5" title="5 sao">★</label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" title="4 sao">★</label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" title="3 sao">★</label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" title="2 sao">★</label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" title="1 sao">★</label>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 32px;">
                    <label class="form-label" for="comment">Nhận xét chi tiết (Tùy chọn)</label>
                    <textarea id="comment" name="comment" class="form-control" placeholder="Chia sẻ trải nghiệm của bạn về thái độ làm việc, kỹ năng chuyên môn của nghệ sĩ..." rows="4"></textarea>
                </div>

                <div style="display: flex; gap: 16px; justify-content: center;">
                    <a href="${pageContext.request.contextPath}/employer/applicants?jobId=${app.jobId}" class="btn btn-secondary" style="min-width: 120px; text-align: center;">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border: none; min-width: 150px; box-shadow: 0 4px 14px rgba(245, 158, 11, 0.3);">Gửi Đánh Giá</button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
