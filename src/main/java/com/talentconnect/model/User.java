package com.talentconnect.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String passwordHash;
    private String email;
    private String phone;
    private String fullName;
    private int roleId;
    private String roleName; // Hỗ trợ hiển thị tên vai trò
    private boolean isActive;
    private Timestamp createdAt;
    
    // New fields for ranking/rating
    private double rating;
    private int ratingCount;
    private int rankingPoints;
    private String avatarUrl;
    private String skills;
    private String roleInBand;

    public User() {}

    public User(int id, String username, String passwordHash, String email, String phone, String fullName, int roleId, boolean isActive, java.sql.Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phone = phone;
        this.fullName = fullName;
        this.roleId = roleId;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getRatingCount() { return ratingCount; }
    public void setRatingCount(int ratingCount) { this.ratingCount = ratingCount; }

    public int getRankingPoints() { return rankingPoints; }
    public void setRankingPoints(int rankingPoints) { this.rankingPoints = rankingPoints; }
    
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getRoleInBand() { return roleInBand; }
    public void setRoleInBand(String roleInBand) { this.roleInBand = roleInBand; }
}
