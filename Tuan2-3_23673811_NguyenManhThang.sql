/* Ho va ten: Nguyen Manh Thang
Lop: DHDTMT19B
MSSV: 23673811 */


use master
go

--BAITAP1

create database QLBH
on primary (
	name = QLBH_Data,
	filename='T:\BTSQL\QLBH_Data.mdf',
	size=10mb, maxsize = 100mb, filegrowth=20%)
log on (
	name=QLBH_Log,
	filename='T:\BTSQL\QLBH_Log.ldf',
	size=10mb,maxsize=50mb,filegrowth=1mb)

use QLBH
go

create table NhomSanPham (
	MaNhom int not null primary key,
	TenNhom nvarchar(15) );
go

create table NhaCungCap (
	MaNCC int not null primary key,
	TenNCC nvarchar(40) not null,
	Diachi nvarchar(60),
	Phone nvarchar(24),
	SoFax nvarchar(24),
	DCMail nvarchar(50) );
go

create table SanPham (
	MaSP int not null primary key,
	TenSP nvarchar(40) not null,
	MaNCC int,
	foreign key (MaNCC) references NhaCungCap(MaNCC),
	MoTa nvarchar(50),
	MaNhom int,
	foreign key (MaNhom) references NhomSanPham(MaNhom),
	Donvitinh nvarchar(20), 
	GiaGoc money check (GiaGoc > 0),
	SLTON int check (SLTON >= 0) );
go

create table HoaDon (
	MaHD int not null primary key,
	NgayLapHD datetime default getdate() check(NgayLapHD >= getdate()),
	NgayGiao datetime,
	Noichuyen nvarchar(60) not null,
	MaKH char(5) );
go

create table CT_HoaDon (
	MaHD int not null,
	MaSP int not null,
	Soluong smallint check (Soluong > 0),
	Dongia money,
	ChietKhau money check (ChietKhau >=0), 
	primary key(MaHD, MaSP),
	foreign key (MaHD) references HoaDon(MaHD),
	foreign key (MaSP) references SanPham(MaSP) );
go

create table KhachHang (
	MaKH char (5) not null primary key,
	TenKh nvarchar(40) not null,
	LoaiKH nvarchar(3),
	constraint chk_LoaiKH check (LoaiKH in ('VIP','TV','VL')), 
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	DCMail nvarchar(50),
	DiemTL int check (DiemTL >= 0) );
go

alter table HoaDon add LoaiHD char(1) default 'N' check (LoaiHD in ('N','X','C','T'));
go

alter table HoaDon with check
add constraint MaKH_FK foreign key (MaKH) references KhachHang(MaKH);
go

alter table HoaDon
add constraint NgayGiao check (NgayGiao >= NgayLapHD);
go

ALTER AUTHORIZATION ON DATABASE::QLBH TO sa;


--BAITAP2

use master
go

create database Movies
on primary (
	name = Movies_Data,
	filename='D:\Code\HCSDL\BTSQL\Movies_data.mdf',
	size=25mb, maxsize = 40mb, filegrowth=1mb)
log on (
	name=Movies_Log,
	filename='D:\Code\HCSDL\BTSQL\Movies_log.ldf',
	size=6mb,maxsize=8mb,filegrowth=1mb)

ALTER DATABASE Movies
ADD File (Name = Movies_data2,
Filename ='D:\Code\HCSDL\Movies_data2.ndf',
SIZE =10 MB);


USE master;
ALTER DATABASE Movies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
use Movies
go

alter database Movies
set single_user;
SELECT name, state_desc FROM sys.databases WHERE name = 'Movies';

alter database Movies
set restricted_user;
SELECT name, state_desc FROM sys.databases WHERE name = 'Movies';

alter database Movies
set multi_user;
SELECT name, state_desc FROM sys.databases WHERE name = 'Movies';

ALTER DATABASE Movies
MODIFY FILE (NAME = 'Movies_data2', size =15MB);
EXEC sp_helpfile;

alter database Movies
set auto_shrink on;

USE master;
ALTER DATABASE Movies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Movies;

--after created Movies database again in script file --
use Movies;
EXEC sp_addtype Movie_num, 'int', 'NOT NULL';
EXEC sp_addtype Category_num, 'int', 'NOT NULL';
EXEC sp_addtype Cust_num, 'int', 'NOT NULL';
EXEC sp_addtype Invoice_num, 'int', 'NOT NULL';

use Movies
go

create table Customer (
	Cust_num int identity(300,1) not null,
	Lname varchar(20) not null,
	Fname varchar(20) not null,
	Address1 varchar(30) null,
	Address2 varchar(20) null,
	City varchar(20) null,
	Statee char(2) null,
	Zip char(10) null,
	Phone varchar(10) not null,
	Join_date smalldatetime not null );

create table Category (
	Category_num int identity(1,1) not null,
	Descriptionn varchar(20) not null );

create table Movie (
	Movie_num int not null,
	Title nvarchar(100) not null,
	Category_num int not null,
	Date_purch smalldatetime null,
	Rental_price int null,
	Rating char(5) null );

create table Rental (
	Invoice_num int not null,
	Cust_num int not null,
	Rental_date smalldatetime not null,
	Due_date smalldatetime not null );

create table Rental_Detail (
	Invoice_num int not null,
	Line_num int not null,
	Movie_num int not null,
	Rental_price smallmoney not null);

sp_help 'Customer';
sp_help 'Category';
sp_help 'Movie';
sp_help 'Rental';
sp_help 'Rental_Detail';

