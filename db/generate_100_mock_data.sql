USE TalentConnectionDB;
GO

-- ==============================================================
-- 0. ĐẢM BẢO CÁC CỘT VÀ BẢNG MỚI ĐÃ TỒN TẠI
-- ==============================================================
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Jobs' AND COLUMN_NAME = 'tags')
BEGIN
    ALTER TABLE Jobs ADD tags NVARCHAR(255);
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reviews')
BEGIN
    CREATE TABLE Reviews (
        id INT IDENTITY(1,1) PRIMARY KEY,
        job_id INT FOREIGN KEY REFERENCES Jobs(id),
        candidate_id INT FOREIGN KEY REFERENCES Users(id),
        employer_id INT FOREIGN KEY REFERENCES Users(id),
        rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
        comment NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'rating')
BEGIN
    ALTER TABLE Users ADD rating FLOAT DEFAULT 0.0, rating_count INT DEFAULT 0;
END
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Profiles' AND COLUMN_NAME = 'ranking_points')
BEGIN
    ALTER TABLE Profiles ADD ranking_points INT DEFAULT 0;
END
GO


-- ==============================================================
-- 1. THÊM 5 NHÀ TUYỂN DỤNG MỚI (Role_id = 3)
-- ==============================================================
INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active)
VALUES 
('emp_anhsao', '123456', 'contact@anhsao.vn', '0900000001', N'Công ty Giải trí Ánh Sao', 3, 1),
('emp_dainam', '123456', 'info@dainam.com', '0900000002', N'Tổ chức Sự kiện Đại Nam', 3, 1),
('emp_nhahat', '123456', 'booking@nhahatsg.vn', '0900000003', N'Nhà hát Kịch Sài Gòn', 3, 1),
('emp_phongtra', '123456', 'dongdao@phongtra.com', '0900000004', N'Phòng trà Đồng Dao', 3, 1),
('emp_vision', '123456', 'hello@visionmedia.com', '0900000005', N'Công ty Truyền thông Vision', 3, 1);
GO

-- ==============================================================
-- 2. THÊM 15 TIN TUYỂN DỤNG MỚI (JOBS)
-- Ghi chú: Sử dụng ID của các Employer vừa được tạo ở trên.
-- Ta giả sử ID của họ tiếp nối sau các user cũ, khoảng ID = 7 đến 11.
-- ==============================================================
DECLARE @emp1 INT = (SELECT id FROM Users WHERE username = 'emp_anhsao');
DECLARE @emp2 INT = (SELECT id FROM Users WHERE username = 'emp_dainam');
DECLARE @emp3 INT = (SELECT id FROM Users WHERE username = 'emp_nhahat');
DECLARE @emp4 INT = (SELECT id FROM Users WHERE username = 'emp_phongtra');
DECLARE @emp5 INT = (SELECT id FROM Users WHERE username = 'emp_vision');

