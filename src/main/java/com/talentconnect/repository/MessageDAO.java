package com.talentconnect.repository;

import com.talentconnect.model.Message;
import com.talentconnect.model.Conversation;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO extends BaseDAO {

    public boolean sendMessage(int senderId, int receiverId, String content) {
        String sql = "INSERT INTO Messages (sender_id, receiver_id, content, created_at, is_read) VALUES (?, ?, ?, GETDATE(), 0)";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, senderId);
            statement.setInt(2, receiverId);
            statement.setString(3, content);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public List<Message> getConversationHistory(int userId1, int userId2) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT * FROM Messages WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) ORDER BY created_at ASC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId1);
            statement.setInt(2, userId2);
            statement.setInt(3, userId2);
            statement.setInt(4, userId1);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Message msg = new Message();
                msg.setId(resultSet.getInt("id"));
                msg.setSenderId(resultSet.getInt("sender_id"));
                msg.setReceiverId(resultSet.getInt("receiver_id"));
                msg.setContent(resultSet.getString("content"));
                msg.setCreatedAt(resultSet.getTimestamp("created_at"));
                msg.setRead(resultSet.getBoolean("is_read"));
                messages.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return messages;
    }

    public boolean markAsRead(int senderId, int receiverId) {
        // Marks messages sent by senderId to receiverId as read. (Called by receiver)
        String sql = "UPDATE Messages SET is_read = 1 WHERE sender_id = ? AND receiver_id = ? AND is_read = 0";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, senderId);
            statement.setInt(2, receiverId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public List<Conversation> getRecentConversations(int userId) {
        List<Conversation> conversations = new ArrayList<>();
        String sql = 
            "WITH RankedMessages AS (" +
            "    SELECT " +
            "        CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END as other_user_id," +
            "        content, created_at, is_read, receiver_id, sender_id," +
            "        ROW_NUMBER() OVER(PARTITION BY CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END ORDER BY created_at DESC) as rn " +
            "    FROM Messages " +
            "    WHERE sender_id = ? OR receiver_id = ?" +
            ") " +
            "SELECT r.other_user_id, r.content as last_message, r.created_at as last_message_time, " +
            "       u.full_name as other_user_name, p.avatar_url as other_user_avatar_url, " +
            "       (SELECT COUNT(*) FROM Messages WHERE sender_id = r.other_user_id AND receiver_id = ? AND is_read = 0) as unread_count " +
            "FROM RankedMessages r " +
            "JOIN Users u ON r.other_user_id = u.id " +
            "LEFT JOIN Profiles p ON u.id = p.user_id " +
            "WHERE r.rn = 1 " +
            "ORDER BY r.created_at DESC";
            
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, userId);
            statement.setInt(3, userId);
            statement.setInt(4, userId);
            statement.setInt(5, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Conversation conv = new Conversation();
                conv.setOtherUserId(resultSet.getInt("other_user_id"));
                conv.setOtherUserName(resultSet.getString("other_user_name"));
                conv.setOtherUserAvatarUrl(resultSet.getString("other_user_avatar_url"));
                conv.setLastMessage(resultSet.getString("last_message"));
                conv.setLastMessageTime(resultSet.getTimestamp("last_message_time"));
                conv.setUnreadCount(resultSet.getInt("unread_count"));
                conversations.add(conv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return conversations;
    }
}
