package com.talentconnect.repository;

import com.talentconnect.model.Job;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends BaseDAO {

    /**
     * Lấy toàn bộ các tin tuyển dụng đang mở (Status = 'Open') có hạn nộp lớn hơn hiện tại.
     */
    public List<Job> getAllOpenJobs() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, u.full_name AS employer_name FROM Jobs j " +
                     "JOIN Users u ON j.employer_id = u.id " +
                     "WHERE j.status = 'Open' AND (j.deadline IS NULL OR j.deadline >= GETDATE()) " +
                     "ORDER BY j.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Job job = mapResultSetToJob(resultSet);
                list.add(job);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Tìm kiếm và lọc tin tuyển dụng theo từ khóa (tiêu đề, mô tả, yêu cầu) và địa điểm.
     */
    public List<Job> searchJobs(String query, String location) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT j.*, u.full_name AS employer_name FROM Jobs j " +
            "JOIN Users u ON j.employer_id = u.id " +
            "WHERE j.status = 'Open' AND (j.deadline IS NULL OR j.deadline >= GETDATE())"
        );
        
        String[] keywords = null;
        if (query != null && !query.trim().isEmpty()) {
            keywords = query.trim().split("[,\\s]+");
            for (String kw : keywords) {
                if (!kw.isEmpty()) {
                    sql.append(" AND (j.title LIKE ? OR j.description LIKE ? OR j.requirements LIKE ? OR j.tags LIKE ?)");
                }
            }
        }
        if (location != null && !location.trim().isEmpty() && !location.equals("all")) {
            sql.append(" AND j.location LIKE ?");
        }
        sql.append(" ORDER BY j.created_at DESC");

        try {
            openConnection();
            statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (keywords != null) {
                for (String kw : keywords) {
                    if (!kw.isEmpty()) {
                        String searchPattern = "%" + kw + "%";
                        statement.setString(paramIndex++, searchPattern);
                        statement.setString(paramIndex++, searchPattern);
                        statement.setString(paramIndex++, searchPattern);
                        statement.setString(paramIndex++, searchPattern);
                    }
                }
            }
            if (location != null && !location.trim().isEmpty() && !location.equals("all")) {
                statement.setString(paramIndex++, "%" + location.trim() + "%");
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Job job = mapResultSetToJob(resultSet);
                list.add(job);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lấy thông tin chi tiết của 1 tin tuyển dụng.
     */
    public Job getJobById(int id) {
        String sql = "SELECT j.*, u.full_name AS employer_name FROM Jobs j " +
                     "JOIN Users u ON j.employer_id = u.id " +
                     "WHERE j.id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToJob(resultSet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Tạo mới tin tuyển dụng (Show diễn).
     */
    public boolean addJob(Job job) {
        String sql = "INSERT INTO Jobs (employer_id, title, description, requirements, salary, location, status, deadline, tags, created_at, thumbnail_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'Pending', ?, ?, GETDATE(), ?)";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, job.getEmployerId());
            statement.setString(2, job.getTitle());
            statement.setString(3, job.getDescription());
            statement.setString(4, job.getRequirements());
            statement.setDouble(5, job.getSalary());
            statement.setString(6, job.getLocation());
            statement.setTimestamp(7, job.getDeadline());
            statement.setString(8, job.getTags());
            statement.setString(9, job.getThumbnailUrl());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy danh sách tin tuyển dụng do 1 Nhà tuyển dụng cụ thể đã đăng.
     */
    public List<Job> getJobsByEmployer(int employerId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, u.full_name AS employer_name FROM Jobs j " +
                     "JOIN Users u ON j.employer_id = u.id " +
                     "WHERE j.employer_id = ? " +
                     "ORDER BY j.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, employerId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Job job = mapResultSetToJob(resultSet);
                list.add(job);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lấy tất cả tin tuyển dụng trong hệ thống (dành cho Admin).
     */
    public List<Job> getAllJobsForAdmin() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, u.full_name AS employer_name FROM Jobs j " +
                     "JOIN Users u ON j.employer_id = u.id " +
                     "ORDER BY j.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Job job = mapResultSetToJob(resultSet);
                list.add(job);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Cập nhật trạng thái tin tuyển dụng (Open, Closed).
     */
    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE Jobs SET status = ? WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, jobId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Phương thức helper để map ResultSet thành đối tượng Job.
     */
    private Job mapResultSetToJob(java.sql.ResultSet rs) throws java.sql.SQLException {
        Job job = new Job();
        job.setId(rs.getInt("id"));
        job.setEmployerId(rs.getInt("employer_id"));
        job.setEmployerName(rs.getString("employer_name"));
        job.setTitle(rs.getString("title"));
        job.setDescription(rs.getString("description"));
        job.setRequirements(rs.getString("requirements"));
        job.setSalary(rs.getDouble("salary"));
        job.setLocation(rs.getString("location"));
        job.setStatus(rs.getString("status"));
        job.setDeadline(rs.getTimestamp("deadline"));
        job.setTags(rs.getString("tags"));
        job.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Handle missing column gracefully in case query doesn't select it, but we expect it to
        try {
            job.setThumbnailUrl(rs.getString("thumbnail_url"));
        } catch (java.sql.SQLException e) {
            // ignore
        }
        
        return job;
    }
}
