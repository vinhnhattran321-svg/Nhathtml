package com.talentconnect.model;

import java.sql.Timestamp;

public class Job {
    private int id;
    private int employerId;
    private String employerName; // Tên công ty/nhà tuyển dụng hiển thị trên UI
    private String title;
    private String description;
    private String requirements;
    private double salary;
    private String location;
    private String status;
    private Timestamp deadline;
    private Timestamp createdAt;
    private String tags;
    private String thumbnailUrl;

    public Job() {}

    public Job(int id, int employerId, String title, String description, String requirements, double salary, String location, String status, Timestamp deadline, Timestamp createdAt, String tags) {
        this.id = id;
        this.employerId = employerId;
        this.title = title;
        this.description = description;
        this.requirements = requirements;
        this.salary = salary;
        this.location = location;
        this.status = status;
        this.deadline = deadline;
        this.createdAt = createdAt;
        this.tags = tags;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployerId() { return employerId; }
    public void setEmployerId(int employerId) { this.employerId = employerId; }

    public String getEmployerName() { return employerName; }
    public void setEmployerName(String employerName) { this.employerName = employerName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }

    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStatus() {
        if ("open".equalsIgnoreCase(status) && deadline != null && deadline.before(new java.util.Date())) {
            return "expired";
        }
        return status;
    }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
}
