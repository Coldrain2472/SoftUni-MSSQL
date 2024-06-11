CREATE DATABASE [NationalTouristSitesOfBulgaria]

USE [NationalTouristSitesOfBulgaria]

-- Problem 01

CREATE TABLE [Categories]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
	)

CREATE TABLE [Locations]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Municipality] VARCHAR(50),
	[Province] VARCHAR(50)
	)

CREATE TABLE [Sites]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[LocationId] INT FOREIGN KEY REFERENCES [Locations]([Id]) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[Establishment] VARCHAR(15)
	)

CREATE TABLE [Tourists]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Age] INT CHECK([Age] >= 0 AND [Age] <= 120) NOT NULL,
	[PhoneNumber] VARCHAR(20) NOT NULL,
	[Nationality] VARCHAR(30) NOT NULL,
	[Reward] VARCHAR(20)
	)

CREATE TABLE [SitesTourists]
	(
	[TouristId] INT FOREIGN KEY REFERENCES [Tourists]([Id]) NOT NULL,
	[SiteId] INT FOREIGN KEY REFERENCES [Sites]([Id]) NOT NULL
	PRIMARY KEY([TouristId], [SiteId])
	)

CREATE TABLE [BonusPrizes]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
	)

CREATE TABLE [TouristsBonusPrizes]
	(
	[TouristId] INT FOREIGN KEY REFERENCES [Tourists]([Id]) NOT NULL,
	[BonusPrizeId] INT FOREIGN KEY REFERENCES [BonusPrizes]([Id]) NOT NULL
	PRIMARY KEY([TouristId], [BonusPrizeId])
	)

-- Problem 02

INSERT INTO [Tourists]([Name], [Age], [PhoneNumber], [Nationality], [Reward])
	VALUES
		('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
		('Peter Bosh', 48, '+447911844141', 'UK', NULL),
		('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
		('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
		('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO [Sites]([Name], [LocationId], [CategoryId], [Establishment])
	VALUES
	('Ustra fortress', 90, 7, 'X'),
	('Karlanovo Pyramids', 65, 7, NULL),
	('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
	('Sinite Kamani Natural Park', 17, 1, NULL),
	('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

-- Problem 03

UPDATE [Sites]
SET [Establishment] = '(not defined)'
WHERE [Establishment] IS NULL

-- Problem 04

DELETE
FROM [TouristsBonusPrizes]
WHERE [BonusPrizeId] = 5

DELETE
FROM [BonusPrizes]
WHERE [Name] = 'Sleeping bag'

-- Problem 05

  SELECT 
	[Name],
	[Age],
	[PhoneNumber],
	[Nationality]
    FROM 
	[Tourists]
ORDER BY 
	[Nationality],
	[Age] DESC,
	[Name]

-- Problem 06

  SELECT 
	   s.[Name] AS [Site],
	   l.[Name] AS [Location],
	   s.[Establishment],
	   c.[Name] AS [Category]
    FROM [Sites] AS s
	JOIN [Locations] AS l ON l.[Id] = s.[LocationId]
	JOIN [Categories] AS c ON c.[Id] = s.[CategoryId]
ORDER BY 
	   c.[Name] DESC,
	   l.[Name],
	   s.[Name]

-- Problem 07

  SELECT 
	   l.[Province],
	   l.[Municipality],
	   l.[Name] AS [Location],
	   COUNT(*) AS [Sites]
    FROM [Locations] AS l
    JOIN [Sites] AS s ON s.[LocationId] = l.[Id]
	WHERE 
	   l.[Province] = 'Sofia'
GROUP BY 
	   l.[Province], 
	   l.[Municipality], 
	   l.[Name]
ORDER BY 
	     [Sites] DESC,
	     [Location]

-- Problem 08

  SELECT 
	   s.[Name] AS [Site],
       l.[Name] AS [Location],
       l.[Municipality],
       l.[Province],
       s.[Establishment]
    FROM [Sites] AS s
    JOIN [Locations] AS l ON l.[Id] = s.[LocationId]
   WHERE 
	   l.[Name] NOT LIKE 'B%' 
	AND l.[Name] NOT LIKE 'M%' 
   AND l.[Name] NOT LIKE 'D%' 
   AND s.[Establishment] LIKE '%BC'
ORDER BY
       s.[Name]

-- Problem 09

   SELECT 
	    t.[Name],
	    t.[Age],
	    t.[PhoneNumber],
	    t.[Nationality],
	   CASE
		   WHEN bp.[Name] IS NULL 
		   THEN '(no bonus prize)'
	   ELSE bp.[Name]
	   END AS 'Reward'
     FROM [Tourists] AS t
LEFT JOIN [TouristsBonusPrizes] AS tbp ON tbp.[TouristId] = t.[Id]
LEFT JOIN [BonusPrizes] AS bp ON bp.[Id] = tbp.[BonusPrizeId]
 ORDER BY 
	    t.[Name]

-- Problem 10

SELECT
	SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name], 1) + 1, LEN(t.[Name])) AS [LastName],
	t.[Nationality],
	t.[Age],
	t.[PhoneNumber]
 FROM [Tourists] AS t
 JOIN [SitesTourists] AS st ON st.[TouristId] = t.[Id]
 JOIN [Sites] AS s ON s.[Id] = st.[SiteId]
WHERE 
	s.[CategoryId] = 8
GROUP BY 
SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name], 1)+1, LEN(t.[Name])), t.[Nationality], t.[Age], t.[PhoneNumber]
ORDER BY 
	  [LastName]

-- Problem 11

CREATE FUNCTION [udf_GetTouristsCountOnATouristSite](@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
RETURN
	(
		SELECT
			COUNT(t.[Id])
		FROM [SitesTourists] AS st
		JOIN [Sites] AS s ON s.[Id] = st.[SiteId]
		JOIN [Tourists] AS t ON t.[Id] = st.[TouristId]
		WHERE s.[Name] = @Site
	)
END
