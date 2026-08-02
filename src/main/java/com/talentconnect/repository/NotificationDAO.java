package com.talentconnect.repository;

import com.talentconnect.model.Notification;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends BaseDAO {

    /**
     * Thêm thông báo mới cho người dùng.
     */
    public boolean addNotification(int userId, String message) {
        String sql = "INSERT INTO Notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, GETDATE())";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setString(2, message);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy danh sách tất cả thông báo của 1 người dùng, xếp theo thời gian mới nhất.
     */
    public List<Notification> getNotificationsByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Notification notif = new Notification();
                notif.setId(resultSet.getInt("id"));
                notif.setUserId(resultSet.getInt("user_id"));
                notif.setMessage(resultSet.getString("message"));
                notif.setRead(resultSet.getBoolean("is_read"));
                notif.setCreatedAt(resultSet.getTimestamp("created_at"));
                list.add(notif);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Đánh dấu toàn bộ thông báo của người dùng đã được đọc.
     */
    public boolean markAsRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE user_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy số lượng thông báo chưa đọc.
     */
    public int getUnreadCount(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }
}
