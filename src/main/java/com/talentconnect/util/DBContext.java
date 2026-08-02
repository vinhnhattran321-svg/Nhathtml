package com.talentconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * Lớp cấu hình kết nối Cơ Sở Dữ Liệu SQL Server.
 * Bạn có thể thay đổi các tham số dưới đây (username, password, port) để phù hợp với môi trường máy của bạn.
 */
public class DBContext {
    
    // Tên máy chủ SQL Server (mặc định là localhost)
    private static final String SERVER_NAME = "localhost";
    
    // Tên Cơ sở dữ liệu đã tạo từ script db/setup.sql
    private static final String DB_NAME = "TalentConnectionDB";
    
    // Cổng kết nối SQL Server (mặc định là 1433)
    private static final String PORT = "1433";
    
    // Tài khoản kết nối SQL Server (thay bằng tài khoản của bạn, ví dụ: 'sa')
    private static final String USER = "sa";
    
    // Mật khẩu của tài khoản SQL Server trên máy bạn
    private static final String PASSWORD = "1234"; 

    /**
     * Phương thức lấy kết nối đến cơ sở dữ liệu.
     * Hỗ trợ tự động load Driver JDBC của Microsoft SQL Server.
     */
    public static Connection getConnection() throws Exception {
        // Cấu hình URL kết nối SQL Server, tắt SSL check (encrypt=true;trustServerCertificate=true) tránh lỗi chứng chỉ trên localhost
        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT + ";databaseName=" + DB_NAME 
                   + ";encrypt=true;trustServerCertificate=true;";
        
        // Đăng ký Driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // Trả về đối tượng Connection
        Connection conn = DriverManager.getConnection(url, USER, PASSWORD);
        
        // Auto-patch DB schema for Review table if missing reviewer_id
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("IF COL_LENGTH('Reviews', 'reviewer_id') IS NULL BEGIN ALTER TABLE Reviews ADD reviewer_id INT; END");
        } catch (Exception e) {
            // ignore
        }
        
        return conn;
    }

    /**
     * Hàm test nhanh kết nối (dành cho chế độ debug)
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Kết nối SQL Server THÀNH CÔNG!");
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Kết nối THẤT BẠI: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
