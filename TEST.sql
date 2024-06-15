create database test
use test
go

create table NV (
LUONG varbinary(max),
LUONG_ENCRYPTED VARBINARY(MAX),
PUBKEY varchar(max)
)
go

create asymmetric key PUBKEY
with algorithm = rsa_2048
encryption by password = '123';
go

drop table NV
insert into NV (LUONG,LUONG_ENCRYPTED, PUBKEY) values (CAST ('ABCDEF' AS varbinary(MAX)),0 , 'PUBPUB')
GO

UPDATE NV
SET LUONG_ENCRYPTED = ENCRYPTBYASYMKEY(ASYMKEY_ID('PUBKEY'), LUONG)
GO

SELECT DECRYPTBYASYMKEY(ASYMKEY_ID('PUBKEY'), LUONG_ENCRYPTED) FROM NV

select convert (varchar(max), LUONG) FROM NV
SELECT * FROM NV