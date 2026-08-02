package com.talentconnect.repository;

import com.talentconnect.model.Review;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends BaseDAO {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO Reviews (job_id, candidate_id, employer_id, reviewer_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, review.getJobId());
            statement.setInt(2, review.getCandidateId());
            statement.setInt(3, review.getEmployerId());
            statement.setInt(4, review.getReviewerId());
            statement.setInt(5, review.getRating());
            statement.setString(6, review.getComment());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean hasReviewed(int jobId, int reviewerId) {
        String sql = "SELECT id FROM Reviews WHERE job_id = ? AND reviewer_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, jobId);
            statement.setInt(2, reviewerId);
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

    public List<Review> getReviewsByEmployerId(int employerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT * FROM Reviews WHERE employer_id = ? ORDER BY created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, employerId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Review r = new Review();
                r.setId(resultSet.getInt("id"));
                r.setJobId(resultSet.getInt("job_id"));
                r.setCandidateId(resultSet.getInt("candidate_id"));
                r.setEmployerId(resultSet.getInt("employer_id"));
                r.setReviewerId(resultSet.getInt("reviewer_id"));
                r.setRating(resultSet.getInt("rating"));
                r.setComment(resultSet.getString("comment"));
                r.setCreatedAt(resultSet.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    public List<Review> getReviewsReceivedByEmployer(int employerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as reviewer_name, j.title as job_title FROM Reviews r "
                   + "JOIN Users u ON r.reviewer_id = u.id "
                   + "JOIN Jobs j ON r.job_id = j.id "
                   + "WHERE r.employer_id = ? AND r.reviewer_id != ? ORDER BY r.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, employerId);
            statement.setInt(2, employerId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Review r = new Review();
                r.setId(resultSet.getInt("id"));
                r.setJobId(resultSet.getInt("job_id"));
                r.setCandidateId(resultSet.getInt("candidate_id"));
                r.setEmployerId(resultSet.getInt("employer_id"));
                r.setReviewerId(resultSet.getInt("reviewer_id"));
                r.setRating(resultSet.getInt("rating"));
                r.setComment(resultSet.getString("comment"));
                r.setCreatedAt(resultSet.getTimestamp("created_at"));
                r.setReviewerName(resultSet.getString("reviewer_name"));
                r.setJobTitle(resultSet.getString("job_title"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Review> getReviewsReceivedByCandidate(int candidateId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as reviewer_name, j.title as job_title FROM Reviews r "
                   + "JOIN Users u ON r.reviewer_id = u.id "
                   + "JOIN Jobs j ON r.job_id = j.id "
                   + "WHERE r.candidate_id = ? AND r.reviewer_id != ? ORDER BY r.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, candidateId);
            statement.setInt(2, candidateId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Review r = new Review();
                r.setId(resultSet.getInt("id"));
                r.setJobId(resultSet.getInt("job_id"));
                r.setCandidateId(resultSet.getInt("candidate_id"));
                r.setEmployerId(resultSet.getInt("employer_id"));
                r.setReviewerId(resultSet.getInt("reviewer_id"));
                r.setRating(resultSet.getInt("rating"));
                r.setComment(resultSet.getString("comment"));
                r.setCreatedAt(resultSet.getTimestamp("created_at"));
                r.setReviewerName(resultSet.getString("reviewer_name"));
                r.setJobTitle(resultSet.getString("job_title"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
}
