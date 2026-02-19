/*BT TUAN 8 - 9
Họ và tên: Nguyễn Mạnh Thắng
MSSV: 23673811 */

use Northwind
go

--TUAN 8--
--BÀI TẬP 4: LỆNH select – TRUY VẤN LỒNG NHAU --
/*
1. Liệt kê các product có đơn giá mua lớn hơn đơn giá mua trung bình của
tất cả các product.*/

select * from Products
where unitprice > (select avg(unitprice) from products)

/*
2. Liệt kê các product có đơn giá mua lớn hơn đơn giá mua nhỏ nhất của tất
cả các product.*/

select * from Products
where unitprice > (select min(unitprice) from products)

/*
3. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
các product. Thông tin gồm ProductID, ProductName, OrderID,
Orderdate, Unitprice .*/

select p.ProductID, ProductName, o.OrderID, o.Orderdate, od.Unitprice 
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID 
where od.unitprice > (select avg(unitprice) from [Order Details])


/*
4. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
các product có ProductName bắt đầu là ‘N’.*/

select p.ProductID, ProductName, od.UnitPrice
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
where od.unitprice > (select avg(od.UnitPrice) from [Order Details] od join Products p on p.ProductID = od.ProductID where ProductName like 'N%')
order by od.UnitPrice

/*
5. Cho biết những sản phẩm có tên bắt đầu bằng ‘T’ và có đơn giá bán lớn
hơn đơn giá bán của (tất cả) những sản phẩm có tên bắt đầu bằng chữ
‘V’.*/

select p.ProductID, ProductName, od.UnitPrice
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
where ProductName like 'T%' and od.UnitPrice >all (select (od.UnitPrice) from [Order Details] od join Products p on p.ProductID = od.ProductID where ProductName like 'V%')

/*
6. Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm
có đơn vị tính có chứa chữ ‘box’ .*/

select top 1 p.ProductID, ProductName, od.UnitPrice
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
where od.UnitPrice = (select max(od.unitprice) from [Order Details] od join Products p on p.ProductID = od.ProductID where QuantityPerUnit like '%box%')

/*
7. Liệt kê các product có tổng số lượng bán (Quantity) trong năm 1998 lớn
hơn tổng số lượng bán trong năm 1998 của mặt hàng có mã 71*/

select ProductID
from [Order Details] od join Orders o on od.OrderID = o.OrderID
where year(OrderDate) = 1998
group by ProductID
having sum(Quantity) > (
	select sum(Quantity) from [Order Details] od join Orders o on od.OrderID = o.OrderID
	where year(OrderDate) = 1998 and ProductID = 71);

/*
8. Thực hiện :
- Thống kê tổng số lượng bán của mỗi mặt hàng thuộc nhóm hàng 
4. Thông tin : ProductID, QuantityTotal (tập A) */

select p.ProductID, ProductName, sum(Quantity) as QuantityTotal
from [Order Details] od join Products p on od.ProductID = p.ProductID
where p.CategoryID = 4
group by p.ProductID, ProductName;


/*- Thống kê tổng số lượng bán của mỗi mặt hàng thuộc nhóm hàng
khác 4 . Thông tin : ProductID, QuantityTotal (tập B)*/

select p.ProductID, ProductName, sum(Quantity) as QuantityTotal
from [Order Details] od join Products p on od.ProductID = p.ProductID
where p.CategoryID <> 4
group by p.ProductID, ProductName;

/*- Dựa vào 2 truy vấn trên : Liệt kê danh sách các mặt hàng trong
tập A có QuantityTotal lớn hơn tất cả QuantityTotal của tập B*/

select ProductID, ProductName, QuantityTotal
from (
    select p.ProductID, ProductName, sum(Quantity) as QuantityTotal
    from [Order Details] od
    join Products p on od.ProductID = p.ProductID
    where p.CategoryID = 4
    group by p.ProductID, ProductName
) as TapA
where QuantityTotal > ALL (
    select sum(Quantity)
    from [Order Details] od
    join Products p on od.ProductID = p.ProductID
    where p.CategoryID <> 4
    group by p.ProductID
);


