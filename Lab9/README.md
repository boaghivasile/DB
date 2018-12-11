<p><b><h2> Task 1 </h2></b></p>
<pSă se creeze proceduri stocate în baza exercițiilor (2 exerciții) din capitolul 4. 
Parametrii de intrare trebuie să corespundă criteriilor din clauzele WHERE ale exercițiilor respective.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.1.PNG"  />

```sql
/* 27.Afisati studentii (identificatorii) care au sustinut (evaluarea examen) la toate disciplinele predate de prof.Ion. */
SELECT distinct sr.Id_Student
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')

GO
CREATE PROCEDURE Procedure1
@NOTA INT,
@TIP_EVALUARE VARCHAR(20),
@NUME_PROFESOR VARCHAR(20),
@PRENUME_PROFESOR VARCHAR(20)
AS
BEGIN
	SELECT DISTINCT sr.Id_Student
	FROM studenti_reusita AS sr
	JOIN profesori AS pr
	ON sr.Id_Profesor = pr.Id_Profesor
	WHERE sr.Nota >= @NOTA AND sr.Tip_Evaluare = @TIP_EVALUARE 
		AND (pr.Nume_Profesor = @NUME_PROFESOR OR pr.Prenume_Profesor = @PRENUME_PROFESOR)
END

EXECUTE Procedure1 5, 'Examen', 'Ion', 'Ion';

----------------------------------------------------------------------------------------------------------------------

/* 35.Gasiti denuumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari ca 7.0. */

SELECT distinct dis.Disciplina, (SELECT AVG(CAST(sr1.Nota AS FLOAT)) 
FROM studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) as Media
FROM studenti_reusita AS sr
JOIN discipline AS dis
ON sr.Id_Disciplina = dis.Id_Disciplina
WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) from studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7

GO 
CREATE PROCEDURE Procedure3
@NOTA INT
AS 
BEGIN
	SELECT DISTINCT dis.Disciplina, (SELECT AVG(CAST(sr1.NOTA AS FLOAT))
		FROM studenti.studenti_reusita AS sr1 
		WHERE sr.Id_Disciplina = sr1.Id_Disciplina) AS Media
	FROM studenti.studenti_reusita AS sr
	JOIN plan_studii.discipline AS dis
	ON sr.Id_Disciplina = dis.Id_Disciplina
	WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) 
		FROM studenti.studenti_reusita AS sr1 
		WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > @NOTA
END

EXECUTE Procedure3 7;
```

<p><b><h2> Task 2 </h2></b></p> 
<p>Să se creeze o procedură stocată, care nu are niciun parametru de intrare si posedă un parametru de ieșire. Parametrul de ieșire trebuie să returneze numărul de studenți, care nu au susținut cel puțin o formă de evaluare (nota mai mică de 5 sau valoare NULL).</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.2.PNG"  />

```sql
GO
CREATE PROCEDURE Procedure4
@RESULT INT OUTPUT
AS
BEGIN
	SET @result = (
		SELECT COUNT(DISTINCT Id_Student)
		FROM studenti.studenti_reusita AS sr1
		WHERE sr1.Nota < 5 OR sr1.Nota IS NULL
	)
END

DECLARE @NUMBER_OF_STUDENTS INT;
EXECUTE Procedure4 @NUMBER_OF_STUDENTS OUTPUT;
SELECT @NUMBER_OF_STUDENTS;
```

<p><b><h2> Task 3 </h2></b></p> 
<p>Să se creeze o procedură stocată, care ar însera în baza de date informații despre un student nou. În calitate de parametri de intrare să servească datele personale ale studentului nou și Cod_ Grupa. Să se genereze toate intrările-cheie necesare în tabelul studenti_reusita. Notele de evaluare să fie inserate ca NULL.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.3.PNG"  />

```sql 
CREATE PROCEDURE AddStudent
	@ID_STUDENT INT,
	@NUME_STUDENT VARCHAR(20),
	@PRENUME_STUDENT VARCHAR(20),
	@DATA_NASTERE VARCHAR(20),
	@ADRESA_STUDENT VARCHAR(20),
	@ID_DISCIPLINA INT,
	@ID_PROFESOR INT,
	@ID_GRUPA INT,
	@COD_GRUPA VARCHAR(20),
	@TIP_EVALUARE VARCHAR(20),
	@DATA_EVALUARE VARCHAR(20)
AS
BEGIN
	INSERT INTO studenti.studenti VALUES(@ID_STUDENT, @NUME_STUDENT, @PRENUME_STUDENT, @DATA_NASTERE, @ADRESA_STUDENT);

	INSERT INTO studenti.studenti_reusita
	VALUES(@ID_STUDENT, @ID_DISCIPLINA, @ID_PROFESOR, @ID_GRUPA, @TIP_EVALUARE, NULL, @DATA_EVALUARE);
END


GO
EXEC AddStudent 1, 'Boaghi', 'Vasile', '1998-01-24', 'rn.Criuleni, Pacii 12', 102, 100, 1, 'CIB171', 'Examen', '2018-11-23';
```

