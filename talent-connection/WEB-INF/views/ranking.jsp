<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xếp hạng - TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .ranking-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        .ranking-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .ranking-header h1 {
            color: var(--primary-dark);
            font-size: 28px;
            margin-bottom: 10px;
        }
        .ranking-tabs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .tab-btn {
            padding: 10px 20px;
            border-radius: 20px;
            background: white;
            color: var(--text-main);
            border: 2px solid var(--border-color);
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .tab-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        .ranking-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
        }
        .ranking-card {
            flex: 0 1 280px;
            background: var(--bg-card);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .ranking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 20px rgba(0, 242, 254, 0.2);
            border-color: var(--primary);
        }
        .ranking-cover {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-bottom: 2px solid var(--primary);
        }
        .ranking-card-body {
            padding: 0 20px 20px 20px;
        }
        .ranking-card .rank-badge {
            position: absolute;
            top: -10px;
            left: 50%;
            transform: translateX(-50%);
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .ranking-card .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin: -40px auto 10px;
            border: 3px solid var(--primary-light);
            background: var(--bg-main);
            position: relative;
            z-index: 2;
        }
        .ranking-card h3 {
            font-size: 16px;
            color: var(--text-main);
            margin: 10px 0 5px;
        }
        .ranking-card p {
            font-size: 13px;
            color: var(--text-muted);
        }
        .points-badge {
            display: inline-block;
            background: var(--bg-main);
            color: var(--primary);
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 10px;
        }
        .rating-stars {
            color: #f59e0b;
            font-size: 14px;
            margin-top: 10px;
        }
        .filter-btn {
            padding: 6px 16px;
            border-radius: 20px;
            background: transparent;
            color: var(--text-main);
            border: 1px solid var(--border-color);
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .filter-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        .filter-btn.active {
            background: rgba(0, 242, 254, 0.1);
            color: var(--primary);
            border-color: var(--primary);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="ranking-container">
        <div class="ranking-header">
            <c:choose>
                <c:when test="${activeTab == 'employers'}">
                    <h1>Top Nhà tuyển dụng uy tín nhất</h1>
                    <p>Được đánh giá dựa trên mức độ hài lòng của nghệ sĩ</p>
                </c:when>
                <c:otherwise>
                    <h1>Top Nghệ sĩ được yêu thích nhất</h1>
                    <p>Bảng xếp hạng dựa trên điểm đánh giá trung bình từ các nhà tuyển dụng</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="ranking-tabs">
            <a href="${pageContext.request.contextPath}/ranking?tab=artists" class="tab-btn ${activeTab == 'artists' ? 'active' : ''}">🌟 Nghệ sĩ</a>
            <a href="${pageContext.request.contextPath}/ranking?tab=employers" class="tab-btn ${activeTab == 'employers' ? 'active' : ''}">🏢 Nhà tuyển dụng</a>
        </div>

        <c:if test="${activeTab == 'artists'}">
            <div class="search-container" style="display: flex; justify-content: center; align-items: center; gap: 15px; margin-bottom: 40px; margin-top: 10px;">
                <span style="font-weight: 600; color: var(--text-main); font-size: 16px;">Nghệ sĩ cần tìm: </span>
                <form action="${pageContext.request.contextPath}/ranking" method="GET" class="search-form" style="max-width: 400px; width: 100%; justify-content: center; margin: 0;">
                    <input type="hidden" name="tab" value="artists">
                    <input type="hidden" name="page" value="1">
                    <div class="search-input-group" style="width: 100%;">
                        <span style="color: var(--text-muted); font-size: 18px;">🎤</span>
                        <select name="skill" onchange="this.form.submit()">
                            <option value="all" ${param.skill == null || param.skill == 'all' ? 'selected' : ''}>Tất cả chuyên môn</option>
                            <option value="Ca sĩ" ${param.skill == 'Ca sĩ' ? 'selected' : ''}>🎤 Ca sĩ</option>
                            <option value="Rapper" ${param.skill == 'Rapper' ? 'selected' : ''}>🎙️ Rapper</option>
                            <option value="MC" ${param.skill == 'MC' ? 'selected' : ''}>🎙️ MC</option>
                            <option value="Dancer" ${param.skill == 'Dancer' ? 'selected' : ''}>💃 Vũ công / Dancer</option>
                            <option value="DJ" ${param.skill == 'DJ' ? 'selected' : ''}>🎧 DJ</option>
                            <option value="Band nhạc" ${param.skill == 'Band nhạc' ? 'selected' : ''}>🎸 Ban nhạc</option>
                            <option value="Nhạc công" ${param.skill == 'Nhạc công' ? 'selected' : ''}>🎻 Nhạc công</option>
                            <option value="Diễn viên" ${param.skill == 'Diễn viên' ? 'selected' : ''}>🎭 Diễn viên</option>
                            <option value="Nhạc sĩ" ${param.skill == 'Nhạc sĩ' ? 'selected' : ''}>🎼 Nhạc sĩ sáng tác</option>
                            <option value="Beatboxer" ${param.skill == 'Beatboxer' ? 'selected' : ''}>🥁 Beatboxer</option>
                            <option value="Ảo thuật gia" ${param.skill == 'Ảo thuật gia' ? 'selected' : ''}>🪄 Ảo thuật gia</option>
                            <option value="Người dẫn chương trình" ${param.skill == 'Người dẫn chương trình' ? 'selected' : ''}>📢 Người dẫn chương trình</option>
                            <option value="Hài độc thoại" ${param.skill == 'Hài độc thoại' ? 'selected' : ''}>😄 Hài độc thoại</option>
                            <option value="Xiếc" ${param.skill == 'Xiếc' ? 'selected' : ''}>🤸 Xiếc / Acrobatics</option>
                        </select>
                    </div>
                </form>
            </div>
        </c:if>

        <div class="ranking-grid">
            <c:choose>
                <c:when test="${activeTab == 'artists'}">
                    <c:forEach var="artist" items="${topArtists}" varStatus="status">
                        <div class="ranking-card">
                            <div class="rank-badge">Top ${status.index + 1}</div>
                            <img src="https://loremflickr.com/600/300/portrait,stage,singer?random=${artist.id}" alt="Cover" class="ranking-cover">
                            <div class="ranking-card-body">
                                <c:choose>
                                    <c:when test="${not empty artist.avatarUrl}">
                                        <img src="${artist.avatarUrl}" alt="Avatar của ${artist.fullName}" class="avatar" style="object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://ui-avatars.com/api/?name=${artist.fullName}&background=random" alt="Avatar" class="avatar">
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user and 'Employer'.equalsIgnoreCase(sessionScope.user.roleName)}">
                                        <a href="${pageContext.request.contextPath}/employer/candidate-profile?id=${artist.id}" style="text-decoration: none; color: inherit;" title="Xem hồ sơ năng lực">
                                            <h3 style="color: var(--primary); transition: color 0.3s;" onmouseover="this.style.color='var(--secondary)'" onmouseout="this.style.color='var(--primary)'">${artist.fullName}</h3>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>${artist.fullName}</h3>
                                    </c:otherwise>
                                </c:choose>
                                <p>${artist.email}</p>
                                <c:if test="${not empty artist.skills}">
                                    <div style="margin-top: 8px; font-size: 11px; color: var(--text-muted); display: flex; flex-wrap: wrap; justify-content: center; gap: 4px;">
                                        <c:forEach var="skill" items="${fn:split(artist.skills, ',')}">
                                            <c:set var="trimmedSkill" value="${fn:trim(skill)}" />
                                            <c:if test="${not empty trimmedSkill}">
                                                <span style="background: rgba(255,255,255,0.05); padding: 3px 8px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.1); color: var(--text-main);">${trimmedSkill}</span>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <div class="rating-stars">
                                    ⭐ ${artist.rating > 0 ? String.format("%.1f", artist.rating) : '5.0'} (${artist.ratingCount} đánh giá)
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:when test="${activeTab == 'employers'}">
                    <c:forEach var="employer" items="${topEmployers}" varStatus="status">
                        <div class="ranking-card">
                            <div class="rank-badge">Top ${status.index + 1}</div>
                            <img src="https://loremflickr.com/600/300/stage,event,concert?random=${employer.id + 1000}" alt="Cover" class="ranking-cover">
                            <div class="ranking-card-body">
                                <c:choose>
                                    <c:when test="${not empty employer.avatarUrl}">
                                        <img src="${employer.avatarUrl}" alt="Avatar của ${employer.fullName}" class="avatar" style="object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://ui-avatars.com/api/?name=${employer.fullName}&background=random" alt="Avatar" class="avatar">
                                    </c:otherwise>
                                </c:choose>
                                <h3>${employer.fullName}</h3>
                                <div class="rating-stars">
                                    ⭐ ${employer.rating > 0 ? String.format("%.1f", employer.rating) : '5.0'} (${employer.ratingCount} đánh giá)
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
            </c:choose>
        </div>

        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; gap: 10px; margin-top: 50px; margin-bottom: 20px; align-items: center;">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/ranking?tab=${activeTab}&skill=${activeSkill}&page=${currentPage - 1}" 
                       style="padding: 8px 16px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s; background: transparent; color: var(--text-main); border: 1px solid var(--border-color);">
                        &laquo; Trước
                    </a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/ranking?tab=${activeTab}&skill=${activeSkill}&page=${i}" 
                       style="padding: 8px 16px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s;
                              ${i == currentPage ? 'background: var(--primary); color: white; border: 1px solid var(--primary);' : 'background: transparent; color: var(--text-main); border: 1px solid var(--border-color);'}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/ranking?tab=${activeTab}&skill=${activeSkill}&page=${currentPage + 1}" 
                       style="padding: 8px 16px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s; background: transparent; color: var(--text-main); border: 1px solid var(--border-color);">
                        Tiếp &raquo;
                    </a>
                </c:if>
            </div>
        </c:if>
    </div>

    <!-- Khoảng cách đệm tách biệt phần nội dung và footer đen -->
    <div style="height: 80px;"></div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
</html>
