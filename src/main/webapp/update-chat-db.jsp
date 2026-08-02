<%@ page import="java.sql.*" %>
<%@ page import="com.talentconnect.util.DBContext" %>
<%
    String message = "";
    try (Connection conn = DBContext.getConnection();
         Statement stmt = conn.createStatement()) {
        
        String sql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Messages' and xtype='U') " +
                     "CREATE TABLE Messages (" +
                     "    id INT IDENTITY(1,1) PRIMARY KEY," +
                     "    sender_id INT," +
                     "    receiver_id INT," +
                     "    content NVARCHAR(MAX)," +
                     "    created_at DATETIME DEFAULT GETDATE()," +
                     "    is_read BIT DEFAULT 0," +
                     "    FOREIGN KEY (sender_id) REFERENCES Users(id)," +
                     "    FOREIGN KEY (receiver_id) REFERENCES Users(id)" +
                     ")";
        stmt.execute(sql);
        message = "Table Messages created successfully.";
        
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<body>
    <h1>Database Update (Chat)</h1>
    <p><%= message %></p>
</body>
</html>
