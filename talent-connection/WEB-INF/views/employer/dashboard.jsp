<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Nhà Tuyển Dụng | TalentConnect</title>
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
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/employer/dashboard">
                            <span style="margin-right: 12px;">📋</span> Quản lý tin đăng tuyển
                        </a>
                    </li>
                    <li class="sidebar-item">
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
            <div style="display: flex; flex-direction: column; gap: 32px;">
                
                <!-- Alerts -->
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success">${sessionScope.successMsg}</div>
                    <% session.removeAttribute("successMsg"); %>
                </c:if>
                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger">${sessionScope.errorMsg}</div>
                    <% session.removeAttribute("errorMsg"); %>
                </c:if>

                <!-- Posted Jobs List -->
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                        <h2 style="font-size: 20px; font-weight: 700;">💼 Tin Tuyển Dụng / Show Diễn Đã Đăng</h2>
                        <a href="${pageContext.request.contextPath}/employer/post-job" class="btn btn-primary btn-sm">➕ Tạo tin mới</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty jobs}">
                            <div style="text-align: center; padding: 40px 20px;">
                                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">Bạn chưa đăng tin tuyển dụng nào.</p>
                                <a href="${pageContext.request.contextPath}/employer/post-job" class="btn btn-primary">Đăng tin ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Tiêu đề show / công việc</th>
                                            <th>Địa điểm</th>
                                            <th>Hạn nộp</th>
                                            <th>Lương (VNĐ)</th>
                                            <th>Trạng thái</th>
                                            <th>Quản lý ứng viên</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${jobs}" var="job">
                                            <tr>
                                                <td style="font-weight: 600;">${job.title}</td>
                                                <td>${job.location}</td>
                                                <td><fmt:formatDate value="${job.deadline}" pattern="dd/MM/yyyy"/></td>
                                                <td><fmt:formatNumber value="${job.salary}" type="number"/></td>
                                                <td>
                                                     <c:choose>
                                                         <c:when test="${'Open'.equalsIgnoreCase(job.status)}">
                                                            <span class="badge badge-approved">Đang mở</span>
                                                        </c:when>
                                                        <c:when test="${'Expired'.equalsIgnoreCase(job.status)}">
                                                            <span class="badge" style="background: var(--text-muted); color: white;">Hết hạn</span>
                                                        </c:when>
                                                         <c:when test="${'Pending'.equalsIgnoreCase(job.status)}">
                                                             <span class="badge badge-pending">Chờ duyệt</span>
                                                         </c:when>
                                                         <c:when test="${'Rejected'.equalsIgnoreCase(job.status)}">
                                                             <span class="badge badge-rejected">Từ chối</span>
                                                         </c:when>
                                                         <c:otherwise>
                                                             <span class="badge badge-rejected" style="filter: opacity(0.7);">Đã đóng</span>
                                                         </c:otherwise>
                                                     </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/employer/applicants?jobId=${job.id}" class="btn btn-secondary btn-sm" style="padding: 4px 12px; font-size: 12px; display: inline-flex; align-items: center; gap: 4px;">
                                                        <span>👥</span> Xem hồ sơ ứng tuyển
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
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
