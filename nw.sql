CREATE DATABASE [test-hackolade];
USE [test-hackolade];

CREATE SCHEMA [dbo];

CREATE TABLE [dbo].[Categories] (
	[CategoryID] INT IDENTITY(1, 1) NOT NULL,
	[CategoryName] NVARCHAR(15) NOT NULL,
	[Description] NTEXT,
	[Picture] IMAGE,
	CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC) ON [PRIMARY]
);

CREATE INDEX CategoryName
	ON [dbo].[Categories] ( [CategoryName] );

CREATE TABLE [dbo].[CustomerDemographics] (
	[CustomerTypeID] NCHAR(10) NOT NULL,
	[CustomerDesc] NTEXT,
	CONSTRAINT [PK_CustomerDemographics] PRIMARY KEY NONCLUSTERED ([CustomerTypeID] ASC) ON [PRIMARY]
);

CREATE TABLE [dbo].[Customers] (
	[CustomerID] NCHAR(5) NOT NULL,
	[CompanyName] NVARCHAR(40) NOT NULL,
	[ContactName] NVARCHAR(30),
	[ContactTitle] NVARCHAR(30),
	[Address] NVARCHAR(60),
	[City] NVARCHAR(15),
	[Region] NVARCHAR(15),
	[PostalCode] NVARCHAR(10),
	[Country] NVARCHAR(15),
	[Phone] NVARCHAR(24),
	[Fax] NVARCHAR(24),
	CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC) ON [PRIMARY]
);

CREATE INDEX City
	ON [dbo].[Customers] ( [City] );

CREATE INDEX CompanyName
	ON [dbo].[Customers] ( [CompanyName] );

CREATE INDEX PostalCode
	ON [dbo].[Customers] ( [PostalCode] );

CREATE INDEX Region
	ON [dbo].[Customers] ( [Region] );

CREATE TABLE [dbo].[CustomerCustomerDemo] (
	[CustomerID] NCHAR(5) NOT NULL,
	[CustomerTypeID] NCHAR(10) NOT NULL,
	CONSTRAINT [PK_CustomerCustomerDemo] PRIMARY KEY NONCLUSTERED ([CustomerID] ASC, [CustomerTypeID] ASC) ON [PRIMARY],
	CONSTRAINT [FK_CustomerCustomerDemo] FOREIGN KEY ([CustomerTypeID]) REFERENCES [dbo].[CustomerDemographics]([CustomerTypeID]),
	CONSTRAINT [FK_CustomerCustomerDemo_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers]([CustomerID])
);

CREATE TABLE [dbo].[Employees] (
	[EmployeeID] INT IDENTITY(1, 1) NOT NULL,
	[LastName] NVARCHAR(20) NOT NULL,
	[FirstName] NVARCHAR(10) NOT NULL,
	[Title] NVARCHAR(30),
	[TitleOfCourtesy] NVARCHAR(25),
	[BirthDate] DATETIME,
	[HireDate] DATETIME,
	[Address] NVARCHAR(60),
	[City] NVARCHAR(15),
	[Region] NVARCHAR(15),
	[PostalCode] NVARCHAR(10),
	[Country] NVARCHAR(15),
	[HomePhone] NVARCHAR(24),
	[Extension] NVARCHAR(4),
	[Photo] IMAGE,
	[Notes] NTEXT,
	[ReportsTo] INT,
	[PhotoPath] NVARCHAR(255),
	CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID] ASC) ON [PRIMARY],
	CONSTRAINT [CK_Birthdate] CHECK ([BirthDate]<getdate()),
	CONSTRAINT [FK_Employees_Employees] FOREIGN KEY ([ReportsTo]) REFERENCES [dbo].[Employees]([EmployeeID])
);

CREATE INDEX LastName
	ON [dbo].[Employees] ( [LastName] );

CREATE INDEX PostalCode
	ON [dbo].[Employees] ( [PostalCode] );

