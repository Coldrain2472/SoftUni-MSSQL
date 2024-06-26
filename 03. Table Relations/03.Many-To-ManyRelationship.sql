CREATE TABLE [Students]
  (
  [StudentID] INT PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(50) NOT NULL
  )

CREATE TABLE [Exams]
  (
  [ExamID] INT PRIMARY KEY IDENTITY(101, 1),
  [Name] NVARCHAR(100) NOT NULL
  )

CREATE TABLE [StudentsExams]
  (
  [StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL,
  [ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]) NOT NULL,
  PRIMARY KEY ([StudentID], [ExamID])
  )