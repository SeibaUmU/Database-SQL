/* Ho va ten: Nguyen Manh Thang
Lop: DHDTMT19B
MSSV: 23673811 */

use master
go

create database QLBH
on primary (
	name = QLBH_Data,
	filename='D:\Code\HCSDL\BTSQL\QLBH_Data.mdf',
	size=10mb, maxsize = 100mb, filegrowth=20%)
log on (
	name=QLBH_Log,
	filename='D:\Code\HCSDL\BTSQL\QLBH_Log.ldf',
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

alter table NhomSanPham
alter column TenNhom nvarchar(50)


insert into NhomSanPham (MaNhom, TenNhom)
values 
	(1, N'Điện Tử'),
	(2, N'Gia Dụng'),
	(3, N'Dụng Cụ Gia Đình'),
	(4, N'Các Mặt Hàng Khác');
select * from NhomSanPham

insert into NhaCungCap (MaNCC, TenNCC, Diachi, Phone, SoFax, DCMail)
values
	(1, N'Công ty TNHH Nam Phương', N'1 Lê Lợi Phường 4 Quận Gò Vấp', 083843456, 32343434, N'NamPhuong@yahoo.com'),
	(2, N'Công ty Lan Ngọc', N'12 Cao Bá Quát Quận 1 Tp.Hồ Chí Minh', 086234567, 83434355, N'LanNgoc@gmail.com');
select * from NhaCungCap

insert into SanPham (MaSP, TenSP, Donvitinh, GiaGoc, SLTON, MaNhom, MaNCC, MoTa)
values
	(1, N'Máy Tính', N'Cái', 7000.0000, 100, 1, 1, N'Máy Sony Ram 2GB'),
	(2, N'Bàn Phím', N'Cái', 1000.0000, 50, 1, 1, N'Bàn phím 101 phím'),
	(3, N'Chuột', N'Cái', 800.0000, 150, 1, 1, N'Chuột không dây'),
	(4, N'CPU', N'Cái', 3000.0000, 200, 1, 1, N'CPU'),
	(5, N'USB', N'Cái', 500.0000, 100, 1, 1, N'8GB'),
	(6, N'Lò Vi Sóng', N'Cái', 1000000.0000, 20, 3, 2, null);
select * from SanPham

alter table KhachHang
add SoFax int null
insert into KhachHang (MaKH, TenKh, DiaChi, Phone, LoaiKH, SoFax, DCMail, DiemTL)
values 
	('KH1', N'Nguyễn Thu Hằng', N'12 Nguyễn Du', null, 'VL', null, null, null),
	('KH2', N'Lê Minh', N'34 Điện Biên Phủ', 0123943455, 'TV', null, N'LeMinh@yahoo.com', 100),
	('KH3', N'Nguyễn Minh Trung', N'3 Lê Lợi Quận Gò Vấp', 098343434, 'VIP', null, N'Trung@gmai.com', 800);
select * from KhachHang

insert into HoaDon (MaHD, NgayLapHD, MaKH, NgayGiao, Noichuyen)
values
	(1, '2025-03-09 00:00:00:000', 'KH1', '2025-10-05 00:00:00:000', N'Cửa Hàng ABC 3 Lý Chính Thắng Quận 3'),
	(2, '2025-03-09 00:00:00:000', 'KH2', '2025-08-10 00:00:00:000', N'23 Lê Lợi Quận Gò Vấp'),
	(3, '2025-03-09 00:00:00:000', 'KH3', '2025-10-01 00:00:00:000', N'2 Nguyễn Du Quận Gò Vấp');
select * from HoaDon

insert into CT_HoaDon (MaHD, MaSP, Dongia, Soluong)
values
	(1, 1, 8000.0000, 5),
	(1, 2, 1200.0000, 4),
	(1, 3, 1000.0000, 15),
	(2, 2, 1200.0000, 9),
	(2, 4, 800.0000, 5),
	(3, 2, 3500.0000, 20),
	(3, 3, 1000.0000, 15);
select * from CT_HoaDon

update SanPham
set GiaGoc = GiaGoc * 1.05 where MaSP = 2;
select * from SanPham

update SanPham
set SLTON = 100 where MaNhom = 3 and MaNCC = 2;
select * from SanPham

update SanPham
set MoTa = 'PhoneWave (name subject to change)' where TenSP = N'Lò Vi Sóng';
select * from SanPham

UPDATE Hoadon
SET MaKH = NULL
WHERE MaKH = 'KH3';
update KhachHang
set MaKH = 'VI003' where MaKH = 'KH3';
select * from KhachHang

ALTER TABLE HoaDon
DROP CONSTRAINT MaKH_FK;

ALTER TABLE HoaDon
ADD CONSTRAINT MaKH_FK
FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
ON UPDATE CASCADE;

update KhachHang
set MaKH = 'VL001' where MaKH = 'KH1';
update KhachHang
set MaKH = 'T0002' where MaKH = 'KH2';
select * from KhachHang
select * from HoaDon

delete from NhomSanPham where MaNhom = '4';
select * from NhomSanPham

delete from CT_HoaDon where MaHD = '1' and MaSP = '3';
select * from CT_HoaDon

DELETE FROM CT_HoaDon
WHERE MaHD = '1';
select * from CT_HoaDon

delete from HoaDon where MaHD = '1';
select * from HoaDon

ALTER TABLE CT_HoaDon
DROP CONSTRAINT FK__CT_HoaDon__MaHD__45F365D3;

ALTER TABLE CT_HoaDon
ADD CONSTRAINT FK__CT_HoaDon__MaHD__45F365D3
FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
ON DELETE CASCADE;

delete from HoaDon where MaHD = '2';
select * from HoaDon



