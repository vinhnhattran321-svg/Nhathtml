package com.talentconnect.repository;

import com.talentconnect.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Lớp cơ sở cho các DAO, quản lý việc mở và đóng kết nối tự động.
 */
public class BaseDAO {
    protected Connection connection;
    protected PreparedStatement statement;
    protected ResultSet resultSet;

    protected void openConnection() throws Exception {
        connection = DBContext.getConnection();
    }

    protected void closeResources() {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null && !connection.isClosed()) connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
