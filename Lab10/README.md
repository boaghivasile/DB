


<p><b><h2> Task 1 </h2></b></p>
<p>Să se modifice declansatorul inregistrare_noua, în așa fel, încât în cazul actualizării auditoriului să apară mesajul de informare, care, în afară de disciplina și ora, va afișa codul grupei afectate, ziua, blocul, auditoriul vechi și auditoriul nou.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.1.PNG"  />

```sql

CREATE TRIGGER Inregistrare_Noua on orarul
AFTER UPDATE
AS
BEGIN
	IF UPDATE(Auditoriu)
	SELECT 'Lecția: ' + UPPER(dis.Disciplina) + '  ' +
			'Ora: ' + CAST(ins.Ora AS VARCHAR(5)) + '  ' +
			'Aula inițială: ' + CAST(del.Auditoriu AS CHAR(3)) + '  ' +
			'Aula finală: ' + CAST(ins.Auditoriu AS CHAR(3)) + '  ' +
			'Grupa: ' + CAST(gr.Cod_Grupa AS VARCHAR(6)) + '  ' +
			'Ziua: ' + CAST(ins.Ziua AS CHAR(10)) + '  ' +
			'Blocu: ' + CAST(ins.Bloc AS CHAR(1))
	FROM inserted ins
		JOIN plan_studii.discipline dis ON dis.Id_Disciplina = ins.Id_Disciplina
		JOIN deleted del ON del.Id_Disciplina = ins.Id_Disciplina
		JOIN grupe.grupe gr ON gr.Id_Grupa = ins.Id_Grupa
END;

UPDATE orarul
SET Auditoriu = 203
```

<p><b><h2> Task 2 </h2></b></p> 
<p>Să se creeze declansatorul, care ar asigura popularea corectă (consecutivă) a tabelelor studenti și studenti_reusita,
 și ar permite evitarea erorilor la nivelul cheilor exteme.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.2.PNG" />

```sql

CREATE TRIGGER INSERT_STUDENTI_REUSITA
ON studenti.studenti_reusita
INSTEAD OF INSERT
as
BEGIN
	DECLARE @ID_STUDENT INT = (SELECT Id_Student FROM inserted);
	DECLARE @ID_DISCIPLINA INT = (SELECT Id_Disciplina FROM inserted);
	DECLARE @ID_PROFESOR INT = (SELECT Id_Profesor FROM inserted);
	DECLARE @ID_GRUPA INT = (SELECT Id_Grupa FROM inserted);
	DECLARE @TIP_EVALUARE VARCHAR(60) = (SELECT Tip_Evaluare FROM inserted);
	DECLARE @NOTA TINYINT = (SELECT Nota FROM inserted);
	DECLARE @DATA_EVALUARE DATE = (SELECT Data_Evaluare FROM inserted);
	
	IF NOT EXISTS (
		SELECT st.Id_Student 
		FROM inserted AS ins
			INNER JOIN studenti.studenti AS st ON ins.Id_Student = st.Id_Student
	) BEGIN 
		INSERT INTO studenti.studenti
		VALUES (@ID_STUDENT, 'Boaghi', 'Vasile', '1998-01-24', 'rn.Criuleni, str.Pacii 12')
	END;

	INSERT INTO studenti.studenti_reusita
	VALUES(@ID_STUDENT, @ID_DISCIPLINA, @ID_PROFESOR, @ID_GRUPA, @TIP_EVALUARE, @NOTA, @DATA_EVALUARE);
END;

INSERT INTO studenti.studenti_reusita 
VALUES (2, 100, 110, 1, 'Test In', 9, '2018-01-25');

SELECT COUNT(*)
FROM studenti.studenti_reusita
WHERE Tip_Evaluare = 'Test In'
```

<p><b><h2> Task 3 </h2></b></p> 
<p>Să se creeze un declanșator, care ar interzice micșorarea notelor în tabelul studenti_reusita și modificarea valorilor câmpului Data_Evaluare, unde valorile acestui câmp sunt nenule. Declanșatorul trebuie să se lanseze, numai dacă sunt afectate datele studenților din grupa "CIB 171".Se va afișa un mesaj de avertizare în cazul tentativei de a încălca constrângerea.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.3a.PNG" />