CREATE TABLE [dbo].[Territories] (
	[TerritoryID] NVARCHAR(20) NOT NULL,
	[TerritoryDescription] NCHAR(50) NOT NULL,
	[RegionID] INT NOT NULL,
	CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED ([TerritoryID] ASC) ON [PRIMARY],
	CONSTRAINT [FK_Territories_Region] FOREIGN KEY ([RegionID]) REFERENCES [dbo].[Region]([RegionID])
);

CREATE TABLE [dbo].[Shippers] (
	[ShipperID] INT IDENTITY(1, 1) NOT NULL,
	[CompanyName] NVARCHAR(40) NOT NULL,
	[Phone] NVARCHAR(24),
	CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED ([ShipperID] ASC) ON [PRIMARY]
);

CREATE TABLE [dbo].[Suppliers] (
	[SupplierID] INT IDENTITY(1, 1) NOT NULL,
	[CompanyName] NVARCHAR(40) NOT NULL,
	[ContactName] NVARCHAR(30),
	[ContactTitle] NVARCHAR(30),
	[Address] NVARCHAR(60),
	[City] NVARCHAR(15),
	[Region] NVARCHAR(15),
	[PostalCode] NVARCHAR(10),
	[Country] NVARCHAR(15),
	[Phone] NVARCHAR(24),
	[Fax] NVARCHAR(24),
	[HomePage] NTEXT,
	CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierID] ASC) ON [PRIMARY]
);

CREATE INDEX CompanyName
	ON [dbo].[Suppliers] ( [CompanyName] );

CREATE INDEX PostalCode
	ON [dbo].[Suppliers] ( [PostalCode] );

CREATE TABLE [dbo].[Orders] (
	[OrderID] INT IDENTITY(1, 1) NOT NULL,
	[CustomerID] NCHAR(5),
	[EmployeeID] INT,
	[OrderDate] DATETIME,
	[RequiredDate] DATETIME,
	[ShippedDate] DATETIME,
	[ShipVia] INT,
	[Freight] MONEY DEFAULT ,
	[ShipName] NVARCHAR(40),
	[ShipAddress] NVARCHAR(60),
	[ShipCity] NVARCHAR(15),
	[ShipRegion] NVARCHAR(15),
	[ShipPostalCode] NVARCHAR(10),
	[ShipCountry] NVARCHAR(15),
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC) ON [PRIMARY],
	CONSTRAINT [FK_Orders_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees]([EmployeeID]),
	CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers]([CustomerID]),
	CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY ([ShipVia]) REFERENCES [dbo].[Shippers]([ShipperID])
);


ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_Freight] DEFAULT ((0)) FOR [Freight];

CREATE INDEX CustomerID
	ON [dbo].[Orders] ( [CustomerID] );

CREATE INDEX CustomersOrders
	ON [dbo].[Orders] ( [CustomerID] );

CREATE INDEX EmployeeID
	ON [dbo].[Orders] ( [EmployeeID] );

CREATE INDEX EmployeesOrders
	ON [dbo].[Orders] ( [EmployeeID] );

CREATE INDEX OrderDate
	ON [dbo].[Orders] ( [OrderDate] );

CREATE INDEX ShippedDate
	ON [dbo].[Orders] ( [ShippedDate] );

CREATE INDEX ShippersOrders
	ON [dbo].[Orders] ( [ShipVia] );

CREATE INDEX ShipPostalCode
	ON [dbo].[Orders] ( [ShipPostalCode] );

CREATE TABLE [dbo].[Region] (
	[RegionID] INT NOT NULL,
	[RegionDescription] NCHAR(50) NOT NULL,
	CONSTRAINT [PK_Region] PRIMARY KEY NONCLUSTERED ([RegionID] ASC) ON [PRIMARY]
);