INSERT INTO Jobs (employer_id, title, description, requirements, salary, location, status, deadline, tags) VALUES 
(@emp1, N'Tuyển Ca sĩ hát Pop Ballad', N'Cần ca sĩ hát 5 bài.', N'Giọng tốt.', 2000000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'ca sĩ, pop'),
(@emp1, N'Cần MC dẫn chương trình Gala Dinner', N'Dẫn tiệc cuối năm.', N'Hoạt ngôn, vui vẻ.', 3500000, N'Hà Nội', 'Open', '2026-12-31', N'MC, gala'),
(@emp2, N'Tìm Dancer nhảy múa hiện đại', N'Múa mở màn sự kiện.', N'Biết nhảy hiphop/đương đại.', 1500000, N'Đà Nẵng', 'Open', '2026-12-31', N'nhảy múa, dancer'),
(@emp2, N'Tuyển Ban nhạc Acoustic', N'Chơi nhạc tại quán cà phê.', N'Có đủ nhạc cụ cơ bản.', 2500000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'ban nhạc, acoustic'),
(@emp3, N'Nghệ sĩ chơi Saxophone sự kiện', N'Thổi kèn đón khách.', N'Chơi nhạc jazz.', 3000000, N'Hà Nội', 'Open', '2026-12-31', N'saxophone, nhạc cụ'),
(@emp3, N'Diễn viên kịch nói', N'Tuyển diễn viên kịch.', N'Có kỹ năng diễn xuất tốt.', 4000000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'diễn viên, kịch'),
(@emp4, N'Rapper cho sự kiện ra mắt game', N'Rap khuấy động sân khấu.', N'Sôi động, biết rap.', 5000000, N'Đà Nẵng', 'Open', '2026-12-31', N'rapper, hiphop'),
(@emp4, N'Ca sĩ hát dân ca', N'Hát tại hội chợ ẩm thực.', N'Giọng ngọt ngào.', 1800000, N'Cần Thơ', 'Open', '2026-12-31', N'ca sĩ, dân ca'),
(@emp5, N'DJ chơi nhạc EDM', N'Đánh nhạc EDM tiệc tối.', N'Kinh nghiệm 2 năm.', 6000000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'DJ, EDM'),
(@emp5, N'Nghệ sĩ múa đương đại', N'Múa phụ họa sự kiện nghệ thuật.', N'Dẻo dai.', 2000000, N'Hà Nội', 'Open', '2026-12-31', N'nhảy múa, đương đại'),
(@emp1, N'MC song ngữ Anh-Việt', N'Dẫn chương trình quốc tế.', N'IELTS 7.0 trở lên.', 8000000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'MC, song ngữ'),
(@emp2, N'Nhạc công Guitar Bass', N'Đánh bass cho band nhạc rock.', N'Biết chơi rock.', 2500000, N'Hà Nội', 'Open', '2026-12-31', N'guitar, nhạc cụ'),
(@emp3, N'Ảo thuật gia biểu diễn tiệc', N'Biểu diễn ảo thuật đường phố.', N'Lôi cuốn, hấp dẫn.', 3000000, N'Đà Nẵng', 'Open', '2026-12-31', N'ảo thuật, biểu diễn'),
(@emp4, N'Nhóm nhạc nữ Idol', N'Biểu diễn 3 tiết mục.', N'Xinh đẹp, vũ đạo tốt.', 10000000, N'Hồ Chí Minh', 'Open', '2026-12-31', N'nhóm nhạc, idol'),
(@emp5, N'Nghệ sĩ Beatbox', N'Mở màn sự kiện giao lưu.', N'Beatbox tốt.', 1500000, N'Hà Nội', 'Open', '2026-12-31', N'beatbox, nghệ sĩ');
GO

