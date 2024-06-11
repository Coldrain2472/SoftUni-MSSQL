CREATE DATABASE [Zoo]

USE [Zoo]

-- Problem 01

CREATE TABLE [Owners]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
	)

CREATE TABLE [AnimalTypes]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalType] VARCHAR(30) NOT NULL
	)

CREATE TABLE [Cages]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
	)

CREATE TABLE [Animals]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	[BirthDate] DATE NOT NULL,
	[OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
	[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
	)

CREATE TABLE [AnimalsCages]
	(
	[CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]) NOT NULL,
	[AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) NOT NULL
	PRIMARY KEY([CageId], [AnimalId])
	)

CREATE TABLE [VolunteersDepartments]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[DepartmentName] VARCHAR(30) NOT NULL
	)

CREATE TABLE [Volunteers]
	(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	[AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
	[DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments]([Id]) NOT NULL
	)

-- Problem 02

INSERT INTO [Volunteers]([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
	VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO [Animals]([Name], [BirthDate], [OwnerId], [AnimalTypeId])
	VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)

-- Problem 03

UPDATE [Animals]
SET [OwnerId] = 4
WHERE [OwnerId] IS NULL

-- Problem 04

DELETE
FROM [Volunteers]
WHERE [DepartmentId] = 2

DELETE
FROM [VolunteersDepartments]
WHERE [DepartmentName] = 'Education program assistant'

-- Problem 05

  SELECT 
	[Name],
	[PhoneNumber],
	[Address],
	[AnimalId],
	[DepartmentId]
    FROM 
	[Volunteers]
ORDER BY 
	[Name], 
	[AnimalId], 
	[DepartmentId]

-- Problem 06

  SELECT 
	   a.[Name],
	  at.[AnimalType],
	FORMAT(a.[BirthDate], 'dd.MM.yyyy')
	FROM [Animals] AS A
	JOIN [AnimalTypes] AS at ON at.[Id] = a.[AnimalTypeId]
ORDER BY 
	   a.[Name]

-- Problem 07

  SELECT TOP(5)
	   o.[Name] AS [Owner],
	 COUNT(*) AS [CountOfAnimals]
	FROM [Owners] AS o
	JOIN [Animals] AS a ON a.[OwnerId] = o.[Id]
GROUP BY 
	   o.[Name]
ORDER BY [CountOfAnimals] DESC,
		 [Owner]

-- Problem 08

  SELECT
	CONCAT(o.[Name], '-', a.[Name]) AS [Owners-Animals],
	   o.[PhoneNumber],
	   c.[Id] AS [CageId]
	FROM [Owners] AS o
	JOIN [Animals] AS a ON a.[OwnerId] = o.[Id]
	JOIN [AnimalTypes] AS ant ON ant.[Id] = a.[AnimalTypeId]
	JOIN [AnimalsCages] AS ac ON ac.[AnimalId] = a.[Id]
	JOIN [Cages] AS c ON c.[Id] = ac.[CageId]
	WHERE 
	 ant.[AnimalType] = 'mammals'
 ORDER BY 
	   o.[Name],
	   a.[Name] DESC

-- Problem 09

  SELECT 
	   v.[Name],
	   v.[PhoneNumber],
	   SUBSTRING(v.[Address], CHARINDEX(',', v.[Address]) + 2, LEN(v.[Address])) AS [Address]
	FROM [Volunteers] AS v
	JOIN [VolunteersDepartments] AS vd ON vd.[Id] = v.[DepartmentId]
   WHERE 
	  vd.[DepartmentName] = 'Education program assistant' AND v.[Address] LIKE '%Sofia%'
ORDER BY 
	   v.[Name]

-- Problem 10

	SELECT 
		 a.[Name],
	YEAR(a.[BirthDate]) AS [BirthYear],
	   ant.[AnimalType]
	  FROM [Animals] AS a
	  JOIN [AnimalTypes] AS ant ON ant.[Id] = a.[AnimalTypeId]
	 WHERE 
		 a.[OwnerId] IS NULL AND AnimalTypeId != 3 AND DATEDIFF(YEAR, BirthDate, '01/01/2022') < 5
  ORDER BY 
		 a.[Name]

-- Problem 11

CREATE FUNCTION [udf_GetVolunteersCountFromADepartment](@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
BEGIN
		RETURN
		(
		SELECT 
			COUNT(v.[Id])
		FROM [VolunteersDepartments] AS vd
		JOIN [Volunteers] AS v ON v.[DepartmentId] = vd.[Id]
		WHERE vd.[DepartmentName] = @VolunteersDepartment
		GROUP BY vd.[DepartmentName]
		)
END

-- Problem 12

CREATE PROCEDURE [usp_AnimalsWithOwnersOrNot](@AnimalName VARCHAR(30)) 
AS
BEGIN
		IF (SELECT [OwnerId] FROM [Animals] WHERE [Name] = @AnimalName) IS NULL
		BEGIN 
			SELECT [Name], 'For adoption' AS [OwnerName]
			FROM [Animals]
			WHERE [Name] = @AnimalName
		END
	ELSE
		BEGIN
			SELECT a.[Name], o.[Name] AS [OwnerName]
				FROM [Animals] AS a
				JOIN [Owners] AS o ON o.[Id] = a.[OwnerId]
				WHERE a.[Name] = @AnimalName
		END
END