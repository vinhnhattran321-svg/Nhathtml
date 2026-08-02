<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ Thống Quản Trị Admin | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .admin-layout {
            display: flex;
            flex-direction: column;
            gap: 28px;
        }
        .admin-tabs {
            display: flex;
            gap: 12px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
            margin-bottom: 8px;
        }
        .tab-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            padding: 10px 24px;
            border-radius: var(--radius-sm);
            font-size: 14.5px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-fast);
        }
        .tab-btn:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--text-main);
        }
        .tab-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-inverse);
            border: none;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.2);
        }
        .tab-content {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 12px;
        }
        .stat-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.02) 0%, rgba(255,255,255,0.05) 100%);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-sm);
            background: rgba(79, 70, 229, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: var(--secondary);
        }
        .stat-number {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            margin-top: 4px;
        }
        .stat-label {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="../navbar.jsp" />

    <main class="container">
        <div class="admin-layout">
            
            <!-- Page Header -->
            <div>
                <span style="font-size: 12px; font-weight: 700; color: var(--secondary); text-transform: uppercase; letter-spacing: 1.5px;">Bảng Điều Khiển Hệ Thống</span>
                <h1 style="font-size: 32px; font-weight: 800; margin-top: 6px; background: linear-gradient(135deg, #ffffff, #a5b4fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Hệ Thống Quản Trị Admin</h1>
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

            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div>
                        <div class="stat-label">Tổng người dùng</div>
                        <div class="stat-number">${users.size()}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💼</div>
                    <div>
                        <div class="stat-label">Tin tuyển dụng</div>
                        <div class="stat-number">${jobs.size()}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🛡️</div>
                    <div>
                        <div class="stat-label">Vai trò Admin</div>
                        <div class="stat-number">1</div>
                    </div>
                </div>
            </div>

            <!-- Tabs Navigation -->
            <div class="admin-tabs">
                <button id="users-btn" class="tab-btn active" onclick="switchTab('users-tab', this)">👤 Quản lý Người dùng</button>
                <button id="jobs-btn" class="tab-btn" onclick="switchTab('jobs-tab', this)">💼 Quản lý Tin tuyển dụng</button>
            </div>

            <!-- Tab 1: Users Management -->
            <div id="users-tab" class="tab-content" style="display: block;">
                <div class="card" style="padding: 28px;">
                    <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 20px; color: var(--text-main);">Danh Sách Tất Cả Thành Viên</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và tên</th>
                                    <th>Tài khoản</th>
                                    <th>Email / SĐT</th>
                                    <th>Vai trò</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="u">
                                    <tr>
                                        <td>#${u.id}</td>
                                        <td style="font-weight: 600; color: var(--text-main);">${u.fullName}</td>
                                        <td><code>${u.username}</code></td>
                                        <td>
                                            <div style="font-size: 13px; margin-bottom: 2px;">${u.email}</div>
                                            <div style="font-size: 13px; color: var(--text-muted);">${u.phone}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Admin'.equalsIgnoreCase(u.roleName)}">
                                                    <span style="color: var(--accent); font-weight: 700;">🛡️ Admin</span>
                                                </c:when>
                                                <c:when test="${'Employer'.equalsIgnoreCase(u.roleName)}">
                                                    <span style="color: var(--secondary); font-weight: 600;">💼 Bầu show</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #a5b4fc; font-weight: 500;">🎨 Nghệ sĩ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.active}">
                                                    <span class="badge badge-approved" style="font-size: 11px;">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-rejected" style="font-size: 11px;">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: center;">
                                            <c:choose>
                                                <c:when test="${'Admin'.equalsIgnoreCase(u.roleName)}">
                                                    <span style="font-size: 12px; color: var(--text-muted); font-style: italic;">Hệ thống</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/admin/user-status" method="POST" style="margin: 0; display: inline-block;">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <c:choose>
                                                            <c:when test="${u.active}">
                                                                <input type="hidden" name="active" value="false">
                                                                <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none;">
                                                                    🔒 Khóa
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="hidden" name="active" value="true">
                                                                <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none; background: var(--color-success);">
                                                                    🔓 Mở khóa
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Tab 2: Jobs Management -->
            <div id="jobs-tab" class="tab-content">
                <div class="card" style="padding: 28px;">
                    <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 20px; color: var(--text-main);">Danh Sách Bài Đăng Tuyển Dụng / Show Diễn</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tiêu đề bài đăng</th>
                                    <th>Nhà tuyển dụng / Bầu show</th>
                                    <th>Địa điểm</th>
                                    <th>Lương</th>
                                    <th>Hạn nộp</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${jobs}" var="j">
                                    <tr>
                                        <td>#${j.id}</td>
                                        <td style="font-weight: 600; color: var(--text-main);">${j.title}</td>
                                        <td>${j.employerName}</td>
                                        <td>📍 ${j.location}</td>
                                        <td>💰 <fmt:formatNumber value="${j.salary}" type="number"/> VNĐ</td>
                                        <td><fmt:formatDate value="${j.deadline}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Open'.equalsIgnoreCase(j.status)}">
                                                    <span class="badge badge-approved" style="font-size: 11px;">Đang mở</span>
                                                </c:when>
                                                <c:when test="${'Pending'.equalsIgnoreCase(j.status)}">
                                                    <span class="badge badge-pending" style="font-size: 11px;">Chờ duyệt</span>
                                                </c:when>
                                                <c:when test="${'Rejected'.equalsIgnoreCase(j.status)}">
                                                    <span class="badge badge-rejected" style="font-size: 11px;">Từ chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-rejected" style="font-size: 11px; filter: opacity(0.7);">Đã đóng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: center;">
                                            <c:choose>
                                                <c:when test="${'Pending'.equalsIgnoreCase(j.status)}">
                                                    <form action="${pageContext.request.contextPath}/admin/job-status" method="POST" style="margin: 0; display: inline-block; margin-right: 6px;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="status" value="Open">
                                                        <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none; background: var(--color-success);">
                                                            ✅ Duyệt
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/job-status" method="POST" style="margin: 0; display: inline-block;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="status" value="Rejected">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none;">
                                                            ❌ Từ chối
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${'Open'.equalsIgnoreCase(j.status)}">
                                                    <form action="${pageContext.request.contextPath}/admin/job-status" method="POST" style="margin: 0; display: inline-block;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="status" value="Closed">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none;">
                                                            🛑 Đóng tin
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/admin/job-status" method="POST" style="margin: 0; display: inline-block;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="status" value="Open">
                                                        <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 12px; box-shadow: none; background: var(--color-success);">
                                                            🟢 Mở tin
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="../footer.jsp" />

    <script>
        function switchTab(tabId, btn) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(el => {
                el.style.display = 'none';
            });
            // Show target tab
            document.getElementById(tabId).style.display = 'block';
            
            // Deactivate all tab buttons
            document.querySelectorAll('.tab-btn').forEach(el => {
                el.classList.remove('active');
            });
            // Activate current button
            btn.classList.add('active');
        }
    </script>
</body>
</html>
