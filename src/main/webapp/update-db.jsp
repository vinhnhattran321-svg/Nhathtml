<%@ page import="java.sql.*" %>
<%@ page import="com.talentconnect.util.DBContext" %>
<%
    String message = "";
    try (Connection conn = DBContext.getConnection();
         Statement stmt = conn.createStatement()) {
        
        String sql = "ALTER TABLE Jobs ADD thumbnail_url NVARCHAR(MAX)";
        stmt.execute(sql);
        message = "Column thumbnail_url added successfully.";
        
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<body>
    <h1>Database Update</h1>
    <p><%= message %></p>
</body>
</html>
