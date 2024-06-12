CREATE DATABASE [Airport]

USE [Airport]

-- Problem 01

CREATE TABLE [Passengers]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[FullName] VARCHAR(100) UNIQUE NOT NULL,
	[Email] VARCHAR(50) UNIQUE NOT NULL
	)

CREATE TABLE [Pilots]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(30) UNIQUE NOT NULL,
	[LastName] VARCHAR(30) UNIQUE NOT NULL,
	[Age] TINYINT CHECK([Age] >= 21 AND [Age] <= 62) NOT NULL,
	[Rating] FLOAT CHECK([Rating] >= 0.0 AND [Rating] <= 10.0)
	)

CREATE TABLE [AircraftTypes]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[TypeName] VARCHAR(30) UNIQUE NOT NULL
	)

CREATE TABLE [Aircraft]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Manufacturer] VARCHAR(25) NOT NULL,
	[Model] VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	[FlightHours] INT,
	[Condition] CHAR NOT NULL,
	[TypeId] INT FOREIGN KEY REFERENCES [AircraftTypes]([Id]) NOT NULL
	)

CREATE TABLE [PilotsAircraft]
	(
	[AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL,
	[PilotId] INT FOREIGN KEY REFERENCES [Pilots]([Id]) NOT NULL
	PRIMARY KEY([AircraftId], [PilotId])
	)

CREATE TABLE [Airports]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[AirportName] VARCHAR(70) UNIQUE NOT NULL,
	[Country] VARCHAR(100) UNIQUE NOT NULL
	)

CREATE TABLE [FlightDestinations]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[AirportId] INT FOREIGN KEY REFERENCES [Airports]([Id]) NOT NULL,
	[Start] DATETIME NOT NULL,
	[AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL,
	[PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL,
	[TicketPrice] DECIMAL(18, 2) NOT NULL DEFAULT 15
	)

-- Problem 02

INSERT INTO [Passengers]([FullName], [Email])
SELECT 
    [FirstName] + ' ' + [LastName] AS [FullName],
    REPLACE([FirstName] + [LastName], ' ', '') + '@gmail.com' AS [Email]
FROM 
    [Pilots]
WHERE 
    [Id] BETWEEN 5 AND 15