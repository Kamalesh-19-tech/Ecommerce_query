use ECOMMERCE_ASSIGNMENT_DB;
GO

create table Customer
(
CustomerId int primary key identity,
CustomerName varchar(100) not null,
Email varchar(100) unique not null,
MobileNo bigint not null,
City varchar(100),
Address varchar(200),
IsActive bit default 1,
CreatedDate datetime default getdate()
);

create table Seller
(
SellerId int primary key identity,
SellerName varchar(100)not null,
Email varchar(100) unique not null,
MobileNo bigint not null,
City varchar(100),
Rating decimal(2,1),
IsActive bit default 1
);

create table Product
(
ProductId int primary key identity,
ProductName varchar(100) not null,
Category varchar(100),
Price money check(Price > 0),
StockQuantity int check(StockQuantity >= 0),
SellerId int,
CreatedDate datetime default getdate(),

constraint fk_product_seller
foreign key(SellerId)
references Seller(SellerId)
);

create table Orders
(
OrderId int primary key identity,
CustomerId int,
OrderDate Datetime default getdate(),
OrderStatus varchar(50) default 'Pending',
PaymentMode varchar(50),
DeliveryCity varchar(100),

constraint fk_orders_customer
foreign key(CustomerId)
references Customer(CustomerId)
);

create table OrderItem
(
OrderItemId int primary key identity,
OrderId int,
ProductId int,
quantity int check(Quantity > 0),
UnitPrice money,

constraint fk_orderitem_order
foreign key(OrderId)
references Orders(orderId),

CONSTRAINT fk_orderitem_product
FOREIGN KEY(ProductId)
REFERENCES Product(ProductId)
);

INSERT INTO Customer
(CustomerName,Email,MobileNo,City,Address)
VALUES
('Arun Kumar','arun@gmail.com',9876543210,'Chennai','Anna Nagar'),

('Priya Sharma','priya@gmail.com',9876543211,'Bangalore','MG Road'),

('Rahul Verma','rahul@gmail.com',9876543212,'Hyderabad','Banjara Hills'),

('Sneha Reddy','sneha@gmail.com',9876543213,'Chennai','Velachery'),

('Akash Singh','akash@gmail.com',9876543214,'Mumbai','Andheri');


INSERT INTO Seller
(SellerName,Email,MobileNo,City,Rating)
VALUES
('Tech World','techworld@gmail.com',9000000001,'Chennai',4.5),

('Mobile Hub','mobilehub@gmail.com',9000000002,'Bangalore',4.2),

('Laptop Store','laptop@gmail.com',9000000003,'Hyderabad',4.7),

('Gadget Zone','gadget@gmail.com',9000000004,'Mumbai',4.1);


INSERT INTO Product
(ProductName,Category,Price,StockQuantity,SellerId)
VALUES
('iPhone 15','Mobile',80000,10,2),

('Samsung S24','Mobile',75000,8,2),

('Dell XPS','Laptop',95000,5,3),

('HP Pavilion','Laptop',65000,6,3),

('Boat Headset','Accessories',3000,20,1),

('Smart Watch','Accessories',12000,15,1),

('Lenovo Legion','Laptop',110000,4,3),

('OnePlus 12','Mobile',60000,7,2);

INSERT INTO Orders
(CustomerId,PaymentMode,DeliveryCity)
VALUES
(1,'UPI','Chennai'),

(2,'Card','Bangalore'),

(3,'Cash On Delivery','Hyderabad'),

(4,'UPI','Chennai'),

(5,'Card','Mumbai');


INSERT INTO OrderItem
(OrderId,ProductId,Quantity,UnitPrice)
VALUES
(1,1,1,80000),

(1,5,2,3000),

(2,3,1,95000),

(2,6,1,12000),

(3,2,1,75000),

(3,8,1,60000),

(4,4,1,65000),

(4,5,1,3000),

(5,7,1,110000),

(5,6,2,12000);


