DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();

IF @N1 >= @N2
	
		IF @N1 > @N3 SET @MAI_MARE = @N1
		else SET @MAI_MARE = @N3
	
ELSE 

		IF @N2 >= @N3 SET @MAI_MARE = @N2
		ELSE SET @MAI_MARE = @N3


PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Cel mai mare = ' + CAST(@MAI_MARE as varchar(2));
