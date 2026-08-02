-- Chạy script này trong SQL Server để thêm cột tags vào bảng Jobs
USE TalentConnectionDB;
GO

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Jobs' AND COLUMN_NAME = 'tags'
)
BEGIN
    ALTER TABLE Jobs ADD tags NVARCHAR(255);
END
GO