CREATE TABLE [dbo].[Products] (
	[ProductID] INT IDENTITY(1, 1) NOT NULL,
	[ProductName] NVARCHAR(40) NOT NULL,
	[SupplierID] INT,
	[CategoryID] INT,
	[QuantityPerUnit] NVARCHAR(20),
	[UnitPrice] MONEY DEFAULT ,
	[UnitsInStock] SMALLINT DEFAULT ,
	[UnitsOnOrder] SMALLINT DEFAULT ,
	[ReorderLevel] SMALLINT DEFAULT ,
	[Discontinued] BIT DEFAULT  NOT NULL,
	CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC) ON [PRIMARY],
	CONSTRAINT [CK_Products_UnitPrice] CHECK ([UnitPrice]>=(0)),
	CONSTRAINT [CK_ReorderLevel] CHECK ([ReorderLevel]>=(0)),
	CONSTRAINT [CK_UnitsInStock] CHECK ([UnitsInStock]>=(0)),
	CONSTRAINT [CK_UnitsOnOrder] CHECK ([UnitsOnOrder]>=(0)),
	CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Categories]([CategoryID]),
	CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY ([SupplierID]) REFERENCES [dbo].[Suppliers]([SupplierID])
);


ALTER TABLE [dbo].[Products] ADD CONSTRAINT [DF_Products_UnitPrice] DEFAULT ((0)) FOR [UnitPrice];

ALTER TABLE [dbo].[Products] ADD CONSTRAINT [DF_Products_UnitsInStock] DEFAULT ((0)) FOR [UnitsInStock];

ALTER TABLE [dbo].[Products] ADD CONSTRAINT [DF_Products_UnitsOnOrder] DEFAULT ((0)) FOR [UnitsOnOrder];

ALTER TABLE [dbo].[Products] ADD CONSTRAINT [DF_Products_ReorderLevel] DEFAULT ((0)) FOR [ReorderLevel];

ALTER TABLE [dbo].[Products] ADD CONSTRAINT [DF_Products_Discontinued] DEFAULT ((0)) FOR [Discontinued];

CREATE INDEX CategoriesProducts
	ON [dbo].[Products] ( [CategoryID] );

CREATE INDEX CategoryID
	ON [dbo].[Products] ( [CategoryID] );

CREATE INDEX ProductName
	ON [dbo].[Products] ( [ProductName] );

CREATE INDEX SupplierID
	ON [dbo].[Products] ( [SupplierID] );

CREATE INDEX SuppliersProducts
	ON [dbo].[Products] ( [SupplierID] );

CREATE TABLE [dbo].[Order Details] (
	[OrderID] INT NOT NULL,
	[ProductID] INT NOT NULL,
	[UnitPrice] MONEY DEFAULT  NOT NULL,
	[Quantity] SMALLINT DEFAULT  NOT NULL,
	[Discount] REAL DEFAULT  NOT NULL,
	CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED ([OrderID] ASC, [ProductID] ASC) ON [PRIMARY],
	CONSTRAINT [CK_Quantity] CHECK ([Quantity]>(0)),
	CONSTRAINT [CK_UnitPrice] CHECK ([UnitPrice]>=(0)),
	CONSTRAINT [CK_Discount] CHECK ([Discount]>=(0) AND [Discount]<=(1)),
	CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders]([OrderID]),
	CONSTRAINT [FK_Order_Details_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products]([ProductID])
);


ALTER TABLE [dbo].[Order Details] ADD CONSTRAINT [DF_Order_Details_UnitPrice] DEFAULT ((0)) FOR [UnitPrice];

ALTER TABLE [dbo].[Order Details] ADD CONSTRAINT [DF_Order_Details_Quantity] DEFAULT (1) FOR [Quantity];

ALTER TABLE [dbo].[Order Details] ADD CONSTRAINT [DF_Order_Details_Discount] DEFAULT ((0)) FOR [Discount];

CREATE INDEX OrderID
	ON [dbo].[Order Details] ( [OrderID] );

CREATE INDEX OrdersOrder_Details
	ON [dbo].[Order Details] ( [OrderID] );

CREATE INDEX ProductID
	ON [dbo].[Order Details] ( [ProductID] );

CREATE INDEX ProductsOrder_Details
	ON [dbo].[Order Details] ( [ProductID] );

CREATE TABLE [dbo].[EmployeeTerritories] (
	[EmployeeID] INT NOT NULL,
	[TerritoryID] NVARCHAR(20) NOT NULL,
	CONSTRAINT [PK_EmployeeTerritories] PRIMARY KEY NONCLUSTERED ([EmployeeID] ASC, [TerritoryID] ASC) ON [PRIMARY],
	CONSTRAINT [FK_EmployeeTerritories_Territories] FOREIGN KEY ([TerritoryID]) REFERENCES [dbo].[Territories]([TerritoryID]),
	CONSTRAINT [FK_EmployeeTerritories_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees]([EmployeeID])
);

