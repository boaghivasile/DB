DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 28;
SET @N2 = 32;
SET @N3 = 32;

BEGIN TRY
	IF @N1 is NULL THROW 1, 'N1 is missing', 1
	IF @N2 is NULL THROW 1, 'N2 is missing', 1
	IF @N3 is NULL THROW 1, 'N3 is missing', 1
	
	IF @N1 >= @N2
			IF @N1 > @N3 SET @MAI_MARE = @N1
			else SET @MAI_MARE = @N3
	ELSE 
			IF @N2 >= @N3 SET @MAI_MARE = @N2
			ELSE SET @MAI_MARE = @N3
END TRY

BEGIN CATCH
	PRINT 'You forgot to a variale'
END CATCH

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Cel mai mare = ' + CAST(@MAI_MARE as varchar(2));


