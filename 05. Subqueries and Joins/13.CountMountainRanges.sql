  SELECT 
	  mc.[CountryCode],
 COUNT(m.[MountainRange]) AS [MountainRanges]
	FROM [MountainsCountries] AS mc
	JOIN [Mountains] AS m ON mc.[MountainId] = m.[Id]
  WHERE 
	  mc.[CountryCode] IN ('RU', 'BG', 'US')
  GROUP BY 
	  mc.[CountryCode]