/*
9. Danh sách các Product có tổng số lượng bán được lớn nhất trong năm
1998
Lưu ý : Có nhiều phương án thực hiện các truy vấn sau (dùng join hoặc
subquery ). Hãy đưa ra phương án sử dụng subquery.*/
      
select od.ProductID, sum(od.Quantity) as QuantityTotal
from [Order Details] od
where od.OrderID IN (
    select o.OrderID
    from Orders o
    where year(o.OrderDate) = 1998
)
group by od.ProductID
having sum(od.Quantity) in (
    select TOP 10 sum(od.Quantity) as TotalQuantity
    from [Order Details] od
    where od.OrderID IN (
        select o.OrderID
        from Orders o
        where year(o.OrderDate) = 1998
    )
    group by od.ProductID
    order by TotalQuantity desc
 )
 order by QuantityTotal desc


/*
10. Danh sách các products đã có khách hàng mua hàng (tức là ProductID có
trong [Order Details]). Thông tin bao gồm ProductID, ProductName,
Unitprice*/

select ProductID, ProductName, UnitPrice
from Products
where ProductID IN (
    select ProductID
    from [Order Details]
);


/*
11. Danh sách các hóa đơn của những khách hàng ở thành phố LonDon và
Madrid.*/

select OrderID, OrderDate, CustomerID
from Orders
where CustomerID IN (
    select CustomerID
    from Customers
    where City IN ('London', 'Madrid')
);

/*12.Liệt kê các sản phẩm có trên 20 đơn hàng trong quí 3 năm 1998, thông
tin gồm ProductID, ProductName.*/

select p.ProductID, p.ProductName
from [Order Details] od
join Products p on od.ProductID = p.ProductID
where od.OrderID IN (
    select o.OrderID
    from Orders o
    where year(o.OrderDate) = 1998
      and month(o.OrderDate) BETWEEN 7 and 9
)
group by p.ProductID, p.ProductName
having COUNT(od.OrderID) > 20;


--13.Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996

select p.ProductID, p.ProductName
from Products p
where p.ProductID NOT IN (
    select od.ProductID
    from [Order Details] od
    join Orders o on od.OrderID = o.OrderID
    where year(o.OrderDate) = 1996 and month(o.OrderDate) = 6
); 

--14.Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay

select EmployeeID, concat(LastName,' ',FirstName) as EmployeeName
from Employees
where EmployeeID NOT IN (
    select e.EmployeeID
    from Employees e
    join Orders o on e.EmployeeID = o.EmployeeID
    where o.OrderDate = GETDATE()
);


--15.Liệt kê danh sách các Customers chưa mua hàng trong năm 1997

select CustomerID, ContactName, City
from Customers
where CustomerID NOT IN (
    select DISTINCT o.CustomerID --distinct: moi cusid chi xh 1 lan
    from Orders o
    where year(o.OrderDate) = 1997
);


/*16.Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T
trong tháng 7 năm 1997*/

select CustomerID, ContactName, City
from Customers
where CustomerID IN (
    select DISTINCT o.CustomerID
    from Orders o
    join [Order Details] od on o.OrderID = od.OrderID
    join Products p on od.ProductID = p.ProductID
    where year(o.OrderDate) = 1997
      and month(o.OrderDate) = 7
      and p.ProductName LIKE 'T%'
);

/*17.Liệt kê danh sách các khách hàng mua các hóa đơn mà các hóa đơn này
chỉ mua những sản phẩm có mã >=3*/

select CustomerID, ContactName, City
from Customers
where CustomerID IN (
	select distinct CustomerID
    from Orders
    where OrderID NOT IN (
        select OrderID
        from [Order Details] od
        where ProductID < 3
    )
);

/*18.Tìm các Customer chưa từng lập hóa đơn (viết bằng ba cách: dùng NOT
EXISTS, dùng LEFT join, dùng NOT IN )*/

select CustomerID, ContactName, City
from Customers c
where NOT EXISTS (
    select *
    from Orders o
    where o.CustomerID = c.CustomerID
);

select c.CustomerID, ContactName, c.City
from Customers c
left join Orders o on c.CustomerID = o.CustomerID
where o.OrderID is null;

select CustomerID, ContactName, City
from Customers
where CustomerID NOT IN (
    select CustomerID
    from Orders
);


