package com.talentconnect.controller;

import com.talentconnect.model.User;
import com.talentconnect.repository.UserDAO;
import com.talentconnect.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/verify-code", "/reset-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/forgot-password".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
        } else if ("/verify-code".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/verify-code.jsp").forward(request, response);
        } else if ("/reset-password".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        if ("/forgot-password".equals(path)) {
            String email = request.getParameter("email");
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                // Generate 6 digit code
                String code = String.format("%06d", new Random().nextInt(999999));
                
                // Save to session
                session.setAttribute("resetCode", code);
                session.setAttribute("resetEmail", email);
                session.setAttribute("resetUserId", user.getId());
                
                // Send email
                String subject = "Mã xác nhận lấy lại mật khẩu TalentConnect";
                String body = "Mã xác nhận của bạn là: " + code + "\n\nVui lòng không chia sẻ mã này với bất kỳ ai.";
                
                try {
                    EmailUtil.sendEmail(email, subject, body);
                    response.sendRedirect(request.getContextPath() + "/verify-code");
                } catch (Exception e) {
                    request.setAttribute("errorMsg", "Không thể gửi email. Vui lòng kiểm tra lại cấu hình SMTP.");
                    request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMsg", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            }
        } else if ("/verify-code".equals(path)) {
            String code = request.getParameter("code");
            String sessionCode = (String) session.getAttribute("resetCode");

            if (sessionCode != null && sessionCode.equals(code)) {
                // Code matches
                session.setAttribute("codeVerified", true);
                response.sendRedirect(request.getContextPath() + "/reset-password");
            } else {
                request.setAttribute("errorMsg", "Mã xác nhận không đúng.");
                request.getRequestDispatcher("/WEB-INF/views/verify-code.jsp").forward(request, response);
            }
        } else if ("/reset-password".equals(path)) {
            Boolean verified = (Boolean) session.getAttribute("codeVerified");
            if (verified != null && verified) {
                String newPassword = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");

                if (newPassword.equals(confirmPassword)) {
                    // Password complexity validation
                    if (!newPassword.matches("^(?=(.*[0-9]){2})(?=.*[^a-zA-Z0-9]).{8,}$")) {
                        request.setAttribute("errorMsg", "Mật khẩu không đạt yêu cầu. Cần ít nhất 8 ký tự, 1 ký tự đặc biệt, 2 chữ số.");
                        request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(request, response);
                        return;
                    }

                    Integer userId = (Integer) session.getAttribute("resetUserId");
                    if (userId != null) {
                        userDAO.updatePassword(userId, newPassword);
                        
                        // Clear session attributes
                        session.removeAttribute("resetCode");
                        session.removeAttribute("resetEmail");
                        session.removeAttribute("resetUserId");
                        session.removeAttribute("codeVerified");

                        session.setAttribute("successMsg", "Đổi mật khẩu thành công. Vui lòng đăng nhập.");
                        response.sendRedirect(request.getContextPath() + "/login");
                    }
                } else {
                    request.setAttribute("errorMsg", "Mật khẩu không khớp.");
                    request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            }
        }
    }
}
