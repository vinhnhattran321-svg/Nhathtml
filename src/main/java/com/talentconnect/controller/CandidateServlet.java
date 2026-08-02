package com.talentconnect.controller;

import com.talentconnect.model.Application;
import com.talentconnect.model.Profile;
import com.talentconnect.model.User;
import com.talentconnect.model.Job;
import com.talentconnect.repository.ApplicationDAO;
import com.talentconnect.repository.JobDAO;
import com.talentconnect.repository.UserDAO;
import com.talentconnect.repository.NotificationDAO;
import com.talentconnect.repository.ReviewDAO;
import com.talentconnect.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

/**
 * Servlet xử lý các chức năng của Ứng viên (Candidate).
 * URL Patterns: /candidate/* (ví dụ: /candidate/dashboard, /candidate/profile, /candidate/apply)
 */
@WebServlet(name = "CandidateServlet", urlPatterns = {"/candidate/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class CandidateServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        User sessionUser = (User) request.getSession().getAttribute("user");
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response, sessionUser);
                break;
                
            case "/profile":
                showProfile(request, response, sessionUser);
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
            response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/profile/update":
                updateProfile(request, response, sessionUser);
                break;
                
            case "/profile/delete-cv":
                deleteCv(request, response, sessionUser);
                break;
                
            case "/profile/upload-cv-ajax":
                uploadCvAjax(request, response, sessionUser);
                break;
                
            case "/apply":
                submitApplication(request, response, sessionUser);
                break;
                
            case "/review/submit":
                submitReview(request, response, sessionUser);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Lấy danh sách lịch sử ứng tuyển
        List<Application> apps = applicationDAO.getApplicationsByCandidate(user.getId());
        request.setAttribute("apps", apps);
        
        request.getRequestDispatcher("/WEB-INF/views/candidate/dashboard.jsp").forward(request, response);
    }
    
    private void showReviews(HttpServletRequest request, HttpServletResponse response, User sessionUser) 
            throws ServletException, IOException {
        List<Review> reviews = reviewDAO.getReviewsReceivedByCandidate(sessionUser.getId());
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/candidate/reviews.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Lấy thông tin chi tiết profile của ứng viên
        Profile profile = userDAO.getProfileByUserId(user.getId());
        if (profile == null) {
            profile = new Profile();
            profile.setUserId(user.getId());
        }
        
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/WEB-INF/views/candidate/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String avatarUrl = request.getParameter("avatarUrl");
        String bio = request.getParameter("bio");
        String skills = request.getParameter("skills");
        String experience = request.getParameter("experience");
        String certificates = request.getParameter("certificates");
        String portfolioUrl = request.getParameter("portfolioUrl");

        // Handle File Uploads
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "cvs";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Profile existingProfile = userDAO.getProfileByUserId(user.getId());
        String currentCvImages = (existingProfile != null && existingProfile.getCvImages() != null) ? existingProfile.getCvImages() : "";
        
        StringBuilder newCvImages = new StringBuilder(currentCvImages);

        Collection<Part> parts = request.getParts();
        for (Part part : parts) {
            if ("cvFiles".equals(part.getName()) && part.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + part.getSubmittedFileName().replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
                saveFilePersistent(part, "uploads" + File.separator + "cvs", fileName, request);
                
                String fileUrl = request.getContextPath() + "/uploads/cvs/" + fileName;
                if (newCvImages.length() > 0) newCvImages.append(",");
                newCvImages.append(fileUrl);
            }
        }

        // Handle Avatar File Upload
        Part avatarPart = request.getPart("avatarFile");
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String uploadPathAvatar = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
            File uploadDirAvatar = new File(uploadPathAvatar);
            if (!uploadDirAvatar.exists()) uploadDirAvatar.mkdirs();
            
            String avatarFileName = UUID.randomUUID().toString() + "_" + avatarPart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            saveFilePersistent(avatarPart, "uploads" + File.separator + "avatars", avatarFileName, request);
            avatarUrl = request.getContextPath() + "/uploads/avatars/" + avatarFileName;
        }

        Profile profile = new Profile();
        profile.setUserId(user.getId());
        profile.setAvatarUrl(avatarUrl != null ? avatarUrl.trim() : "");
        profile.setBio(bio != null ? bio.trim() : "");
        profile.setSkills(skills != null ? skills.trim() : "");
        profile.setExperience(experience != null ? experience.trim() : "");
        profile.setCertificates(certificates != null ? certificates.trim() : "");
        profile.setPortfolioUrl(portfolioUrl != null ? portfolioUrl.trim() : "");
        profile.setCvImages(newCvImages.toString());

        boolean success = userDAO.updateProfile(profile);

        if (success) {
            request.setAttribute("successMsg", "Cập nhật hồ sơ năng lực thành công!");
        } else {
            request.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại!");
        }
        
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/WEB-INF/views/candidate/profile.jsp").forward(request, response);
    }
    
    private void deleteCv(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String cvUrlToDelete = request.getParameter("cvUrl");
        if (cvUrlToDelete != null && !cvUrlToDelete.trim().isEmpty()) {
            Profile profile = userDAO.getProfileByUserId(user.getId());
            if (profile != null && profile.getCvImages() != null) {
                String[] images = profile.getCvImages().split(",");
                List<String> updatedImages = new ArrayList<>();
                for (String img : images) {
                    if (!img.equals(cvUrlToDelete)) {
                        updatedImages.add(img);
                    }
                }
                profile.setCvImages(String.join(",", updatedImages));
                userDAO.updateProfile(profile);
                
                // Delete physical file
                String fileName = cvUrlToDelete.substring(cvUrlToDelete.lastIndexOf("/") + 1);
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "cvs";
                File file = new File(uploadPath + File.separator + fileName);
                if (file.exists()) {
                    file.delete();
                }
                
                request.getSession().setAttribute("successMsg", "Đã xóa ảnh CV thành công!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/candidate/profile");
    }

    private void uploadCvAjax(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            Part cvPart = request.getPart("cvFile");
            if (cvPart == null || cvPart.getSize() == 0) {
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy tệp CV\"}");
                return;
            }
            
            // Save the file
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "cvs";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            String fileName = UUID.randomUUID().toString() + "_" + cvPart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            saveFilePersistent(cvPart, "uploads" + File.separator + "cvs", fileName, request);
            
            String fileUrl = request.getContextPath() + "/uploads/cvs/" + fileName;
            
            // Update candidate's profile
            Profile profile = userDAO.getProfileByUserId(user.getId());
            if (profile == null) {
                profile = new Profile();
                profile.setUserId(user.getId());
            }
            
            String currentCvImages = profile.getCvImages() != null ? profile.getCvImages() : "";
            StringBuilder newCvImages = new StringBuilder(currentCvImages);
            if (newCvImages.length() > 0) newCvImages.append(",");
            newCvImages.append(fileUrl);
            
            profile.setCvImages(newCvImages.toString());
            userDAO.updateProfile(profile);
            
            response.getWriter().write("{\"success\": true, \"cvUrl\": \"" + fileUrl + "\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private void submitApplication(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("jobId");
        String coverLetter = request.getParameter("coverLetter");
        String resumeUrl = request.getParameter("resumeUrl");

        if (jobIdStr == null || resumeUrl == null || resumeUrl.trim().isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Vui lòng nhập link CV hồ sơ ứng tuyển!");
            response.sendRedirect(request.getContextPath() + "/candidate/job-detail?id=" + jobIdStr);
            return;
        }

        try {
            int jobId = Integer.parseInt(jobIdStr);
            
            // Check if job exists and is not expired
            Job job = jobDAO.getJobById(jobId);
            if (job == null || !"open".equalsIgnoreCase(job.getStatus())) {
                request.getSession().setAttribute("errorMsg", "Tin tuyển dụng này đã hết hạn hoặc không còn nhận hồ sơ.");
                response.sendRedirect(request.getContextPath() + "/candidate/job-detail?id=" + jobIdStr);
                return;
            }
            
            // Kiểm tra trùng lặp đơn ứng tuyển
            if (applicationDAO.hasApplied(user.getId(), jobId)) {
                request.getSession().setAttribute("errorMsg", "Bạn đã nộp đơn ứng tuyển cho tin tuyển dụng này rồi!");
                response.sendRedirect(request.getContextPath() + "/candidate/job-detail?id=" + jobIdStr);
                return;
            }

            Application app = new Application();
            app.setJobId(jobId);
            app.setCandidateId(user.getId());
            app.setCoverLetter(coverLetter != null ? coverLetter.trim() : "");
            app.setResumeUrl(resumeUrl.trim());

            boolean success = applicationDAO.apply(app);

            if (success) {
                // Tạo thông báo cho Candidate
                notificationDAO.addNotification(user.getId(), "Bạn đã nộp hồ sơ ứng tuyển thành công. Vui lòng chờ phản hồi!");
                
                // Lấy thông tin Job để báo cho Employer
                if (job != null) {
                    notificationDAO.addNotification(job.getEmployerId(), "Bạn có 1 đơn ứng tuyển mới cho vị trí: " + job.getTitle());
                }
                
                request.getSession().setAttribute("successMsg", "Nộp đơn ứng tuyển thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Nộp đơn thất bại. Vui lòng kiểm tra lại!");
            }
            
            response.sendRedirect(request.getContextPath() + "/candidate/job-detail?id=" + jobIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void submitReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("jobId");
        String employerIdStr = request.getParameter("employerId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (jobIdStr == null || employerIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
            return;
        }

        try {
            int jobId = Integer.parseInt(jobIdStr);
            int employerId = Integer.parseInt(employerIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (reviewDAO.hasReviewed(jobId, user.getId())) {
                request.getSession().setAttribute("errorMsg", "Bạn đã đánh giá nhà tuyển dụng này cho show diễn này rồi!");
                response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
                return;
            }

            Review review = new Review();
            review.setJobId(jobId);
            review.setCandidateId(user.getId());
            review.setEmployerId(employerId);
            review.setReviewerId(user.getId());
            review.setRating(rating);
            review.setComment(comment != null ? comment.trim() : "");

            boolean success = reviewDAO.addReview(review);
            if (success) {
                // Update average rating
                userDAO.updateEmployerRating(employerId);
                notificationDAO.addNotification(employerId, "Bạn nhận được một đánh giá mới từ nghệ sĩ sau khi hoàn thành show diễn.");
                request.getSession().setAttribute("successMsg", "Đánh giá nhà tuyển dụng thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Gửi đánh giá thất bại. Vui lòng thử lại!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu đánh giá không hợp lệ!");
        }
        
        
        response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
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
