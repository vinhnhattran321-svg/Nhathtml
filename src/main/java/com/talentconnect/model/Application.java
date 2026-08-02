package com.talentconnect.model;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int jobId;
    private String jobTitle; // Tiêu đề công việc/show
    private int employerId;
    private String employerName; // Tên nhà tuyển dụng
    private int candidateId;
    private String candidateName; // Tên đầy đủ của ứng viên
    private String candidateEmail;
    private String candidatePhone;
    private String coverLetter;
    private String resumeUrl;
    private String status; // Pending, Approved, Rejected
    private Timestamp appliedAt;

    public Application() {}

    public Application(int id, int jobId, int candidateId, String coverLetter, String resumeUrl, String status, Timestamp appliedAt) {
        this.id = id;
        this.jobId = jobId;
        this.candidateId = candidateId;
        this.coverLetter = coverLetter;
        this.resumeUrl = resumeUrl;
        this.status = status;
        this.appliedAt = appliedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getEmployerName() { return employerName; }
    public void setEmployerName(String employerName) { this.employerName = employerName; }

    public int getEmployerId() { return employerId; }
    public void setEmployerId(int employerId) { this.employerId = employerId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public String getCandidateName() { return candidateName; }
    public void setCandidateName(String candidateName) { this.candidateName = candidateName; }

    public String getCandidateEmail() { return candidateEmail; }
    public void setCandidateEmail(String candidateEmail) { this.candidateEmail = candidateEmail; }

    public String getCandidatePhone() { return candidatePhone; }
    public void setCandidatePhone(String candidatePhone) { this.candidatePhone = candidatePhone; }

    public String getCoverLetter() { return coverLetter; }
    public void setCoverLetter(String coverLetter) { this.coverLetter = coverLetter; }

    public String getResumeUrl() { return resumeUrl; }
    public void setResumeUrl(String resumeUrl) { this.resumeUrl = resumeUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }
}
