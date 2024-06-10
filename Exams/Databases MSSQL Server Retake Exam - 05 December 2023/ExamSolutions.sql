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