USE TalentConnectionDB;
GO

-- 1. Thêm cột điểm xếp hạng cho Bảng Profiles (Dành cho nghệ sĩ)
ALTER TABLE Profiles
ADD ranking_points INT DEFAULT 0;
GO

-- 2. Thêm cột đánh giá trung bình và số lượng đánh giá cho Bảng Users (Dành cho nhà tuyển dụng)
ALTER TABLE Users
ADD rating FLOAT DEFAULT 0.0,
    rating_count INT DEFAULT 0;
GO

-- 3. Tạo bảng Reviews để lưu lịch sử đánh giá của nghệ sĩ đối với nhà tuyển dụng
CREATE TABLE Reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_id INT FOREIGN KEY REFERENCES Jobs(id),
    candidate_id INT FOREIGN KEY REFERENCES Users(id),
    employer_id INT FOREIGN KEY REFERENCES Users(id),
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
GO
