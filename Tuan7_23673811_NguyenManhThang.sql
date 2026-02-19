/*HO TEN: Nguyễn Mạnh Thắng
MSSV: 23673811
BT TUAN 7*/

use Northwind
go

/*
1. Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin
bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của Quantity *
Unitprice, kết nhóm theo OrderID.*/

select o.OrderID, OrderDate, sum(Quantity * Unitprice) as Total
from Orders o join [Order Details] od on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate

/*2. Liệt kê danh sách các orders mà địa chỉ nhận hàng ở thành phố ‘Madrid’
(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó Total
là tổng trị giá hóa đơn, kết nhóm theo OrderID.*/

select o.OrderID, OrderDate, sum(Quantity * Unitprice) as Total
from Orders o join [Order Details] od on o.OrderID = od.OrderID
where ShipCity = 'Madrid'
group by o.OrderID, o.OrderDate

/*
3. Viết các truy vấn để thống kê số lượng các hóa đơn :*/
-- Trong mỗi năm. Thông tin hiển thị : Year , CoutOfOrders ?

select datepart(year, OrderDate) as Year, count(*) as CountOfOrders
from Orders 
group by datepart(year, OrderDate)

-- Trong mỗi tháng/năm . Thông tin hiển thị : Year , Month, CoutOfOrders ?

select year(OrderDate) as Year, month(OrderDate) as Month, count(*) as CountOfOrders
from Orders 
group by year(OrderDate), month(OrderDate)
order by year(OrderDate), month(OrderDate)

-- Trong mỗi tháng/năm và ứng với mỗi nhân viên. Thông tin hiển thị : Year, Month, EmployeeID, CoutOfOrders ?*/

select year(OrderDate) as Year, month(OrderDate) as Month, EmployeeID, count(*) as CountOfOrders
from Orders 
group by year(OrderDate), month(OrderDate), EmployeeID
order by EmployeeID

/*
4. Cho biết mỗi Employee đã lập bao nhiêu hóa đơn. Thông tin gồm
EmployeeID, EmployeeName, CountOfOrder. Trong đó CountOfOrder là tổng số hóa đơn của từng employee. EmployeeName được ghép từ
LastName và FirstName.*/

select o.EmployeeID, concat(FirstName,' ',LastName) as EmployeeName, count(OrderID) as CountOfOrder
from Orders o join Employees e on o.EmployeeID = e.EmployeeID
group by o.EmployeeID, concat(FirstName,' ',LastName)


/*
5. Cho biết mỗi Employee đã lập được bao nhiêu hóa đơn, ứng với tổng tiền
các hóa đơn tương ứng. Thông tin gồm EmployeeID, EmployeeName,
CountOfOrder , Total.*/

select o.EmployeeID, concat(FirstName,' ',LastName) as EmployeeName, count(o.OrderID) as CountOfOrder, sum(Quantity * Unitprice) as Total
from Orders o 
join Employees e on o.EmployeeID = e.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
group by o.EmployeeID, concat(FirstName,' ',LastName)


/*
6. Liệt kê bảng lương của mỗi Employee theo từng tháng trong năm 1996
gồm EmployeeID, EmployName, Month_Salary, Salary =
sum(quantity*unitprice)*10%. Được sắp xếp theo Month_Salary, cùmg
Month_Salary thì sắp xếp theo Salary giảm dần.*/

select o.EmployeeID, concat(FirstName,' ',LastName) as EmployeeName, month(OrderDate) as Month_Salary, sum(quantity*unitprice)*0.1 as Salary
from Orders o 
join Employees e on o.EmployeeID = e.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where year(OrderDate) = 1996
group by month(OrderDate), o.EmployeeID, concat(FirstName,' ',LastName)
order by month(OrderDate), Salary desc


/*
7. Tính tổng số hóa đơn và tổng tiền các hóa đơn của mỗi nhân viên đã bán
trong tháng 3/1997, có tổng tiền >4000. Thông tin gồm EmployeeID,
LastName, FirstName, CountofOrder, Total.*/

