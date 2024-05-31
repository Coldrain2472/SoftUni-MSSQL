CREATE PROCEDURE [usp_GetHoldersWithBalanceHigherThan] @number DECIMAL(20, 4)
	   AS
	BEGIN
			SELECT ah.[FirstName] AS [First Name],
				   ah.[LastName] AS [Last Name]
			     FROM [AccountHolders] AS ah
	             JOIN
				   (
					SELECT [AccountHolderId],
					   SUM([Balance]) AS [TotalMoney]
					  FROM [Accounts]
				  GROUP BY [AccountHolderId]
				   ) AS a ON ah.[Id] = a.[AccountHolderId]

			 WHERE a.[TotalMoney] > @number
		 ORDER BY ah.[FirstName], 
				  ah.[LastName]
	  END