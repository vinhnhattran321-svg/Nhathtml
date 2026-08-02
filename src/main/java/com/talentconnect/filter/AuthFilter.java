package com.talentconnect.filter;

import com.talentconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Bộ lọc phân quyền (Authentication & Authorization Filter).
 * Đảm bảo người dùng phải đăng nhập mới được vào các trang dashboard
 * và có đúng vai trò tương ứng (Candidate, Employer, Admin).
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/candidate/*", "/employer/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Lấy thông tin user đăng nhập từ session
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String requestURI = httpRequest.getRequestURI();
        
        // 1. Kiểm tra xem người dùng đã đăng nhập chưa
        if (user == null) {
            // Lưu lại đường dẫn định truy cập để sau khi đăng nhập thành công thì chuyển hướng về đó
            String redirectUrl = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                redirectUrl += "?" + httpRequest.getQueryString();
            }
            httpRequest.getSession(true).setAttribute("redirectAfterLogin", redirectUrl);
            
            // Chuyển hướng đến trang đăng nhập kèm thông báo
            session = httpRequest.getSession(true);
            session.setAttribute("errorMsg", "Vui lòng đăng nhập để tiếp tục.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // 2. Kiểm tra vai trò dựa vào URL truy cập
        boolean isAuthorized = false;
        String role = user.getRoleName();
        
        if (requestURI.contains("/candidate/") && "Candidate".equalsIgnoreCase(role)) {
            isAuthorized = true;
        } else if (requestURI.contains("/employer/") && "Employer".equalsIgnoreCase(role)) {
            isAuthorized = true;
        } else if (requestURI.contains("/admin/") && "Admin".equalsIgnoreCase(role)) {
            isAuthorized = true;
        }
        
        // Nếu có quyền, cho phép đi tiếp. Nếu không có quyền, từ chối và báo lỗi
        if (isAuthorized) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
        }
    }

    @Override
    public void destroy() {}
}
