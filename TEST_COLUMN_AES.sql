--tạo bảng dữ liệu mẫu
CREATE DATABASE QLNS;
GO
use QLNS;
CREATE TABLE NHANVIEN (
 MaNV INT primary key,
 HoTen NVARCHAR(MAX),
 Tuoi INT,
 DiaChi NVARCHAR(MAX),
 SĐT INT,
 MatKhau NVARCHAR(MAX)
 )
 GO
 
INSERT INTO NHANVIEN(MaNV, HoTen, Tuoi, DiaChi, SĐT, MatKhau)
VALUES 
(1, N'Đinh Hoàng Ân', 30, N'Hà Nội', '0931000111', 'DHA@111'),
(2, N'Phạm Thái Bình', 25, N'Đà Nẵng', '0791000222', 'PTB*222'),
(3, N'Nguyễn Lê Bảo Công', 35, N'Cà Mau', '0933000333', 'NLBC#333')
SELECT * from NHANVIEN
GO

--*** bắt đầu mã hoá ***--
--kiểm tra master key trong bảng dữ liệu đã tồn tại chưa.
USE QLNS;
SELECT * FROM sys.symmetric_keys
WHERE NAME = '##MS_DatabaseMasterKey##';
GO

--khởi tạo master key
CREATE MASTER KEY ENCRYPTION BY
PASSWORD = 'SIGM@4';
GO

-- Tạo chứng chỉ
CREATE CERTIFICATE TestAES
WITH SUBJECT = 'Ma hoa MatKhau NV';
GO

-- Tạo khoá đối xứng
CREATE SYMMETRIC KEY QL_NV
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE TestAES;
GO

-- Tạo 1 cột chứa dữ liệu đã mã hoá
ALTER TABLE NHANVIEN
ADD Password_Encrypted VARBINARY(MAX);   
GO

-- Mở chìa khoá đối xứng để mã hoá dữ liệu
OPEN SYMMETRIC KEY QL_NV
DECRYPTION BY CERTIFICATE TestAES; 

-- Mã hoá dữ liệu cột |MatKhau| 
-- Dùng khoá đối xứng 'QL_NV' để mã hoá  
UPDATE NHANVIEN
SET MatKhau = CONVERT(nvarchar(MAX), ENCRYPTBYKEY(KEY_GUID('QL_NV'),  MatKhau),1);
SELECT * FROM QLNS.dbo.NHANVIEN;
GO
UPDATE NHANVIEN
SET Password_Encrypted = ENCRYPTBYKEY(KEY_GUID('QL_NV'),  MatKhau);

-- Giải mã 
SELECT MatKhau FROM NHANVIEN;
SELECT CONVERT(NVARCHAR(MAX), DECRYPTBYKEY( CONVERT(VARBINARY(MAX), MatKhau, 1),KEY_ID('QL_NV'))) AS GiaiMa_MatKhau FROM NHANVIEN;