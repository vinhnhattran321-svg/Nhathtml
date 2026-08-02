-- 1. Tạo Cơ Sở Dữ Liệu
CREATE DATABASE TalentConnectionDB;
GO
USE TalentConnectionDB;
GO

-- 2. Tạo Bảng Vai Trò (Roles)
CREATE TABLE Roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE
);

-- Chèn dữ liệu vai trò mặc định
INSERT INTO Roles (role_name) VALUES ('Admin'), ('Candidate'), ('Employer');

-- 3. Bảng Người Dùng (Users)
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Sẽ được mã hóa trước khi lưu
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    full_name NVARCHAR(100) NOT NULL,
    role_id INT FOREIGN KEY REFERENCES Roles(id),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

-- 4. Bảng Hồ Sơ Ứng Viên (Profiles)
CREATE TABLE Profiles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    avatar_url VARCHAR(255),
    bio NVARCHAR(MAX),
    skills NVARCHAR(MAX),      -- Các kỹ năng phân tách bằng dấu phẩy hoặc dạng JSON
    experience NVARCHAR(MAX),  -- Kinh nghiệm làm việc
    certificates NVARCHAR(MAX),-- Các chứng chỉ đạt được
    portfolio_url VARCHAR(255),-- Link đến dự án cá nhân hoặc sản phẩm nghệ thuật
    updated_at DATETIME DEFAULT GETDATE()
);

-- 5. Bảng Tin Tuyển Dụng / Show Diễn (Jobs)
CREATE TABLE Jobs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employer_id INT FOREIGN KEY REFERENCES Users(id),
    title NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    requirements NVARCHAR(MAX),
    salary DECIMAL(18, 2),
    location NVARCHAR(100),
    status NVARCHAR(20) DEFAULT 'Open', -- Open, Closed, Pending
    deadline DATETIME,
    created_at DATETIME DEFAULT GETDATE()
);

-- 6. Bảng Hồ Sơ Ứng Tuyển (Applications)
CREATE TABLE Applications (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_id INT FOREIGN KEY REFERENCES Jobs(id) ON DELETE CASCADE,
    candidate_id INT FOREIGN KEY REFERENCES Users(id),
    cover_letter NVARCHAR(MAX),
    resume_url VARCHAR(255),
    status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Approved, Rejected
    applied_at DATETIME DEFAULT GETDATE()
);

-- 7. Bảng Thông Báo (Notifications)
CREATE TABLE Notifications (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    message NVARCHAR(500) NOT NULL,
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

-- ==========================================
-- CHÈN DỮ LIỆU MẪU ĐỂ CHẠY THỬ (SEVERAL MOCK DATA)
-- Mật khẩu mặc định của tất cả tài khoản mẫu là: '123456'
-- (Trong code sẽ sử dụng BCrypt hoặc thuật toán băm tương tự)
-- Ở đây ta dùng chuỗi MD5 hoặc Text thô tùy cấu hình.
-- Giả sử mật khẩu thô dạng băm sẵn hoặc text thô để kiểm tra trước.
-- ==========================================

-- Thêm tài khoản Admin
INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active)
VALUES ('admin', '123456', 'admin@talentconnect.com', '0912345678', N'Quản Trị Viên Hệ Thống', 1, 1);

-- Thêm tài khoản Nhà tuyển dụng / Bầu show (Employer - Role ID = 3)
INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active)
VALUES ('vietart', '123456', 'contact@vietart.vn', '0987654321', N'Công ty Truyền Thông VietArt', 3, 1),
       ('saigonshow', '123456', 'show@saigonmusic.com', '0909123456', N'Sài Gòn Music Show', 3, 1);

-- Thêm tài khoản Ứng viên / Nghệ sĩ (Candidate - Role ID = 2)
INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active)
VALUES ('trongnghia', '123456', 'nghia.nt@gmail.com', '0966778899', N'Nguyễn Trọng Nghĩa (Vocalist)', 2, 1),
       ('dinhhai', '123456', 'hai.nd@gmail.com', '0955443322', N'Nguyễn Đình Hải (Guitarist)', 2, 1),
       ('vinhnhat', '123456', 'nhat.tv@gmail.com', '0911223344', N'Trần Vĩnh Nhật (Pianist)', 2, 1);

-- Thêm Hồ sơ ứng viên (Profiles)
INSERT INTO Profiles (user_id, avatar_url, bio, skills, experience, certificates, portfolio_url)
VALUES 
(4, 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150', 
 N'Ca sĩ tự do với chất giọng nam cao ấm áp. Có kinh nghiệm hát sự kiện và phòng trà.', 
 N'Hát Acoustic, Pop Ballad, Kỹ thuật thanh nhạc, Giao tiếp tốt', 
 N'2 năm hát tại phòng trà Acoustic Đà Nẵng, Á quân cuộc thi tiếng hát sinh viên.', 
 N'Chứng chỉ Thanh nhạc Nhạc viện TP.HCM, Chứng chỉ Tiếng Anh B2', 
 'https://youtube.com/demo-vocalist'),
