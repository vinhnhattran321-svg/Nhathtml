<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Năng Lực | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div class="dashboard-layout">
            
            <!-- Sidebar -->
            <div class="card dashboard-sidebar" style="padding: 20px;">
                <h3 style="font-size: 16px; color: var(--text-muted); text-transform: uppercase; margin-bottom: 20px; font-weight: 600;">Menu Chức Năng</h3>
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/candidate/dashboard">
                            <span style="margin-right: 12px;">📊</span> Dashboard của tôi
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/candidate/profile">
                            <span style="margin-right: 12px;">👤</span> Hồ sơ năng lực
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/home">
                            <span style="margin-right: 12px;">🔍</span> Tìm kiếm show diễn
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/candidate/reviews">
                            <span style="margin-right: 12px;">⭐</span> Đánh giá & Nhận xét
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Panel -->
            <div class="card" style="padding: 40px;">
                <h2 style="font-size: 24px; font-weight: 700; margin-bottom: 8px;">👤 Hồ Sơ Năng Lực Cá Nhân</h2>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 32px;">Cập nhật đầy đủ hồ sơ để lọt vào mắt xanh của các nhà tuyển dụng và bầu show.</p>

                <!-- Alerts -->
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success">${successMsg}</div>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger">${errorMsg}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/candidate/profile/update" method="POST" enctype="multipart/form-data">
                    
                    <div style="display: grid; grid-template-columns: 150px 1fr; gap: 24px; margin-bottom: 32px; align-items: center;">
                        <!-- Avatar Preview & Upload -->
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                            <div id="avatarPreviewContainer" style="width: 120px; height: 120px; border-radius: 50%; overflow: hidden; border: 2px solid var(--border-color); background-color: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center;">
                                <c:choose>
                                    <c:when test="${not empty profile.avatarUrl}">
                                        <img src="${profile.avatarUrl}" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size: 40px; color: var(--text-muted);">👤</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button type="button" class="btn btn-secondary btn-sm" style="width: 100%; padding: 6px 12px; font-size: 13px; margin-top: 4px;" onclick="document.getElementById('avatarFile').click();">Đổi ảnh</button>
                            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display: none;" onchange="previewAvatar(this)">
                        </div>
                        
                        <div class="form-group" style="margin-bottom: 0; width: 100%;">
                            <label class="form-label" for="avatarUrl">Đường dẫn ảnh đại diện (Avatar URL)</label>
                            <input type="url" id="avatarUrl" name="avatarUrl" class="form-control" value="${profile.avatarUrl}" placeholder="https://images.unsplash.com/photo-...">
                            <span style="font-size: 12px; color: var(--text-muted); display: block; margin-top: 4px;">Bạn có thể dán URL ảnh trực tiếp hoặc nhấn nút "Đổi ảnh" ở bên trái để chọn ảnh từ máy tính.</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="bio">Giới thiệu bản thân (Bio)</label>
                        <textarea id="bio" name="bio" class="form-control" placeholder="Viết giới thiệu ngắn về chất giọng, phong cách nghệ thuật hoặc định hướng của bản thân...">${profile.bio}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="skills">Các kỹ năng / Nhạc cụ chuyên môn</label>
                        <input type="text" id="skills" name="skills" class="form-control" value="${profile.skills}" placeholder="Ví dụ: Guitar, Piano, Hát bè, Pop Ballad, EDM (cách nhau bằng dấu phẩy)...">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="experience">Kinh nghiệm biểu diễn</label>
                        <textarea id="experience" name="experience" class="form-control" placeholder="Mô tả các sự kiện, phòng trà, hoặc dự án bạn từng cộng tác...">${profile.experience}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="certificates">Chứng chỉ / Giải thưởng đạt được</label>
                        <textarea id="certificates" name="certificates" class="form-control" placeholder="Ví dụ: Giải nhì cuộc thi âm nhạc, Chứng chỉ nhạc viện...">${profile.certificates}</textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 24px;">
                        <label class="form-label" for="portfolioUrl">Đường dẫn sản phẩm nghệ thuật (Portfolio / Youtube / Soundcloud Link)</label>
                        <input type="url" id="portfolioUrl" name="portfolioUrl" class="form-control" value="${profile.portfolioUrl}" placeholder="https://youtube.com/watch?v=...">
                    </div>

                    <div class="form-group" style="margin-bottom: 40px;">
                        <label class="form-label" style="display: block; margin-bottom: 8px;">Tải lên ảnh CV</label>
                        <input type="file" name="cvFiles" accept="image/*,application/pdf" multiple style="display: block; width: 100%; padding: 10px; background-color: var(--bg-input, #f3f4f6); border: 1px dashed var(--primary, #4F46E5); border-radius: var(--radius-sm, 8px); cursor: pointer; color: var(--text-main, #333);">
                        
                        <!-- Hiển thị các CV đã tải lên -->
                        <c:if test="${not empty profile.cvImages}">
                            <div style="margin-top: 16px;">
                                <h4 style="font-size: 14px; margin-bottom: 12px; color: var(--text-muted);">Các CV đã tải lên:</h4>
                                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 16px;">
                                    <c:forEach items="${fn:split(profile.cvImages, ',')}" var="cvUrl">
                                        <div style="position: relative; border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; background: rgba(255,255,255,0.05); padding: 4px;">
                                            <a href="${cvUrl}" target="_blank">
                                                <img src="${cvUrl}" style="width: 100%; height: 120px; object-fit: cover; border-radius: 4px;" alt="CV">
                                            </a>
                                            <button type="button" class="btn btn-danger btn-sm" style="position: absolute; top: 8px; right: 8px; padding: 2px 6px; font-size: 10px; opacity: 0.8;" onclick="deleteCv('${cvUrl}')">✕ Xóa</button>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div style="display: flex; gap: 16px; justify-content: flex-end;">
                        <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi hồ sơ</button>
                    </div>

                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

    <script>
        function deleteCv(cvUrl) {
            if (confirm('Bạn có chắc chắn muốn xóa ảnh CV này?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/candidate/profile/delete-cv';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'cvUrl';
                input.value = cvUrl;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var container = document.getElementById('avatarPreviewContainer');
                    container.innerHTML = '<img src="' + e.target.result + '" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
