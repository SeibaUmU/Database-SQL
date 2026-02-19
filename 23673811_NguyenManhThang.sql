/* Ho va ten: Nguyen Manh Thang
Lop: DHDTMT19B
MSSV: 23673811 */
--BT1--
CREATE DATABASE QLSach
ON PRIMARY
	(NAME = QLSach_data,
	FILENAME='D:\QLTV\QLSach_Data.mdf', 
	SIZE=20MB, MAXSIZE=40MB, FILEGROWTH=1MB)
LOG ON
	(NAME = QLSach_Log,
	FILENAME='D:\QLTV\QLSach_Log.ldf',
	SIZE=6MB, MAXSIZE=8MB, FILEGROWTH=1MB)

	alter database QLSach
		add filegroup DuLieuSach
	alter database QLSach
		add file (name= QlSach_Data2,
			filename='D:\QLTV\QlSach_Data2.ndf',
			size=1MB, maxsize=10MB) to filegroup DuLieuSach
	alter database QLSach
		set read_only
	alter database QLSach
		set read_write
	alter authorization on database::QLSach to sa

--BT2--
create database QLBH
on primary
	(name=QLBH_data1,
	filename='D:\QLBH_data1.mdf',
	size=10MB, maxsize=40MB, filegrowth=1MB)
log on
	(name=QLBH_Log,
	filename='D:\QLBH_Log.ldf',
	size=6MB, maxsize=8MB, filegrowth=1MB)

sp_helpdb QLBH
use QLBH
sp_spaceused
sp_helpfile

alter database QLBH
	add filegroup DuLieuQLBH
alter database QLBH
	add file (name=QLBH_data2,
		filename='D:\QLBH_data2.ndf',
		size=1MB, maxsize=10MB) to filegroup DuLieuQLBH
sp_helpfilegroup
alter database QLBH
	set read_only
sp_helpdb
alter database QLBH
	set read_write
alter database QLBH
	modify file (name = 'QLBH_data1', size=50MB)
alter database QLBH
	modify file (name = 'QLBH_Log', size=10MB)

--Bai3--
CREATE DATABASE QLSV;
go
use QLSV;
go
create table LOP(
	MaLop CHAR(5) PRIMARY KEY NOT NULL, TenLop NVARCHAR(20) NOT NULL, SiSoDuKien INT, NgayKhaiGiang DATETIME );
CREATE TABLE SINHVIEN ( MaSV CHAR(5) PRIMARY KEY NOT NULL, TenHo NVARCHAR(40) NOT NULL, NgaySinh DATETIME, MaLop CHAR(5) NOT NULL, FOREIGN KEY (MaLop) REFERENCES LOP(MaLop) );
CREATE TABLE MONHOC ( MaMH CHAR(5) PRIMARY KEY NOT NULL, Tenmh NVARCHAR(30) NOT NULL, SoTC INT );
CREATE TABLE KETQUA ( MaSV CHAR(5) NOT NULL, MaMH CHAR(5) NOT NULL, Diem REAL, PRIMARY KEY (MaSV, MaMH), FOREIGN KEY (MaSV) REFERENCES SINHVIEN(MaSV), FOREIGN KEY (MaMH) REFERENCES MONHOC(MaMH) );

--Bai4--
use QLBH;
exec sp_addtype SoDienThoai, 'char(13)', 'NULL';
exec sp_addtype Mavung, 'char(10)', 'NOT NULL';
exec sp_addtype STT, 'int','NOT NULL';
exec sp_addtype Shortstring, 'varchar(15)', 'NULL';

SELECT domain_name, data_type, character_maximum_length 
FROM information_schema.domains 
ORDER BY domain_name 

use QLBH
create table ThongTinKH (
	MaKH STT primary key,
	Vung MaVung,
	Diachi Shortstring,
	DienThoai SoDienThoai
)
DROP TYPE dbo.SoDienThoai