(5, 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 
 N'Nghệ sĩ guitar với niềm đam mê nhạc Jazz và Flamenco. Thích phối khí và đệm hát.', 
 N'Guitar Classic, Guitar Jazz, Phối khí, Sáng tác nhạc', 
 N'3 năm chơi guitar solo tại các nhà hàng Tây, cộng tác viên ban nhạc sông Hàn.', 
 N'Chứng chỉ Guitar trình độ nâng cao (Trinity College London)', 
 'https://soundcloud.com/demo-guitarist'),
(6, 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150', 
 N'Nghệ sĩ Piano chuyên nghiệp, tốt nghiệp khoa nhạc cụ truyền thống và hiện đại.', 
 N'Piano Classic, Đệm nhạc nhẹ, Cảm âm tốt, Làm việc nhóm', 
 N'Giảng viên dạy Piano tại Trung tâm âm nhạc Đà Nẵng, 5 năm kinh nghiệm biểu diễn tiệc cưới và sự kiện lớn.', 
 N'Tốt nghiệp xuất sắc chuyên ngành Piano học viện Âm nhạc Huế', 
 'https://youtube.com/demo-pianist');

-- Thêm Tin tuyển dụng / Show diễn (Jobs)
INSERT INTO Jobs (employer_id, title, description, requirements, salary, location, status, deadline)
VALUES 
(2, N'Tuyển Ca sĩ Acoustic Hát Phòng Trà Cuối Tuần', 
 N'Cần tìm ca sĩ nam/nữ hát dòng nhạc Pop Ballad, Acoustic cho phòng trà ấm cúng vào tối thứ 7 và chủ nhật hàng tuần.', 
 N'Giọng hát truyền cảm, phong cách biểu diễn tự tin, biết tương tác với khán giả. Có thể hát kết hợp guitar/piano.', 
 1500000.00, N'Hải Châu, Đà Nẵng', 'Open', '2026-08-30'),
(2, N'Tìm Nhạc Công Guitar Đệm Hát Sự Kiện Khai Trương', 
 N'Cần tuyển 1 nghệ sĩ guitar đệm hát và solo nhạc nhẹ trong 2 tiếng tại buổi lễ khai trương trung tâm thương mại mới.', 
 N'Có kinh nghiệm đệm hát đa thể loại, trang phục lịch sự, chuyên nghiệp đúng giờ.', 
 2000000.00, N'Sơn Trà, Đà Nẵng', 'Open', '2026-07-15'),
(3, N'Tuyển Nghệ Sĩ Biểu Diễn Piano Tại Khách Sạn 5 Sao', 
 N'Khách sạn Sài Gòn Music Palace tuyển dụng nhạc công piano biểu diễn tại sảnh chính vào các khung giờ trà chiều từ 15h đến 17h.', 
 N'Có kỹ thuật chơi piano cổ điển và bán cổ điển tốt, ngoại hình sáng, tác phong chuyên nghiệp.', 
 8000000.00, N'Quận 1, TP. Hồ Chí Minh', 'Open', '2026-09-01');

-- Thêm Hồ sơ ứng tuyển (Applications)
INSERT INTO Applications (job_id, candidate_id, cover_letter, resume_url, status)
VALUES 
(1, 4, N'Tôi rất mong muốn được hợp tác cùng phòng trà. Đây là link bài hát thử giọng của tôi.', 'https://drive.google.com/resume-nghia.pdf', 'Pending'),
(2, 5, N'Tôi có kinh nghiệm đệm hát sự kiện và chơi nhạc nhẹ Flamenco rất phù hợp với lễ khai trương.', 'https://drive.google.com/resume-hai.pdf', 'Approved');

-- Thêm Thông báo (Notifications)
INSERT INTO Notifications (user_id, message, is_read)
VALUES 
(4, N'Hồ sơ ứng tuyển của bạn cho vị trí "Tuyển Ca sĩ Acoustic Hát Phòng Trà Cuối Tuần" đã được gửi đi thành công.', 0),
(5, N'Chúc mừng! Hồ sơ ứng tuyển cho vị trí "Tìm Nhạc Công Guitar Đệm Hát Sự Kiện Khai Trương" của bạn đã được CHẤP NHẬN.', 0),
(2, N'Bạn có 1 hồ sơ ứng tuyển mới từ Nguyễn Trọng Nghĩa cho tin tuyển dụng của bạn.', 0);