-- ==============================================================
-- 3. THÊM 100 TÀI KHOẢN NGƯỜI DÙNG (CANDIDATES - Role_id = 2)
-- Tên người Việt thực tế
-- ==============================================================
INSERT INTO Users (username, password_hash, email, phone, full_name, role_id, is_active) VALUES
('can_1', '123456', 'can_1@gmail.com', '0910000001', N'Trần Minh Tuấn', 2, 1),
('can_2', '123456', 'can_2@gmail.com', '0910000002', N'Nguyễn Thị Thu Thảo', 2, 1),
('can_3', '123456', 'can_3@gmail.com', '0910000003', N'Lê Phương Nam', 2, 1),
('can_4', '123456', 'can_4@gmail.com', '0910000004', N'Phạm Bích Ngọc', 2, 1),
('can_5', '123456', 'can_5@gmail.com', '0910000005', N'Hoàng Thế Dũng', 2, 1),
('can_6', '123456', 'can_6@gmail.com', '0910000006', N'Vũ Ngọc Linh', 2, 1),
('can_7', '123456', 'can_7@gmail.com', '0910000007', N'Võ Đình Khoa', 2, 1),
('can_8', '123456', 'can_8@gmail.com', '0910000008', N'Phan Thanh Trúc', 2, 1),
('can_9', '123456', 'can_9@gmail.com', '0910000009', N'Đặng Tuấn Đạt', 2, 1),
('can_10', '123456', 'can_10@gmail.com', '0910000010', N'Bùi Phương Anh', 2, 1),
('can_11', '123456', 'can_11@gmail.com', '0910000011', N'Đỗ Hữu Long', 2, 1),
('can_12', '123456', 'can_12@gmail.com', '0910000012', N'Hồ Mai Lan', 2, 1),
('can_13', '123456', 'can_13@gmail.com', '0910000013', N'Ngô Gia Bảo', 2, 1),
('can_14', '123456', 'can_14@gmail.com', '0910000014', N'Dương Thu Trang', 2, 1),
('can_15', '123456', 'can_15@gmail.com', '0910000015', N'Lý Công Hoàng', 2, 1),
('can_16', '123456', 'can_16@gmail.com', '0910000016', N'Trần Quỳnh My', 2, 1),
('can_17', '123456', 'can_17@gmail.com', '0910000017', N'Nguyễn Quang Hải', 2, 1),
('can_18', '123456', 'can_18@gmail.com', '0910000018', N'Lê Minh Vy', 2, 1),
('can_19', '123456', 'can_19@gmail.com', '0910000019', N'Phạm Tiến Đạt', 2, 1),
('can_20', '123456', 'can_20@gmail.com', '0910000020', N'Hoàng Thúy Vân', 2, 1),
('can_21', '123456', 'can_21@gmail.com', '0910000021', N'Trần Quốc Bảo', 2, 1),
('can_22', '123456', 'can_22@gmail.com', '0910000022', N'Nguyễn Thanh Hương', 2, 1),
('can_23', '123456', 'can_23@gmail.com', '0910000023', N'Lê Văn Hùng', 2, 1),
('can_24', '123456', 'can_24@gmail.com', '0910000024', N'Phạm Thùy Chi', 2, 1),
('can_25', '123456', 'can_25@gmail.com', '0910000025', N'Hoàng Ngọc Sơn', 2, 1),
('can_26', '123456', 'can_26@gmail.com', '0910000026', N'Vũ Khánh Ngân', 2, 1),
('can_27', '123456', 'can_27@gmail.com', '0910000027', N'Võ Thành Nam', 2, 1),
('can_28', '123456', 'can_28@gmail.com', '0910000028', N'Phan Yến Nhi', 2, 1),
('can_29', '123456', 'can_29@gmail.com', '0910000029', N'Đặng Gia Huy', 2, 1),
('can_30', '123456', 'can_30@gmail.com', '0910000030', N'Bùi Bích Phương', 2, 1),
('can_31', '123456', 'can_31@gmail.com', '0910000031', N'Đỗ Minh Cường', 2, 1),
('can_32', '123456', 'can_32@gmail.com', '0910000032', N'Hồ Phương Anh', 2, 1),
('can_33', '123456', 'can_33@gmail.com', '0910000033', N'Ngô Duy Mạnh', 2, 1),
('can_34', '123456', 'can_34@gmail.com', '0910000034', N'Dương Tuyết Mai', 2, 1),
('can_35', '123456', 'can_35@gmail.com', '0910000035', N'Lý Quốc Hưng', 2, 1),
('can_36', '123456', 'can_36@gmail.com', '0910000036', N'Trần Ngọc Ánh', 2, 1),
('can_37', '123456', 'can_37@gmail.com', '0910000037', N'Nguyễn Việt Đức', 2, 1),
('can_38', '123456', 'can_38@gmail.com', '0910000038', N'Lê Minh Châu', 2, 1),
('can_39', '123456', 'can_39@gmail.com', '0910000039', N'Phạm Quang Dũng', 2, 1),
('can_40', '123456', 'can_40@gmail.com', '0910000040', N'Hoàng Mai Hương', 2, 1),
('can_41', '123456', 'can_41@gmail.com', '0910000041', N'Trần Hữu Thắng', 2, 1),
('can_42', '123456', 'can_42@gmail.com', '0910000042', N'Nguyễn Hồng Gấm', 2, 1),
('can_43', '123456', 'can_43@gmail.com', '0910000043', N'Lê Xuân Trường', 2, 1),
('can_44', '123456', 'can_44@gmail.com', '0910000044', N'Phạm Thu Hiền', 2, 1),
('can_45', '123456', 'can_45@gmail.com', '0910000045', N'Hoàng Văn Kiên', 2, 1),
('can_46', '123456', 'can_46@gmail.com', '0910000046', N'Vũ Bích Hạnh', 2, 1),
('can_47', '123456', 'can_47@gmail.com', '0910000047', N'Võ Trung Kiên', 2, 1),
('can_48', '123456', 'can_48@gmail.com', '0910000048', N'Phan Cẩm Tú', 2, 1),
('can_49', '123456', 'can_49@gmail.com', '0910000049', N'Đặng Ngọc Hải', 2, 1),
('can_50', '123456', 'can_50@gmail.com', '0910000050', N'Bùi Thanh Thủy', 2, 1),
('can_51', '123456', 'can_51@gmail.com', '0910000051', N'Đỗ Quốc Hùng', 2, 1),
('can_52', '123456', 'can_52@gmail.com', '0910000052', N'Hồ Thảo Nguyên', 2, 1),
('can_53', '123456', 'can_53@gmail.com', '0910000053', N'Ngô Tuấn Anh', 2, 1),
('can_54', '123456', 'can_54@gmail.com', '0910000054', N'Dương Phương Thảo', 2, 1),
('can_55', '123456', 'can_55@gmail.com', '0910000055', N'Lý Chí Thanh', 2, 1),
('can_56', '123456', 'can_56@gmail.com', '0910000056', N'Trần Ngọc My', 2, 1),
('can_57', '123456', 'can_57@gmail.com', '0910000057', N'Nguyễn Mạnh Hùng', 2, 1),
('can_58', '123456', 'can_58@gmail.com', '0910000058', N'Lê Bích Ngọc', 2, 1),
('can_59', '123456', 'can_59@gmail.com', '0910000059', N'Phạm Hữu Phước', 2, 1),
('can_60', '123456', 'can_60@gmail.com', '0910000060', N'Hoàng Yến Chi', 2, 1),
('can_61', '123456', 'can_61@gmail.com', '0910000061', N'Trần Đăng Khoa', 2, 1),
('can_62', '123456', 'can_62@gmail.com', '0910000062', N'Nguyễn Bảo Tâm', 2, 1),
('can_63', '123456', 'can_63@gmail.com', '0910000063', N'Lê Minh Khang', 2, 1),
('can_64', '123456', 'can_64@gmail.com', '0910000064', N'Phạm Thu Uyên', 2, 1),
('can_65', '123456', 'can_65@gmail.com', '0910000065', N'Hoàng Quang Huy', 2, 1),
('can_66', '123456', 'can_66@gmail.com', '0910000066', N'Vũ Lan Hương', 2, 1),
('can_67', '123456', 'can_67@gmail.com', '0910000067', N'Võ Minh Quân', 2, 1),
('can_68', '123456', 'can_68@gmail.com', '0910000068', N'Phan Thùy Dung', 2, 1),
('can_69', '123456', 'can_69@gmail.com', '0910000069', N'Đặng Hữu Lộc', 2, 1),
('can_70', '123456', 'can_70@gmail.com', '0910000070', N'Bùi Phương Trinh', 2, 1),
('can_71', '123456', 'can_71@gmail.com', '0910000071', N'Đỗ Thanh Lâm', 2, 1),
('can_72', '123456', 'can_72@gmail.com', '0910000072', N'Hồ Mỹ Tâm', 2, 1),
('can_73', '123456', 'can_73@gmail.com', '0910000073', N'Ngô Hữu Tài', 2, 1),
('can_74', '123456', 'can_74@gmail.com', '0910000074', N'Dương Quỳnh Anh', 2, 1),
('can_75', '123456', 'can_75@gmail.com', '0910000075', N'Lý Nhật Hào', 2, 1),
('can_76', '123456', 'can_76@gmail.com', '0910000076', N'Trần Ngọc Lan', 2, 1),
('can_77', '123456', 'can_77@gmail.com', '0910000077', N'Nguyễn Quang Minh', 2, 1),
('can_78', '123456', 'can_78@gmail.com', '0910000078', N'Lê Minh Đức', 2, 1),
('can_79', '123456', 'can_79@gmail.com', '0910000079', N'Phạm Tiến Long', 2, 1),
('can_80', '123456', 'can_80@gmail.com', '0910000080', N'Hoàng Yến', 2, 1),
('can_81', '123456', 'can_81@gmail.com', '0910000081', N'Trần Văn Lâm', 2, 1),
('can_82', '123456', 'can_82@gmail.com', '0910000082', N'Nguyễn Thị Thu', 2, 1),
('can_83', '123456', 'can_83@gmail.com', '0910000083', N'Lê Đức Anh', 2, 1),
('can_84', '123456', 'can_84@gmail.com', '0910000084', N'Phạm Hồng Ngân', 2, 1),
('can_85', '123456', 'can_85@gmail.com', '0910000085', N'Hoàng Phúc', 2, 1),
('can_86', '123456', 'can_86@gmail.com', '0910000086', N'Vũ Minh Nhựt', 2, 1),
('can_87', '123456', 'can_87@gmail.com', '0910000087', N'Võ Thanh Tú', 2, 1),
('can_88', '123456', 'can_88@gmail.com', '0910000088', N'Phan Đình Phùng', 2, 1),
('can_89', '123456', 'can_89@gmail.com', '0910000089', N'Đặng Thanh Bình', 2, 1),
('can_90', '123456', 'can_90@gmail.com', '0910000090', N'Bùi Quang Vinh', 2, 1),
('can_91', '123456', 'can_91@gmail.com', '0910000091', N'Đỗ Hữu Nghĩa', 2, 1),
('can_92', '123456', 'can_92@gmail.com', '0910000092', N'Hồ Quang Hiếu', 2, 1),
('can_93', '123456', 'can_93@gmail.com', '0910000093', N'Ngô Thanh Vân', 2, 1),
('can_94', '123456', 'can_94@gmail.com', '0910000094', N'Dương Minh Trí', 2, 1),
('can_95', '123456', 'can_95@gmail.com', '0910000095', N'Lý Hùng', 2, 1),
('can_96', '123456', 'can_96@gmail.com', '0910000096', N'Trần Ngọc Sơn', 2, 1),
('can_97', '123456', 'can_97@gmail.com', '0910000097', N'Nguyễn Quang Dũng', 2, 1),
('can_98', '123456', 'can_98@gmail.com', '0910000098', N'Lê Minh Hằng', 2, 1),
('can_99', '123456', 'can_99@gmail.com', '0910000099', N'Phạm Đăng Khoa', 2, 1),
('can_100', '123456', 'can_100@gmail.com', '0910000100', N'Hoàng Thanh', 2, 1);
GO

