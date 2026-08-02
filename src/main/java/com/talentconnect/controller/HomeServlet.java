package com.talentconnect.controller;

import com.talentconnect.model.Job;
import com.talentconnect.model.Profile;
import com.talentconnect.model.Review;
import com.talentconnect.model.User;
import com.talentconnect.repository.ApplicationDAO;
import com.talentconnect.repository.JobDAO;
import com.talentconnect.repository.ReviewDAO;
import com.talentconnect.repository.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet trang chủ. Hiển thị danh sách tin tuyển dụng/show diễn,
 * hỗ trợ tìm kiếm và lọc tin tuyển dụng.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/job-detail"})
public class HomeServlet extends HttpServlet {
    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        if ("/job-detail".equals(path)) {
            showJobDetail(request, response);
            return;
        }
        // Nhận tham số tìm kiếm
        String query = request.getParameter("q");
        String location = request.getParameter("loc");
        
        List<Job> jobs;
        
        // Nếu có tìm kiếm, gọi hàm search. Ngược lại lấy tất cả tin đang mở.
        if ((query != null && !query.trim().isEmpty()) || (location != null && !location.trim().isEmpty())) {
            jobs = jobDAO.searchJobs(query, location);
        } else {
            jobs = jobDAO.getAllOpenJobs();
        }
        
        String minSalStr = request.getParameter("minSal");
        String maxSalStr = request.getParameter("maxSal");
        if (minSalStr != null && !minSalStr.isEmpty()) {
            try {
                double minSal = Double.parseDouble(minSalStr);
                jobs.removeIf(job -> job.getSalary() < minSal);
            } catch (Exception e) {}
        }
        if (maxSalStr != null && !maxSalStr.isEmpty()) {
            try {
                double maxSal = Double.parseDouble(maxSalStr);
                jobs.removeIf(job -> job.getSalary() > maxSal);
            } catch (Exception e) {}
        }
        
        // Pagination
        int pageSize = 9; // 3 cột x 3 hàng
        int currentPage = 1;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) currentPage = Integer.parseInt(pageStr);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) { currentPage = 1; }

        int totalJobs = jobs.size();
        int totalPages = (int) Math.ceil((double) totalJobs / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalJobs);
        List<Job> pagedJobs = jobs.subList(fromIndex, toIndex);

        // Đặt dữ liệu vào request attributes để hiển thị lên JSP
        request.setAttribute("jobs", pagedJobs);
        request.setAttribute("query", query);
        request.setAttribute("location", location);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        // Forward tới trang index.jsp nằm trong WEB-INF bảo mật
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }

    private void showJobDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int jobId = Integer.parseInt(idStr);
            Job job = jobDAO.getJobById(jobId);
            if (job == null || "Pending".equalsIgnoreCase(job.getStatus()) || "Rejected".equalsIgnoreCase(job.getStatus())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tin tuyển dụng này chưa được duyệt hoặc không tồn tại.");
                return;
            }
            
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            boolean hasApplied = false;
            Profile profile = null;
            if (user != null && "Candidate".equalsIgnoreCase(user.getRoleName())) {
                hasApplied = applicationDAO.hasApplied(user.getId(), jobId);
                profile = userDAO.getProfileByUserId(user.getId());
            }
            
            // Lấy danh sách đánh giá của nhà tuyển dụng này
            List<Review> employerReviews = reviewDAO.getReviewsReceivedByEmployer(job.getEmployerId());
            
            boolean isExpired = false;
            if (job.getDeadline() != null) {
                isExpired = job.getDeadline().before(new java.util.Date());
            }
            
            request.setAttribute("job", job);
            request.setAttribute("hasApplied", hasApplied);
            request.setAttribute("profile", profile);
            request.setAttribute("employerReviews", employerReviews);
            request.setAttribute("isExpired", isExpired);
            
            request.getRequestDispatcher("/WEB-INF/views/job-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
