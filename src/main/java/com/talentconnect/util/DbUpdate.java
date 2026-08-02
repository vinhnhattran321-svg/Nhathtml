package com.talentconnect.util;

import java.sql.Connection;
import java.sql.Statement;

public class DbUpdate {
    public static void main(String[] args) {
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement()) {
            
            java.sql.ResultSet rs = stmt.executeQuery("SELECT user_id FROM Profiles");
            java.util.List<Integer> userIds = new java.util.ArrayList<>();
            while (rs.next()) {
                userIds.add(rs.getInt("user_id"));
            }
            
            String[] allSkills = {"MC", "Nhạc công", "Rapper", "Ca sĩ", "Dancer", "DJ"};
            java.util.Random random = new java.util.Random();
            
            java.sql.PreparedStatement updateStmt = conn.prepareStatement("UPDATE Profiles SET skills = ? WHERE user_id = ?");
            for (int userId : userIds) {
                java.util.List<String> userSkills = new java.util.ArrayList<>();
                int numSkills = 2 + random.nextInt(2); // 2 to 3
                while(userSkills.size() < numSkills) {
                    String skill = allSkills[random.nextInt(allSkills.length)];
                    if(!userSkills.contains(skill)) {
                        userSkills.add(skill);
                    }
                }
                updateStmt.setString(1, String.join(", ", userSkills));
                updateStmt.setInt(2, userId);
                updateStmt.executeUpdate();
            }
            System.out.println("Skills updated for all profiles successfully.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