--19.Bạn hãy mô tả kết quả của các câu truy vấn sau ?
select ProductID, ProductName, UnitPrice from [Products]
where Unitprice>ALL (select Unitprice from [Products] where
ProductName like 'N%');
-- tra ve danh sach cac product co unitprice > unitprice cua tat ca nhung product co ten bat dau bang chu N

select ProductId, ProductName, UnitPrice from [Products]
where Unitprice>ANY (select Unitprice from [Products] where
ProductName like 'N%');
-- tra ve danh sach cac product co unitprice > it nhat 1 gia tri unitprice cua nhung product co ten bat dau bang chu N

select ProductId, ProductName, UnitPrice from [Products]
where Unitprice=ANY (select Unitprice from [Products] where
ProductName like 'N%');
-- tra ve danh sach cac product co unitprice = it nhat 1 gia tri unitprice cua nhung product co ten bat dau bang chu N

select ProductId, ProductName, UnitPrice from [Products]
where ProductName like 'N%' and
Unitprice>=ALL (select Unitprice from [Products] where
ProductName like 'N%')
-- tra ve danh sach cac product co ten bat dau bang chu N co unitprice > unitprice cua tat ca nhung product co ten bat dau bang chu N



--BÀI TẬP 5: LỆNH select – CÁC LOẠI TRUY VẤN KHÁC 

/*1. Sử dụng select và Union để “hợp” tập dữ liệu lấy từ bảng Customers và 
Employees. Thông tin gồm CodeID, Name, Address, Phone. Trong đó 
CodeID là CustomerID/EmployeeID, Name là Companyname/LastName 
+ FirstName, Phone là Homephone. */

select 
    CustomerID as CodeID,
    CompanyName as Name,
    Address,
    Phone as Phone
from Customers
UNIon
select 
    CasT(EmployeeID as NVARCHAR) as CodeID, --cast: chuyen doi kieu du lieu
    (LastName + ' ' + FirstName) as Name,
    Address,
    HomePhone as Phone
from Employees;

/*2. Dùng lệnh select…INTO tạo bảng HDKH_71997 chứa thông tin về 
các khách hàng gồm : CustomerID, CompanyName, Address, ToTal 
=sum(quantity*Unitprice) , với total là tổng tiền khách hàng đã mua 
trong tháng 7 năm 1997.*/

select c.CustomerID, 
       c.CompanyName, 
       c.Address, 
       sum(od.Quantity * od.UnitPrice) as Total
INTO HDKH_71997
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997 and month(o.OrderDate) = 7
group by c.CustomerID, c.CompanyName, c.Address;
select * from HDKH_71997

/*3. Dùng lệnh select…INTO tạo bảng LuongNV chứa dữ liệu về nhân 
viên gổm : EmployeeID, Name = LastName + FirstName, Address, 
ToTal =10%*sum(quantity*Unitprice) , với Total là tổng lương của nhân 
viên trong tháng 12 năm 1996.*/

select 
    e.EmployeeID, 
    concat(LastName,' ',FirstName) as Name, 
    e.Address, 
    0.1 * sum(od.Quantity * od.UnitPrice) as Total
INTO LuongNV
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1996 and month(o.OrderDate) = 12
group by e.EmployeeID, e.LastName, e.FirstName, e.Address;
select * from LuongNV


/*4. Dùng lệnh select…INTO tạo bảng Ger_USA chứa thông tin về các 
hóa đơn xuất bán trong quý 1 năm 1998 với địa chỉ nhận hàng thuộc các 
quốc gia (ShipCountry) là 'Germany' và 'USA', do công ty vận chuyển 
‘Speedy Express’ thực hiện. */

select 
    OrderID, 
    OrderDate, 
    ShipCountry,  
    ShipName
INTO Ger_USA
from Orders o
where year(OrderDate) = 1998 
      and month(OrderDate) BETWEEN 1 and 3
      and ShipCountry IN ('Germany', 'USA')
      and ShipName = 'Speedy Express';
select * from Ger_USA

