CREATE TABLE [Teachers]
  (
  [TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
  [Name] NVARCHAR(50) NOT NULL,
  [ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
  )