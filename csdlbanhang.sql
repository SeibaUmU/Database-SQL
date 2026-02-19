---------------------------------------------------------
--Sửa ổ đĩa lưu CSDL là D:, T:, ... trước khi chạy script
---------------------------------------------------------

USE [master]
GO
/****** Object:  Database [QLBH]    Script Date: 03/27/2017 06:39:22 ******/
CREATE DATABASE [QLBH] ON  PRIMARY 
( NAME = N'QLBH_Data', FILENAME = N'D:\QLBH_Data.mdf' , SIZE = 10240KB , MAXSIZE = 40960KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLBH_Log', FILENAME = N'D:\QLBH_Log.ldf' , SIZE = 6144KB , MAXSIZE = 8192KB , FILEGROWTH = 1024KB )
GO
ALTER DATABASE [QLBH] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLBH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLBH] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [QLBH] SET ANSI_NULLS OFF
GO
ALTER DATABASE [QLBH] SET ANSI_PADDING OFF
GO
ALTER DATABASE [QLBH] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [QLBH] SET ARITHABORT OFF
GO
ALTER DATABASE [QLBH] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [QLBH] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [QLBH] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [QLBH] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [QLBH] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [QLBH] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [QLBH] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [QLBH] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [QLBH] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [QLBH] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [QLBH] SET  ENABLE_BROKER
GO
ALTER DATABASE [QLBH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [QLBH] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [QLBH] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [QLBH] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [QLBH] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [QLBH] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [QLBH] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [QLBH] SET  READ_WRITE
GO
ALTER DATABASE [QLBH] SET RECOVERY FULL
GO
ALTER DATABASE [QLBH] SET  MULTI_USER
GO
ALTER DATABASE [QLBH] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [QLBH] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'QLBH', N'ON'
GO
USE [QLBH]
GO
/****** Object:  Table [dbo].[NhomHang]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhomHang](
	[MaNhom] [char](5) NOT NULL,
	[TenNhom] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNhom] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[NhomHang] ([MaNhom], [TenNhom]) VALUES (N'1    ', N'Điện tử')
INSERT [dbo].[NhomHang] ([MaNhom], [TenNhom]) VALUES (N'2    ', N'Gia dụng')
INSERT [dbo].[NhomHang] ([MaNhom], [TenNhom]) VALUES (N'3    ', N'Dụng cụ gia đình')
INSERT [dbo].[NhomHang] ([MaNhom], [TenNhom]) VALUES (N'4    ', N'Các mặt hàng khác')
/****** Object:  Table [dbo].[NhaCungCap]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhaCungCap](
	[MaNCC] [int] NOT NULL,
	[TenNCC] [nvarchar](50) NOT NULL,
	[DiaChi] [nvarchar](50) NULL,
	[Phone] [varchar](24) NULL,
	[SoFax] [varchar](24) NULL,
	[DCMail] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [Phone], [SoFax], [DCMail]) VALUES (1, N'Công ty TNHH Nam Phương', N'1 Lê Lợi, P4, Gò vấp', N'08123456', N'08123457', N'NamPhuong@yahoo.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [Phone], [SoFax], [DCMail]) VALUES (2, N'Công ty Lan Ngọc', N'12, Cao Bá Quát, Q1', N'08563456', N'08563457', N'LanNgoc@yahoo.com')
/****** Object:  Table [dbo].[KhachHang]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKh] [char](5) NOT NULL,
	[TenKh] [nvarchar](50) NOT NULL,
	[LoaiKh] [nvarchar](3) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[Phone] [varchar](24) NULL,
	[SoFax] [varchar](24) NULL,
	[DcMail] [varchar](50) NULL,
	[DiemTL] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKh] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[KhachHang] ([MaKh], [TenKh], [LoaiKh], [DiaChi], [Phone], [SoFax], [DcMail], [DiemTL]) VALUES (N'KH1  ', N'Nguyễn Thu Hằng', N'VL', N'12 Nguyễn Du', NULL, NULL, NULL, NULL)
INSERT [dbo].[KhachHang] ([MaKh], [TenKh], [LoaiKh], [DiaChi], [Phone], [SoFax], [DcMail], [DiemTL]) VALUES (N'KH2  ', N'Lê Minh', N'TV', N'34 Điện Biên Phủ', N'123456789', NULL, N'Leminh@yahoo.com', 100)
INSERT [dbo].[KhachHang] ([MaKh], [TenKh], [LoaiKh], [DiaChi], [Phone], [SoFax], [DcMail], [DiemTL]) VALUES (N'KH3  ', N'Nguyễn Minh Trung', N'VIP', N'3 Lê Lợi, Gò vấp', N'098343434', NULL, N'Trung@yahoo.com', 800)
/****** Object:  Table [dbo].[SanPham]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SanPham](
	[MaSp] [int] NOT NULL,
	[TenSp] [nvarchar](50) NOT NULL,
	[MaNCC] [int] NULL,
	[MoTa] [nvarchar](50) NULL,
	[MaNhom] [char](5) NULL,
	[ĐonViTinh] [nvarchar](20) NULL,
	[GiaGoc] [money] NULL,
	[SLTon] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (1, N'Máy tính', 1, N'Máy Sony Ram 2MB', N'1    ', N'cái', 7000.0000, 100)
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (2, N'Bàn phím', 1, N'Bàn phím 101 phím', N'1    ', N'cái', 1000.0000, 50)
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (3, N'Chuột', 1, N'Chuột không dây', N'1    ', N'cái', 800.0000, 150)
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (4, N'CPU', 1, N'CPU', N'1    ', N'cái', 3000.0000, 200)
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (5, N'USB', 1, N'8GB', N'1    ', N'cái', 500.0000, 100)
INSERT [dbo].[SanPham] ([MaSp], [TenSp], [MaNCC], [MoTa], [MaNhom], [ĐonViTinh], [GiaGoc], [SLTon]) VALUES (6, N'Lò vi sóng', 2, NULL, N'3    ', N'cái', 1000000.0000, 20)
/****** Object:  Table [dbo].[HoaDon]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHD] [int] NOT NULL,
	[NgayLapHD] [datetime] NULL,
	[NgayGiao] [datetime] NULL,
	[NoiChuyen] [nvarchar](50) NOT NULL,
	[MaKh] [char](5) NULL,
	[LoaiHD] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiao], [NoiChuyen], [MaKh], [LoaiHD]) VALUES (1, CAST(0x0000A7FE00000000 AS DateTime), CAST(0x0000A80300000000 AS DateTime), N'Cửa hàng ABC, 15 Lý Chính Thắng Q3', N'KH1  ', N'N')
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiao], [NoiChuyen], [MaKh], [LoaiHD]) VALUES (2, CAST(0x0000A7BF00000000 AS DateTime), CAST(0x0000A7CB00000000 AS DateTime), N'23 Lê Lợi, Gò vấp', N'KH2  ', N'N')
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiao], [NoiChuyen], [MaKh], [LoaiHD]) VALUES (3, CAST(0x0000A7FF00000000 AS DateTime), CAST(0x0000A80000000000 AS DateTime), N'2 Nguyễn Du, Gò vấp', N'KH3  ', N'N')
/****** Object:  Table [dbo].[CT_HoaDon]    Script Date: 03/27/2017 06:39:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_HoaDon](
	[MaHD] [int] NOT NULL,
	[MaSp] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [money] NULL,
	[ChietKhau] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaSp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (1, 1, 5, 8000.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (1, 2, 4, 1200.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (1, 3, 15, 1000.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (2, 2, 9, 1200.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (2, 4, 5, 800.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (3, 2, 20, 3500.0000, NULL)
INSERT [dbo].[CT_HoaDon] ([MaHD], [MaSp], [SoLuong], [DonGia], [ChietKhau]) VALUES (3, 3, 15, 1000.0000, NULL)
/****** Object:  Default [DF__HoaDon__NgayLapH__164452B1]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT (getdate()) FOR [NgayLapHD]
GO
/****** Object:  Default [DF__HoaDon__LoaiHD__173876EA]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ('N') FOR [LoaiHD]
GO
/****** Object:  Check [CK__KhachHang__DiemT__09DE7BCC]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD CHECK  (([DiemTL]>=(0)))
GO
/****** Object:  Check [CK__KhachHang__LoaiK__08EA5793]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD CHECK  (([LoaiKH]='VL' OR [LoaiKH]='TV' OR [LoaiKH]='VIP'))
GO
/****** Object:  Check [CK__SanPham__GiaGoc__108B795B]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD CHECK  (([GiaGoc]>(0)))
GO
/****** Object:  Check [CK__SanPham__SLTon__117F9D94]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD CHECK  (([SLTon]>(0)))
GO
/****** Object:  Check [CK__HoaDon__1B0907CE]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD CHECK  (([NgayGiao]>=[NgayLapHD]))
GO
/****** Object:  Check [CK__HoaDon__LoaiHD__1A14E395]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD CHECK  (([LoaiHD]='T' OR [LoaiHD]='C' OR [LoaiHD]='X' OR [LoaiHD]='N'))
GO
/****** Object:  Check [CK__HoaDon__NgayLapH__1920BF5C]    Script Date: 03/27/2017 06:39:22 ******/
--ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD CHECK  (([NgayLapHD]>=getdate()))
--GO
/****** Object:  Check [CK__CT_HoaDon__Chiet__22AA2996]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[CT_HoaDon]  WITH CHECK ADD CHECK  (([ChietKhau]>=(0)))
GO
/****** Object:  Check [CK__CT_HoaDon__SoLuo__21B6055D]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[CT_HoaDon]  WITH CHECK ADD CHECK  (([SoLuong]>(0)))
GO
/****** Object:  ForeignKey [FK__SanPham__MaNCC__0EA330E9]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD FOREIGN KEY([MaNCC])
REFERENCES [dbo].[NhaCungCap] ([MaNCC])
GO
/****** Object:  ForeignKey [FK__SanPham__MaNhom__0F975522]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD FOREIGN KEY([MaNhom])
REFERENCES [dbo].[NhomHang] ([MaNhom])
GO
/****** Object:  ForeignKey [FK__HoaDon__MaKh__182C9B23]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([MaKh])
REFERENCES [dbo].[KhachHang] ([MaKh])
GO
/****** Object:  ForeignKey [FK__CT_HoaDon__MaHD__20C1E124]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[CT_HoaDon]  WITH CHECK ADD FOREIGN KEY([MaHD])
REFERENCES [dbo].[HoaDon] ([MaHD])
GO
/****** Object:  ForeignKey [FK__CT_HoaDon__MaSp__1FCDBCEB]    Script Date: 03/27/2017 06:39:22 ******/
ALTER TABLE [dbo].[CT_HoaDon]  WITH CHECK ADD FOREIGN KEY([MaSp])
REFERENCES [dbo].[SanPham] ([MaSp])
GO