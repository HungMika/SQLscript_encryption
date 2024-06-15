create database BMCSDL
use BMCSDL
create table SinhVien(
MaSV varchar(20) primary key,
MatKhau varchar(max) not null,
Ten nvarchar(50),
)
go

create master key encryption by password = 'Sigm@44444'

create asymmetric key ASymKey
with algorithm = RSA_2048
go

create trigger tr_SinhVien on SinhVien
instead of insert
as
begin
Insert into SinhVien select MaSV, CONVERT(varchar(max), ENCRYPTBYASYMKEY(ASYMKEY_ID('ASymKey'), MatKhau), 1), Ten from inserted
end

insert into SinhVien (MaSV, MatKhau, Ten) values (
'SIGMA01', 'Sigma1207', N'Trần Duy Quân'
)
insert into SinhVien (MaSV, MatKhau, Ten) values (
'SIGMA02', 'Sigma2206', N'Đặng Quốc Hưng'
)
insert into SinhVien (MaSV, MatKhau, Ten) values (
'SIGMA03', 'Sigma2206', N'Nguyễn Nguyên Khang'
)
insert into SinhVien (MaSV, MatKhau, Ten) values (
'SIGMA04', 'Sigma1709', N'Phạm Thành Nhân'
)
insert into SinhVien (MaSV, MatKhau, Ten) values (
'SIGMA05', 'Sigma2804',N'Nguyễn Mậu Thành Đạt'
)
go

--create proc prc_SV(@Id varchar(20), @passToMatch varchar(max))
--as
--begin
--declare @Password varchar(max) = (select CONVERT(varchar(max), DECRYPTBYASYMKEY(ASYMKEY_ID('ASymKey'), CONVERT(varbinary(max), MatKhau, 1))) from SinhVien where MaSV = @Id)
--if(@passToMatch = @Password) print('Match')
--else print('Not match')
--end

create proc prc_DecryptPassSV(@Id varchar(20))
as
begin
select CONVERT(varchar(max), DECRYPTBYASYMKEY(ASYMKEY_ID('ASymKey'), CONVERT(varbinary(max), MatKhau, 1))) from SinhVien where MaSV = @Id
end

exec prc_DecryptPassSV 'SIGMA04'


select * from SinhVien

delete from SinhVien
