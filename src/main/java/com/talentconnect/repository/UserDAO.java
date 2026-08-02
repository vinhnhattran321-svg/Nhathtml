package com.talentconnect.repository;

import com.talentconnect.model.User;
import com.talentconnect.model.Profile;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends BaseDAO {

    /**
     * Xác thực thông tin đăng nhập của người dùng.
     * Hỗ trợ kiểm tra mật khẩu dạng mã hóa BCrypt và dạng chữ thô (dành cho dữ liệu mẫu).
     */
    public User login(String username, String password) {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.id WHERE u.username = ? AND u.is_active = 1";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                String dbHash = resultSet.getString("password_hash");
                boolean passwordMatch = false;

                // Kiểm tra bằng BCrypt
                try {
                    if (dbHash.startsWith("$2a$") || dbHash.startsWith("$2b$")) {
                        passwordMatch = BCrypt.checkpw(password, dbHash);
                    }
                } catch (Exception e) {
                    // BCrypt parse lỗi, bỏ qua
                }

                // Fallback kiểm tra text thô (cho dữ liệu mẫu sql setup)
                if (!passwordMatch) {
                    passwordMatch = dbHash.equals(password);
                }

                if (passwordMatch) {
                    User user = new User();
                    user.setId(resultSet.getInt("id"));
                    user.setUsername(resultSet.getString("username"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPhone(resultSet.getString("phone"));
                    user.setFullName(resultSet.getString("full_name"));
                    user.setRoleId(resultSet.getInt("role_id"));
                    user.setRoleName(resultSet.getString("role_name"));
                    user.setActive(resultSet.getBoolean("is_active"));
                    user.setCreatedAt(resultSet.getTimestamp("created_at"));
                    user.setRating(resultSet.getDouble("rating"));
                    user.setRatingCount(resultSet.getInt("rating_count"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Đăng ký tài khoản người dùng mới.
     * Mật khẩu sẽ được mã hóa tự động bằng BCrypt trước khi lưu vào DB.
     */
    public boolean register(User user) {
        String sqlUser = "INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active) VALUES (?, ?, ?, ?, ?, ?, 1)";
        String sqlProfile = "INSERT INTO Profiles (user_id, bio, skills, experience, certificates, portfolio_url) VALUES (?, '', '', '', '', '')";
        
        try {
            openConnection();
            connection.setAutoCommit(false); // Chạy Transaction
            
            // 1. Thêm User
            statement = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getUsername());
            // Mã hóa mật khẩu bằng BCrypt
            String hashedPw = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
            statement.setString(2, hashedPw);
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getFullName());
            statement.setInt(6, user.getRoleId());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                connection.rollback();
                return false;
            }
            
            // Lấy ID tự sinh của User vừa tạo
            int userId = -1;
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                userId = resultSet.getInt(1);
            }
            
            // 2. Nếu là ứng viên (Role = 2), tự động tạo Profile trống
            if (user.getRoleId() == 2 && userId != -1) {
                statement.close(); // Đóng statement cũ trước khi tạo cái mới
                statement = connection.prepareStatement(sqlProfile);
                statement.setInt(1, userId);
                statement.executeUpdate();
            }
            
            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                if (connection != null) connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy thông tin cá nhân dựa trên User ID.
     */
    public User getUserById(int id) {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.id WHERE u.id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setRoleName(resultSet.getString("role_name"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Lấy thông tin cá nhân dựa trên Email.
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.id WHERE u.email = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setRoleName(resultSet.getString("role_name"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu người dùng
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET password_hash = ? WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            String hashedPw = BCrypt.hashpw(newPasswordHash, BCrypt.gensalt());
            statement.setString(1, hashedPw);
            statement.setString(2, userId + "");
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy Hồ sơ ứng viên dựa trên User ID.
     */
    public Profile getProfileByUserId(int userId) {
        String sql = "SELECT * FROM Profiles WHERE user_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Profile profile = new Profile();
                profile.setId(resultSet.getInt("id"));
                profile.setUserId(resultSet.getInt("user_id"));
                profile.setAvatarUrl(resultSet.getString("avatar_url"));
                profile.setBio(resultSet.getString("bio"));
                profile.setSkills(resultSet.getString("skills"));
                profile.setExperience(resultSet.getString("experience"));
                profile.setCertificates(resultSet.getString("certificates"));
                profile.setPortfolioUrl(resultSet.getString("portfolio_url"));
                profile.setUpdatedAt(resultSet.getTimestamp("updated_at"));
                profile.setRankingPoints(resultSet.getInt("ranking_points"));
                profile.setCvImages(resultSet.getString("cv_images"));
                return profile;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Cập nhật thông tin Hồ sơ ứng viên.
     */
    public boolean updateProfile(Profile profile) {
        String sql = "UPDATE Profiles SET avatar_url = ?, bio = ?, skills = ?, experience = ?, certificates = ?, portfolio_url = ?, cv_images = ?, updated_at = GETDATE() WHERE user_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, profile.getAvatarUrl());
            statement.setString(2, profile.getBio());
            statement.setString(3, profile.getSkills());
            statement.setString(4, profile.getExperience());
            statement.setString(5, profile.getCertificates());
            statement.setString(6, profile.getPortfolioUrl());
            statement.setString(7, profile.getCvImages());
            statement.setInt(8, profile.getUserId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Lấy toàn bộ danh sách người dùng (dành cho Admin).
     */
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.id ORDER BY u.created_at DESC";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setRoleName(resultSet.getString("role_name"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Thay đổi trạng thái tài khoản (Khóa hoặc Mở khóa) của người dùng.
     */
    public boolean updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE Users SET is_active = ? WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setBoolean(1, isActive);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Tăng điểm xếp hạng cho nghệ sĩ
     */
    public boolean addRankingPoints(int userId, int points) {
        String sql = "UPDATE Profiles SET ranking_points = ISNULL(ranking_points, 0) + ? WHERE user_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, points);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Cập nhật điểm đánh giá trung bình cho nhà tuyển dụng
     */
    public boolean updateEmployerRating(int employerId) {
        String sql = "UPDATE Users SET rating = (SELECT AVG(CAST(rating AS FLOAT)) FROM Reviews WHERE employer_id = ? AND reviewer_id != ?), " +
                     "rating_count = (SELECT COUNT(*) FROM Reviews WHERE employer_id = ? AND reviewer_id != ?) WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, employerId);
            statement.setInt(2, employerId);
            statement.setInt(3, employerId);
            statement.setInt(4, employerId);
            statement.setInt(5, employerId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Cập nhật điểm đánh giá trung bình cho nghệ sĩ (candidate)
     */
    public boolean updateArtistRating(int candidateId) {
        String sql = "UPDATE Users SET rating = (SELECT AVG(CAST(rating AS FLOAT)) FROM Reviews WHERE candidate_id = ? AND reviewer_id != ?), " +
                     "rating_count = (SELECT COUNT(*) FROM Reviews WHERE candidate_id = ? AND reviewer_id != ?) WHERE id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, candidateId);
            statement.setInt(2, candidateId);
            statement.setInt(3, candidateId);
            statement.setInt(4, candidateId);
            statement.setInt(5, candidateId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Đếm số lượng Top nghệ sĩ để phân trang
     */
    public int countTopArtists(String skill) {
        int count = 0;
        String sql = "SELECT COUNT(*) as total FROM Users u LEFT JOIN Profiles p ON u.id = p.user_id WHERE u.is_active = 1 ";
        if ("Band nhạc".equals(skill)) {
            sql += " AND u.role_id = 4 ";
        } else {
            sql += " AND u.role_id = 2 ";
            if (skill != null && !skill.trim().isEmpty() && !skill.equals("all")) {
                sql += " AND p.skills LIKE ? ";
            }
        }
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            if (!"Band nhạc".equals(skill) && skill != null && !skill.trim().isEmpty() && !skill.equals("all")) {
                statement.setString(1, "%" + skill + "%");
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    /**
     * Lấy Top nghệ sĩ (dựa vào đánh giá sao) và lọc theo kỹ năng (Có phân trang)
     */
    public List<User> getTopArtists(int page, int pageSize, String skill) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, p.avatar_url, p.skills FROM Users u JOIN Roles r ON u.role_id = r.id " +
                     "LEFT JOIN Profiles p ON u.id = p.user_id " +
                     "WHERE u.is_active = 1 ";
        
        if ("Band nhạc".equals(skill)) {
            sql += " AND u.role_id = 4 ";
        } else {
            sql += " AND u.role_id = 2 ";
            if (skill != null && !skill.trim().isEmpty() && !skill.equals("all")) {
                sql += " AND p.skills LIKE ? ";
            }
        }
        
        sql += " ORDER BY ISNULL(u.rating, 0) DESC, ISNULL(u.rating_count, 0) DESC " +
               " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            
            int paramIndex = 1;
            if (!"Band nhạc".equals(skill) && skill != null && !skill.trim().isEmpty() && !skill.equals("all")) {
                statement.setString(paramIndex++, "%" + skill + "%");
            }
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex, pageSize);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setRoleName(resultSet.getString("role_name"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                user.setAvatarUrl(resultSet.getString("avatar_url"));
                user.setSkills(resultSet.getString("skills"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lấy danh sách thành viên của một Band nhạc
     */
    public List<User> getBandMembers(int bandId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, p.avatar_url, p.skills, bm.band_role FROM Users u " +
                     "JOIN Band_Members bm ON u.id = bm.member_id " +
                     "LEFT JOIN Profiles p ON u.id = p.user_id " +
                     "WHERE bm.band_id = ?";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, bandId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                user.setAvatarUrl(resultSet.getString("avatar_url"));
                user.setSkills(resultSet.getString("skills"));
                user.setRoleInBand(resultSet.getString("band_role"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Đếm số lượng Top nhà tuyển dụng để phân trang
     */
    public int countTopEmployers() {
        int count = 0;
        String sql = "SELECT COUNT(*) as total FROM Users WHERE role_id = 3 AND is_active = 1";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    /**
     * Lấy Top nhà tuyển dụng (dựa vào đánh giá)
     */
    public List<User> getTopEmployers(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, p.avatar_url FROM Users u JOIN Roles r ON u.role_id = r.id " +
                     "LEFT JOIN Profiles p ON u.id = p.user_id " +
                     "WHERE u.role_id = 3 AND u.is_active = 1 " +
                     "ORDER BY ISNULL(u.rating, 0) DESC, ISNULL(u.rating_count, 0) DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            openConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, (page - 1) * pageSize);
            statement.setInt(2, pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setFullName(resultSet.getString("full_name"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setRoleName(resultSet.getString("role_name"));
                user.setActive(resultSet.getBoolean("is_active"));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setRating(resultSet.getDouble("rating"));
                user.setRatingCount(resultSet.getInt("rating_count"));
                user.setAvatarUrl(resultSet.getString("avatar_url"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
}