-- ==============================================================
-- 3b. THÊM PROFILES VỚI SKILLS/ROLES CHO 100 CANDIDATES
-- ==============================================================
INSERT INTO Profiles (user_id, bio, skills, experience, ranking_points)
SELECT u.id,
    N'Nghệ sĩ chuyên nghiệp với nhiều năm kinh nghiệm biểu diễn.',
    CASE
        WHEN u.username IN ('can_1','can_2','can_3','can_4')       THEN N'Ca sĩ, Rapper'
        WHEN u.username IN ('can_5','can_6','can_7','can_8')       THEN N'Ca sĩ, MC'
        WHEN u.username IN ('can_9','can_10','can_11','can_12')    THEN N'Rapper, Beatboxer'
        WHEN u.username IN ('can_13','can_14','can_15')            THEN N'Rapper, MC'
        WHEN u.username IN ('can_16','can_17','can_18','can_19')   THEN N'MC, Người dẫn chương trình'
        WHEN u.username IN ('can_20','can_21','can_22')            THEN N'MC, Ca sĩ'
        WHEN u.username IN ('can_23','can_24','can_25','can_26')   THEN N'Dancer, Diễn viên'
        WHEN u.username IN ('can_27','can_28','can_29')            THEN N'Dancer, Xiếc'
        WHEN u.username IN ('can_30','can_31','can_32','can_33')   THEN N'DJ, Nhạc công'
        WHEN u.username IN ('can_34','can_35','can_36')            THEN N'DJ, Band nhạc'
        WHEN u.username IN ('can_37','can_38','can_39','can_40')   THEN N'Band nhạc, Nhạc công'
        WHEN u.username IN ('can_41','can_42','can_43')            THEN N'Band nhạc, Ca sĩ'
        WHEN u.username IN ('can_44','can_45','can_46','can_47')   THEN N'Nhạc công, Nhạc sĩ'
        WHEN u.username IN ('can_48','can_49','can_50')            THEN N'Nhạc công, DJ'
        WHEN u.username IN ('can_51','can_52','can_53','can_54')   THEN N'Diễn viên, MC'
        WHEN u.username IN ('can_55','can_56','can_57')            THEN N'Diễn viên, Hài độc thoại'
        WHEN u.username IN ('can_58','can_59','can_60','can_61')   THEN N'Nhạc sĩ, Nhạc công'
        WHEN u.username IN ('can_62','can_63','can_64')            THEN N'Nhạc sĩ, Ca sĩ'
        WHEN u.username IN ('can_65','can_66','can_67','can_68')   THEN N'Beatboxer, Rapper'
        WHEN u.username IN ('can_69','can_70','can_71')            THEN N'Beatboxer, MC'
        WHEN u.username IN ('can_72','can_73','can_74','can_75')   THEN N'Ảo thuật gia, Diễn viên'
        WHEN u.username IN ('can_76','can_77','can_78')            THEN N'Ảo thuật gia, Xiếc'
        WHEN u.username IN ('can_79','can_80','can_81','can_82')   THEN N'Người dẫn chương trình, MC'
        WHEN u.username IN ('can_83','can_84','can_85')            THEN N'Người dẫn chương trình, Hài độc thoại'
        WHEN u.username IN ('can_86','can_87','can_88','can_89')   THEN N'Hài độc thoại, Diễn viên'
        WHEN u.username IN ('can_90','can_91','can_92')            THEN N'Hài độc thoại, MC'
        WHEN u.username IN ('can_93','can_94','can_95','can_96')   THEN N'Xiếc, Dancer'
        WHEN u.username IN ('can_97','can_98','can_99','can_100')  THEN N'Xiếc, Ảo thuật gia'
        ELSE N'Ca sĩ, MC'
    END,
    N'Từng tham gia nhiều sự kiện âm nhạc, gala dinner và chương trình giải trí lớn.',
    (ABS(CHECKSUM(NEWID())) % 50 + 10) * 10
