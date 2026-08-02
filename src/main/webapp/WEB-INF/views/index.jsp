<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=4">
    <style>
        /* Custom styles for index only if any */
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <c:if test="${empty sessionScope.user}">
        <section class="hero-wrapper">
            <div class="hero-content">
                <div class="hero-pill">✨ Nơi Tỏa Sáng Đam Mê Nghệ Thuật</div>
                
                <div class="hero-toggle">
                    <button class="toggle-btn active">🎵 Tôi là Nghệ sĩ</button>
                    <button class="toggle-btn">🤝 Tôi muốn Tuyển dụng</button>
                </div>
    
                <h1 style="font-size: 56px; line-height: 1.15; margin-bottom: 24px;">Kết nối tài năng, <br>bứt phá <span class="gradient-text">sự nghiệp</span></h1>
                
                <p style="font-size: 18px; line-height: 1.6; color: var(--text-muted); margin-bottom: 36px; max-width: 90%;">Chúng tôi ở đây để giúp bạn kết nối với những cơ hội tuyệt vời nhất. Tạo hồ sơ ngay hôm nay để mang tiếng hát, âm nhạc của bạn đến gần hơn với khán giả.</p>
                
                <div class="hero-cta">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding: 16px 40px; font-size: 16px; border-radius: var(--radius-full);">
                        Bắt đầu hành trình của bạn ➔
                    </a>
                    <span class="free-badge">MIỄN PHÍ</span>
                </div>
                
                <br>
                <div class="stats-pill">
                    <div class="stats-dot"></div>
                    +42.645 Nghệ sĩ đã tham gia
                </div>
            </div>
    
            <div class="hero-visual">
                <div class="floating-card card-1">
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
    
                <div class="floating-card card-2">
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <div style="width: 40px; height: 40px; background: #14b8a6; color: white; display: flex; align-items: center; justify-content: center; border-radius: 50%; font-weight: bold;">H</div>
                        <div>
                            <div style="font-weight: 700; font-size: 14px;">Hoàng Trần <span style="background: rgba(37,99,235,0.1); color: var(--primary); padding: 2px 6px; border-radius: 4px; font-size: 10px; margin-left: 4px;">✦ Nổi bật</span></div>
                            <div style="font-size: 12px; color: var(--text-muted);">Guitarist</div>
                        </div>
                    </div>
                </div>
    
                <div class="floating-card card-3">
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
        </section>
    </c:if>

    <!-- Search Section -->
    <div class="container">
        <!-- Marquee / News Ticker -->
        <div class="news-ticker-wrapper">
            <div class="news-ticker-title">TIN NỔI BẬT</div>
            <div class="news-ticker-content">
                <span class="news-ticker-item">🔥 HOT: Tuyển gấp 5 ca sĩ nhạc nhẹ cho sự kiện Countdown 2027</span>
                <span class="news-ticker-item">⭐ Vinh danh Top 1 Nhà Tuyển Dụng: Sài Gòn Music Show</span>
                <span class="news-ticker-item">🎉 TalentConnect chính thức cán mốc 10.000 nghệ sĩ đăng ký</span>
                <span class="news-ticker-item">💼 Hàng trăm cơ hội biểu diễn tại Đà Nẵng đang chờ đón bạn</span>
                <!-- Duplicate for seamless scroll -->
                <span class="news-ticker-item">🔥 HOT: Tuyển gấp 5 ca sĩ nhạc nhẹ cho sự kiện Countdown 2027</span>
                <span class="news-ticker-item">⭐ Vinh danh Top 1 Nhà Tuyển Dụng: Sài Gòn Music Show</span>
                <span class="news-ticker-item">🎉 TalentConnect chính thức cán mốc 10.000 nghệ sĩ đăng ký</span>
                <span class="news-ticker-item">💼 Hàng trăm cơ hội biểu diễn tại Đà Nẵng đang chờ đón bạn</span>
            </div>
        </div>

        <div class="search-container">
            <form action="${pageContext.request.contextPath}/home" method="GET" class="search-form">
                <div class="search-input-group" style="flex: 2;">
                    <!-- Kính lúp -->
                    <span style="color: var(--text-muted); font-size: 18px;">🔍</span>
                    <input type="text" name="q" value="${query}" placeholder="Bạn đang tìm kiếm tài năng hay cơ hội nào hôm nay? (VD: Guitar, Ca sĩ, Sự kiện)..." style="width: 100%; font-size: 16px;">
                </div>
                
                <div class="search-input-group">
                    <span style="color: var(--text-muted); font-size: 18px;">📍</span>
                    <select name="loc">
                        <option value="all" ${location == 'all' ? 'selected' : ''}>Tất cả địa điểm</option>
                        <option value="Đà Nẵng" ${location == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                        <option value="Hồ Chí Minh" ${location == 'Hồ Chí Minh' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                        <option value="Hà Nội" ${location == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary" style="padding: 12px 32px;">Tìm kiếm</button>
            </form>
        </div>

        <!-- Jobs Listing -->
        <div style="position: relative; z-index: 1;">

            
            <h2 style="font-size: 32px; font-weight: 700; margin-bottom: 32px; text-align: center; font-family: var(--font-heading);">
                Khám Phá Cơ Hội Mới Nhất ✨
            </h2>

        <c:choose>
            <c:when test="${empty jobs}">
                <div class="card" style="text-align: center; padding: 60px 20px;">
                    <span style="font-size: 48px;">🥺</span>
                    <p style="margin-top: 16px; color: var(--text-muted); font-size: 16px;">Hiện tại không tìm thấy tin tuyển dụng nào phù hợp với yêu cầu của bạn.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary btn-sm" style="margin-top: 24px;">Xóa bộ lọc tìm kiếm</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="jobs-grid">
                    <c:forEach items="${jobs}" var="job">
                        <c:set var="imgKeyword" value="concert,stage" />
                        <c:set var="titleLower" value="${fn:toLowerCase(job.title)}" />
                        <c:choose>
                            <c:when test="${fn:contains(titleLower, 'guitar')}"><c:set var="imgKeyword" value="guitar" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'dj')}"><c:set var="imgKeyword" value="dj" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'ca sĩ') || fn:contains(titleLower, 'hát')}"><c:set var="imgKeyword" value="singer,vocal" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'trống') || fn:contains(titleLower, 'drum')}"><c:set var="imgKeyword" value="drummer,drums" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'piano') || fn:contains(titleLower, 'organ')}"><c:set var="imgKeyword" value="piano,keyboard" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'múa') || fn:contains(titleLower, 'dance')}"><c:set var="imgKeyword" value="dance,dancer" /></c:when>
                            <c:when test="${fn:contains(titleLower, 'mc') || fn:contains(titleLower, 'dẫn chương trình')}"><c:set var="imgKeyword" value="microphone,host" /></c:when>
                        </c:choose>

                        <div class="card job-card">
                            <c:choose>
                                <c:when test="${not empty job.thumbnailUrl}">
                                    <img src="${job.thumbnailUrl}" alt="Cover" class="job-card-cover" style="object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://loremflickr.com/600/300/${imgKeyword}?random=${job.id}" alt="Cover" class="job-card-cover">
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="job-card-body">
                                <div class="job-card-header">
                                    <div>
                                        <div class="job-employer">${job.employerName}</div>
                                        <h3 class="job-title">${job.title}</h3>
                                    </div>
                                    <span class="badge badge-open">Đang nhận hồ sơ</span>
                                </div>

                                <div class="job-tags">
                                    <c:if test="${not empty job.tags}">
                                        <c:forEach items="${job.tags.split(',')}" var="tag">
                                            <span class="tag">🏷️ ${tag.trim()}</span>
                                        </c:forEach>
                                    </c:if>
                                    <span class="tag tag-location">📍 ${job.location}</span>
                                    <span class="tag tag-salary">
                                        💰 <fmt:formatNumber value="${job.salary}" type="number" maxFractionDigits="0"/> VNĐ
                                    </span>
                                </div>

                                <p class="job-description">${job.description}</p>
                            </div>

                            <div class="job-card-footer" style="padding: 0 24px 24px 24px; border-top: none; margin-top: auto;">
                                <span class="job-date">Hạn nộp: <fmt:formatDate value="${job.deadline}" pattern="dd/MM/yyyy"/></span>
                                <a href="${pageContext.request.contextPath}/job-detail?id=${job.id}" class="btn btn-secondary btn-sm">Xem chi tiết</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; gap: 10px; margin-top: 48px; margin-bottom: 20px; align-items: center; flex-wrap: wrap;">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/home?q=${query}&amp;loc=${location}&amp;page=${currentPage - 1}"
                       style="padding: 8px 18px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s; background: transparent; color: var(--text-main); border: 1px solid var(--border-color);"
                       onmouseover="this.style.borderColor='var(--primary)';this.style.color='var(--primary)'"
                       onmouseout="this.style.borderColor='var(--border-color)';this.style.color='var(--text-main)'"
                    >&laquo; Trước</a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/home?q=${query}&amp;loc=${location}&amp;page=${i}"
                       style="padding: 8px 16px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s;
                              ${i == currentPage ? 'background: var(--primary); color: white; border: 1px solid var(--primary);' : 'background: transparent; color: var(--text-main); border: 1px solid var(--border-color);'}"
                    >${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/home?q=${query}&amp;loc=${location}&amp;page=${currentPage + 1}"
                       style="padding: 8px 18px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.2s; background: transparent; color: var(--text-main); border: 1px solid var(--border-color);"
                       onmouseover="this.style.borderColor='var(--primary)';this.style.color='var(--primary)'"
                       onmouseout="this.style.borderColor='var(--border-color)';this.style.color='var(--text-main)'"
                    >Tiếp &raquo;</a>
                </c:if>
            </div>
        </c:if>

        </div>
    </main>

    <!-- Khoảng cách đệm tách biệt phần nội dung và footer đen -->
    <div style="height: 80px;"></div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
</html>
