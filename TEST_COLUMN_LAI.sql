USE QLNS
-- Thêm bảng dữ liệu khách hàng
CREATE TABLE KHACH_HANG (
MaKH NVARCHAR(MAX),
HoTen NVARCHAR(MAX),
DiaChi NVARCHAR(MAX),
SDT INT,
Mail NVARCHAR(MAX),
MaPin NVARCHAR(MAX)
)
GO

INSERT INTO KHACH_HANG (MaKH, HoTen, DiaChi, SDT, Mail, MaPin)
VALUES
('A01', N'Hoàng Thiên An', N'111, Quận Gò Vấp, TP.HCM', '0123000001', 'HTA@gmail.com', 'A1Z0'),
('A02', N'Đặng Quang Bảo', N'222, Quận Bình Thạnh, TP.HCM', '0124000002', 'DQB@gmail.com', 'B2Y1'),
('A03', N'Nguyễn Quốc Bình', N'333, Quận 12, TP.HCM', '0125000003', 'NQB@gmail.com', 'C3X2'),
('A04', N'Ngô Gia Cường', N'444, Quận 5, TP.HCM', '0126000004', 'NGC@gmail.com', 'C4W3'),
('A05', N'Thái Thị Cẩm Dương', N'555, Quận Phú Nhuận, TP.HCM', '0126000005', '2TCD@gmail.com', 'D5V4'),
('A06', N'Trịnh Lâm Duy', N'666, Quận 8, TP.HCM', '0127000006', 'TLD@gmail.com', 'E6@5')
SELECT * FROM KHACH_HANG;
GO

-- Bắt đầu mã hoá --
-- Mã hoá cột MaPin của KH bằng thuật toán Đối Xứng AES --
-- Mã hoá chìa AES bằng thuật toán Bất Đối Xứng RSA --

-- Tạo cặp khóa bất đối xứng
CREATE ASYMMETRIC KEY SecretKey
WITH ALGORITHM = RSA_2048;

-- Tạo khóa đối xứng
CREATE SYMMETRIC KEY InfoKey
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY SecretKey;
GO

-- Mã hoá dữ liệu MaPin bằng khoá Đối Xứng --
OPEN SYMMETRIC KEY InfoKey
DECRYPTION BY ASYMMETRIC KEY SecretKey;

UPDATE KHACH_HANG
SET MaPin = CONVERT(NVARCHAR(MAX), ENCRYPTBYKEY(KEY_GUID('InfoKey'),  MaPin),1) ;
SELECT MaPin AS MaPin_Encrypted FROM KHACH_HANG;
GO
CLOSE SYMMETRIC KEY InfoKey
-- Giải mã dữ liệu MaPin bằng khoá DX InfoKey

OPEN SYMMETRIC KEY InfoKey
DECRYPTION BY ASYMMETRIC KEY SecretKey;
SELECT MaPin FROM KHACH_HANG
SELECT CONVERT(NVARCHAR(MAX), DECRYPTBYKEY( CONVERT(VARBINARY(MAX), MaPin, 1))) AS GIAIMA FROM KHACH_HANG;
