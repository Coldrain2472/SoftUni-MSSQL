CREATE DATABASE [RailwaysDb]

USE [RailwaysDb]

-- Problem 01

CREATE TABLE [Passengers]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL
	)

CREATE TABLE [Towns]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
	)

CREATE TABLE [RailwayStations]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL
	)

CREATE TABLE [Trains]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[HourOfDeparture] VARCHAR(5) NOT NULL,
	[HourOfArrival] VARCHAR(5) NOT NULL,
	[DepartureTownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL,
	[ArrivalTownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL
	)

CREATE TABLE [TrainsRailwayStations]
	(
	[TrainId] INT FOREIGN KEY REFERENCES [Trains]([Id]) NOT NULL,
	[RailwayStationId] INT FOREIGN KEY REFERENCES [RailwayStations]([Id]) NOT NULL
	PRIMARY KEY([TrainId], [RailwayStationId])
	)

CREATE TABLE [MaintenanceRecords]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[DateOfMaintenance] DATE NOT NULL,
	[Details] VARCHAR(2000) NOT NULL,
	[TrainId] INT FOREIGN KEY REFERENCES [Trains]([Id]) NOT NULL
	)

CREATE TABLE [Tickets]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Price] DECIMAL(10, 2) NOT NULL,
	[DateOfDeparture] DATE NOT NULL,
	[DateOfArrival] DATE NOT NULL,
	[TrainId] INT FOREIGN KEY REFERENCES [Trains]([Id]) NOT NULL,
	[PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL
	)

-- Problem 02

INSERT INTO [Trains]([HourOfDeparture], [HourOfArrival], [DepartureTownId], [ArrivalTownId])
	VALUES
	('07:00', '19:00', 1, 3),
	('08:30', '20:30', 5, 6),
	('09:00', '21:00', 4, 8),
	('06:45', '03:55', 27, 7),
	('10:15', '12:15', 15, 5)

INSERT INTO [TrainsRailwayStations]([TrainId], [RailwayStationId])
	VALUES
	(36, 1),
	(36, 4),
	(36, 31),
	(36, 57),
	(36, 7),
	(37, 13),
	(37, 54),
	(37, 60),
	(37, 16),
	(38, 10),
	(38, 50),
	(38, 52),
	(38, 22),
	(39, 68),
	(39, 3),
	(39, 31),
	(39, 19),
	(40, 41),
	(40, 7),
	(40, 52),
	(40, 13)

INSERT INTO [Tickets]([Price], [DateOfDeparture], [DateOfArrival], [TrainId], [PassengerId])
	VALUES
	(90.00, '2023-12-01', '2023-12-01', 36, 1),
	(115.00, '2023-08-02', '2023-08-02', 37, 2),
	(160.00, '2023-08-03', '2023-08-03', 38, 3),
	(255.00, '2023-09-01', '2023-09-02', 39, 21),
	(95.00, '2023-09-02', '2023-09-03', 40, 22)

-- Problem  03

UPDATE [Tickets]
SET [DateOfDeparture] = DATEADD(DAY, 7, [DateOfDeparture])
WHERE [DateOfDeparture] > '2023-10-31'

UPDATE [Tickets]
SET [DateOfArrival] = DATEADD(DAY, 7, [DateOfArrival])
WHERE [DateOfArrival] > '2023-10-31'

-- Problem 04

DECLARE @BerlinId INT
DECLARE @TrainId INT

SELECT @BerlinId = [Id] FROM [Towns] WHERE [Name] = 'Berlin'
SELECT @TrainId = [Id] FROM [Trains] WHERE [DepartureTownId] = @BerlinId

DELETE 
FROM [TrainsRailwayStations]
WHERE [TrainId] = @TrainId

DELETE 
FROM [Tickets]
WHERE [TrainId] = @TrainId

DELETE 
FROM [MaintenanceRecords]
WHERE [TrainId] = @TrainId

DELETE 
FROM [Trains]
WHERE [Id] = @TrainId

