 CREATE TABLE [Users](
   [Id] BIGINT PRIMARY KEY IDENTITY,
   [Username] VARCHAR(30) NOT NULL,
   [Password] VARCHAR(26) NOT NULL,
   [ProfilePicture] VARBINARY(MAX),
   [LastLoginTime] DATE,
   [IsDeleted] BIT NOT NULL
   )

 INSERT INTO [Users]([Username], [Password], [IsDeleted])
   VALUES
   ('sadserpent', '123456789', 0),
   ('sneakypants', 'asdasd123', 1),
   ('superpants', 'qwertyzxcv', 0),
   ('kimchilover', 'musaka', 0),
   ('sunflower', 'flowers789', 0)