CREATE VIEW [dbo].[Alphabetical list of products]
AS SELECT Products.*, Categories.CategoryName
	FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
	WHERE (((Products.Discontinued)=0))
;

CREATE VIEW [dbo].[Product Sales for 1997]
AS SELECT Categories.CategoryName, Products.ProductName, 
	Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ProductSales
	FROM (Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID) 
		INNER JOIN (Orders 
			INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
		ON Products.ProductID = "Order Details".ProductID
	WHERE (((Orders.ShippedDate) Between '19970101' And '19971231'))
	GROUP BY Categories.CategoryName, Products.ProductName
;

CREATE VIEW [dbo].[Products by Category]
AS SELECT Categories.CategoryName, Products.ProductName, Products.QuantityPerUnit, Products.UnitsInStock, Products.Discontinued
	FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
	WHERE Products.Discontinued <> 1
;

CREATE VIEW [dbo].[Customer and Suppliers by City]
AS SELECT City, CompanyName, ContactName, 'Customers' AS Relationship 
	FROM Customers
	UNION SELECT City, CompanyName, ContactName, 'Suppliers'
	FROM Suppliers
;

CREATE VIEW [dbo].[Invoices]
AS SELECT Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode, 
		Orders.ShipCountry, Orders.CustomerID, Customers.CompanyName AS CustomerName, Customers.Address, Customers.City, 
		Customers.Region, Customers.PostalCode, Customers.Country, 
		(FirstName + ' ' + LastName) AS Salesperson, 
		Orders.OrderID, Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, Shippers.CompanyName As ShipperName, 
		"Order Details".ProductID, Products.ProductName, "Order Details".UnitPrice, "Order Details".Quantity, 
		"Order Details".Discount, 
		(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ExtendedPrice, Orders.Freight
	FROM 	Shippers INNER JOIN 
			(Products INNER JOIN 
				(
					(Employees INNER JOIN 
						(Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID) 
					ON Employees.EmployeeID = Orders.EmployeeID) 
				INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
			ON Products.ProductID = "Order Details".ProductID) 
		ON Shippers.ShipperID = Orders.ShipVia
;

CREATE VIEW [dbo].[Orders Qry]
AS SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, Orders.RequiredDate, 
		Orders.ShippedDate, Orders.ShipVia, Orders.Freight, Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, 
		Orders.ShipRegion, Orders.ShipPostalCode, Orders.ShipCountry, 
		Customers.CompanyName, Customers.Address, Customers.City, Customers.Region, Customers.PostalCode, Customers.Country
	FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
;

CREATE VIEW [dbo].[Quarterly Orders]
AS SELECT DISTINCT Customers.CustomerID, Customers.CompanyName, Customers.City, Customers.Country
	FROM Customers RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
	WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
;

CREATE VIEW [dbo].[Order Details Extended]
AS SELECT "Order Details".OrderID, "Order Details".ProductID, Products.ProductName, 
		"Order Details".UnitPrice, "Order Details".Quantity, "Order Details".Discount, 
		(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ExtendedPrice
	FROM Products INNER JOIN "Order Details" ON Products.ProductID = "Order Details".ProductID
;

CREATE VIEW [dbo].[Order Subtotals]
AS SELECT "Order Details".OrderID, Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS Subtotal
	FROM "Order Details"
	GROUP BY "Order Details".OrderID
;

CREATE VIEW [dbo].[Current Product List]
AS SELECT Product_List.ProductID, Product_List.ProductName
	FROM Products AS Product_List
	WHERE (((Product_List.Discontinued)=0))
;

CREATE VIEW [dbo].[Products Above Average Price]
AS SELECT Products.ProductName, Products.UnitPrice
	FROM Products
	WHERE Products.UnitPrice>(SELECT AVG(UnitPrice) From Products)
;
