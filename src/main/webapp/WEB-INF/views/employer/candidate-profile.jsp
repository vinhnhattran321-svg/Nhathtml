<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Năng Lực Ứng Viên | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .profile-container {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 32px;
        }
        .profile-sidebar {
            text-align: center;
        }
        .avatar-large {
            width: 150px;
            height: 150px;
            border-radius: var(--radius-full);
            object-fit: cover;
            border: 4px solid var(--primary);
            box-shadow: var(--shadow-md);
            margin-bottom: 20px;
        }
        .avatar-placeholder {
            width: 150px;
            height: 150px;
            border-radius: var(--radius-full);
            background-color: rgba(79, 70, 229, 0.1);
            border: 4px solid var(--border-color);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .profile-section {
            margin-bottom: 28px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 24px;
        }
        .profile-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .profile-section h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 16px;
            color: var(--secondary);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .profile-meta-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed var(--border-color);
            font-size: 14px;
        }
        .profile-meta-item:last-child {
            border-bottom: none;
        }
        .skill-tag {
            display: inline-block;
            background-color: rgba(6, 182, 212, 0.1);
            color: var(--secondary);
            border: 1px solid rgba(6, 182, 212, 0.3);
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 13.5px;
            font-weight: 500;
            margin-right: 8px;
            margin-bottom: 8px;
        }
        .pre-wrap-content {
            white-space: pre-wrap;
            font-size: 15px;
            line-height: 1.6;
            color: var(--text-main);
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div style="margin-bottom: 24px;">
            <!-- Back using JavaScript back history, which is smart if they came from applicants or another page -->
            <button onclick="history.back()" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 8px;">
                <span>⬅️</span> Quay lại trang trước
            </button>
        </div>

        <div class="profile-container">
            
            <!-- Sidebar: Avatar and Quick Metadata -->
            <div class="card profile-sidebar">
                <c:choose>
                    <c:when test="${not empty profile.avatarUrl}">
                        <img src="${profile.avatarUrl}" alt="Avatar của ${candidate.fullName}" class="avatar-large">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-placeholder">👤</div>
                    </c:otherwise>
                </c:choose>
                
                <h2 style="font-size: 22px; font-weight: 800; color: var(--text-main); margin-bottom: 4px;">${candidate.fullName}</h2>
                <span style="font-size: 13px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 12px;">
                    <c:choose>
                        <c:when test="${candidate.roleId == 4}">Band Nhạc</c:when>
                        <c:otherwise>Ứng Viên / Nghệ Sĩ</c:otherwise>
                    </c:choose>
                </span>
                
                <div style="margin-bottom: 24px; color: var(--text-main); font-weight: 600; display: flex; justify-content: center; align-items: center; gap: 6px; font-size: 15px;">
                    <span style="color: #f59e0b; font-size: 16px;">⭐</span> 
                    <span>${candidate.rating > 0 ? String.format("%.1f", candidate.rating) : '5.0'}</span> 
                    <span style="color: var(--text-muted); font-weight: 400; font-size: 14px;">(${candidate.ratingCount} đánh giá)</span>
                </div>
                
                <button class="btn btn-primary" onclick="openChatWithUser(${candidate.id}, '${candidate.fullName.replace('\'', '\\\'')}')" style="width: 100%; margin-bottom: 24px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                    <c:choose>
                        <c:when test="${candidate.roleId == 4}">💬 Liên hệ / Thuê Toàn Band</c:when>
                        <c:otherwise>💬 Liên hệ ngay</c:otherwise>
                    </c:choose>
                </button>
                
                <div style="text-align: left; border-top: 1px solid var(--border-color); padding-top: 16px;">
                    <div class="profile-meta-item">
                        <span style="color: var(--text-muted);">📧 Email:</span>
                        <strong style="color: var(--text-main);">${candidate.email}</strong>
                    </div>
                    <div class="profile-meta-item">
                        <span style="color: var(--text-muted);">📞 SĐT:</span>
                        <strong style="color: var(--text-main);">${candidate.phone}</strong>
                    </div>
                    <div class="profile-meta-item">
                        <span style="color: var(--text-muted);">📅 Ngày tham gia:</span>
                        <strong style="color: var(--text-main);"><fmt:formatDate value="${candidate.createdAt}" pattern="dd/MM/yyyy"/></strong>
                    </div>
                    <div class="profile-meta-item">
                        <span style="color: var(--text-muted);">🕒 Cập nhật:</span>
                        <strong style="color: var(--text-main);"><fmt:formatDate value="${profile.updatedAt}" pattern="dd/MM/yyyy"/></strong>
                    </div>
                </div>
            </div>

            <!-- Details Panel -->
            <div class="card" style="padding: 32px;">
                
                <c:if test="${candidate.roleId == 4 && not empty bandMembers}">
                    <div class="profile-section" style="background: rgba(79, 70, 229, 0.03); padding: 20px; border-radius: 12px; border: 1px solid rgba(79, 70, 229, 0.1);">
                        <h3 style="color: var(--primary);"><span>🎸</span> Thành viên Ban nhạc</h3>
                        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; margin-top: 16px;">
                            <c:forEach var="member" items="${bandMembers}">
                                <div style="background: #fff; border: 1px solid var(--border-color); border-radius: 8px; padding: 16px; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                                    <c:choose>
                                        <c:when test="${not empty member.avatarUrl}">
                                            <img src="${member.avatarUrl}" alt="${member.fullName}" style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover; margin-bottom: 12px;">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="width: 60px; height: 60px; border-radius: 50%; background: #eee; margin: 0 auto 12px; display: flex; align-items: center; justify-content: center; font-size: 24px;">👤</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <h4 style="font-size: 15px; margin: 0 0 4px; color: var(--text-main); font-weight: 700;">${member.fullName}</h4>
                                    <span style="font-size: 13px; color: var(--primary); font-weight: 600; display: block; margin-bottom: 12px;">${member.roleInBand}</span>
                                    <button class="btn btn-outline" onclick="openChatWithUser(${member.id}, '${member.fullName.replace('\'', '\\\'')}')" style="width: 100%; padding: 6px; font-size: 13px; display: flex; align-items: center; justify-content: center; gap: 6px; border: 1px solid var(--primary); color: var(--primary); background: transparent; border-radius: 6px; cursor: pointer;">
                                        💬 Thuê lẻ
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <!-- Bio -->
                <div class="profile-section">
                    <h3><span>📝</span> Tiểu sử cá nhân</h3>
                    <c:choose>
                        <c:when test="${not empty profile.bio}">
                            <p class="pre-wrap-content">${profile.bio}</p>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); font-style: italic; font-size: 14.5px;">Chưa cập nhật tiểu sử cá nhân.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Skills -->
                <div class="profile-section">
                    <h3><span>⚡</span> Kỹ năng chuyên môn</h3>
                    <c:choose>
                        <c:when test="${not empty profile.skills}">
                            <div style="margin-top: 8px;">
                                <c:forEach items="${profile.skills.split(',')}" var="skill">
                                    <c:if test="${not empty skill.trim()}">
                                        <span class="skill-tag">${skill.trim()}</span>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); font-style: italic; font-size: 14.5px;">Chưa cập nhật kỹ năng chuyên môn.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Experience -->
                <div class="profile-section">
                    <h3><span>💼</span> Kinh nghiệm biểu diễn / làm việc</h3>
                    <c:choose>
                        <c:when test="${not empty profile.experience}">
                            <div class="pre-wrap-content">${profile.experience}</div>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); font-style: italic; font-size: 14.5px;">Chưa cập nhật kinh nghiệm làm việc.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Certificates -->
                <div class="profile-section">
                    <h3><span>🏆</span> Bằng cấp / Chứng chỉ đạt được</h3>
                    <c:choose>
                        <c:when test="${not empty profile.certificates}">
                            <div class="pre-wrap-content">${profile.certificates}</div>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); font-style: italic; font-size: 14.5px;">Chưa cập nhật bằng cấp hoặc chứng chỉ.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Portfolio link -->
                <div class="profile-section">
                    <h3><span>🌐</span> Dự án & Tác phẩm tiêu biểu (Portfolio)</h3>
                    <c:choose>
                        <c:when test="${not empty profile.portfolioUrl}">
                            <div style="margin-top: 8px;">
                                <p style="font-size: 14.5px; color: var(--text-muted); margin-bottom: 12px;">Nhà tuyển dụng có thể theo dõi thêm các sản phẩm nghệ thuật của ứng viên tại liên kết dưới đây:</p>
                                <a href="${profile.portfolioUrl}" target="_blank" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                    <span>🔗</span> Ghé thăm Portfolio / Tác phẩm nghệ thuật
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); font-style: italic; font-size: 14.5px;">Chưa cập nhật liên kết Portfolio.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>

        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
