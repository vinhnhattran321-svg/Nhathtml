<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Tin Tuyển Dụng | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div class="dashboard-layout">
            
            <!-- Sidebar -->
            <div class="card dashboard-sidebar" style="padding: 20px;">
                <h3 style="font-size: 16px; color: var(--text-muted); text-transform: uppercase; margin-bottom: 20px; font-weight: 600;">Chức năng Bầu show</h3>
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/employer/dashboard">
                            <span style="margin-right: 12px;">📋</span> Quản lý tin đăng tuyển
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/employer/post-job">
                            <span style="margin-right: 12px;">➕</span> Đăng tin tuyển dụng mới
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/employer/reviews">
                            <span style="margin-right: 12px;">⭐</span> Đánh giá & Nhận xét
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Panel -->
            <div class="card" style="padding: 40px;">
                <h2 style="font-size: 24px; font-weight: 700; margin-bottom: 8px;">💼 Đăng Tin Tuyển Dụng / Show Diễn Mới</h2>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 32px;">Điền đầy đủ thông tin để thu hút các ứng viên, nghệ sĩ tài năng nhất nộp hồ sơ.</p>

                <!-- Alerts -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger">${errorMsg}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/employer/post-job" method="POST" enctype="multipart/form-data">
                    
                    <div class="form-group">
                        <label class="form-label" for="title">Tiêu đề tin tuyển dụng / Show diễn <span style="color: var(--color-error);">*</span></label>
                        <input type="text" id="title" name="title" class="form-control" placeholder="Ví dụ: Tìm Ca sĩ hát Acoustic sự kiện cuối tuần..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="thumbnailFile">Ảnh Thumbnail (Không bắt buộc)</label>
                        <input type="file" id="thumbnailFile" name="thumbnailFile" class="form-control" accept="image/*">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label class="form-label" for="salary">Mức lương / Thù lao (VNĐ) <span style="color: var(--color-error);">*</span></label>
                            <input type="number" id="salary" name="salary" class="form-control" placeholder="Ví dụ: 1500000" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="location">Địa điểm biểu diễn / Làm việc</label>
                            <select id="location" name="location" class="form-control">
                                <option value="Đà Nẵng">Đà Nẵng</option>
                                <option value="Hồ Chí Minh">TP. Hồ Chí Minh</option>
                                <option value="Hà Nội">Hà Nội</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="tags">Thẻ Tag (Ví dụ: Nhạc công, Nghệ sĩ, Ca sĩ Acoustic)</label>
                        <input type="text" id="tags" name="tags" class="form-control" placeholder="Ngăn cách bằng dấu phẩy...">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="deadline">Hạn nhận hồ sơ ứng tuyển <span style="color: var(--color-error);">*</span></label>
                        <input type="date" id="deadline" name="deadline" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="description">Mô tả công việc chi tiết <span style="color: var(--color-error);">*</span></label>
                        <textarea id="description" name="description" class="form-control" placeholder="Nhập thời gian biểu diễn cụ thể, số lượng bài biểu diễn, thời lượng..." required></textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 40px;">
                        <label class="form-label" for="requirements">Yêu cầu đối với ứng viên</label>
                        <textarea id="requirements" name="requirements" class="form-control" placeholder="Nhập các yêu cầu về kỹ năng, dòng nhạc, nhạc cụ chuyên môn hoặc kinh nghiệm tối thiểu cần thiết..."></textarea>
                    </div>

                    <div style="display: flex; gap: 16px; justify-content: flex-end;">
                        <a href="${pageContext.request.contextPath}/employer/dashboard" class="btn btn-secondary">Quay lại</a>
                        <button type="submit" class="btn btn-primary">Xác nhận đăng tin</button>
                    </div>

                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
