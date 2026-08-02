package com.talentconnect.controller;

import com.talentconnect.model.User;
import com.talentconnect.model.Message;
import com.talentconnect.model.Conversation;
import com.talentconnect.repository.MessageDAO;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ChatServlet", urlPatterns = {"/api/chat/*"})
public class ChatServlet extends HttpServlet {
    
    private final MessageDAO messageDAO = new MessageDAO();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/conversations".equals(pathInfo)) {
            List<Conversation> conversations = messageDAO.getRecentConversations(sessionUser.getId());
            out.print(gson.toJson(conversations));
        } else if ("/messages".equals(pathInfo)) {
            String otherUserIdStr = request.getParameter("userId");
            if (otherUserIdStr != null && !otherUserIdStr.isEmpty()) {
                int otherUserId = Integer.parseInt(otherUserIdStr);
                // Mark messages from otherUser to sessionUser as read
                messageDAO.markAsRead(otherUserId, sessionUser.getId());
                
                List<Message> messages = messageDAO.getConversationHistory(sessionUser.getId(), otherUserId);
                out.print(gson.toJson(messages));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Missing userId\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"error\":\"Not found\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/send".equals(pathInfo)) {
            String receiverIdStr = request.getParameter("receiverId");
            String content = request.getParameter("content");
            
            if (receiverIdStr != null && content != null && !content.trim().isEmpty()) {
                int receiverId = Integer.parseInt(receiverIdStr);
                boolean success = messageDAO.sendMessage(sessionUser.getId(), receiverId, content.trim());
                if (success) {
                    out.print("{\"success\":true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.print("{\"error\":\"Failed to send message\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Missing parameters\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"error\":\"Not found\"}");
        }
    }
}
