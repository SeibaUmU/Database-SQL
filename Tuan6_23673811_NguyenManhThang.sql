/*
BT TUAN 6
Ho & ten: Nguyễn Mạnh Thắng
MSSV: 23673811
*/

use Northwind
go

alter authorization on database::NorthWind to sa;

/*
1. Hiển thị thông tin về hóa đơn có mã ‘10248’, bao gồm: OrderID,
OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,
Discount. */

select O.OrderID,
OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,
Discount
from Orders O join [Order Details] OD
on O.OrderID = OD.OrderID
where O.OrderID = 10248

/*
2. Liệt kê các khách hàng có lập hóa đơn trong tháng 7/1997 và 9/1997.
Thông tin gồm CustomerID, CompanyName, Address, OrderID,
Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp
theo OrderDate giảm dần. */

select C.CustomerID, CompanyName, Address, OrderID,
Orderdate
from Customers C join Orders O
on C.CustomerID = O.CustomerID
where Year(OrderDate) = 1997 and Month(OrderDate) in ('9','7') 
order by c.CustomerID asc, OrderDate desc

/*
3. Liệt kê danh sách các mặt hàng xuất bán vào ngày 19/7/1996. Thông tin
gồm : ProductID, ProductName, OrderID, OrderDate, Quantity. */

select P.ProductID, ProductName, O.OrderID, OrderDate, Quantity
from Products P 
join [Order Details] OD on P.ProductID = OD.ProductID 
join Orders O on OD.OrderID = O.OrderID
where O.OrderDate = '1996-07-19'

/*
4. Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
đã xuất bán trong quý 2 năm 1997. Thông tin gồm : ProductID,
ProductName, SupplierID, OrderID, Quantity. Được sắp xếp theo mã nhà cung cấp (SupplierID), cùng mã nhà cung cấp thì sắp xếp theo
ProductID. */

select p.ProductID, ProductName, SupplierID, o.OrderID, Quantity
from Products p 
join [Order Details] od on p.ProductID = od.ProductID 
join Orders o on o.OrderID = od.OrderID
where p.SupplierID in ('1','3','6') and o.OrderDate between '1997-04-01' and '1997-06-30'
order by p.SupplierID asc, p.ProductID;

--5. Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.

select p.ProductID, ProductName, p.UnitPrice, (od.UnitPrice - (od.UnitPrice * od.Discount) ) as PurchasePrice
from Products p join [Order Details] od
on p.ProductID = od.ProductID
where p.UnitPrice = (od.UnitPrice - (od.UnitPrice * od.Discount))

/*
6. Danh sách các mặt hàng bán trong ngày thứ 7 và chủ nhật của tháng 12
năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate,
CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp
xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.
*/

select p.ProductID, ProductName, o.OrderID, OrderDate, 
CustomerID, p.Unitprice, Quantity, (od.Quantity*od.UnitPrice) as ToTal
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on o.OrderID = od.OrderID
where year(OrderDate) = 1996 and MONTH(OrderDate) = 12 and datepart(weekday, OrderDate) in ('1','7')
order by p.ProductID, od.Quantity desc;

/*
7. Liệt kê danh sách các nhân viên đã lập hóa đơn trong tháng 7 của năm
1996. Thông tin gồm : EmployeeID, EmployeeName, OrderID,
Orderdate.*/

select e.EmployeeID, concat(e.FirstName,' ',e.LastName) as EmployeeName , OrderID, Orderdate
from Employees e join Orders o
on e.EmployeeID = o.EmployeeID
where year(OrderDate) = 1996 and month(OrderDate) = 7

/*
8. Liệt kê danh sách các hóa đơn do nhân viên có Lastname là ‘Fuller’ lập.
Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice.*/

select o.OrderID, Orderdate, ProductID, Quantity, Unitprice
from Employees e 
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where e.LastName = 'Fuller'

/*
9. Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn trong năm
1996. Thông tin gồm: EmployeeID, EmployName, OrderID, Orderdate,
ProductID, quantity, unitprice, ToTalLine=quantity*unitprice.*/

select e.EmployeeID, concat(e.FirstName,' ',e.LastName) as EmployName, o.OrderID, Orderdate,
ProductID, Quantity, UnitPrice, (Quantity*UnitPrice) as ToTalLine
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where year(OrderDate) = 1996

/*
10.Danh sách các đơn hàng sẽ được giao trong các thứ 7 của tháng 12 năm
1996.*/

select * from Orders where year(ShippedDate) = 1996 and month(ShippedDate) = 12 and datepart(weekday, ShippedDate) in ('7')

/*
11.Liệt kê danh sách các nhân viên chưa lập hóa đơn (dùng LEFT
JOIN/RIGHT JOIN).*/

SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName
FROM 
    Employees e
LEFT JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
WHERE 
    o.OrderID IS NULL;

SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName
FROM 
    Orders o
RIGHT JOIN 
    Employees e ON e.EmployeeID = o.EmployeeID
WHERE 
    o.OrderID IS NULL;

/*
12.Liệt kê danh sách các sản phẩm chưa bán được (dùng LEFT
JOIN/RIGHT JOIN).*/

SELECT 
    p.ProductID, 
    p.ProductName 
FROM 
    Products p
LEFT JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
WHERE 
    od.ProductID IS NULL;

SELECT 
    p.ProductID, 
    p.ProductName 
FROM 
    [Order Details] od
RIGHT JOIN 
    Products p ON p.ProductID = od.ProductID
WHERE 
    od.ProductID IS NULL;

/*
13.Liệt kê danh sách các khách hàng chưa mua hàng lần nào (dùng LEFT
JOIN/RIGHT JOIN)*/

select c.ContactName, c.CustomerID
from Customers c
left join Orders o on c.CustomerID = o.CustomerID
where o.CustomerID is null;

select c.ContactName, c.CustomerID
from Orders o
right join Customers c on c.CustomerID = o.CustomerID
where o.CustomerID is null;