-- Problem 05

   SELECT 
		  [DateOfDeparture],
		  [Price] AS [TicketPrice]
     FROM [Tickets]
 ORDER BY [Price],
		  [DateOfDeparture] DESC

-- Problem 06

	SELECT 
		p.[Name],
		t.[Price] AS [TicketPrice],
		t.[DateOfDeparture],
		t.[TrainId]
	 FROM [Tickets] AS t
	 JOIN [Passengers] AS p ON p.[Id] = t.[PassengerId]
 ORDER BY 
	    t.[Price] DESC,
		p.[Name]

-- Problem 07

	SELECT 
		 t.[Name] AS [Town],
		rs.[Name] AS [RailwayStation]
	  FROM 
		   [RailwayStations] AS rs
	  JOIN 
		   [Towns] AS t ON rs.[TownId] = T.[Id]
 LEFT JOIN 
		   [TrainsRailwayStations] AS trs ON rs.[Id] = trs.[RailwayStationId]
	 WHERE 
	   trs.[RailwayStationId] IS NULL
  ORDER BY 
		 t.[Name],
		rs.[Name]

-- Problem 08

  SELECT TOP(3)
	  tr.[Id] AS [TrainId],
	  tr.[HourOfDeparture],
	  tc.[Price] AS [TicketPrice],
	   t.[Name] AS [Destination]	
	FROM [Trains] AS tr
	JOIN [Tickets] AS tc ON tr.[Id] = tc.[TrainId]
	JOIN [Towns] AS t ON t.[Id] = tr.[ArrivalTownId]
   WHERE 
	  tr.[HourOfDeparture] LIKE '08:%' AND tc.[Price] > 50
ORDER BY 
	  tc.[Price], 
	  tr.[DepartureTownId]

-- Problem 09

  SELECT 
		 tn.[Name] AS [TownName],
		COUNT(*) AS [PassengersCount]
    FROM [Tickets] AS t
    JOIN [Passengers] AS p ON p.[Id] = t.[PassengerId]
	JOIN [Trains] AS tr ON tr.[Id] = t.[TrainId]
	JOIN [Towns] as tn ON tn.[Id] = tr.[ArrivalTownId]
	WHERE
	   t.[Price] > 76.99
 GROUP BY 
	  tn.[Name]
 ORDER BY 
	  tn.[Name]

-- Problem 10  

  SELECT 
		 tr.[Id] AS [TrainId],
		  t.[Name] AS [DepartureTown],
		 mr.[Details]
	FROM [Trains] AS tr
	JOIN [MaintenanceRecords] AS mr ON tr.[Id] = mr.[TrainId]
	JOIN [Towns] AS t ON t.[Id] = tr.[DepartureTownId]
   WHERE 
	  mr.[Details] LIKE '%inspection%'
ORDER BY 
	  tr.[Id]

-- Problem 11

CREATE FUNCTION [udf_TownsWithTrains](@Name VARCHAR(30))
	RETURNS INT
			 AS
		  BEGIN

				DECLARE @Count INT
				DECLARE @TownId INT

				SELECT @TownId = [Id]
				  FROM [Towns]
				 WHERE [Name] = @Name;
				SELECT @Count = COUNT(*) 
				  FROM [Trains]
				 WHERE [ArrivalTownId] = @TownId OR [DepartureTownId] = @TownId

				RETURN @Count

		   END

-- Problem 12

CREATE PROCEDURE [usp_SearchByTown](@TownName VARCHAR(50)) 
		 AS
	  BEGIN
			DECLARE @TownId INT

			 SELECT @TownId = [Id]
			   FROM [Towns]
			  WHERE [Name] = @TownName;

			  SELECT 
					  p.[Name] AS [PassengerName],
					 ti.[DateOfDeparture],
					 tr.[HourOfDeparture]
				FROM [Trains] AS tr
				JOIN [Tickets] AS ti ON tr.[Id] = ti.[TrainId]
				JOIN [Passengers] AS p ON ti.[PassengerId] = p.[Id]
			   WHERE tr.[ArrivalTownId] = @TownId
			ORDER BY ti.[DateOfDeparture] DESC, 
					  p.[Name]

		END