FROM Users u
WHERE u.role_id = 2
  AND u.username LIKE 'can_%'
  AND NOT EXISTS (SELECT 1 FROM Profiles p WHERE p.user_id = u.id);
GO

-- Một số user có 3 roles nổi bật
UPDATE p SET p.skills = N'Ca sĩ, Rapper, MC'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id WHERE u.username = 'can_1';
UPDATE p SET p.skills = N'DJ, Nhạc công, Band nhạc'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id WHERE u.username = 'can_30';
UPDATE p SET p.skills = N'Dancer, Diễn viên, Xiếc'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id WHERE u.username = 'can_23';
UPDATE p SET p.skills = N'MC, Người dẫn chương trình, Hài độc thoại'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id WHERE u.username = 'can_79';
UPDATE p SET p.skills = N'Beatboxer, Rapper, MC'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id WHERE u.username = 'can_65';
GO

-- ==============================================================
-- 4. THÊM 100 ĐÁNH GIÁ (REVIEWS) TỪ 100 TÀI KHOẢN TRÊN
-- (Mỗi tài khoản đánh giá ngẫu nhiên 1 trong 15 jobs với số sao 4-5)
-- ==============================================================
-- Lưu ý: id của 15 jobs vừa thêm nằm từ (SELECT MAX(id)-14 FROM Jobs) đến (SELECT MAX(id) FROM Jobs).
-- Tuy nhiên, để đơn giản trong SQL, ta dùng CURSOR hoặc tự gen 100 lệnh INSERT tĩnh.
-- Ở đây tôi dùng 100 dòng lệnh Insert tĩnh lấy User ID từ can_1 đến can_100.
-- Việc map vào JobID (1 đến 15) và EmployerID (7 đến 11) sẽ được làm tĩnh.

