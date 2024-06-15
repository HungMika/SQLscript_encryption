create database BMCSDL
use BMCSDL
create table BanCanSu(
MaSV varchar(20) primary key,
MatKhau varchar(max) not null,
Ten nvarchar(50),
ChucVu nvarchar(50)
)
go

create master key encryption by password = 'Sigm@44444'

create asymmetric key ASymKey 
with algorithm = RSA_2048
go

create symmetric key SymLaiKey 
with algorithm = AES_256
encryption by asymmetric key ASymKey
go

create trigger tr_BanCanSu on BanCanSu
instead of insert
as
begin
Open Symmetric Key SymLaiKey Decryption By Asymmetric key ASymKey
Insert into BanCanSu select MaSV, CONVERT(varchar(max), ENCRYPTBYKEY(KEY_GUID('SymLaiKey'), MatKhau), 1), Ten, ChucVu from inserted
Close Symmetric Key SymLaiKey
end

drop trigger tr_BanCanSu


insert into BanCanSu (MaSV, MatKhau, Ten, ChucVu) values (
'SIGMA01', 'Sigma1207', N'Trần Duy Quân', N'Captain'
)
insert into BanCanSu (MaSV, MatKhau, Ten, ChucVu) values (
'SIGMA02', 'Sigma2206', N'Đặng Quốc Hưng', N'Normal'
)
insert into BanCanSu (MaSV, MatKhau, Ten, ChucVu) values (
'SIGMA03', 'Sigma2206', N'Nguyễn Nguyên Khang', N'Normal'
)
insert into BanCanSu (MaSV, MatKhau, Ten, ChucVu) values (
'SIGMA04', 'Sigma1709', N'Phạm Thành Nhân',N'Normal'
)
insert into BanCanSu (MaSV, MatKhau, Ten, ChucVu) values (
'SIGMA05', 'Sigma2804',N'Nguyễn Mậu Thành Đạt', N'Normal'
)
go

create proc prc_DecryptPassBanCS(@Id varchar(20))
as
begin
Open Symmetric Key SymLaiKey Decryption By Asymmetric key ASymKey
select CONVERT(varchar(max), DECRYPTBYKEY(CONVERT(varbinary(max), MatKhau, 1))) from BanCanSu where MaSV = @Id
Close Symmetric Key SymLaiKey
end

exec prc_DecryptPassBanCS 'SIGMA05'

select * from BanCanSu

delete from BanCanSu