--5. Pivot Query 
CREATE TABLE dbo.HoaDonBanHang 
(    
    orderid INT NOT NULL, 
    orderdate DATE NOT NULL, 
    empid INT NOT NULL, 
    custid VARCHAR(5) NOT NULL, 
    qty INT NOT NULL, 
    ConSTRAINT PK_HoaDonBanHang PRIMARY KEY(orderid)
);
insert into dbo.HoaDonBanHang
values
	(30001, '20070802', 3, 'A', 10), 
(10001, '20071224', 2, 'A', 12), 
(10005, '20071224', 1, 'B', 20), 
(40001, '20080109', 2, 'A', 40), 
(10006, '20080118', 1, 'C', 14), 
(20001, '20080212', 2, 'B', 12), 
(40005, '20090212', 3, 'A', 10), 
(20002, '20090216', 1, 'C', 20), 
(30003, '20090418', 2, 'B', 15), 
(30004, '20070418', 3, 'C', 22), 
(30007, '20090907', 3, 'D', 30);
	
--a) Tính tổng Qty cho mỗi nhân viên. Thông tin gồm empid, custid 

select 
    empid, 
    custid, 
    sum(qty) as TotalQty
from HoaDonBanHang
group by empid, custid
order by empid, custid;

--b) Tạo bảng Pivot có dạng sau 
select empid, A, B, C, D 
from (
	select empid, custid, qty 
	from dbo.HoaDonBanHang) as D 
	PIVOT(sum(qty) FOR custid IN(A, B, C, D) ) as P;
--sum tinh tong qty moi cusid (for cusid in)
--Pivot Query dùng để xoay dữ liệu từ dạng hàng (dọc) sang dạng cột (ngang)
--FOR CustID chỉ định rằng muốn xoay dữ liệu dựa trên giá trị của cột CustID. Các giá trị trong cột CustID (ví dụ: A, B, C, D) sẽ trở thành các cột mới trong kết quả.
--vi ko co empid trong for nen chi dinh empid de nhom dl


--c) Tạo 1 query lấy dữ liệu từ bảng dbo.HoaDonBanHang trả về số hóa đơn 
--đã lập của nhân viên employee trong mỗi năm. 
select 
    empid as EmployeeID,
    year(orderdate) as Orderyear,
    COUNT(orderid) as TotalOrders
from dbo.HoaDonBanHang
group by empid, year(orderdate)
order by empid, Orderyear;

--d) Tạo bảng pivot hiển thị số đơn đặt hàng được thực hiện bởi nhân viên có 
--mã 1, 3, 4, 8, 9
select empid, A, B, C, D 
from (
    select empid, custid, COUNT(orderid) as OrderCount
    from dbo.HoaDonBanHang
    where empid IN (1, 3, 4, 8, 9)
    group by empid, custid
) as SourceTable
PIVOT (
    sum(OrderCount)
    FOR custid IN(A, B, C, D)
) as PivotTable;


--Tuan 9--
--BÀI TẬP 1: INSERT dữ liệu 
/*1. Dùng lệnh Insert…select… 
Lệnh INSERT … select …  cho phép nhập dữ liệu vào một bảng 
(bảng đích) bằng cách lấy (truy vấn) dữ liệu từ bảng đã tồn tại (bảng 
nguồn). Bảng đích và bảng nguồn có thể nằm trong cùng CSDL hay thuộc 
những CSDL khác nhau. 
Lưu ý : tập dữ liệu lấy từ bảng nguồn phải phù hợp cấu trúc, kiểu dữ liệu 
và ràng buộc dữ liệu trên bảng đích. 
Áp dụng lệnh INSERT … select … để nhập dữ liệu vào các bảng 
trong csdl QLBH dựa trên dữ liệu trong csdl Northwind ? Kiểm tra kết quả 
sau mỗi lần thực hiện ? */

/*a. Insert dữ liệu vào bảng KhachHang trong QLBH với dữ liệu nguồn là 
bảng Customers trong NorthWind. */
insert into QLBH.dbo.KhachHang (MaKh,TenKh)
select CustomerID, ContactName
from Northwind.dbo.Customers

select * from QLBH.dbo.KhachHang

/*b. Insert dữ liệu vào bảng Sanpham trong QLBH. Dữ liệu nguồn là các 
sản phẩm có SupplierID từ 4 đến 29 trong bảng Northwind.dbo.Products  */

