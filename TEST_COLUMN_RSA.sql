use QLNS
CREATE TABLE PHONGBAN (
MaPhong NVARCHAR(MAX),
DiaChi NVARCHAR(MAX),
SoLuongNV INT,
ThongTinQuanTrong VARCHAR(MAX)
)
GO

INSERT INTO PHONGBAN (MaPhong, DiaChi, SoLuongNV, ThongTinQuanTrong)
VALUES 
('PB001', N'123 Đường ABC, Quận Bình Thạnh, Thành phố HCM', 10, 'planning work'),
('PB002', N'456 Đường XYZ, Quận 5, Thành phố HCM', 15, 'fired some employee'),
('PB003', N'789 Đường LMN, Quận Bình Tân, Thành phố HCM', 20, 'introduce new product');

-- Hiển thị dữ liệu trong bảng PHONGBAN
SELECT * FROM PHONGBAN;
GO

--*** bắt đầu mã hoá ***--
--kiểm tra master key trong bảng dữ liệu đã tồn tại chưa.
USE QLNS;
SELECT * FROM sys.symmetric_keys 
WHERE NAME = '##MS_DatabaseMasterKey##';
GO

-- Tạo khoá bất đối xứng
CREATE ASYMMETRIC KEY QL_PB
WITH ALGORITHM = RSA_2048;

-- Mã hoá dữ liệu trong cột ThongTinQuanTrong
UPDATE PHONGBAN
SET ThongTinQuanTrong = CONVERT (VARCHAR(MAX), ENCRYPTBYASYMKEY(ASYMKEY_ID('QL_PB'), ThongTinQuanTrong),1);
SELECT ThongTinQuanTrong AS InFo_Encrypted FROM PHONGBAN;
GO

-- Giải mã dữ liệu cột ThongtinQuanTrong

SELECT CONVERT(VARCHAR(MAX), DECRYPTBYASYMKEY(ASYMKEY_ID('QL_PB'), CONVERT(VARBINARY(MAX), ThongTinQuanTrong, 1)))
AS GiaiMa_ThongTin FROM PHONGBAN ;
GO