<p><b><h2> Task 4 </h2></b></p> 
<p>Fie că un profesor se eliberează din funcție la mijlocul semestrului. Să se creeze o procedură stocată care ar reatribui înregistrările din tabelul studenti_reusita unui alt profesor. Parametri de intrare: numele și prenumele profesorului vechi, numele și prenumele profesorului nou, disciplina. În cazul în care datele înserate sunt incorecte sau incomplete, să se afișeze un mesaj de avertizare.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.4.PNG"  />

```sql
ALTER PROCEDURE ReplaceTeacher
	@NUME_PROFESOR_VECHI VARCHAR(20),
	@PRENUME_PROFESOR_VECHI VARCHAR(20),
	@NUME_PROFESOR_NOU VARCHAR(20),
	@PRENUME_PROFESOR_NOU VARCHAR(20),
	@DISCIPLINA VARCHAR(20)
AS
BEGIN
	IF @NUME_PROFESOR_NOU IS NULL BEGIN PRINT('Introdu prof nou nume.'); RETURN; END;
	if @PRENUME_PROFESOR_NOU IS NULL BEGIN PRINT('Introdu prof nou prenume.'); RETURN; END;
	if @NUME_PROFESOR_VECHI IS NULL BEGIN PRINT('Introdu prof vechi nume.'); RETURN; END;
	if @PRENUME_PROFESOR_VECHI IS NULL BEGIN PRINT('Introdu prof vechi prenume.'); RETURN; END;
	if @DISCIPLINA IS NULL BEGIN PRINT('Introdu disciplina.'); RETURN; END;

	DECLARE @PROFESOR_VECHI_ID INT = (
		SELECT pr1.Id_Profesor 
		FROM cadre_didactice.profesori AS pr1
		WHERE pr1.Nume_Profesor = @NUME_PROFESOR_VECHI AND pr1.Prenume_Profesor = @PRENUME_PROFESOR_VECHI
	);

	DECLARE @PROFESOR_NOU_ID INT = (
		SELECT pr1.Id_Profesor
		FROM cadre_didactice.profesori AS pr1
		WHERE pr1.Nume_Profesor = @NUME_PROFESOR_NOU AND pr1.Prenume_Profesor = @PRENUME_PROFESOR_NOU
	);

	UPDATE studenti.studenti_reusita
	SET Id_Profesor = @PROFESOR_VECHI_ID
	WHERE Id_Profesor = @PROFESOR_VECHI_ID;
END

EXEC ReplaceTeacher 'Frent', 'Tudor', 'Boaghi', 'Vrilion', 'Cercetari operationale';
```

<p><b><h2> Task 5 </h2></b></p> 
<p>Să se creeze o procedură stocată care ar forma o listă cu primii 3 cei mai buni studenți la o disciplină, și acestor studenți să le fie marită nota la examenul final cu un punct (nota maximală posibilă este 10). În calitate de parametru de intrare, va servi denumirea disciplinei. Procedura să returneze următoarele câmpuri: Cod_ Grupa, Nume_Prenume_Student, Disciplina, Nota_Veche, Nota_Noua.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.5.PNG"  />

