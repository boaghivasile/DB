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

Ex.2

DECLARE @TEST INTEGER	
DECLARE @LIMIT INTEGER
DECLARE @INDEX INTEGER
DECLARE @NUME CHAR(40)
DECLARE @PRENUME CHAR(40)
SET @INDEX = 100
set @LIMIT = 1
WHILE(@LIMIT <= 10)
		BEGIN 
			SET @TEST = (SELECT sr.Nota FROM studenti_reusita as sr 
							WHERE sr.Id_Disciplina = 107 AND sr.Tip_Evaluare = 'Testul 1' AND sr.Id_Student = @INDEX )
							SET @NUME = (SELECT distinct Nume_Student
										 FROM studenti as st
										 WHERE st.Id_Student = @INDEX)
							SET @PRENUME = (SELECT distinct Prenume_Student
										 FROM studenti as st
										 WHERE st.Id_Student = @INDEX)

			 IF(@TEST = 6 OR @TEST = 8 )  
				BEGIN
			PRINT  'Nume: ' + CAST(@NUME as char(15))  + 'Prenume: ' + CAST(@PRENUME as char(15)) + 'Nota nu coincide cu conditia: ' + CAST(@TEST as char(3))
				END

			ELSE IF (@TEST <> 6 AND @TEST <> 8)
				BEGIN
					SET @LIMIT = @LIMIT + 1
					PRINT 'Nume: ' + CAST(@NUME as char(15)) + 'Prenume: ' + CAST(@PRENUME as char(15)) + 'Nota: ' + CAST(@TEST as char(3)) 
				END
			
			SET @INDEX = @INDEX + 1
		END

Ex.3

DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Cel mai mare = ' + CAST(
	CASE
		WHEN @N1 >= @N2 AND @N1 > @N3 THEN @N1
		WHEN @N2 > @N1 AND @N2 > @N3 THEN @N2
		WHEN @N3 >= @N1 AND @N3 > @N2 THEN @N3
	END
as varchar(2))

Ex.4.A

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

Ex.4.B

DECLARE @TEST INTEGER	
DECLARE @LIMIT INTEGER
DECLARE @INDEX INTEGER
DECLARE @NUME CHAR(40)
DECLARE @PRENUME CHAR(40)
SET @INDEX = 100
set @LIMIT = 1
IF @LIMIT IS NULL RAISERROR('You must set the limit', 1, 1)
IF @INDEX IS NULL RAISERROR('You must give the index of the first element', 1, 1)
IF @TEST IS NULL RAISERROR('Your querry does not provide you a mark', 1, 1)
WHILE(@LIMIT <= 10)
		BEGIN 
			SET @TEST = (SELECT sr.Nota FROM studenti_reusita as sr 
							WHERE sr.Id_Disciplina = 107 AND sr.Tip_Evaluare = 'Testul 1' AND sr.Id_Student = @INDEX )
							SET @NUME = (SELECT distinct Nume_Student
										 FROM studenti as st
										 WHERE st.Id_Student = @INDEX)
							SET @PRENUME = (SELECT distinct Prenume_Student
										 FROM studenti as st
										 WHERE st.Id_Student = @INDEX)

			 IF(@TEST = 6 OR @TEST = 8 )  
				BEGIN
			PRINT  'Nume: ' + CAST(@NUME as char(15))  + 'Prenume: ' + CAST(@PRENUME as char(15)) + 'Nota nu coincide cu conditia: ' + CAST(@TEST as char(3))
				END

			ELSE IF (@TEST <> 6 AND @TEST <> 8)
				BEGIN
					SET @LIMIT = @LIMIT + 1
					PRINT 'Nume: ' + CAST(@NUME as char(15)) + 'Prenume: ' + CAST(@PRENUME as char(15)) + 'Nota: ' + CAST(@TEST as char(3)) 
				END
			
			SET @INDEX = @INDEX + 1
		END