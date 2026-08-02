package com.talentconnect.controller;

import com.talentconnect.model.Notification;
import com.talentconnect.model.User;
import com.talentconnect.repository.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications", "/notifications/unread-count"})
public class NotificationServlet extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            if (request.getServletPath().equals("/notifications/unread-count")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"count\": 0}");
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        String path = request.getServletPath();
        
        if (path.equals("/notifications/unread-count")) {
            int unreadCount = notificationDAO.getUnreadCount(sessionUser.getId());
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"count\": " + unreadCount + "}");
            out.flush();
        } else {
            // Hiển thị trang danh sách thông báo
            List<Notification> notifications = notificationDAO.getNotificationsByUser(sessionUser.getId());
            request.setAttribute("notifications", notifications);
            
            // Đánh dấu đã đọc tất cả
            notificationDAO.markAsRead(sessionUser.getId());
            
            request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
        }
    }
}
