package com.talentconnect.model;

import java.sql.Timestamp;

public class Profile {
    private int id;
    private int userId;
    private String avatarUrl;
    private String bio;
    private String skills;
    private String experience;
    private String certificates;
    private String portfolioUrl;
    private Timestamp updatedAt;
    
    // New field for ranking
    private int rankingPoints;
    
    // New field for CV images
    private String cvImages;

    public Profile() {}

    public Profile(int id, int userId, String avatarUrl, String bio, String skills, String experience, String certificates, String portfolioUrl, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.avatarUrl = avatarUrl;
        this.bio = bio;
        this.skills = skills;
        this.experience = experience;
        this.certificates = certificates;
        this.portfolioUrl = portfolioUrl;
        this.updatedAt = updatedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public String getCertificates() { return certificates; }
    public void setCertificates(String certificates) { this.certificates = certificates; }

    public String getPortfolioUrl() { return portfolioUrl; }
    public void setPortfolioUrl(String portfolioUrl) { this.portfolioUrl = portfolioUrl; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public int getRankingPoints() { return rankingPoints; }
    public void setRankingPoints(int rankingPoints) { this.rankingPoints = rankingPoints; }

    public String getCvImages() { return cvImages; }
    public void setCvImages(String cvImages) { this.cvImages = cvImages; }
}