select e.EmployeeID, LastName, FirstName, count(o.OrderID) as CountOfOrder, sum(Quantity * Unitprice) as Total
from Employees e 
join Orders o on o.EmployeeID = e.EmployeeID
join [Order Details] od on od.OrderID = o.OrderID
where month(OrderDate) = 3 and year(OrderDate) = 1997
group by e.EmployeeID, LastName, FirstName
having sum(Quantity * Unitprice)>4000


/*
8. Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các hoá
đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các
hóa đơn >20000. Thông tin được sắp xếp theo CustomerID, cùng mã thì
sắp xếp theo tổng tiền giảm dần.*/

select c.CustomerID, count(o.OrderID) as CountOfOrder, sum(Quantity * Unitprice) as Total
from Customers c
join Orders o on o.CustomerID = c.CustomerID
join [Order Details] od on od.OrderID = o.OrderID
where OrderDate between '1996-12-31' and '1998-1-1'
group by c.CustomerID
having sum(Quantity * Unitprice)>20000
order by CustomerID, Total desc

/*
9. Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng
tháng. Thông tin bao gồm CustomerID, CompanyName, Month_Year,
Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng của
Unitprice* Quantity.*/

select c.CustomerID, CompanyName, concat(month(OrderDate), '/', year(OrderDate)) as Month_Year, sum(Quantity * Unitprice) as Total
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on od.OrderID = od.OrderID
group by c.CustomerID, month(OrderDate), year(OrderDate), CompanyName

/*
10.Liệt kê danh sách các nhóm hàng (category) có tổng số lượng tồn
(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin bao
gồm CategoryID, CategoryName, Total_UnitsInStock, Average_Unitprice.*/

select c.CategoryID, CategoryName, sum(p.UnitsInStock) as Total_UnitsInStock, avg(p.UnitPrice) as Average_Unitprice
from Categories c join Products p
on c.CategoryID = p.CategoryID
group by c.CategoryID, CategoryName
having sum(p.UnitsInStock) > 300 and avg(p.UnitPrice) < 25

/*
11.Liệt kê danh sách các nhóm hàng (category) có tổng số mặt hàng (product) nhỏ hớn 10. Thông tin kết quả bao gồm CategoryID, CategoryName,
CountOfProducts. Được sắp xếp theo CategoryName, cùng CategoryName
thì sắp theo CountOfProducts giảm dần.*/

select c.CategoryID, CategoryName, count(p.ProductID) as CountOfProducts
from Categories c join Products p
on c.CategoryID = p.CategoryID
group by c.CategoryID, CategoryName
having count(p.ProductID) < 10
order by CategoryName, CountOfProducts desc

/*
12.Liệt kê danh sách các Product bán trong quý 1 năm 1998 có tổng số lượng
bán ra >200, thông tin gồm [ProductID], [ProductName], SumofQuatity*/

select p.ProductID, ProductName, sum(od.Quantity) as SumofQuatity
from Products p 
join [Order Details] od on od.ProductID = p.ProductID
join Orders o on od.OrderID = o.OrderID
where o.OrderDate between '1998-01-01' and '1998-03-31'
group by p.ProductID, ProductName
having sum(od.Quantity) > 200

--13.Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997

select top 1 e.EmployeeID, concat(LastName, ' ', FirstName) as EmployeeName, SUM(UnitPrice * Quantity * (1 - Discount)) AS TotalSales
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on od.OrderID = o.OrderID
where month(OrderDate) = 7 and year(OrderDate) = 1997
group by e.EmployeeID, concat(LastName, ' ', FirstName)
ORDER BY TotalSales desc

--14.Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.

select top 3 c.CustomerID, CompanyName, ContactName, count(OrderID) as TotalOrders
from Customers c join Orders o on o.CustomerID = c.CustomerID
where year(OrderDate) = 1996
group by c.CustomerID, CompanyName, ContactName
order by TotalOrders desc

/*
15.Liệt kê danh sách các Products có tổng số lượng lập hóa đơn lớn nhất.
Thông tin gồm ProductID, ProductName, CountOfOrders.*/

select p.ProductID, ProductName, count(OrderID) as CountOfOrders
from Products p join [Order Details] od on od.ProductID = p.ProductID
group by p.ProductID, ProductName
order by CountOfOrders desc
