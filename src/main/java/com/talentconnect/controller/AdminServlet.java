package com.talentconnect.controller;

import com.talentconnect.model.Job;
import com.talentconnect.model.User;
import com.talentconnect.repository.JobDAO;
import com.talentconnect.repository.UserDAO;
import com.talentconnect.repository.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý các chức năng quản trị hệ thống của Quản trị viên (Admin).
 * URL Patterns: /admin/* (dashboard, user-status, job-status)
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin/*"})
public class AdminServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if ("/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/user-status":
                changeUserStatus(request, response);
                break;
                
            case "/job-status":
                changeJobStatus(request, response);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách toàn bộ người dùng
        List<User> users = userDAO.getAllUsers();
        // Lấy danh sách toàn bộ bài tuyển dụng
        List<Job> jobs = jobDAO.getAllJobsForAdmin();

        request.setAttribute("users", users);
        request.setAttribute("jobs", jobs);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void changeUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String activeStr = request.getParameter("active"); // true hoặc false

        if (userIdStr != null && activeStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                boolean active = Boolean.parseBoolean(activeStr);
                
                boolean success = userDAO.updateUserStatus(userId, active);
                if (success) {
                    request.getSession().setAttribute("successMsg", "Đã cập nhật trạng thái tài khoản thành công!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Cập nhật trạng thái tài khoản thất bại!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "Mã người dùng không hợp lệ!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private void changeJobStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("jobId");
        String status = request.getParameter("status"); // Open, Closed, Rejected

        if (jobIdStr != null && status != null) {
            try {
                int jobId = Integer.parseInt(jobIdStr);
                boolean success = jobDAO.updateJobStatus(jobId, status);
                if (success) {
                    // Gửi thông báo cho nhà tuyển dụng
                    Job job = jobDAO.getJobById(jobId);
                    if (job != null) {
                        String notifMsg = "";
                        if ("Open".equalsIgnoreCase(status)) {
                            notifMsg = "Bài đăng tuyển dụng '" + job.getTitle() + "' của bạn đã được Admin phê duyệt và đang hiển thị.";
                        } else if ("Rejected".equalsIgnoreCase(status)) {
                            notifMsg = "Bài đăng tuyển dụng '" + job.getTitle() + "' của bạn đã bị từ chối phê duyệt.";
                        } else if ("Closed".equalsIgnoreCase(status)) {
                            notifMsg = "Bài đăng tuyển dụng '" + job.getTitle() + "' của bạn đã được đóng.";
                        } else {
                            notifMsg = "Trạng thái bài đăng tuyển dụng '" + job.getTitle() + "' của bạn đã được cập nhật thành: " + status;
                        }
                        notificationDAO.addNotification(job.getEmployerId(), notifMsg);
                    }
                    request.getSession().setAttribute("successMsg", "Đã cập nhật trạng thái tin tuyển dụng!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Cập nhật trạng thái tin tuyển dụng thất bại!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "Mã tin tuyển dụng không hợp lệ!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