UPDATE Customer
SET City='Coimbatore'
WHERE CustomerId=1;

UPDATE Product
SET Price=85000
WHERE ProductId=1;

UPDATE Orders
SET OrderStatus='Delivered'
WHERE OrderId=1;

DELETE FROM Product
WHERE ProductId=6;

SELECT * FROM Customer;

SELECT * FROM Seller;

SELECT * FROM Product;

SELECT * FROM Orders;

SELECT * FROM OrderItem;


SELECT * FROM Customer
WHERE City='Chennai';

SELECT * FROM Customer
WHERE City!='Chennai';

SELECT * FROM Product
WHERE Price > 50000;

SELECT * FROM Product
WHERE Price BETWEEN 10000 AND 60000;

SELECT * FROM Product
WHERE Category IN ('Mobile','Laptop');

SELECT * FROM Customer
WHERE CustomerName LIKE 'A%';

SELECT * FROM Customer
WHERE Email LIKE '%gmail%';

SELECT * FROM Product
WHERE ProductName LIKE '%Phone%';

SELECT * FROM Orders
WHERE OrderStatus='Delivered';

SELECT * FROM Product
WHERE StockQuantity < 10;

SELECT * FROM Customer
WHERE MobileNo IS NOT NULL;

SELECT * FROM Product
WHERE Price NOT BETWEEN 10000 AND 50000;

SELECT * FROM Customer
WHERE City IN ('Chennai','Bangalore');

SELECT * FROM Customer
WHERE City='Chennai'
AND IsActive=1;

SELECT * FROM Customer
WHERE City<>'Hyderabad';

SELECT City,COUNT(CustomerId) AS TotalCustomers
FROM Customer
GROUP BY City;

SELECT Category,COUNT(ProductId) AS TotalProducts
FROM Product
GROUP BY Category;

SELECT Category,SUM(StockQuantity) AS TotalStock
FROM Product
GROUP BY Category;

SELECT Category,MAX(Price) AS MaximumPrice
FROM Product
GROUP BY Category;

SELECT Category,MIN(Price) AS MinimumPrice
FROM Product
GROUP BY Category;

SELECT Category,AVG(Price) AS AveragePrice
FROM Product
GROUP BY Category;

SELECT c.CustomerName,SUM(oi.Quantity*oi.UnitPrice) AS TotalOrderAmount
FROM Customer c
INNER JOIN Orders o
ON c.CustomerId=o.CustomerId
INNER JOIN OrderItem oi
ON o.OrderId=oi.OrderId
GROUP BY c.CustomerName;

SELECT p.ProductName,SUM(oi.Quantity*oi.UnitPrice) AS TotalSales
FROM Product p
INNER JOIN OrderItem oi
ON p.ProductId=oi.ProductId
GROUP BY p.ProductName;

SELECT p.ProductName,SUM(oi.Quantity) AS TotalQuantitySold
FROM Product p
INNER JOIN OrderItem oi
ON p.ProductId=oi.ProductId
GROUP BY p.ProductName;

SELECT Category,COUNT(ProductId) AS TotalProducts
FROM Product
GROUP BY Category
HAVING COUNT(ProductId) > 1;