```sql

CREATE TRIGGER UPDATE_STUDENTI_REUSITA
ON studenti.studenti_reusita
AFTER UPDATE
AS
IF (
	SELECT gr.Cod_Grupa
	FROM grupe.grupe AS gr 
		INNER JOIN inserted AS ins ON gr.Id_Grupa = ins.Id_Grupa
) = 'CIB171'
BEGIN
	DECLARE @NOTA_VECHE TINYINT = (SELECT Nota FROM deleted);
	DECLARE @NOTA_NOUA TINYINT = (SELECT Nota FROM inserted);

	IF @NOTA_NOUA < @NOTA_VECHE
		BEGIN
			PRINT('The mark is not allowed to be decreased.');
			ROLLBACK TRANSACTION;
		END;

	DECLARE @DATA_EVALUARE_VECHE DATE = (SELECT Data_Evaluare FROM deleted);
	DECLARE @DATA_EVALUARE_NOUA DATE = (SELECT Data_Evaluare FROM inserted);

	IF @DATA_EVALUARE_VECHE IS NOT NULL
	IF(@DATA_EVALUARE_NOUA <> @DATA_EVALUARE_VECHE)
		BEGIN
			PRINT('The Data_evaluare is not allowed to be changed.');
			ROLLBACK TRANSACTION;
		END;
END ELSE 
	BEGIN
		PRINT('Trigger runs only for grupe CIB171.');
	END;

UPDATE studenti.studenti_reusita
set Nota = 6
where Id_Student = 100 and Id_Disciplina = 105 and Id_Profesor = 110 and Id_Grupa = 1  and Tip_Evaluare = 'Examen'
```

<p><b><h2> Task 4 </h2></b></p> 
<p>Să se creeze un declanșator DDL care ar interzice modificarea coloanei ld_Disciplina în tabelele bazei de date universitatea cu afișarea mesajului respectiv.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.4.PNG" />

```sql

CREATE TRIGGER Cant_Change_Id_Student
ON DATABASE
AFTER alter_table, drop_table
AS
BEGIN
	IF EVENTDATA().value
		('(EVENT_INSTANCE/AlterTableActionList/Alter/Columns/Name)[1]', 'nvarchar(max)') = 'Id_Disciplina'
	BEGIN
		PRINT('Alter or drop column Id_Discilina is not allowed.');
		ROLLBACK;
		RETURN;
	END
END;

ALTER TABLE studenti.studenti_reusita
ALTER COLUMN Id_Disciplina INT NOT NULL;
```

<p><b><h2> Task 5 </h2></b></p> 
<p>Să se creeze un declanșator DDL care ar interzice modificarea schemei bazei de date în afara orelor de lucru.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.5.PNG" />

 ```sql
 
CREATE TRIGGER Changes_On_Time
ON DATABASE
AFTER alter_table
AS
BEGIN
	DECLARE @TIME_START TIME = '08:00:00';
	DECLARE @TIME_END TIME = '23:00:00';
	DECLARE @CURRENT_TIME TIME = CONVERT (TIME, SYSDATETIME());

	IF @CURRENT_TIME < @TIME_START or @CURRENT_TIME > @TIME_END
		BEGIN
			PRINT('Alter is not allowed outside the work time.');
			ROLLBACK TRANSACTION;
		END
END;

ALTER TABLE studenti.studenti_reusita
ALTER COLUMN Id_Profesor INT NOT NULL;
```

<p><b><h2> Task 6 </h2></b></p> 
<p>Să se creeze un declanșator DDL care, la modificarea proprietăților coloanei ld_Profesor dintr-un tabel, ar face schimbări asemănătoare în mod automat în restul tabelelor.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab10/Screens/Ex.6.PNG" />

```sql

CREATE TRIGGER PROFESORI_NEW_CHANGES
ON DATABASE
AFTER ALTER_TABLE
AS
BEGIN
	IF eventdata().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)') = 'Prenume_Profesor'    
	 BEGIN  
		DECLARE @COMMAND_1 VARCHAR(100) = eventdata().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
		DECLARE @COMMAND_3 VARCHAR(100) = eventdata().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)') 

		DECLARE @COMMAND_2 VARCHAR(100) = replace(@COMMAND_1, @COMMAND_3, 'profesori');
		EXECUTE (@COMMAND_2) 
		SET @COMMAND_2 = replace(@COMMAND_1, @COMMAND_3, 'profesori_new');
		EXECUTE (@COMMAND_2)  
	 END
 END;

ALTER TABLE cadre_didactice.profesori 
ALTER COLUMN Prenume_Profesor CHAR(20);
```

