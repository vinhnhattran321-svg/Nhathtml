-- Script xóa "(Pianist)" và bất kỳ "(xxx)" nào khỏi cột full_name trong bảng Users
-- Chạy script này trong SQL Server Management Studio (SSMS) hoặc Azure Data Studio

USE TalentConnectionDB;
GO

-- Xem trước những dòng sẽ bị ảnh hưởng
SELECT id, full_name,
    RTRIM(LEFT(full_name, CHARINDEX(' (', full_name + ' (') - 1)) AS full_name_moi
FROM Users
WHERE full_name LIKE '% (%';
GO

-- Thực hiện update: xóa phần " (xxx)" ra khỏi full_name
UPDATE Users
SET full_name = RTRIM(LEFT(full_name, CHARINDEX(' (', full_name) - 1))
WHERE full_name LIKE '% (%';
GO

-- Kiểm tra lại kết quả sau khi update
SELECT id, username, full_name FROM Users;
GO