SELECT c.CustomerName,
SUM(oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Customer c
INNER JOIN Orders o
ON c.CustomerId = o.CustomerId
INNER JOIN OrderItem oi
ON o.OrderId = oi.OrderId
GROUP BY c.CustomerName
HAVING SUM(oi.Quantity * oi.UnitPrice) > 50000;

SELECT s.SellerName,COUNT(p.ProductId) AS TotalProducts
FROM Seller s
LEFT JOIN Product p
ON s.SellerId=p.SellerId
GROUP BY s.SellerName;

SELECT s.SellerName,SUM(oi.Quantity*oi.UnitPrice) AS TotalSales
FROM Seller s
INNER JOIN Product p
ON s.SellerId=p.SellerId
INNER JOIN OrderItem oi
ON p.ProductId=oi.ProductId
GROUP BY s.SellerName;

SELECT OrderStatus,COUNT(OrderId) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

SELECT City,COUNT(CustomerId) AS CustomerCount
FROM Customer
GROUP BY City
ORDER BY CustomerCount DESC;

SELECT * FROM Product
ORDER BY Price ASC;

SELECT * FROM Product
ORDER BY Price DESC;

SELECT * FROM Customer
ORDER BY City ASC, CustomerName ASC;

SELECT * FROM Orders
ORDER BY OrderDate DESC;

SELECT * FROM Product
ORDER BY Category ASC, Price DESC;

SELECT TOP 3 * FROM Product
ORDER BY Price DESC;

SELECT TOP 5 * FROM Orders
ORDER BY OrderDate DESC;

SELECT * FROM Customer
ORDER BY IsActive DESC, CustomerName ASC;

SELECT o.OrderId,c.CustomerName,o.OrderDate,o.OrderStatus
FROM Orders o
INNER JOIN Customer c
ON o.CustomerId=c.CustomerId;

SELECT p.ProductName,s.SellerName,s.City
FROM Product p
INNER JOIN Seller s
ON p.SellerId=s.SellerId;

SELECT oi.OrderItemId,p.ProductName,oi.Quantity,oi.UnitPrice
FROM OrderItem oi
INNER JOIN Product p
ON oi.ProductId=p.ProductId;

SELECT c.CustomerName,o.OrderId,p.ProductName,s.SellerName,
oi.Quantity,oi.UnitPrice
FROM Customer c
INNER JOIN Orders o
ON c.CustomerId=o.CustomerId
INNER JOIN OrderItem oi
ON o.OrderId=oi.OrderId
INNER JOIN Product p
ON oi.ProductId=p.ProductId
INNER JOIN Seller s
ON p.SellerId=s.SellerId;

SELECT c.CustomerName,o.OrderId,o.OrderStatus
FROM Customer c
LEFT JOIN Orders o
ON c.CustomerId=o.CustomerId;

SELECT o.OrderId,c.CustomerName
FROM Customer c
RIGHT JOIN Orders o
ON c.CustomerId=o.CustomerId;

SELECT c.CustomerName,o.OrderId
FROM Customer c
FULL OUTER JOIN Orders o
ON c.CustomerId=o.CustomerId;

SELECT c.CustomerName,p.ProductName
FROM Customer c
CROSS JOIN Product p;

SELECT c.CustomerName
FROM Customer c
LEFT JOIN Orders o
ON c.CustomerId=o.CustomerId
WHERE o.OrderId IS NULL;

SELECT p.ProductName
FROM Product p
LEFT JOIN OrderItem oi
ON p.ProductId=oi.ProductId
WHERE oi.OrderItemId IS NULL;

SELECT s.SellerName,p.ProductName
FROM Seller s
INNER JOIN Product p
ON s.SellerId=p.SellerId;

SELECT c.CustomerName,p.ProductName
FROM Customer c
INNER JOIN Orders o
ON c.CustomerId=o.CustomerId
INNER JOIN OrderItem oi
ON o.OrderId=oi.OrderId
INNER JOIN Product p
ON oi.ProductId=p.ProductId;

SELECT o.OrderId,SUM(oi.Quantity*oi.UnitPrice) AS TotalAmount
FROM Orders o
INNER JOIN OrderItem oi
ON o.OrderId=oi.OrderId
GROUP BY o.OrderId;

SELECT s.SellerName,SUM(oi.Quantity*oi.UnitPrice) AS TotalSales
FROM Seller s
INNER JOIN Product p
ON s.SellerId=p.SellerId
INNER JOIN OrderItem oi
ON p.ProductId=oi.ProductId
GROUP BY s.SellerName;

SELECT p.ProductName,SUM(oi.Quantity) AS TotalSalesQuantity
FROM Product p
INNER JOIN OrderItem oi
ON p.ProductId=oi.ProductId
GROUP BY p.ProductName; 