```sql
CREATE PROCEDURE ProcedureTop
	@DISCIPLINA_IN VARCHAR(20)
AS
BEGIN
	DECLARE @LAST_EXAM_DATE date = (
		SELECT MAX(Data_Evaluare)
		FROM studenti.studenti_reusita AS sr2
			INNER JOIN plan_studii.discipline AS dis2
				ON dis2.Id_Disciplina = sr2.Id_Disciplina
		WHERE dis2.Disciplina = @DISCIPLINA_IN AND sr2.Tip_Evaluare = 'Examen'
	);

	DECLARE @TOP3 TABLE(
		Id_Student INT,
		Media DECIMAL(5,3)
	);


	INSERT INTO  @TOP3
	SELECT TOP 3 Id_Student, (
		SELECT CAST(AVG(sr1.Nota*1.0) AS DECIMAL(5,3))
		FROM studenti.studenti_reusita AS sr1
			INNER JOIN plan_studii.discipline AS dis1
				ON dis1.Id_Disciplina = sr1.Id_Disciplina
			WHERE dis1.Disciplina = @DISCIPLINA_IN AND Id_Student = st1.Id_Student
		) AS Media
	FROM studenti.studenti AS st1
	ORDER BY Media DESC;

	SELECT gr3.Cod_Grupa, st3.Nume_Student, st3.Prenume_Student, @DISCIPLINA_IN, sr3.Nota, 
	CASE WHEN sr3.Nota < 10 THEN sr3.Nota + 1 ELSE sr3.Nota END
	FROM studenti.studenti_reusita AS sr3
		INNER JOIN grupe.grupe AS gr3
			ON sr3.Id_Grupa = gr3.Id_Grupa
		INNER JOIN studenti.studenti AS st3
			ON sr3.Id_Student = st3.Id_Student
	WHERE st3.Id_Student IN (SELECT Id_Student FROM @TOP3) AND sr3.Data_Evaluare = @LAST_EXAM_DATE;


	UPDATE studenti.studenti_reusita
	SET Nota = (CASE WHEN Nota < 10 THEN Nota + 1 ELSE Nota END)
	WHERE Id_Student IN ( SELECT Id_Student FROM @TOP3 ) AND Tip_Evaluare = 'Examen' AND Data_Evaluare = @LAST_EXAM_DATE;
END

EXEC ProcedureTop 'Sisteme de operare';
```


<p><b><h2> Task 6 </h2></b></p> 
<p>Să se creeze funcții definite de utilizator în baza exercițiilor (2 exerciții) din capitolul 4. Parametrii de intrare trebuie să corespundă criteriilor din clauzele WHERE ale exercițiilor respective.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.6.PNG"  />

```sql
/* 27.Afisati studentii (identificatorii) care au sustinut (evaluarea examen) la toate disciplinele predate de prof.Ion. */
SELECT distinct sr.Id_Student
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')

CREATE FUNCTION Function1(@NOTA INT, @TIP_EVALUARE VARCHAR(20), @NUME_PROFESOR VARCHAR(20), @PRENUME_PROFESOR VARCHAR(20))
RETURNS TABLE
AS RETURN (
	SELECT DISTINCT sr.Id_Student
	FROM studenti.studenti_reusita AS sr
	JOIN cadre_didactice.profesori AS pr
	ON sr.Id_Profesor = pr.Id_Profesor
	WHERE sr.Nota >= @NOTA AND sr.Tip_Evaluare = @TIP_EVALUARE 
		AND (pr.Nume_Profesor = @NUME_PROFESOR OR pr.Prenume_Profesor = @PRENUME_PROFESOR))
/*----------------------------------------------------------------------------------------------------------------*/
/* 35.Gasiti denuumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari ca 7.0. */

SELECT distinct dis.Disciplina, (SELECT AVG(CAST(sr1.Nota AS FLOAT)) 
FROM studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) as Media
FROM studenti_reusita AS sr
JOIN discipline AS dis
ON sr.Id_Disciplina = dis.Id_Disciplina
WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) from studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7


CREATE FUNCTION Function2(@NOTA INT)
RETURNS TABLE
AS RETURN (
	SELECT DISTINCT dis.Disciplina, (SELECT AVG(CAST(sr1.Nota AS FLOAT))
		FROM studenti.studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) AS Media
	FROM studenti.studenti_reusita AS sr
	JOIN plan_studii.discipline AS dis
	ON sr.Id_Disciplina = dis.Id_Disciplina
	WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) FROM studenti.studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7)

SELECT * FROM Function1(5, 'Examen', 'Ion', 'Ion')
SELECT * FROM Function2(7)
```

<p><b><h2> Task 7 </h2></b></p> 
<p>Să se scrie funcția care ar calcula vârsta studentului. Să se definească următorul format al funcției: ().</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.7.PNG"  />

