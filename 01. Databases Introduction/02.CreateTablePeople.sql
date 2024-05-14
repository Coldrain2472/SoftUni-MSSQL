 CREATE TABLE [People] (
   [Id] INT PRIMARY KEY IDENTITY,
   [Name] NVARCHAR(200) NOT NULL,
   [Picture] VARBINARY(MAX),
   CHECK (DATALENGTH([Picture]) <= 2000000),
   [Height] DECIMAL(3, 2),
   [Weight] DECIMAL (5, 2),
   [Gender] CHAR(1) NOT NULL,
   CHECK ([Gender] = 'm' OR [Gender] = 'f'),
   [Birthdate] DATE NOT NULL,
   [Biography] NVARCHAR(MAX)
 )

 INSERT INTO [People]([Name], [Height], [Weight], [Gender], [Birthdate])
   VALUES
   ('Misho', 1.85, 110.0, 'm', '1993-03-02'),
   ('Sasho', NULL, NULL, 'm', '1992-11-20'),
   ('Ani', 1.59, 44.0, 'f', '2000-02-12'),
   ('Mitko', 1.70, 90.0, 'm', '1996-04-14'),
   ('Nigra', NULL, 20.0, 'f', '2020-03-15')