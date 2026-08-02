package com.talentconnect.controller;

import com.talentconnect.model.Application;
import com.talentconnect.model.Job;
import com.talentconnect.model.User;
import com.talentconnect.model.Profile;
import com.talentconnect.repository.ApplicationDAO;
import com.talentconnect.repository.JobDAO;
import com.talentconnect.repository.NotificationDAO;
import com.talentconnect.repository.UserDAO;
import com.talentconnect.repository.ReviewDAO;
import com.talentconnect.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.File;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

/**
 * Servlet xử lý các chức năng của Nhà tuyển dụng / Bầu show (Employer).
 * URL Patterns: /employer/* (dashboard, post-job, applicants, applicants/status)
 */
@WebServlet(name = "EmployerServlet", urlPatterns = {"/employer/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class EmployerServlet extends HttpServlet {
    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        User sessionUser = (User) request.getSession().getAttribute("user");

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response, sessionUser);
                break;
                
            case "/post-job":
                request.getRequestDispatcher("/WEB-INF/views/employer/post-job.jsp").forward(request, response);
                break;
                
            case "/applicants":
                showApplicants(request, response);
                break;
                
            case "/candidate-profile":
                showCandidateProfile(request, response);
                break;
                
            case "/review":
                showReviewForm(request, response);
                break;
                
            case "/reviews":
                showReviews(request, response, sessionUser);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        User sessionUser = (User) request.getSession().getAttribute("user");

        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/post-job":
                saveJob(request, response, sessionUser);
                break;
                
            case "/applicants/status":
                updateApplicantStatus(request, response);
                break;
                
            case "/review":
                processReview(request, response, sessionUser);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void showReviews(HttpServletRequest request, HttpServletResponse response, User sessionUser) 
            throws ServletException, IOException {
        List<Review> reviews = reviewDAO.getReviewsReceivedByEmployer(sessionUser.getId());
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/employer/reviews.jsp").forward(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Lấy danh sách tin tuyển dụng đã đăng của employer
        List<Job> postedJobs = jobDAO.getJobsByEmployer(user.getId());
        request.setAttribute("jobs", postedJobs);
        
        request.getRequestDispatcher("/WEB-INF/views/employer/dashboard.jsp").forward(request, response);
    }

    private void saveJob(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String requirements = request.getParameter("requirements");
        String salaryStr = request.getParameter("salary");
        String location = request.getParameter("location");
        String deadlineStr = request.getParameter("deadline");
        String tags = request.getParameter("tags");
        Part thumbnailPart = request.getPart("thumbnailFile");

        // 1. Kiểm tra validation
        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            salaryStr == null || deadlineStr == null) {
            
            request.setAttribute("errorMsg", "Vui lòng nhập đầy đủ các trường thông tin!");
            request.getRequestDispatcher("/WEB-INF/views/employer/post-job.jsp").forward(request, response);
            return;
        }

        double salary = 0;
        try {
            salary = Double.parseDouble(salaryStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Mức lương không hợp lệ!");
            request.getRequestDispatcher("/WEB-INF/views/employer/post-job.jsp").forward(request, response);
            return;
        }

        // Chuyển đổi deadline dạng string 'YYYY-MM-DD' sang Timestamp
        Timestamp deadline = null;
        try {
            deadline = Timestamp.valueOf(deadlineStr + " 23:59:59");
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Hạn nộp không đúng định dạng (YYYY-MM-DD)!");
            request.getRequestDispatcher("/WEB-INF/views/employer/post-job.jsp").forward(request, response);
            return;
        }

        Job job = new Job();
        job.setEmployerId(user.getId());
        job.setTitle(title.trim());
        job.setDescription(description.trim());
        job.setRequirements(requirements != null ? requirements.trim() : "");
        job.setSalary(salary);
        job.setLocation(location != null ? location.trim() : "");
        job.setDeadline(deadline);
        job.setTags(tags != null ? tags.trim() : "");
        
        // Handle Thumbnail Upload
        String thumbnailUrl = "";
        if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "jobs";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            String fileName = UUID.randomUUID().toString() + "_" + thumbnailPart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            saveFilePersistent(thumbnailPart, "uploads" + File.separator + "jobs", fileName, request);
            thumbnailUrl = request.getContextPath() + "/uploads/jobs/" + fileName;
        }
        job.setThumbnailUrl(thumbnailUrl);

        boolean success = jobDAO.addJob(job);

        if (success) {
            request.getSession().setAttribute("successMsg", "Đăng tin thành công! Tin đang chờ Admin kiểm duyệt.");
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        } else {
            request.setAttribute("errorMsg", "Đăng tin thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/employer/post-job.jsp").forward(request, response);
        }
    }

    private void showApplicants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("jobId");
        if (jobIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        try {
            int jobId = Integer.parseInt(jobIdStr);
            Job job = jobDAO.getJobById(jobId);
            
            if (job == null) {
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            }

            // Lấy danh sách hồ sơ nộp vào công việc này
            List<Application> apps = applicationDAO.getApplicationsByJob(jobId);
            
            // Kiểm tra trạng thái đã đánh giá
            User sessionUser = (User) request.getSession().getAttribute("user");
            Map<Integer, Boolean> reviewStatus = new HashMap<>();
            if (sessionUser != null) {
                for (Application app : apps) {
                    if ("Completed".equalsIgnoreCase(app.getStatus())) {
                        reviewStatus.put(app.getId(), reviewDAO.hasReviewed(app.getJobId(), sessionUser.getId()));
                    }
                }
            }
            
            request.setAttribute("job", job);
            request.setAttribute("apps", apps);
            request.setAttribute("reviewStatus", reviewStatus);
            request.getRequestDispatcher("/WEB-INF/views/employer/applicants.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        }
    }

    private void updateApplicantStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appIdStr = request.getParameter("appId");
        String status = request.getParameter("status"); // Approved hoặc Rejected
        String jobIdStr = request.getParameter("jobId");

        if (appIdStr == null || status == null || jobIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        try {
            int appId = Integer.parseInt(appIdStr);
            
            boolean success = applicationDAO.updateApplicationStatus(appId, status);
            
            if (success) {
                // Lấy thông tin ứng tuyển để gửi thông báo cho ứng viên
                Application app = applicationDAO.getApplicationById(appId);
                if (app != null) {
                    String statusText = "Approved".equalsIgnoreCase(status) ? "ĐƯỢC CHẤP NHẬN" : ("Rejected".equalsIgnoreCase(status) ? "BỊ TỪ CHỐI" : "ĐÃ HOÀN THÀNH");
                    String message = "Hồ sơ ứng tuyển của bạn cho vị trí '" + app.getJobTitle() + "' đã " + statusText + ".";
                    notificationDAO.addNotification(app.getCandidateId(), message);
                    
                    if ("Completed".equalsIgnoreCase(status)) {
                        userDAO.addRankingPoints(app.getCandidateId(), 10);
                        notificationDAO.addNotification(app.getCandidateId(), "Chúc mừng! Bạn đã hoàn thành show diễn và được cộng 10 điểm xếp hạng.");
                    }
                }
                
                request.getSession().setAttribute("successMsg", "Đã cập nhật trạng thái hồ sơ ứng viên thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Cập nhật trạng thái hồ sơ thất bại!");
            }

            response.sendRedirect(request.getContextPath() + "/employer/applicants?jobId=" + jobIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        }
    }

    private void showCandidateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        try {
            int candidateId = Integer.parseInt(idStr);
            User candidate = userDAO.getUserById(candidateId);
            if (candidate == null || (candidate.getRoleId() != 2 && candidate.getRoleId() != 4)) {
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            }

            Profile profile = userDAO.getProfileByUserId(candidateId);
            if (profile == null) {
                profile = new Profile();
                profile.setUserId(candidateId);
            }

            if (candidate.getRoleId() == 4) {
                List<User> bandMembers = userDAO.getBandMembers(candidateId);
                request.setAttribute("bandMembers", bandMembers);
            }

            request.setAttribute("candidate", candidate);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/employer/candidate-profile.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        }
    }

    private void showReviewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appIdStr = request.getParameter("appId");
        if (appIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        try {
            int appId = Integer.parseInt(appIdStr);
            Application app = applicationDAO.getApplicationById(appId);
            
            if (app == null || !"Completed".equalsIgnoreCase(app.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            }
            
            User sessionUser = (User) request.getSession().getAttribute("user");
            if (reviewDAO.hasReviewed(app.getJobId(), sessionUser.getId())) {
                request.getSession().setAttribute("errorMsg", "Bạn đã đánh giá nghệ sĩ này cho show diễn này rồi!");
                response.sendRedirect(request.getContextPath() + "/employer/applicants?jobId=" + app.getJobId());
                return;
            }

            User candidate = userDAO.getUserById(app.getCandidateId());
            
            request.setAttribute("app", app);
            request.setAttribute("candidate", candidate);
            request.getRequestDispatcher("/WEB-INF/views/employer/review.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        }
    }

    private void processReview(HttpServletRequest request, HttpServletResponse response, User employer)
            throws ServletException, IOException {
        String appIdStr = request.getParameter("appId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (appIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        try {
            int appId = Integer.parseInt(appIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            Application app = applicationDAO.getApplicationById(appId);
            if (app == null || !"Completed".equalsIgnoreCase(app.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            }
            
            if (reviewDAO.hasReviewed(app.getJobId(), employer.getId())) {
                request.getSession().setAttribute("errorMsg", "Bạn đã đánh giá nghệ sĩ này cho show diễn này rồi!");
                response.sendRedirect(request.getContextPath() + "/employer/applicants?jobId=" + app.getJobId());
                return;
            }

            Review review = new Review();
            review.setJobId(app.getJobId());
            review.setCandidateId(app.getCandidateId());
            review.setEmployerId(employer.getId());
            review.setReviewerId(employer.getId());
            review.setRating(rating);
            review.setComment(comment != null ? comment.trim() : "");

            boolean success = reviewDAO.addReview(review);

            if (success) {
                userDAO.updateArtistRating(app.getCandidateId());
                notificationDAO.addNotification(app.getCandidateId(), "Bạn đã nhận được đánh giá " + rating + " sao từ nhà tuyển dụng cho show '" + app.getJobTitle() + "'.");
                request.getSession().setAttribute("successMsg", "Đánh giá nghệ sĩ thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi khi lưu đánh giá.");
            }

            response.sendRedirect(request.getContextPath() + "/employer/applicants?jobId=" + app.getJobId());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        }
    }

    private void saveFilePersistent(Part part, String relativeFolder, String fileName, HttpServletRequest request) throws IOException {
        String deployedPath = request.getServletContext().getRealPath("") + File.separator + relativeFolder;
        File deployDir = new File(deployedPath);
        if (!deployDir.exists()) deployDir.mkdirs();
        
        String deployedFilePath = deployedPath + File.separator + fileName;
        part.write(deployedFilePath);

        try {
            String projectRoot = System.getProperty("user.dir");
            String sourcePath = projectRoot + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + relativeFolder;
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) sourceDir.mkdirs();
            
            java.nio.file.Files.copy(
                java.nio.file.Paths.get(deployedFilePath),
                java.nio.file.Paths.get(sourcePath + File.separator + fileName),
                java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );
        } catch (Exception e) {
            System.err.println("Could not save to source directory: " + e.getMessage());
        }
    }
}
