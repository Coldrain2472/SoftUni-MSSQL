CREATE FUNCTION [ufn_IsWordComprised](@setOfLetters VARCHAR(50), @word VARCHAR(50))
	RETURNS BIT
	         AS
		  BEGIN
					DECLARE @wordIndex INT = 1
					  WHILE (@wordIndex <= LEN(@word))
					  BEGIN
							 DECLARE @currentSymbol CHAR = SUBSTRING(@word, @wordIndex, 1)
							 IF CHARINDEX(@currentSymbol, @setOfLetters) = 0
							 BEGIN
								 RETURN 0
							 END

							 SET @wordIndex += 1
						END
					 RETURN 1
			END