USE TalentConnectionDB;
GO

-- ==============================================================
-- Script gán skills/roles cho 100 candidates (can_1 -> can_100)
-- Chạy script này để các user có role hiển thị trên ranking
-- ==============================================================

-- Danh sách roles có trong filter:
-- Ca sĩ, Rapper, MC, Dancer, DJ, Band nhạc, Nhạc công,
-- Diễn viên, Nhạc sĩ, Beatboxer, Ảo thuật gia,
-- Người dẫn chương trình, Hài độc thoại, Xiếc

-- Bước 1: Tạo Profile nếu chưa có (INSERT OR SKIP)
INSERT INTO Profiles (user_id, bio, skills, experience, ranking_points)
SELECT u.id,
    N'Nghệ sĩ tài năng với nhiều năm kinh nghiệm biểu diễn chuyên nghiệp.',
    N'',   -- skills sẽ được update ở bước 2
    N'Từng tham gia nhiều sự kiện âm nhạc, gala dinner và chương trình giải trí.',
    CAST((ABS(CHECKSUM(NEWID())) % 50) + 10 AS INT) * 10
FROM Users u
WHERE u.role_id = 2
  AND NOT EXISTS (SELECT 1 FROM Profiles p WHERE p.user_id = u.id);
GO

-- Bước 2: Gán skills theo nhóm (phân chia đều 100 user vào 14 roles)
-- Group 1: Ca sĩ (can_1 -> can_8)
UPDATE p SET p.skills = N'Ca sĩ'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_1','can_2','can_3','can_4','can_5','can_6','can_7','can_8');

-- Group 2: Rapper (can_9 -> can_15)
UPDATE p SET p.skills = N'Rapper'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_9','can_10','can_11','can_12','can_13','can_14','can_15');

-- Group 3: MC (can_16 -> can_22)
UPDATE p SET p.skills = N'MC'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_16','can_17','can_18','can_19','can_20','can_21','can_22');

-- Group 4: Dancer (can_23 -> can_29)
UPDATE p SET p.skills = N'Dancer'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_23','can_24','can_25','can_26','can_27','can_28','can_29');

-- Group 5: DJ (can_30 -> can_36)
UPDATE p SET p.skills = N'DJ'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_30','can_31','can_32','can_33','can_34','can_35','can_36');

-- Group 6: Band nhạc (can_37 -> can_43)
UPDATE p SET p.skills = N'Band nhạc'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_37','can_38','can_39','can_40','can_41','can_42','can_43');

-- Group 7: Nhạc công (can_44 -> can_50)
UPDATE p SET p.skills = N'Nhạc công'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_44','can_45','can_46','can_47','can_48','can_49','can_50');

-- Group 8: Diễn viên (can_51 -> can_57)
UPDATE p SET p.skills = N'Diễn viên'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_51','can_52','can_53','can_54','can_55','can_56','can_57');

-- Group 9: Nhạc sĩ (can_58 -> can_64)
UPDATE p SET p.skills = N'Nhạc sĩ'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_58','can_59','can_60','can_61','can_62','can_63','can_64');

-- Group 10: Beatboxer (can_65 -> can_71)
UPDATE p SET p.skills = N'Beatboxer'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_65','can_66','can_67','can_68','can_69','can_70','can_71');

-- Group 11: Ảo thuật gia (can_72 -> can_78)
UPDATE p SET p.skills = N'Ảo thuật gia'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_72','can_73','can_74','can_75','can_76','can_77','can_78');

-- Group 12: Người dẫn chương trình (can_79 -> can_85)
UPDATE p SET p.skills = N'Người dẫn chương trình'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_79','can_80','can_81','can_82','can_83','can_84','can_85');

-- Group 13: Hài độc thoại (can_86 -> can_92)
UPDATE p SET p.skills = N'Hài độc thoại'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_86','can_87','can_88','can_89','can_90','can_91','can_92');

-- Group 14: Xiếc (can_93 -> can_100)
UPDATE p SET p.skills = N'Xiếc'
FROM Profiles p
INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_93','can_94','can_95','can_96','can_97','can_98','can_99','can_100');
GO

-- Gán thêm skill phụ cho một số user để đa dạng hơn
UPDATE p SET p.skills = N'Ca sĩ, Rapper'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_3','can_7');

UPDATE p SET p.skills = N'MC, Người dẫn chương trình'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_18','can_22');

UPDATE p SET p.skills = N'DJ, Nhạc công'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_33','can_36');

UPDATE p SET p.skills = N'Dancer, Diễn viên'
FROM Profiles p INNER JOIN Users u ON p.user_id = u.id
WHERE u.username IN ('can_26','can_29');

-- Kiểm tra kết quả
SELECT u.username, u.full_name, p.skills
FROM Users u
LEFT JOIN Profiles p ON u.id = p.user_id
WHERE u.role_id = 2
ORDER BY u.username;
GO
