<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        .notif-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .notif-item {
            display: flex;
            align-items: flex-start;
            padding: 20px;
            margin-bottom: 16px;
            border-radius: 12px;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            transition: var(--transition-fast);
        }
        .notif-item:hover {
            transform: translateX(4px);
            border-color: var(--primary);
            box-shadow: var(--shadow-sm);
        }
        .notif-item.unread {
            background: rgba(224, 122, 95, 0.05);
            border-left: 4px solid var(--primary);
        }
        .notif-icon {
            font-size: 24px;
            margin-right: 16px;
            background: rgba(224, 122, 95, 0.1);
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }
        .notif-content {
            flex: 1;
        }
        .notif-message {
            font-size: 15px;
            color: var(--text-main);
            margin-bottom: 8px;
            line-height: 1.5;
        }
        .notif-date {
            font-size: 13px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <main class="container">
        <div class="notif-container">
            <h1 style="font-size: 28px; font-weight: 800; margin-bottom: 32px; display: flex; align-items: center; gap: 12px;">
                <span>🔔</span> Thông báo của bạn
            </h1>
            
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="card" style="text-align: center; padding: 60px 20px;">
                        <span style="font-size: 48px; display: block; margin-bottom: 16px; opacity: 0.5;">📭</span>
                        <h3 style="margin-bottom: 8px;">Bạn không có thông báo nào</h3>
                        <p style="color: var(--text-muted);">Khi có hoạt động mới, thông báo sẽ xuất hiện ở đây.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${notifications}" var="notif">
                        <div class="notif-item ${notif.read ? '' : 'unread'}">
                            <div class="notif-icon">
                                🔔
                            </div>
                            <div class="notif-content">
                                <div class="notif-message">
                                    ${notif.message}
                                </div>
                                <div class="notif-date">
                                    <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="footer.jsp" />

</body>
</html>
