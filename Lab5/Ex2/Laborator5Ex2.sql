DECLARE @TEST INTEGER
DECLARE @LIMIT INTEGER
DECLARE @INDEX INTEGER
SET @INDEX = 100
set @LIMIT = 1
WHILE(@LIMIT <= 10 )
		BEGIN 
			SET @test = (SELECT sr.Nota FROM studenti_reusita as sr 
							WHERE sr.Id_Disciplina = 107 AND sr.Tip_Evaluare = 'Testul 1' AND sr.Id_Student = @INDEX )

			IF (@TEST <> 6 AND @TEST <> 8)
				(SELECT st.Nume_student, st.Prenume_Student
				FROM studenti as st
					JOIN (SELECT *
						  FROM studenti_reusita as sr
					      WHERE Tip_Evaluare = 'Testul 1' AND sr.Id_Disciplina = 107 ) as srt
					ON st.Id_Student = srt.Id_Student
					WHERE srt.Id_Student = @INDEX)

			ELSE PRINT 'OPS'
			SET @LIMIT = @LIMIT + 1
			SET @INDEX = @INDEX + 1
		END
