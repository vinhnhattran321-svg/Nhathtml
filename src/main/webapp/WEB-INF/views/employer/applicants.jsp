<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Ứng Tuyển | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .applicant-cover-letter {
            background-color: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 12px;
            font-size: 13.5px;
            color: var(--text-muted);
            margin-top: 8px;
            max-width: 400px;
            word-wrap: break-word;
            white-space: pre-line;
        }
        .job-summary {
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
            border: 1px solid rgba(79, 70, 229, 0.2);
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div style="margin-bottom: 24px;">
            <a href="${pageContext.request.contextPath}/employer/dashboard" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 8px;">
                <span>⬅️</span> Quay lại Dashboard
            </a>
        </div>

        <!-- Job Summary Box -->
        <div class="card job-summary" style="margin-bottom: 32px; padding: 28px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px;">
                <div>
                    <span style="font-size: 12px; font-weight: 700; color: var(--secondary); text-transform: uppercase; letter-spacing: 1px;">Tin tuyển dụng của bạn</span>
                    <h1 style="font-size: 28px; font-weight: 800; margin-top: 6px; color: var(--text-main);">${job.title}</h1>
                    <div style="display: flex; gap: 16px; margin-top: 12px; flex-wrap: wrap;">
                        <span style="font-size: 14px; color: var(--text-muted);">📍 Địa điểm: <strong style="color: var(--text-main);">${job.location}</strong></span>
                        <span style="font-size: 14px; color: var(--text-muted);">💰 Mức lương: <strong style="color: var(--secondary);"><fmt:formatNumber value="${job.salary}" type="number"/> VNĐ</strong></span>
                        <span style="font-size: 14px; color: var(--text-muted);">📅 Hạn nộp: <strong style="color: var(--accent);"><fmt:formatDate value="${job.deadline}" pattern="dd/MM/yyyy"/></strong></span>
                    </div>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${'Open'.equalsIgnoreCase(job.status)}">
                            <span class="badge badge-open" style="font-size: 13px; padding: 6px 16px;">Đang mở</span>
                        </c:when>
                        <c:when test="${'Expired'.equalsIgnoreCase(job.status)}">
                            <span class="badge" style="font-size: 13px; padding: 6px 16px; background: var(--text-muted); color: white;">Hết hạn</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge" style="font-size: 13px; padding: 6px 16px; background: #64748b; color: white;">Đã đóng</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success">${sessionScope.successMsg}</div>
            <% session.removeAttribute("successMsg"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger">${sessionScope.errorMsg}</div>
            <% session.removeAttribute("errorMsg"); %>
        </c:if>

        <!-- Applicants Table -->
        <div class="card" style="padding: 28px;">
            <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 24px; display: flex; align-items: center; gap: 8px;">
                <span>👥</span> Danh Sách Nghệ Sĩ Ứng Tuyển 
                <span style="font-size: 14px; font-weight: 500; color: var(--text-muted); background: rgba(255,255,255,0.08); padding: 2px 10px; border-radius: var(--radius-full); margin-left: 8px;">
                    ${empty apps ? 0 : apps.size()} hồ sơ
                </span>
            </h2>

            <c:choose>
                <c:when test="${empty apps}">
                    <div style="text-align: center; padding: 60px 20px;">
                        <span style="font-size: 48px;">📨</span>
                        <p style="margin-top: 16px; color: var(--text-muted); font-size: 15px;">Chưa có nghệ sĩ nào nộp hồ sơ ứng tuyển cho tin đăng này.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Nghệ sĩ / Ứng viên</th>
                                    <th>Thông tin liên hệ</th>
                                    <th>Thư giới thiệu & Hồ sơ CV</th>
                                    <th>Ngày ứng tuyển</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: center;">Thao tác duyệt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${apps}" var="app">
                                    <tr>
                                        <!-- Candidate Info -->
                                        <td>
                                            <div style="font-weight: 600; font-size: 15px; margin-bottom: 4px;">
                                                <a href="${pageContext.request.contextPath}/employer/candidate-profile?id=${app.candidateId}" style="color: var(--secondary); border-bottom: 1px dashed rgba(6, 182, 212, 0.4);" title="Nhấp để xem hồ sơ năng lực chi tiết">
                                                    ${app.candidateName}
                                                </a>
                                            </div>
                                            <div style="font-size: 12px; color: var(--text-muted);">ID Ứng viên: #${app.candidateId}</div>
                                        </td>
                                        
                                        <!-- Contact -->
                                        <td>
                                            <div style="font-size: 13.5px; margin-bottom: 2px;">✉️ ${app.candidateEmail}</div>
                                            <div style="font-size: 13.5px;">📞 ${app.candidatePhone}</div>
                                        </td>
                                        
                                        <!-- Cover Letter & Resume -->
                                        <td>
                                            <div>
                                                <a href="${app.resumeUrl}" target="_blank" class="btn btn-secondary btn-sm" style="padding: 4px 10px; font-size: 12px; display: inline-flex; align-items: center; gap: 4px;">
                                                    <span>📄</span> Mở CV / Portfolio
                                                </a>
                                            </div>
                                            <c:if test="${not empty app.coverLetter}">
                                                <div class="applicant-cover-letter">
                                                    <strong>Thư giới thiệu:</strong><br>
                                                    "${app.coverLetter}"
                                                </div>
                                            </c:if>
                                        </td>
                                        
                                        <!-- Applied Date -->
                                        <td>
                                            <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        
                                        <!-- Status Badge -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Pending'.equalsIgnoreCase(app.status)}">
                                                    <span class="badge badge-pending">Đang chờ duyệt</span>
                                                </c:when>
                                                <c:when test="${'Approved'.equalsIgnoreCase(app.status)}">
                                                    <span class="badge badge-approved">Đã nhận</span>
                                                </c:when>
                                                <c:when test="${'Completed'.equalsIgnoreCase(app.status)}">
                                                    <span class="badge" style="background: var(--color-success); color: white;">Hoàn thành</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-rejected">Từ chối</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <!-- Actions -->
                                        <td style="text-align: center;">
                                            <c:choose>
                                                <c:when test="${'Pending'.equalsIgnoreCase(app.status)}">
                                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                                        <!-- Form Chấp nhận -->
                                                        <form action="${pageContext.request.contextPath}/employer/applicants/status" method="POST" style="margin: 0;">
                                                            <input type="hidden" name="appId" value="${app.id}">
                                                            <input type="hidden" name="jobId" value="${job.id}">
                                                            <input type="hidden" name="status" value="Approved">
                                                            <button type="submit" class="btn btn-primary btn-sm" style="padding: 6px 12px; font-size: 12px; background: var(--color-success); box-shadow: none;">
                                                                ✔️ Chấp nhận
                                                            </button>
                                                        </form>
                                                        
                                                        <!-- Form Từ chối -->
                                                        <form action="${pageContext.request.contextPath}/employer/applicants/status" method="POST" style="margin: 0;">
                                                            <input type="hidden" name="appId" value="${app.id}">
                                                            <input type="hidden" name="jobId" value="${job.id}">
                                                            <input type="hidden" name="status" value="Rejected">
                                                            <button type="submit" class="btn btn-danger btn-sm" style="padding: 6px 12px; font-size: 12px; box-shadow: none;">
                                                                ❌ Từ chối
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:when>
                                                <c:when test="${'Approved'.equalsIgnoreCase(app.status)}">
                                                    <form action="${pageContext.request.contextPath}/employer/applicants/status" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="appId" value="${app.id}">
                                                        <input type="hidden" name="jobId" value="${job.id}">
                                                        <input type="hidden" name="status" value="Completed">
                                                        <button type="submit" class="btn btn-primary btn-sm" style="padding: 6px 12px; font-size: 12px; box-shadow: none; width: 100%;">
                                                            ✅ Hoàn thành show
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${'Completed'.equalsIgnoreCase(app.status)}">
                                                    <div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                                                        <span style="font-size: 13px; color: var(--text-muted);">Đã quyết định</span>
                                                        <c:choose>
                                                            <c:when test="${reviewStatus[app.id]}">
                                                                <span class="btn btn-sm" style="padding: 6px 12px; font-size: 12px; background-color: #9ca3af; color: white; border: none; box-shadow: none; width: 100%; display: flex; justify-content: center; align-items: center; gap: 4px; border-radius: 6px; cursor: not-allowed;" title="Bạn đã đánh giá ứng viên này rồi">
                                                                    ✔️ Đã đánh giá
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/employer/review?appId=${app.id}" class="btn btn-sm" style="padding: 6px 12px; font-size: 12px; background-color: #f59e0b; color: white; border: none; box-shadow: none; width: 100%; display: flex; justify-content: center; align-items: center; gap: 4px; border-radius: 6px; text-decoration: none;">
                                                                    ⭐ Đánh giá
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="font-size: 13px; color: var(--text-muted);">Đã quyết định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
