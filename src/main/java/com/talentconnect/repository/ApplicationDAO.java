package com.talentconnect.repository;

import com.talentconnect.model.Application;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO extends BaseDAO {

    /**
     * Nộp đơn ứng tuyển cho một tin tuyển dụng.
     */
    public boolean apply(Application app) {
        String sql = "INSERT INTO Applications (job_id, candidate_id, cover_letter, resume_url, status, applied_at) " +
                     "VALUES (?, ?, ?, ?, 'Pending', GETDATE())";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, app.getJobId());
            statement.setInt(2, app.getCandidateId());
            statement.setString(3, app.getCoverLetter());
            statement.setString(4, app.getResumeUrl());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Kiểm tra xem ứng viên đã nộp đơn ứng tuyển cho tin tuyển dụng này chưa.
     */
    public boolean hasApplied(int candidateId, int jobId) {
        String sql = "SELECT id FROM Applications WHERE candidate_id = ? AND job_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, candidateId);
            statement.setInt(2, jobId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy danh sách hồ sơ ứng tuyển của 1 Ứng viên/Nghệ sĩ cụ thể.
     */
    public List<Application> getApplicationsByCandidate(int candidateId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.title AS job_title, j.employer_id, u_emp.full_name AS employer_name " +
                     "FROM Applications a " +
                     "JOIN Jobs j ON a.job_id = j.id " +
                     "JOIN Users u_emp ON j.employer_id = u_emp.id " +
                     "WHERE a.candidate_id = ? " +
                     "ORDER BY a.applied_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, candidateId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Application app = new Application();
                app.setId(resultSet.getInt("id"));
                app.setJobId(resultSet.getInt("job_id"));
                app.setJobTitle(resultSet.getString("job_title"));
                app.setEmployerId(resultSet.getInt("employer_id"));
                app.setEmployerName(resultSet.getString("employer_name"));
                app.setCandidateId(resultSet.getInt("candidate_id"));
                app.setCoverLetter(resultSet.getString("cover_letter"));
                app.setResumeUrl(resultSet.getString("resume_url"));
                app.setStatus(resultSet.getString("status"));
                app.setAppliedAt(resultSet.getTimestamp("applied_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lấy danh sách hồ sơ ứng tuyển của 1 tin tuyển dụng cụ thể (dành cho Nhà tuyển dụng).
     */
    public List<Application> getApplicationsByJob(int jobId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.title AS job_title, u.full_name AS candidate_name, u.email AS candidate_email, u.phone AS candidate_phone " +
                     "FROM Applications a " +
                     "JOIN Users u ON a.candidate_id = u.id " +
                     "JOIN Jobs j ON a.job_id = j.id " +
                     "WHERE a.job_id = ? " +
                     "ORDER BY a.applied_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, jobId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Application app = new Application();
                app.setId(resultSet.getInt("id"));
                app.setJobId(resultSet.getInt("job_id"));
                app.setJobTitle(resultSet.getString("job_title"));
                app.setCandidateId(resultSet.getInt("candidate_id"));
                app.setCandidateName(resultSet.getString("candidate_name"));
                app.setCandidateEmail(resultSet.getString("candidate_email"));
                app.setCandidatePhone(resultSet.getString("candidate_phone"));
                app.setCoverLetter(resultSet.getString("cover_letter"));
                app.setResumeUrl(resultSet.getString("resume_url"));
                app.setStatus(resultSet.getString("status"));
                app.setAppliedAt(resultSet.getTimestamp("applied_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Cập nhật trạng thái ứng tuyển (Duyệt hồ sơ / Từ chối).
     */
    public boolean updateApplicationStatus(int appId, String status) {
        String sql = "UPDATE Applications SET status = ? WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, appId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy thông tin ứng tuyển theo ID (để gửi thông báo phản hồi).
     */
    public Application getApplicationById(int id) {
        String sql = "SELECT a.*, j.title AS job_title, j.employer_id FROM Applications a " +
                     "JOIN Jobs j ON a.job_id = j.id WHERE a.id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Application app = new Application();
                app.setId(resultSet.getInt("id"));
                app.setJobId(resultSet.getInt("job_id"));
                app.setJobTitle(resultSet.getString("job_title"));
                app.setEmployerId(resultSet.getInt("employer_id"));
                app.setCandidateId(resultSet.getInt("candidate_id"));
                app.setCoverLetter(resultSet.getString("cover_letter"));
                app.setResumeUrl(resultSet.getString("resume_url"));
                app.setStatus(resultSet.getString("status"));
                app.setAppliedAt(resultSet.getTimestamp("applied_at"));
                return app;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
}
