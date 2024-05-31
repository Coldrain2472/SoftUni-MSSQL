CREATE FUNCTION [ufn_CalculateFutureValue] (@sum DECIMAL(20, 4), @yearlyInterestRate FLOAT, @years INT)
RETURNS DECIMAL(20, 4)
		AS
	 BEGIN
		   RETURN @sum * POWER(1 + @yearlyInterestRate, @years)
	   END
