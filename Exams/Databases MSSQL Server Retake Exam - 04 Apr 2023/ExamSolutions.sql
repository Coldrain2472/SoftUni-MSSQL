CREATE DATABASE [Accounting]

USE [Accounting]

-- Problem 01

CREATE TABLE [Countries]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(10) NOT NULL
  )

CREATE TABLE [Addresses]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [StreetName] NVARCHAR(20) NOT NULL,
  [StreetNumber] INT NOT NULL,
  [PostCode] INT NOT NULL,
  [City] VARCHAR(25) NOT NULL,
  [CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) NOT NULL
  )

CREATE TABLE [Vendors]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(25) NOT NULL,
  [NumberVAT] NVARCHAR(15) NOT NULL,
  [AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
  )

CREATE TABLE [Clients]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(25) NOT NULL,
  [NumberVAT] NVARCHAR(15) NOT NULL,
  [AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
  )

CREATE TABLE [Categories]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(10) NOT NULL
  )

CREATE TABLE [Products]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(25) NOT NULL,
  [Price] DECIMAL(18, 2) NOT NULL,
  [CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
  [VendorId] INT FOREIGN KEY REFERENCES [Vendors]([Id]) NOT NULL
  )

CREATE TABLE [Invoices]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Number] INT UNIQUE NOT NULL,
  [IssueDate] DATETIME2 NOT NULL,
  [DueDate] DATETIME2 NOT NULL,
  [Amount] DECIMAL(18, 2) NOT NULL,
  [Currency] VARCHAR(5) NOT NULL,
  [ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
  )

CREATE TABLE [ProductsClients]
  (
  [ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]) NOT NULL,
  [ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
  PRIMARY KEY([ProductId], [ClientId])
  )

-- Problem 02

INSERT INTO [Products]([Name], [Price], [CategoryId], [VendorId])
	VALUES
  ('SCANIA Oil Filter XD01', 78.69, 1, 1),
  ('MAN Air Filter XD01', 97.38, 1, 5),
  ('DAF Light Bulb 05FG87', 55.00, 2, 13),
  ('ADR Shoes 47-47.5', 49.85, 3, 5),
  ('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO [Invoices]([Number], [IssueDate], [DueDate], [Amount], [Currency], [ClientId])
	VALUES
  (1219992181, '2023-03-01', '2023-04-30', 180.96, 'BGN', 3),
  (1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
  (1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD', 19)

-- Problem 03

	   UPDATE [Invoices]
		    SET [DueDate] = '2023-04-01'
 WHERE YEAR([IssueDate]) = 2022 AND MONTH([IssueDate]) = 11

	 UPDATE [Clients]
		  SET [AddressId] = 3
	  WHERE [Name] LIKE '%CO%'

-- Problem 04

DECLARE @clientId INT =
(
	SELECT [Id] FROM [Clients]
	WHERE [NumberVAT] LIKE 'IT%'
)

DELETE FROM [ProductsClients]
WHERE [ClientId] = @clientId

DELETE FROM [Invoices]
WHERE [ClientId] = @clientId

DELETE FROM [Clients]
WHERE [NumberVAT] LIKE 'IT%'

-- Problem 05

  SELECT [Number], 
		     [Currency]
	  FROM [Invoices]
ORDER BY [Amount] DESC,
		     [DueDate] 

-- Problem 06

 SELECT 
	  p.[Id],
	  p.[Name],
	  p.[Price],
	  c.[Name] AS [CategoryName]
   FROM [Products] AS p
   JOIN [Categories] AS c ON c.[Id] = p.[CategoryId]
  WHERE 
	  c.[Name] = 'ADR' OR c.[Name] = 'Others'
  ORDER BY 
	  p.[Price] DESC

-- Problem 07

 SELECT 
	c.[Id],
	c.[Name] AS [Client],
  CONCAT( a.[StreetName], ' ', a.[StreetNumber], ', ', a.[City], ', ', a.[PostCode], ', ', co.[Name]) AS [Address]
 FROM [Clients] AS c
 JOIN [Addresses] AS a ON a.[Id] = c.[AddressId]
 JOIN [Countries] AS co ON co.[Id] = a.[CountryId]
 LEFT JOIN 
	  [ProductsClients] AS pc ON pc.[ClientId] = c.[Id]
 WHERE 
   pc.[ProductId] IS NULL
 ORDER BY 
	c.[Name]

-- Problem 08

	SELECT TOP(7)	
		i.[Number],
		i.[Amount],
		c.[Name] AS [Client]
	 FROM [Invoices] AS i
	 JOIN [Clients] AS c ON c.[Id] = i.[ClientId]
  WHERE i.[IssueDate] < '2023-01-01' AND i.[Currency] = 'EUR'
			OR
		i.[Amount] > 500.00 AND c.[NumberVAT] LIKE 'DE%'
 ORDER BY 
	    i.[Number],
	    i.[Amount] DESC

-- Problem 09

   SELECT 
		c.[Name] AS [Client],
	MAX(p.[Price]) AS [Price],
	    c.[NumberVAT] AS [VAT Number]
     FROM [Clients] AS c
LEFT JOIN 
	      [ProductsClients] AS pc ON pc.[ClientId] = c.[Id]
	 JOIN [Products] AS p ON p.[Id] = pc.ProductId
	WHERE 
		c.[Name] NOT LIKE '%KG'
 GROUP BY 
	    c.[Name], c.[NumberVAT]
 ORDER BY 
	MAX(p.[Price]) DESC

-- Problem 10

	SELECT 
		 c.[Name] AS [Client],
		 FLOOR(AVG(p.[Price])) AS [Average Price]
      FROM [Clients] AS c
 LEFT JOIN 
	       [ProductsClients] AS pc ON pc.[ClientId] = c.[Id]
	  JOIN [Products] AS p ON p.[Id] = pc.ProductId
	  JOIN [Vendors] AS v ON v.[Id] = p.[VendorId]
	 WHERE 
		 v.[NumberVAT] LIKE '%FR%'
  GROUP BY 
		 c.[Name]
  ORDER BY 
		   [Average Price],
		   [Client] DESC

-- Problem 11

CREATE OR ALTER FUNCTION [udf_ProductWithClients](@productName NVARCHAR(35))
RETURNS INT AS
BEGIN
	DECLARE @result INT =
	(
		SELECT
			COUNT(*)
		FROM [Clients] AS c
		JOIN [ProductsClients] AS pc ON pc.[ClientId] = c.[Id]
		JOIN [Products] AS p ON pc.[ProductId] = p.[Id]
	   WHERE 
		   p.[Name] = @productName
	GROUP BY 
		   p.[Id]
	)
	RETURN @result
END