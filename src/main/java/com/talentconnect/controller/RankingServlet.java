package com.talentconnect.controller;

import com.talentconnect.model.User;
import com.talentconnect.repository.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RankingServlet", urlPatterns = {"/ranking"})
public class RankingServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "artists"; // Mặc định là tab Nghệ sĩ
        }
        
        String skill = request.getParameter("skill");
        if (skill == null) {
            skill = "all";
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int pageSize = 12;

        if ("employers".equals(tab)) {
            int totalEmployers = userDAO.countTopEmployers();
            int totalPages = (int) Math.ceil((double) totalEmployers / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            List<User> topEmployers = userDAO.getTopEmployers(page, pageSize);
            request.setAttribute("topEmployers", topEmployers);
            request.setAttribute("totalPages", totalPages);
        } else {
            int totalArtists = userDAO.countTopArtists(skill);
            int totalPages = (int) Math.ceil((double) totalArtists / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            List<User> topArtists = userDAO.getTopArtists(page, pageSize, skill);
            request.setAttribute("topArtists", topArtists);
            request.setAttribute("totalPages", totalPages);
        }
        
        request.setAttribute("currentPage", page);
        request.setAttribute("activeTab", tab);
        request.setAttribute("activeSkill", skill);
        request.getRequestDispatcher("/WEB-INF/views/ranking.jsp").forward(request, response);
    }
}
