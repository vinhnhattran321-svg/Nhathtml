package com.talentconnect.controller;

import com.talentconnect.model.User;
import com.talentconnect.repository.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet xử lý đăng ký tài khoản mới cho Ứng viên hoặc Nhà tuyển dụng.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo tiếng Việt không bị lỗi font
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("fullName");
        String roleStr = request.getParameter("roleId");

        // 1. Kiểm tra tính hợp lệ cơ bản
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            roleStr == null) {
            
            request.setAttribute("errorMsg", "Hãy điền đầy đủ các thông tin cần thiết để chúng ta hiểu nhau hơn nhé!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Validate password complexity
        if (!password.matches("^(?=(.*[0-9]){2})(?=.*[^a-zA-Z0-9]).{8,}$")) {
            request.setAttribute("errorMsg", "Mật khẩu cần mạnh hơn một chút (ít nhất 8 ký tự, 1 ký tự đặc biệt, 2 chữ số) để bảo vệ tài khoản của bạn an toàn nhé.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        int roleId;
        try {
            roleId = Integer.parseInt(roleStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Có vẻ như vai trò bạn chọn không hợp lệ, hãy thử lại nhé!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User để lưu
        User user = new User();
        user.setUsername(username.trim());
        user.setPasswordHash(password); // Mật khẩu sẽ được hash tự động trong UserDAO.register()
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setFullName(fullName.trim());
        user.setRoleId(roleId);

        // 2. Thực hiện đăng ký
        boolean success = userDAO.register(user);

        if (success) {
            request.getSession(true).setAttribute("successMsg", "Tuyệt vời! Chào mừng bạn đến với TalentConnect. Hãy đăng nhập để bắt đầu nhé.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMsg", "Rất tiếc, tên đăng nhập hoặc Email này đã có người sử dụng. Bạn thử một tên khác xem sao?");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