```sql

CREATE FUNCTION AGE(@NUME_STUDENT VARCHAR(20), @PRENUME_STUDENT VARCHAR(20))
RETURNS INT
AS
BEGIN
	DECLARE @DATA_NASTERE DATE = (
		SELECT st.Data_Nastere_Student
		FROM studenti.studenti AS st
		WHERE st.Nume_Student = @NUME_STUDENT AND st.Prenume_Student = @PRENUME_STUDENT
		);

RETURN DATEDIFF(Hour, @DATA_NASTERE, GETDATE())/8766
END;

SELECT dbo.AGE('Boaghi', 'Vasile')

SELECT * FROM studenti.studenti
```

<p><b><h2> Task 8 </h2></b></p> 
<p>Să se creeze o funcție definită de utilizator, care ar returna datele referitoare la reușita unui student. Se definește următorul format al funcției: (<Nume_Prenume_Student>). Să fie afișat tabelul cu următoarele câmpuri: Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.8.PNG"  />

```sql

CREATE FUNCTION Reusita(@NUME_PRENUME_STUDENT VARCHAR(50))
	RETURNS @RESULT TABLE (
		NUME_PRENUME_STUDENT VARCHAR(50),
		DISCIPLINA VARCHAR(50),
		NOTA INT, 
		DATA_EVALUARE DATE
	)
AS
BEGIN
	
	DECLARE @STUDENT_NUME VARCHAR(50) = SUBSTRING(@NUME_PRENUME_STUDENT, 1, CHARINDEX(' ', @NUME_PRENUME_STUDENT));
	DECLARE @STUDENT_PRENUME VARCHAR(50) = SUBSTRING(@NUME_PRENUME_STUDENT, 
									CHARINDEX(' ', @NUME_PRENUME_STUDENT) + 1, LEN(@NUME_PRENUME_STUDENT));
	
	INSERT @RESULT
	SELECT @NUME_PRENUME_STUDENT, dis1.Disciplina, sr1.Nota, sr1.Data_Evaluare
	FROM studenti.studenti_reusita AS sr1
		INNER JOIN plan_studii.discipline AS dis1
			ON sr1.Id_Disciplina = dis1.Id_Disciplina
		INNER JOIN studenti.studenti AS st1
			ON sr1.Id_Student = st1.Id_Student
	WHERE st1.Nume_Student = @STUDENT_NUME and st1.Prenume_Student = @STUDENT_PRENUME;

	RETURN
END

SELECT * FROM Reusita('Boaghi Vasile')
```


<p><b><h2> Task 9 </h2></b></p> 
<p>Se cere realizarea unei funcții definite de utilizator, care ar găsi cel mai sârguincios sau cel mai slab student dintr-o grupă. Se definește următorul format al funcției: (<Cod_ Grupa>, <is_good>). Parametrul <is_good> poate accepta valorile "sarguincios" sau "slab", respectiv. Funcția să returneze un tabel cu următoarele câmpuri Grupa, Nume_Prenume_Student, Nota Medie , is_good. Nota Medie să fie cu precizie de 2 zecimale..</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab9/Screens/Ex.9.PNG"  />

```sql

CREATE FUNCTION BestOrLoser(@COD_GRUPA CHAR(6), @IS_GOOD VARCHAR(10))
	RETURNS @RESULT TABLE(
		GRUPA CHAR(6),
		NUME_STUDENT VARCHAR(50),
		PRENUME_STUDENT VARCHAR(50),
		NOTA_MEDIE DECIMAL(5,2),
		IS_GOOD VARCHAR(10)
	)
AS
BEGIN
	INSERT @RESULT
	SELECT TOP 1 gr1.Cod_Grupa, st1.Nume_Student, st1.Prenume_Student,
		CAST(AVG(sr1.Nota*1.0) AS DECIMAL(5,2)) AS Media, @IS_GOOD AS Is_Good
	FROM studenti.studenti AS st1
		INNER JOIN studenti.studenti_reusita AS sr1
			ON st1.Id_Student = sr1.Id_Student
		INNER JOIN grupe.grupe AS gr1
			ON gr1.Id_Grupa = sr1.Id_Grupa
	WHERE gr1.Cod_Grupa = @COD_GRUPA
	GROUP BY gr1.Cod_Grupa, st1.Nume_Student, st1.Prenume_Student
	ORDER BY CASE @IS_GOOD WHEN 'Sarguincios' THEN CAST(AVG(sr1.Nota*1.0) AS DECIMAL(5,2)) END DESC,  
			 CASE @IS_GOOD WHEN 'Slab' THEN CAST(AVG(sr1.Nota*1.0) AS DECIMAL(5,2)) END;
	RETURN
END

SELECT * FROM BestOrLoser('INF171', 'Slab')
```
