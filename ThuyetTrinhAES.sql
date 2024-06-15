create database BMCSDL
use BMCSDL
go
create table NhanVien(
MaNV varchar(20) primary key,
MatKhau varchar(max) not null,
Ten nvarchar(50),
Luong int
)
go

create certificate AESCert
encryption by password = 'Sigm@44444'
with subject = 'Certificate for AES Algor'

create symmetric key SymKey 
with algorithm = AES_256
encryption by certificate AESCert
go

create trigger tr_NhanVien on NhanVien
instead of insert
as
begin
Open Symmetric Key SymKey Decryption By Certificate AESCert with password = 'Sigm@44444'
Insert into NhanVien select MaNV, CONVERT(varchar(max), ENCRYPTBYKEY(KEY_GUID('SymKey'), MatKhau), 1 ), Ten, Luong from inserted
Close Symmetric Key SymKey
end

insert into NhanVien (MaNV, MatKhau, Ten, Luong) values (
'SIGMA01', 'Sigma1207', N'Trần Duy Quân', 100000000
)
insert into NhanVien (MaNV, MatKhau, Ten, Luong) values (
'SIGMA02', 'Sigma2206', N'Đặng Quốc Hưng', 100000000
)
insert into NhanVien (MaNV, MatKhau, Ten, Luong) values (
'SIGMA03', 'Sigma2206', N'Nguyễn Nguyên Khang', 100000000
)
insert into NhanVien (MaNV, MatKhau, Ten, Luong) values (
'SIGMA04', 'Sigma1709', N'Phạm Thành Nhân', 100000000
)
insert into NhanVien (MaNV, MatKhau, Ten, Luong) values (
'SIGMA05', 'Sigma2804',N'Nguyễn Mậu Thành Đạt', 100000000
)
go

--create proc prc_Decrypt(@Id varchar(20),@passToMatch varchar(max))
--as
--begin
--Open Symmetric Key SymKey Decryption By Certificate AESCert with password = 'Sigm@44444'
--declare @Password varchar(max) = (select DECRYPTBYKEY(CONVERT(varbinary(max), MatKhau, 1)) from NhanVien where MaNV = @Id)
--Close Symmetric Key SymKey
--if(@passToMatch = @Password) print('Match')
--else print('Not match')
--end
--go

create proc prc_DecryptPass(@Id varchar(20))
as
begin
Open Symmetric Key SymKey Decryption By Certificate AESCert with password = 'Sigm@44444'
select CONVERT(varchar(max), DECRYPTBYKEY(CONVERT(varbinary(max), MatKhau, 1))) from NhanVien where MaNV = @Id
Close Symmetric Key SymKey
end

select Matkhau from NhanVien where MaNV = 'SIGMA04'
exec prc_DecryptPass 'SIGMA04'


select * from NhanVien

delete from NhanVien
