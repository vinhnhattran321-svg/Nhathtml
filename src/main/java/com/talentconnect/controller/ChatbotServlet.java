package com.talentconnect.controller;

import com.talentconnect.model.Job;
import com.talentconnect.repository.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/api/chatbot"})
public class ChatbotServlet extends HttpServlet {
    
    private final JobDAO jobDAO = new JobDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String message = request.getParameter("message");
        if (message == null) message = "";
        
        String reply = "";
        String redirectUrl = null;
        
        try {
            // 1. Lấy danh sách việc làm để AI "phân tích"
            List<Job> jobs = jobDAO.getAllOpenJobs();
            
            // 2. Xử lý ngôn ngữ tự nhiên (Giả lập AI)
            String msg = message.toLowerCase();
            
            // Xử lý Lọc theo Địa điểm và Nghề nghiệp (Tag) cùng lúc
            String location = "";
            if (msg.contains("đà nẵng")) location = "Đà Nẵng";
            else if (msg.contains("hà nội")) location = "Hà Nội";
            else if (msg.contains("hồ chí minh") || msg.contains("sài gòn")) location = "Hồ Chí Minh";

            java.util.Set<String> matchedTags = new java.util.LinkedHashSet<>();
            for (Job job : jobs) {
                if (job.getTags() != null) {
                    for (String tag : job.getTags().toLowerCase().split(",")) {
                        tag = tag.trim();
                        if (!tag.isEmpty() && msg.contains(tag)) {
                            matchedTags.add(tag);
                        }
                    }
                }
            }
            String matchedTag = String.join(" ", matchedTags);

            double minSal = -1;
            double maxSal = -1;
            if (msg.contains("lương") || msg.contains("thù lao") || msg.contains("tiền")) {
                String cleanMsg = msg.replace(",", "").replace(".", "");
                java.util.regex.Matcher m = java.util.regex.Pattern.compile("\\d+").matcher(cleanMsg);
                java.util.List<Double> numbers = new java.util.ArrayList<>();
                while (m.find()) {
                    double num = Double.parseDouble(m.group());
                    if (num < 1000 && (msg.contains("triệu") || msg.contains("tr"))) {
                        num *= 1000000;
                    } else if (num < 1000 && msg.contains("k") && !msg.contains("không")) {
                        num *= 1000;
                    }
                    numbers.add(num);
                }
                if (numbers.size() >= 2) {
                    minSal = Math.min(numbers.get(0), numbers.get(1));
                    maxSal = Math.max(numbers.get(0), numbers.get(1));
                } else if (numbers.size() == 1) {
                    double target = numbers.get(0);
                    minSal = Math.max(0, target - 2000000);
                    maxSal = target + 2000000;
                }
            }

            if (msg.contains("chào") || msg.contains("hello") || msg.contains("hi")) {
                reply = "Xin chào! Mình là Talent AI Assistant. Mình có thể giúp bạn tìm kiếm show diễn hoặc nghệ sĩ phù hợp. Bạn muốn tìm show ở khu vực nào?";
            } 
            else if (msg.contains("cao nhất") || msg.contains("nhiều nhất")) {
                Job bestJob = null;
                for (Job job : jobs) {
                    if (bestJob == null || job.getSalary() > bestJob.getSalary()) {
                        bestJob = job;
                    }
                }
                if (bestJob != null) {
                    reply = "Show diễn có mức thù lao tốt nhất hiện tại là: <a class=\"chat-job-link\" href=\"" + request.getContextPath() + "/job-detail?id=" + bestJob.getId() + "\">'" + bestJob.getTitle() + "'</a> tại " + bestJob.getLocation() + " với mức lương " + String.format("%.0f", bestJob.getSalary()) + " VNĐ. Đang tự động chuyển hướng...";
                    redirectUrl = request.getContextPath() + "/job-detail?id=" + bestJob.getId();
                } else {
                    reply = "Hệ thống hiện chưa có show diễn nào để phân tích mức lương.";
                }
            }
            else if (msg.contains("thấp nhất") || msg.contains("ít nhất")) {
                Job lowestJob = null;
                for (Job job : jobs) {
                    if (lowestJob == null || job.getSalary() < lowestJob.getSalary()) {
                        lowestJob = job;
                    }
                }
                if (lowestJob != null) {
                    reply = "Show diễn có mức thù lao thấp nhất hiện tại (phù hợp cho người mới) là: <a class=\"chat-job-link\" href=\"" + request.getContextPath() + "/job-detail?id=" + lowestJob.getId() + "\">'" + lowestJob.getTitle() + "'</a> tại " + lowestJob.getLocation() + " với mức lương " + String.format("%.0f", lowestJob.getSalary()) + " VNĐ. Đang chuyển hướng...";
                    redirectUrl = request.getContextPath() + "/job-detail?id=" + lowestJob.getId();
                } else {
                    reply = "Hệ thống hiện chưa có show diễn nào để phân tích mức lương.";
                }
            }
            else if (minSal != -1 || !location.isEmpty() || !matchedTag.isEmpty()) {
                String qParam = matchedTag.isEmpty() ? "" : matchedTag;
                String locParam = location.isEmpty() ? "all" : location;
                String redirect = request.getContextPath() + "/home?q=" + java.net.URLEncoder.encode(qParam, "UTF-8") + "&loc=" + java.net.URLEncoder.encode(locParam, "UTF-8");
                if (minSal != -1) {
                    redirect += "&minSal=" + minSal + "&maxSal=" + maxSal;
                }
                
                redirectUrl = redirect;
                
                String criteriaStr = "";
                if (!matchedTag.isEmpty()) criteriaStr += "'" + matchedTag + "' ";
                if (!location.isEmpty()) criteriaStr += "tại " + location + " ";
                if (minSal != -1) criteriaStr += "với lương từ " + String.format("%.0f", minSal) + " đến " + String.format("%.0f", maxSal) + " VNĐ";
                
                reply = "Tuyệt vời! Mình đã tìm thấy các show diễn phù hợp với yêu cầu " + criteriaStr.trim() + ". Đang tự động chuyển hướng sang danh sách...";
            }
            else if (msg.contains("tìm show") || msg.contains("show diễn") || msg.contains("việc làm")) {
                if (!jobs.isEmpty()) {
                    Job randomJob = jobs.get(0);
                    reply = "Hệ thống hiện đang có rất nhiều show diễn hấp dẫn. Ví dụ tiêu biểu: <a class=\"chat-job-link\" href=\"" + request.getContextPath() + "/job-detail?id=" + randomJob.getId() + "\">'" + randomJob.getTitle() + "'</a> tại " + randomJob.getLocation() + ". Hãy cho mình biết bạn muốn diễn ở đâu hoặc có kỹ năng gì (VD: ca sĩ, MC) để mình lọc giúp nhé!";
                } else {
                    reply = "Hiện tại chưa có show diễn nào mới được đăng tải. Bạn hãy quay lại sau nhé!";
                }
            }
            else {
                reply = "Xin lỗi, mình chưa hiểu ý bạn lắm. Bạn có thể hỏi về 'tìm show ở Đà Nẵng', 'show lương cao nhất', hoặc tìm theo yêu cầu công việc như 'ca sĩ', 'MC' nhé!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Xin lỗi, hệ thống AI đang bảo trì. Vui lòng thử lại sau.";
        }
        
        // 5. Trả về cho Frontend
        JsonObject json = new JsonObject();
        json.addProperty("reply", reply);
        if (redirectUrl != null) {
            json.addProperty("redirectUrl", redirectUrl);
        }
        
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(json));
        out.flush();
    }
}
