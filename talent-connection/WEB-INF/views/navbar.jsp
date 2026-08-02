<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<header>
    <div class="container">
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/home" class="logo" style="font-family: var(--font-heading); font-size: 28px;">
                Talent<span style="color: var(--primary);">Connect</span>
            </a>
            
            <button class="mobile-nav-toggle" aria-label="Toggle navigation">☰</button>
            <ul class="nav-links">
                <li class="dropdown" style="position: relative; display: inline-block;">
                    <a href="#" class="nav-item">Xếp hạng ▼</a>
                    <div class="dropdown-content" style="display: none; position: absolute; background-color: var(--bg-card, #fff); min-width: 160px; box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); z-index: 1; border-radius: 4px; overflow: hidden; margin-top: 5px;">
                        <a href="${pageContext.request.contextPath}/ranking?tab=artists" style="color: var(--text-main, #333); padding: 12px 16px; text-decoration: none; display: block; border-bottom: 1px solid var(--border-color, #eee);">🏆 Top Nghệ Sĩ</a>
                        <a href="${pageContext.request.contextPath}/ranking?tab=employers" style="color: var(--text-main, #333); padding: 12px 16px; text-decoration: none; display: block;">🏢 Top Nhà Tuyển Dụng</a>
                    </div>
                    <style>
                        .dropdown:hover .dropdown-content { display: block !important; }
                        .dropdown-content a:hover { background-color: rgba(79, 70, 229, 0.1); color: var(--primary, #4F46E5) !important; }
                    </style>
                </li>
                <li><a href="${pageContext.request.contextPath}/home" class="nav-item">Việc làm / Show diễn</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li style="position: relative;">
                        <a href="${pageContext.request.contextPath}/notifications" class="nav-item" style="display: flex; align-items: center; gap: 6px;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                            Thông báo
                            <span id="notif-badge" style="display: none; background: #ef4444; color: white; font-size: 11px; font-weight: bold; border-radius: 10px; padding: 2px 6px; position: absolute; top: -5px; right: -15px;">0</span>
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${'Candidate'.equalsIgnoreCase(sessionScope.user.roleName)}">
                            <li><a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-item">Dashboard của tôi</a></li>
                            <li><a href="${pageContext.request.contextPath}/candidate/profile" class="nav-item">Hồ sơ năng lực</a></li>
                        </c:when>
                        <c:when test="${'Employer'.equalsIgnoreCase(sessionScope.user.roleName)}">
                            <li><a href="${pageContext.request.contextPath}/employer/dashboard" class="nav-item">Quản lý tin đăng</a></li>
                            <li><a href="${pageContext.request.contextPath}/employer/post-job" class="nav-item">Đăng tin tuyển dụng</a></li>
                        </c:when>
                        <c:when test="${'Admin'.equalsIgnoreCase(sessionScope.user.roleName)}">
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">Hệ thống quản trị</a></li>
                        </c:when>
                    </c:choose>
                </c:if>
            </ul>
            
            <div class="nav-actions" style="display: flex; align-items: center;">
                <button id="theme-toggle" class="btn btn-secondary btn-sm" style="margin-right: 12px; padding: 6px 10px; border-radius: 50%; font-size: 16px; background: transparent; border: 1px solid var(--border-color); cursor: pointer;" aria-label="Toggle Dark Mode">
                    🌙
                </button>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                    </c:when>
                    <c:otherwise>
                        <span style="font-weight: 500; font-size: 14px; margin-right: 8px;">
                            Xin chào, <strong style="color: var(--secondary);">${fn:substringBefore(sessionScope.user.fullName, ' (') != '' && fn:contains(sessionScope.user.fullName, ' (') ? fn:substringBefore(sessionScope.user.fullName, ' (') : sessionScope.user.fullName}</strong>
                        </span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm">Đăng xuất</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>
<script>
    const themeToggle = document.getElementById('theme-toggle');
    const currentTheme = localStorage.getItem('theme');

    if (currentTheme === 'dark') {
        document.body.classList.add('dark-mode');
        themeToggle.innerText = '☀️';
    }

    themeToggle.addEventListener('click', () => {
        document.body.classList.toggle('dark-mode');
        let theme = 'light';
        if (document.body.classList.contains('dark-mode')) {
            theme = 'dark';
            themeToggle.innerText = '☀️';
        } else {
            themeToggle.innerText = '🌙';
        }
        localStorage.setItem('theme', theme);
    });

    <c:if test="${not empty sessionScope.user}">
    // Fetch unread notifications count
    document.addEventListener("DOMContentLoaded", function() {
        fetch('${pageContext.request.contextPath}/notifications/unread-count')
            .then(response => response.json())
            .then(data => {
                const badge = document.getElementById('notif-badge');
                if (data.count > 0) {
                    badge.innerText = data.count;
                    badge.style.display = 'inline-block';
                }
            })
            .catch(err => console.error("Error fetching notifications", err));
    });
    </c:if>
</script>