insert into QLBH.dbo.SanPham(Masp, TenSp)
select ProductID, ProductName
from Northwind.dbo.Products
where SupplierID between 4 and 29

select * from QLBH.dbo.SanPham

/*c. Insert dữ liệu vào bảng HoaDon trong QLBH. Dữ liệu nguồn là các 
hoá đơn có OrderID nằm trong khoảng 10248 đến 10350 trong 
NorthWind.dbo.[Orders] */

insert into QLBH.dbo.HoaDon (MaHD, NgayLapHD, NgayGiao, NoiChuyen, MaKh)
select OrderID, OrderDate, ShippedDate, ShipAddress, CustomerID
from NorthWind.dbo.Orders
where OrderID between 10248 and 10350

select * from QLBH.dbo.HoaDon

/*d. Insert dữ liệu vào bảng CT_HoaDon trong QLBH. Dữ liệu nguồn là 
các chi tiết hoá đơn có OderID nằm trong khoảng 10248 đến 10350 
trong NorthWind.dbo.[Order Detail]*/

INSERT INTO QLBH.dbo.CT_HoaDon
select OrderID, ProductID, Quantity, UnitPrice, Discount
from Northwind.dbo.[Order Details] 
where OrderID BETWEEN 10248 and 10350
  and ProductID IN (
      select Masp
      from QLBH.dbo.SanPham
  );

--neu productid ch co trong sanpham--
-- Thêm các sản phẩm bị thiếu vào bảng SanPham
/*INSERT INTO QLBH.dbo.SanPham
select DISTINCT od.ProductID, p.ProductName, od.UnitPrice, 0
from Northwind.dbo.[Order Details] od
join Northwind.dbo.Products p on od.ProductID = p.ProductID
LEFT join QLBH.dbo.SanPham sp on od.ProductID = sp.Masp
where od.OrderID BETWEEN 10248 and 10350
  and sp.Masp IS NULL;
-- Thêm vào bảng CT_HoaDon những sản phẩm đã được thêm vào SanPham
INSERT INTO QLBH.dbo.CT_HoaDon
select od.OrderID, od.ProductID, od.Quantity, od.UnitPrice, od.Discount
from Northwind.dbo.[Order Details] od
join QLBH.dbo.SanPham sp on od.ProductID = sp.Masp
where od.OrderID BETWEEN 10248 and 10350;*/


select * from QLBH.dbo.CT_HoaDon



--BÀI TẬP 2: LỆNH UPDATE 
/*Cú pháp 2: UPDATE <table_name>  
set <column_name> = value , [, …] 
from  <table_name> [, …] 
where <condition>  
Sử dụng cú pháp 2 hoặc dùng subquery thực hiện các yêu cầu sau : 
1. Cập nhật chiết khấu 0.1 cho các mặt hàng trong các hóa đơn xuất bán 
vào ngày ‘1/1/1997’ */

UPDATE Northwind.dbo.[Order Details]
set Discount = 0
from Northwind.dbo.Orders o
join Northwind.dbo.[Order Details] od
on o.OrderID = od.OrderID
where o.OrderDate = '1997-01-01';

select *
from Northwind.dbo.Orders o
join Northwind.dbo.[Order Details] od
on o.OrderID = od.OrderID
where o.OrderDate = '1997-01-01';


/*
2. Cập nhật đơn giá bán 17.5 cho mặt hàng có mã 11 trong các hóa đơn  
xuất bán vào tháng 2 năm 1997  */

UPDATE Northwind.dbo.[Order Details]
set UnitPrice = 17.5
from Northwind.dbo.[Order Details] od
join Northwind.dbo.Orders o on od.OrderID = o.OrderID
where od.ProductID = 11
  and month(o.OrderDate) = 2
  and year(o.OrderDate) = 1997;

select *
from Northwind.dbo.Orders o
join Northwind.dbo.[Order Details] od
on o.OrderID = od.OrderID
where od.ProductID = 11
  and month(o.OrderDate) = 2
  and year(o.OrderDate) = 1997;


/*3. Cập nhật giá bán các sản phẩm trong bảng [Order Details] bằng với đơn 
giá mua trong bảng [Products] của các sản phẩm được cung cấp từ nhà 
cung cấp có mã là 4 hay 7 và xuất bán trong tháng 4 năm 1997*/