DECLARE @firstUserId INT = (SELECT id FROM Users WHERE username = 'can_1');
DECLARE @firstJobId INT = (SELECT MAX(id) - 14 FROM Jobs);

-- Tạo bảng tạm chứa 100 dòng dữ liệu
CREATE TABLE #TempReviews (
    idx INT,
    rating INT,
    comment NVARCHAR(255)
);

INSERT INTO #TempReviews (idx, rating, comment) VALUES
(0, 5, N'Sự kiện diễn ra cực kỳ suôn sẻ. Mọi người rất chuyên nghiệp!'),
(1, 4, N'Môi trường tuyệt vời, cát xê chuyển khoản ngay lập tức.'),
(2, 5, N'Khán giả rất đông và nhiệt tình, ban tổ chức chu đáo.'),
(3, 5, N'Rất vui được hợp tác. Mọi thứ được chuẩn bị kỹ lưỡng.'),
(4, 4, N'Sân khấu âm thanh rất tốt, hát cực kỳ đã tai.'),
(5, 5, N'Trải nghiệm tuyệt vời. Cảm ơn nhà tuyển dụng.'),
(6, 4, N'Bầu show rất uy tín, hy vọng được hợp tác lần sau.'),
(7, 5, N'Chất lượng sự kiện chuẩn 5 sao, vô cùng chuyên nghiệp.'),
(8, 5, N'Sự kiện quy mô lớn, thù lao rất xứng đáng.'),
(9, 4, N'Làm việc thoải mái, không áp lực. Rất tuyệt.'),
(10, 5, N'Khâu hậu cần quá đỉnh, chăm sóc nghệ sĩ chu đáo.'),
(11, 4, N'Giao lưu vui vẻ, kịch bản chương trình rõ ràng.'),
(12, 5, N'Tuyệt vời! Show diễn thu hút nhiều người hâm mộ.'),
(13, 5, N'Anh quản lý rất nice, thanh toán sòng phẳng.'),
(14, 4, N'Rất thích không khí ở đây. Sẽ đăng ký thêm nếu có show.'),
(15, 5, N'Chất lượng thiết bị ánh sáng siêu đỉnh.'),
(16, 5, N'Mọi người thân thiện, giúp đỡ mình rất nhiều.'),
(17, 4, N'Thù lao rất cao, đáng công sức bỏ ra.'),
(18, 5, N'Một trong những show diễn đáng nhớ nhất của mình!'),
(19, 4, N'Cám ơn ban tổ chức đã hỗ trợ nhiệt tình.'),
(20, 5, N'Tuyệt vời! Không có gì để chê.'),
(21, 5, N'Bầu show hiểu tâm lý nghệ sĩ, cực kỳ ưng ý.'),
(22, 4, N'Sự kiện lớn, rất tự hào khi được tham gia.'),
(23, 5, N'Chắc chắn sẽ hợp tác lâu dài với đơn vị này.'),
(24, 4, N'Mọi thứ đều hoàn hảo, 10 điểm cho chất lượng.'),
(25, 5, N'Dịch vụ của công ty cực kỳ tốt.'),
(26, 5, N'Rất mong có cơ hội được làm việc lại.'),
(27, 4, N'Môi trường năng động, thích hợp cho người trẻ.'),
(28, 5, N'Mọi người siêu dễ thương và hỗ trợ mình.'),
(29, 4, N'Show diễn rất cháy! Khán giả quẩy cực nhiệt.'),
(30, 5, N'Chất lượng đỉnh cao. Rất uy tín.'),
(31, 5, N'Rất chuyên nghiệp. Mọi thứ đúng theo kịch bản.'),
(32, 4, N'Kỷ niệm đáng nhớ. Cát xê chuẩn.'),
(33, 5, N'Quy mô hoành tráng, âm thanh xịn xò.'),
(34, 4, N'Mọi thứ rất tốt, mình rất hài lòng.'),
(35, 5, N'Một show diễn thành công rực rỡ.'),
(36, 5, N'Đánh giá 5 sao cho sự nhiệt tình của anh quản lý.'),
(37, 4, N'Giao dịch nhanh gọn lẹ, rất sòng phẳng.'),
(38, 5, N'Khán giả đáng yêu, bầu show chuyên nghiệp.'),
(39, 4, N'Sẽ giới thiệu bạn bè tham gia show của công ty này.'),
(40, 5, N'Quá tuyệt vời!'),
(41, 5, N'Chất lượng tốt, giá cát xê hợp lý.'),
(42, 4, N'Không gian biểu diễn siêu đẹp, rất chill.'),
(43, 5, N'Mọi thứ đều ok. Rất ưng.'),
(44, 4, N'Kịch bản hay, diễn rất nhập tâm.'),
(45, 5, N'Được làm việc với ekip giỏi, học hỏi được nhiều.'),
(46, 5, N'Chương trình ý nghĩa, rất vinh dự được tham gia.'),
(47, 4, N'Tốt lắm, mong có nhiều show hơn.'),
(48, 5, N'Trải nghiệm 5 sao.'),
(49, 4, N'Bầu show rất tôn trọng nghệ sĩ.'),
(50, 5, N'Mình cực kỳ hài lòng với show này.'),
(51, 5, N'Âm thanh bắt mic cực tốt, hát nhẹ.'),
(52, 4, N'Chuẩn bị chu đáo, có phòng chờ riêng.'),
(53, 5, N'Đồ ăn hậu cần ngon. Ekip dễ thương.'),
(54, 4, N'Mọi người hỗ trợ mình nhiệt tình.'),
(55, 5, N'Rất tuyệt. Không có lời nào để chê.'),
(56, 5, N'Sự kiện hoành tráng nhất mình từng tham gia.'),
(57, 4, N'Rất uy tín, khuyên mọi người nên nhận show này.'),
(58, 5, N'Tuyệt vời! Mong hợp tác thêm.'),
(59, 4, N'10 điểm cho chất lượng âm thanh ánh sáng.'),
(60, 5, N'Sự kiện diễn ra thành công tốt đẹp.'),
(61, 5, N'Mình rất vui vì được mời.'),
(62, 4, N'Bầu show làm việc rất nguyên tắc và chuẩn.'),
(63, 5, N'Chưa bao giờ tham gia show nào xịn như vậy.'),
(64, 4, N'Rất đáng tiền, cát xê xứng đáng.'),
(65, 5, N'Cảm ơn công ty đã tạo điều kiện.'),
(66, 5, N'Nhiều bạn bè mình cũng khen show này.'),
(67, 4, N'Rất hài lòng.'),
(68, 5, N'Chuyên nghiệp từ khâu nhỏ nhất.'),
(69, 4, N'Mong có nhiều sự kiện như vậy nữa.'),
(70, 5, N'Sự kiện thu hút quá đông khán giả, rất vui.'),
(71, 5, N'Được khán giả ủng hộ nhiệt tình.'),
(72, 4, N'Ban tổ chức rất tốt bụng.'),
(73, 5, N'Chất lượng 5 sao, ekip tận tình.'),
(74, 4, N'Hợp tác vui vẻ.'),
(75, 5, N'Cực kỳ ấn tượng với phong cách làm việc.'),
(76, 5, N'Đánh giá cao sự chuẩn bị của ban tổ chức.'),
(77, 4, N'Rất sòng phẳng, thanh toán ngay sau show.'),
(78, 5, N'Mọi thứ quá tốt.'),
(79, 4, N'Mình sẽ tiếp tục đăng ký tham gia.'),
(80, 5, N'Sự kiện gây quỹ rất ý nghĩa.'),
(81, 5, N'Rất tự hào khi được biểu diễn.'),
(82, 4, N'Một ngày làm việc hiệu quả.'),
(83, 5, N'Ekip hỗ trợ 24/7, rất yên tâm.'),
(84, 4, N'Show diễn rất bùng nổ.'),
(85, 5, N'Không khí siêu nhiệt!'),
(86, 5, N'Mình được trải nghiệm sân khấu lớn.'),
(87, 4, N'Kỹ thuật viên âm thanh rất pro.'),
(88, 5, N'Rất thích phong cách của đơn vị tổ chức.'),
(89, 4, N'Tuyệt vời ông mặt trời.'),
(90, 5, N'100 điểm không có nhưng.'),
(91, 5, N'Bầu show siêu dễ tính.'),
(92, 4, N'Đã tham gia 2 show và đều rất ok.'),
(93, 5, N'Show diễn hoàn hảo.'),
(94, 4, N'Sẽ giới thiệu cho các anh em nghệ sĩ khác.'),
(95, 5, N'Cảm ơn vì một đêm diễn cháy hết mình.'),
(96, 5, N'Rất xứng đáng với công sức bỏ ra.'),
(97, 4, N'Ekip quay phim chụp hình đẹp xuất sắc.'),
(98, 5, N'Rất trân trọng cơ hội này.'),
(99, 4, N'Mình đã có những bức ảnh biểu diễn cực đẹp.');

-- Vòng lặp Insert 100 Đánh giá
DECLARE @i INT = 0;
WHILE @i < 100
BEGIN
    DECLARE @u_id INT = @firstUserId + @i;
    DECLARE @j_id INT = @firstJobId + (@i % 15);
    DECLARE @e_id INT = (SELECT employer_id FROM Jobs WHERE id = @j_id);
    
    DECLARE @r_rating INT = (SELECT rating FROM #TempReviews WHERE idx = @i);
    DECLARE @r_comment NVARCHAR(255) = (SELECT comment FROM #TempReviews WHERE idx = @i);
    
    INSERT INTO Reviews (job_id, candidate_id, employer_id, rating, comment)
    VALUES (@j_id, @u_id, @e_id, @r_rating, @r_comment);
    
    SET @i = @i + 1;
END

DROP TABLE #TempReviews;
GO
