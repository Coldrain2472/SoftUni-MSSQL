CREATE TABLE [Directors](
  [Id] INT PRIMARY KEY IDENTITY,
  [DirectorName] VARCHAR(50) NOT NULL,
  [Notes] NVARCHAR(1000)
  )

CREATE TABLE [Genres](
  [Id] INT PRIMARY KEY IDENTITY,
  [GenreName] VARCHAR(50) NOT NULL,
  [Notes] NVARCHAR(1000)
  )

CREATE TABLE [Categories]
(
  [Id] INT PRIMARY KEY IDENTITY,
  [CategoryName] VARCHAR(50) NOT NULL,
  [Notes] NVARCHAR(1000)
)

CREATE TABLE [Movies]
(
  [Id] INT PRIMARY KEY IDENTITY,
  [Title] VARCHAR(50) NOT NULL,
  [DirectorId] INT FOREIGN KEY REFERENCES [Directors](Id) NOT NULL,
  [CopyrightYear] INT NOT NULL,
  [Length] TIME NOT NULL,
  [GenreId] INT FOREIGN KEY REFERENCES [Genres](Id) NOT NULL,
  [CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
  [Rating] DECIMAL(2, 1) NOT NULL,
  [Notes] NVARCHAR(1000)
)

INSERT INTO [Directors] VALUES
	('Steven Spielberg', NULL),
	('James Cameron', NULL),
	('Quentin Tarantino', NULL),
	('George Lucas', NULL),
	('Peter Jackson', NULL)

INSERT INTO [Genres] VALUES
	('Action', NULL),
	('Comedy', NULL),
	('Thriller', NULL),
	('Fantasy', NULL),
	('Horror', NULL)

INSERT INTO [Categories] VALUES
	('Short', NULL),
	('Long', NULL),
	('Biography', NULL),
	('Documentary', NULL),
	('TV', NULL)

INSERT INTO [Movies] VALUES
	('Meet The Parents', 1, 2000, '01:30:00', 2, 3, 9.4, NULL),
	('Meet the Fockers', 2, 2004, '02:55:00', 3, 4, 9.2, NULL),
	('Little Fockers', 3, 2010, '03:15:00', 4, 5, 9.0, NULL),
	('Spider-Man', 4, 2022, '02:34:00', 5, 1, 8.9, NULL),
	('Central Intelligence', 5, 2016, '02:19:00', 1, 2, 8.8, NULL)