alter table Movie
add constraint PK_movie primary key (Movie_num);
go

alter table Customer
add constraint PK_customer primary key (Cust_num);
go

alter table Category
add constraint PK_category primary key (Category_num);
go

alter table Rental
add constraint PK_rental primary key (Invoice_num);
go

sp_helpconstraint 'Movie';
sp_helpconstraint 'Customer';
sp_helpconstraint 'Category';
sp_helpconstraint 'Rental';

alter table Movie with check
add constraint FK_movie foreign key (Category_num) references Category(Category_num);
go

alter table Rental with check
add constraint FK_rental foreign key (Cust_num) references Customer(Cust_num);
go

alter table Rental_detail
add constraint FK_detail_invoice foreign key (Invoice_num) references Rental(Invoice_num)
on delete cascade;
go

alter table Rental_detail
add constraint FK_detail_movie foreign key (Movie_num) references Movie(Movie_num);
go

sp_helpconstraint 'Movie';
sp_helpconstraint 'Rental';
sp_helpconstraint 'Rental_detail';

alter table Movie
add constraint DK_movie_date_purch default getdate() for Date_purch;

alter table Customer
add constraint DK_customer_join_date default getdate() for join_date ;

alter table Rental
add constraint DK_rental_rental_date default getdate() for Rental_date;

alter table Rental
add constraint DK_rental_due_date default dateadd(day, 2, getdate()) for Due_date;

EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Customer';
EXEC sp_helpconstraint 'Rental';

alter table Movie
add constraint CK_movie check (Rating in ('G', 'PG', 'R', 'NC17', 'NR'));

alter table Rental
add constraint CK_Due_date check (Due_date >= Rental_date);

EXEC sp_helpconstraint 'Movie';
EXEC sp_helpconstraint 'Rental';

--Bai Tap 3--

use master
go

create database QlDuAn
on primary (
	name = QlDuAn,
	filename='D:\Code\HCSDL\BTSQL\QlDuAn_data.mdf',
	size=25mb, maxsize = 40mb, filegrowth=1mb)
log on (
	name=Movies_Log,
	filename='D:\Code\HCSDL\BTSQL\QlDuAn_log.ldf',
	size=6mb,maxsize=8mb,filegrowth=1mb)

use QlDuAn
go
use master
go
drop database QlDuAn

create table CongViec (
	MaCV int not null primary key,
	TenCV nvarchar(60) );

create table DuAn (
	MaDA int not null primary key,
	TenDA nvarchar(80) );

create table NhanVien (
	MaNV int not null primary key,
	Hoten nvarchar(50),
	Phai nvarchar(10),
	Ngaysinh date,
	MaPB int not null,
	NhomTruong int references Nhanvien(MaNV) );

create table Phongban (
	MaPB int not null primary key,
	TenPB nvarchar(100),
	MaTruongPhong int REFERENCES Nhanvien(MaNV) );

alter table NhanVien with check
add constraint MaPB_FK foreign key (MaPB) references Phongban(MaPB);

create table Nhanvien_duan (
	MaDA int not null,
	MaNV int not null,
	MaCV int not null,
	Thoigian datetime,
	primary key(MaDA, MaNV, MaCV),
	foreign key (MaDA) references DuAn(MaDA),
	foreign key (MaCV) references CongViec(MaCV),
	foreign key (MaNV) references NhanVien(MaNV) );


INSERT INTO Phongban (MaPB, TenPB, MaTruongPhong)
VALUES (1, N'Triển khai & bảo trì', NULL);


INSERT INTO NhanVien (MaNV, Hoten, Phai, Ngaysinh, MaPB, NhomTruong)
VALUES (1, N'Nguyễn Năm', N'Nam', '1960-01-01', 1, NULL);


UPDATE Phongban SET MaTruongPhong = 1 WHERE MaPB = 1;


INSERT INTO NhanVien (MaNV, Hoten, Phai, Ngaysinh, MaPB, NhomTruong)
VALUES 
(2, N'An', N'Nam', '1980-01-01', 1, 2), -- Nhóm trưởng nhóm 1
(3, N'Minh', N'Nam', '1982-01-01', 1, 2),
(4, N'Tuấn', N'Nam', '1984-01-01', 1, 2),
(5, N'Lan', N'Nữ', '1985-01-01', 1, 5), -- Nhóm trưởng nhóm 2
(6, N'Hùng', N'Nam', '1986-01-01', 1, 5),
(7, N'Vân', N'Nữ', '1987-01-01', 1, 5),
(8, N'Mai', N'Nữ', '1988-01-01', 1, 8), -- Nhóm trưởng nhóm 3
(9, N'Hà', N'Nam', '1989-01-01', 1, 8),
(10, N'Việt', N'Nam', '1990-01-01', 1, 8);

INSERT INTO DuAn (MaDA, TenDA)
VALUES 
(1, N'Alpha B1 SAP'),
(2, N'Delta B1 SAP');

INSERT INTO CongViec (MaCV, TenCV)
VALUES 
(1, N'Triển khai vòng 1'),
(2, N'Triển khai tổng thể');

INSERT INTO Nhanvien_duan (MaDA, MaNV, MaCV, Thoigian)
VALUES 
(1, 2, 1, '2023-03-01'), -- An tham gia dự án Alpha B1 SAP
(2, 2, 2, '2023-03-01'); -- An tham gia dự án Delta B1 SAP

SELECT * FROM NhanVien;
SELECT * FROM Phongban;
SELECT * FROM Nhanvien_duan;
SELECT * FROM DuAn;
SELECT * FROM CongViec;