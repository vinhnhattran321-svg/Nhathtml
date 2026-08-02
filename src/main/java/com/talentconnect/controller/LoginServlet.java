package com.talentconnect.controller;

import com.talentconnect.model.User;
import com.talentconnect.repository.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet xử lý đăng nhập người dùng.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Đã đăng nhập rồi thì redirect về dashboard tương ứng
            redirectBasedOnRole(request, response, (User) session.getAttribute("user"));
            return;
        }
        
        // Hiển thị trang đăng nhập
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Kiểm tra dữ liệu đầu vào trống
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Ôi, bạn quên nhập tên đăng nhập hoặc mật khẩu rồi này!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            // Kiểm tra xem trước đó có bị chặn do chưa đăng nhập không
            String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
            if (redirectAfterLogin != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectAfterLogin);
            } else {
                // Đăng nhập bình thường, chuyển hướng theo vai trò
                redirectBasedOnRole(request, response, user);
            }
        } else {
            request.setAttribute("errorMsg", "Rất tiếc, thông tin đăng nhập chưa đúng hoặc tài khoản của bạn đang tạm khóa.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String role = user.getRoleName();
        if ("Admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("Candidate".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
        } else if ("Employer".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
