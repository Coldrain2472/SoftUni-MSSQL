CREATE PROCEDURE [usp_GetTownsStartingWith] @townName VARCHAR(50)
			   AS
			BEGIN
						SELECT [Name] AS [Town]
						  FROM [Towns]
						 WHERE [Name] LIKE @townName + '%'
			  END