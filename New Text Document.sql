--BÀI TẬP TUẦN 9
--INSERT, UPDATE, DELETE DỮ LIỆU TRONG BẢNG

/*BÀI TẬP 1: INSERT dữ liệu
CÚ PHÁP
INSERT INTO TEN_BANG_A [(cot1, cot2, ... cot)]
SELECT cot1, cot2, ...cotN
FROM TEN_BANG_B
[WHERE DIEU_KIEN];
*/

--a. Insert  dữ liệu vào bảng KhachHang trong QLBH  với dữ liệu nguồn là 
--bảng Customers trong NorthWind.

insert into QLBH.dbo.KhachHang (MaKh,TenKh)
select CustomerID, ContactName
from Northwind.dbo.Customers

select * from QLBH.dbo.KhachHang

/*
BÀI TẬP 2: LỆNH UPDATE
Cú pháp:  

UPDATE <table_name> 
SET <column_name> = value , [, …]
FROM <table_name> [, …]
WHERE <condition> 
*/

-- 1.  Cập nhật chiết khấu 0.1  cho  các  mặt hàng  trong các hóa đơn  xuất  bán 
-- vào ngày ‘1/1/1997’ 

update [Order Details]
set Discount = 0
from Orders o join [Order Details] od
on o.OrderID = od.OrderID
where OrderDate = '1-1-1997'


select *
from Orders o join [Order Details] od
on o.OrderID = od.OrderID
where OrderDate = '1-1-1997'


/*BÀI TẬP 3: LỆNH DELETE
Cú pháp:   
DELETE FROM <table_name> 
WHERE <condition> 

Cú pháp:
DELETE FROM <table_name> 
FROM <table_name> [, …]
WHERE <condition>
*/

--ví dụ
delete from QLBH.dbo.KhachHang
where LoaiKh is null

select * from QLBH.dbo.KhachHang

--1.  Xóa các dòng trong [Order Details]  có ProductID  24, là “chi tiết của 
--hóa đơn” xuất bán cho khách hàng có mã ‘SANTG’

delete from [Order Details]
from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 24 and CustomerID = 'SANTG'

--để check
select * from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 24 and CustomerID = 'SANTG'
