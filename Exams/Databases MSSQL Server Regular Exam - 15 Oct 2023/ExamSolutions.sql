CREATE DATABASE [TouristAgency]

USE [TouristAgency]

-- Problem 01

CREATE TABLE [Countries]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(50) NOT NULL
  )

CREATE TABLE [Destinations]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(50) NOT NULL,
  [CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) NOT NULL
  )

CREATE TABLE [Rooms]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Type] VARCHAR(40) NOT NULL,
  [Price] DECIMAL(18, 2) NOT NULL,
  [BedCount] INT CHECK([BedCount] > 0 AND [BedCount] <= 10) NOT NULL
  )

CREATE TABLE [Hotels]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(50) NOT NULL,
  [DestinationId] INT FOREIGN KEY REFERENCES [Destinations]([Id]) NOT NULL
  )

CREATE TABLE [Tourists]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(80) NOT NULL,
  [PhoneNumber] VARCHAR(20) NOT NULL,
  [Email] VARCHAR(80) NOT NULL,
  [CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) NOT NULL
  )

CREATE TABLE [Bookings]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [ArrivalDate] DATETIME2 NOT NULL,
  [DepartureDate] DATETIME2 NOT NULL,
  [AdultsCount] INT CHECK([AdultsCount] >= 1 AND [AdultsCount] <= 10) NOT NULL,
  [ChildrenCount] INT CHECK([ChildrenCount] >= 0 AND [ChildrenCount] <= 9) NOT NULL,
  [TouristId] INT FOREIGN KEY REFERENCES [Tourists]([Id]) NOT NULL,
  [HotelId] INT FOREIGN KEY REFERENCES [Hotels]([Id]) NOT NULL,
  [RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id]) NOT NULL
  )

CREATE TABLE [HotelsRooms]
  (
  [HotelId] INT	FOREIGN KEY REFERENCES [Hotels]([Id]) NOT NULL,
  [RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id]) NOT NULL
  PRIMARY KEY([HotelId], [RoomId])
  )

-- Problem 02

INSERT INTO [Tourists]([Name], [PhoneNumber], [Email], [CountryId])
	VALUES
  ('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
  ('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
  ('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
  ('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
  ('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

INSERT INTO [Bookings]([ArrivalDate], [DepartureDate], [AdultsCount], [ChildrenCount], [TouristId], [HotelId], [RoomId])
	VALUES
 ('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
 ('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
 ('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
 ('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
 ('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)

-- Problem 03

UPDATE [Bookings]
   SET [DepartureDate] = DATEADD(DAY, 1, [DepartureDate])
WHERE MONTH([DepartureDate]) = 12

UPDATE [Tourists]
SET Email = NULL
 WHERE [Name] LIKE '%MA%'

-- Problem 04
  DELETE 
  FROM [Bookings]
 WHERE [TouristId] IN (6, 16, 25)

  DELETE 
  FROM [Tourists]
 WHERE [Name] LIKE '%Smith'