UPDATE Northwind.dbo.[Order Details]
set UnitPrice = p.UnitPrice
from Northwind.dbo.[Order Details] od
join Northwind.dbo.Products p on od.ProductID = p.ProductID
join Northwind.dbo.Orders o on od.OrderID = o.OrderID
where p.SupplierID IN (4, 7)
  and month(o.OrderDate) = 4
  and year(o.OrderDate) = 1997;

select *
from Northwind.dbo.[Order Details] od
join Northwind.dbo.Products p on od.ProductID = p.ProductID
join Northwind.dbo.Orders o on od.OrderID = o.OrderID
where p.SupplierID IN (4, 7)
  and month(o.OrderDate) = 4
  and year(o.OrderDate) = 1997;

/*4. Cập nhật tăng phí vận chuyển (Freight) lên 20% cho những hóa đơn có 
tổng trị giá hóa đơn >= 10000 và xuất bán trong tháng 1/1997 */

UPDATE Northwind.dbo.Orders
set Freight = Freight * 1.2
where OrderID IN (
    select od.OrderID
    from Northwind.dbo.[Order Details] od
    join Northwind.dbo.Orders o on od.OrderID = o.OrderID
    where month(o.OrderDate) = 1
      and year(o.OrderDate) = 1997
    group by od.OrderID
    having sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) >= 10000
);

select *
from Orders
where OrderID IN (
    select od.OrderID
    from Northwind.dbo.[Order Details] od
    join Northwind.dbo.Orders o on od.OrderID = o.OrderID
    where month(o.OrderDate) = 1
      and year(o.OrderDate) = 1997
    group by od.OrderID
    having sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) >= 10000
);

/*5. Thêm 1 cột vào bảng Customers lưu thông tin về loại thành viên :   
Member97   varchar(3) . Cập nhật cột Member97  là ‘VIP’ cho những 
khách hàng có tổng trị giá các đơn hàng trong năm 1997 từ 50000 trở 
lên.*/

ALTER TABLE Northwind.dbo.Customers
ADD Member97 VARCHAR(3);
UPDATE Northwind.dbo.Customers
set Member97 = 'VIP'
where CustomerID IN (
    select o.CustomerID
    from Northwind.dbo.Orders o
    join Northwind.dbo.[Order Details] od on o.OrderID = od.OrderID
    where year(o.OrderDate) = 1997
    group by o.CustomerID
    having sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) >= 50000
);

select *
from Customers
where Member97 = 'VIP'


--BÀI TẬP 3: LỆNH DELETE 
/*Cú pháp 2:    DELETE from <table_name>  
from <table_name> [, …] 
where <condition>  
Sử dụng cú pháp 2 hoặc dùng subquery thực hiện các yêu cầu sau : 
HD : Các lệnh sau sẽ xóa những dòng dữ liệu trong [Order Details], là chi tiết 
của các hóa đơn bán cho khách hàng có mã ‘SANTG’ . Có thể sử dụng lệnh 
select … INTO … để sao lưu những dòng này trước khi thực hiện lệnh xóa. 
1. Xóa các dòng trong [Order Details] có ProductID 24, là “chi tiết của 
hóa đơn” xuất bán cho khách hàng có mã ‘SANTG’ */


delete from [Order Details]
from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 24 and CustomerID = 'SANTG'

--để check
select * from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 24 and CustomerID = 'SANTG'

/*2. Xóa các dòng trong [Order Details] có ProductID  35, là “chi tiết của 
hóa đơn” xuất bán trong năm 1998 cho khách hàng có mã ‘SANTG’  */

delete from [Order Details]
from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 35 and CustomerID = 'SANTG' and year(OrderDate) = 1998

--để check
select * from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where ProductID = 35 and CustomerID = 'SANTG' and year(OrderDate) = 1998


/*3. Thực hiện xóa tất cả các dòng trong [Order Details] là “chi tiết của 
các hóa đơn” bán cho khách  hàng có mã ‘SANTG’ */

delete from [Order Details]
from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where CustomerID = 'SANTG'

--để check
select * from [Order Details] od join Orders o
on od.OrderID = o.OrderID
where CustomerID = 'SANTG'
