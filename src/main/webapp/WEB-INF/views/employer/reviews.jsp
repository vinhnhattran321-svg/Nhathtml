<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá & Nhận Xét | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .review-card {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 8px;
        }
        .review-rating {
            color: #fbbf24;
            font-size: 18px;
        }
        .review-job {
            font-size: 14px;
            color: var(--primary);
            font-weight: 600;
        }
    </style>
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
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/employer/post-job">
                            <span style="margin-right: 12px;">➕</span> Đăng tin tuyển dụng mới
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/employer/reviews">
                            <span style="margin-right: 12px;">⭐</span> Đánh giá & Nhận xét
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Panel -->
            <div style="display: flex; flex-direction: column; gap: 32px;">
                <div class="card" style="padding: 24px;">
                    <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                        <span>⭐</span> Đánh giá & Nhận xét của tôi
                    </h2>
                    
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <p style="color: var(--text-muted); font-size: 14px;">Bạn chưa nhận được đánh giá nào.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${reviews}" var="review">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div style="display: flex; flex-direction: column; gap: 4px;">
                                            <span style="font-weight: 600; color: var(--text-color); font-size: 16px;">Từ: ${review.reviewerName}</span>
                                            <span class="review-job">Show: ${review.jobTitle}</span>
                                        </div>
                                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                            <span class="review-rating">
                                                <c:forEach begin="1" end="${review.rating}">★</c:forEach><c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                            </span>
                                            <span style="font-size: 12px; color: var(--text-muted);">
                                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                    </div>
                                    <p style="font-size: 14px; color: var(--text-color); line-height: 1.5; margin-top: 8px; padding: 12px; background-color: var(--background); border-radius: 4px;">
                                        ${empty review.comment ? '<i style="color: var(--text-muted)">Không có nhận xét chi tiết.</i>' : review.comment}
                                    </p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
