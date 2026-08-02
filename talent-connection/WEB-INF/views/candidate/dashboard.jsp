<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Ứng Viên | TalentConnect</title>
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
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/candidate/dashboard">
                            <span style="margin-right: 12px;">📊</span> Dashboard của tôi
                        </a>
                    </li>
                    <li class="sidebar-item">
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
            <div style="display: flex; flex-direction: column; gap: 32px;">

                <!-- Applications List -->
                <div class="card">
                    <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 24px;">📝 Lịch Sử Ứng Tuyển Show Diễn</h2>
                    
                    <c:choose>
                        <c:when test="${empty apps}">
                            <div style="text-align: center; padding: 40px 20px;">
                                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">Bạn chưa nộp đơn ứng tuyển nào.</p>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-sm">Tìm kiếm show ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Tên công việc / Show diễn</th>
                                            <th>Nhà tuyển dụng / Bầu show</th>
                                            <th>Ngày ứng tuyển</th>
                                            <th>Trạng thái</th>
                                            <th>Xem chi tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${apps}" var="app">
                                            <tr>
                                                <td style="font-weight: 600;">${app.jobTitle}</td>
                                                <td>${app.employerName}</td>
                                                <td><fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${'Pending'.equalsIgnoreCase(app.status)}">
                                                            <span class="badge badge-pending">Chờ phản hồi</span>
                                                        </c:when>
                                                        <c:when test="${'Approved'.equalsIgnoreCase(app.status)}">
                                                            <span class="badge badge-approved">Được chấp nhận</span>
                                                        </c:when>
                                                        <c:when test="${'Completed'.equalsIgnoreCase(app.status)}">
                                                            <span class="badge" style="background: var(--color-success); color: white;">Hoàn thành</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-rejected">Từ chối</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/candidate/job-detail?id=${app.jobId}" class="btn btn-secondary btn-sm" style="padding: 4px 12px; font-size: 12px; margin-bottom: 4px; display: block; text-align: center;">Xem lại tin</a>
                                                    <c:if test="${'Completed'.equalsIgnoreCase(app.status)}">
                                                        <button type="button" class="btn btn-primary btn-sm" style="padding: 4px 12px; font-size: 12px; width: 100%;" onclick="openReviewModal(${app.jobId}, ${app.employerId}, '${app.employerName}')">⭐ Đánh giá</button>
                                                    </c:if>
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

    <!-- Review Modal -->
    <div id="reviewModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.5);">
        <div class="modal-content card" style="background-color: var(--bg-card); margin: 15% auto; padding: 24px; border: 1px solid var(--border-color); width: 80%; max-width: 400px; border-radius: var(--radius-lg);">
            <h3 style="margin-top: 0; font-size: 18px; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">Đánh giá Nhà Tuyển Dụng</h3>
            <p id="reviewEmployerName" style="font-weight: bold; margin-bottom: 16px; color: var(--secondary);"></p>
            <form action="${pageContext.request.contextPath}/candidate/review/submit" method="POST">
                <input type="hidden" name="jobId" id="reviewJobId">
                <input type="hidden" name="employerId" id="reviewEmployerId">
                
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 8px; font-size: 14px; color: var(--text-muted);">Số sao (1-5):</label>
                    <select name="rating" required class="form-control" style="width: 100%; padding: 8px; background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); border-radius: var(--radius-sm);">
                        <option value="5">⭐⭐⭐⭐⭐ (5 - Tuyệt vời)</option>
                        <option value="4">⭐⭐⭐⭐ (4 - Tốt)</option>
                        <option value="3">⭐⭐⭐ (3 - Bình thường)</option>
                        <option value="2">⭐⭐ (2 - Kém)</option>
                        <option value="1">⭐ (1 - Rất tệ)</option>
                    </select>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-size: 14px; color: var(--text-muted);">Bình luận:</label>
                    <textarea name="comment" rows="3" class="form-control" placeholder="Nhập nhận xét của bạn..." style="width: 100%; padding: 8px; background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); border-radius: var(--radius-sm);"></textarea>
                </div>
                
                <div style="display: flex; gap: 12px; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeReviewModal()" style="padding: 8px 16px;">Hủy</button>
                    <button type="submit" class="btn btn-primary" style="padding: 8px 16px;">Gửi Đánh Giá</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openReviewModal(jobId, employerId, employerName) {
            document.getElementById('reviewJobId').value = jobId;
            document.getElementById('reviewEmployerId').value = employerId;
            document.getElementById('reviewEmployerName').innerText = 'Nhà tuyển dụng: ' + employerName;
            document.getElementById('reviewModal').style.display = 'block';
        }
        function closeReviewModal() {
            document.getElementById('reviewModal').style.display = 'none';
        }
    </script>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
