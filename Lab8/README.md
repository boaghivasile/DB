<p><b><h2> Ex.1 </h2></b></p>
<p>Să se creeze două viziuni în baza interogărilor formulate în două exerciții indicate din capitolul
4. Prima viziune să fie construită în Editorul de interogări, iar a doua, utilizând View
Designer.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex1a.png"  />

```sql
CREATE VIEW Grupe_View_LAB8_EX1 AS
	SELECT Id_Grupa, Cod_Grupa, Specialitate, Nume_Facultate 
	FROM grupe
GO
```
<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex1b.png"  />

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex1c.png"  />

<p><b><h2> Task 2 </h2></b></p> 
<p>Să se scrie câte un exemplu de instrucțiuni INSERT, UPDATE, DELETE asupra viziunilor
create. Să se adauge comentariile respective referitoare la rezultatele executării acestor
instrucțiuni.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex2.PNG"  />

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex2a.PNG"  />

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex2b.PNG"  />

```sql
/*INSERT*/
SET IDENTITY_INSERT grupe ON
INSERT INTO Grupe_View_LAB8_EX1(Id_Grupa, Cod_Grupa, Specialitate, Nume_Facultate)
values (4,'FAF172', 'ISA', 'FCIM')
SET IDENTITY_INSERT grupe OFF

INSERT INTO VIEW_Interogarea10(Id_Student, Nume_Student, Prenume_Student)
values (99, 'Vasilica', 'Boaghi')
CREATE VIEW VIEW_Interogarea10 AS 
SELECT Id_Student, Nume_student , Prenume_Student FROM studenti
GO

SELECT * 
FROM VIEW_Interogarea10

/*INSERT*/

/*UPDATE*/
SET IDENTITY_INSERT grupe ON
UPDATE Grupe_View_LAB8_EX1
SET Cod_Grupa = 'FAF171'
WHERE Id_Grupa = 4;
SET IDENTITY_INSERT grupe OFF

UPDATE VIEW_Interogarea10
SET Nume_Student = 'Vrilion'
WHERE Prenume_Student = 'Boaghi'
/*UPDATE*/

/*DELETE*/
SET IDENTITY_INSERT grupe ON
DELETE Grupe_View_LAB8_EX1
WHERE Id_Grupa = 4
SET IDENTITY_INSERT grupe OFF

DELETE FROM VIEW_Interogarea10
WHERE Id_Student = 99

SELECT * 
FROM VIEW_Interogarea10
/*DELETE*/
```

<p><b><h2> Task 3 </h2></b></p> 
<p>Să se scrie instrucțiunile SQL care ar modifica viziunile create (în exercițiul 1) în așa fel, încât
să nu fie posibilă modificarea sau ștergerea tabelelor pe care acestea sunt definite și viziunile
să nu accepte operațiuni DML, daca condițiile clauzei WHERE nu sunt satisfăcute.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex3.PNG"  />

```sql 
/*a)*/
ALTER VIEW Interogarea10 WITH SCHEMABINDING AS
SELECT studenti.studenti.Id_Student, studenti.studenti.Nume_Student , studenti.studenti.Prenume_Student 
	FROM studenti.studenti, plan_studii.discipline , studenti.studenti_reusita
	WHERE studenti.studenti.Id_Student = studenti.studenti_reusita.Id_Student
	AND plan_studii.discipline.Id_Disciplina = studenti.studenti_reusita.Id_Disciplina
	AND studenti.studenti_reusita.Tip_Evaluare = 'Examen' 
	AND year(studenti.studenti_reusita.Data_Evaluare) = 2018 
	AND plan_studii.discipline.Disciplina = 'Baze de date'
	AND studenti.studenti_reusita.Nota BETWEEN  4 AND 8
WITH CHECK OPTION

/*b)*/
ALTER VIEW Grupe_View_LAB8_EX1 WITH SCHEMABINDING AS
SELECT grupe.grupe.Id_Grupa, grupe.grupe.Cod_Grupa, grupe.grupe.Specialitate, grupe.grupe.Nume_Facultate 
	FROM grupe.grupe
WITH CHECK OPTION
```

<p><b><h2> Task 4 </h2></b></p> 
<p>Să se scrie instrucțiunile de testare a proprietăților noi definite.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex4.PNG"  />

```sql
/*a)*/
ALTER TABLE studenti.studenti DROP COLUMN Prenume_Student

/*b)*/
INSERT INTO Interogarea10
values (98, 'Virgiliu', 'Tristan')

```

<p><b><h2> Task 5 </h2></b></p> 
<p>Să se rescrie 2 interogări formulate in exercițiile din capitolul 4, in așa fel încât interogările
imbricate să fie redate sub forma expresiilor CTE.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab8/Screens/Ex5.PNG"  />

```sql

/* 27.Afisati studentii (identificatorii) care au sustinut (evaluarea examen) la toate disciplinele predate de prof.Ion. */

SELECT distinct sr.Id_Student
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')

WITH examen_nume_profesor
(Id_Student, Tip_Evaluare, Nota, Nume_Profesor, Prenume_Profesor) as (
	SELECT sr1.Id_Student, sr1.Tip_Evaluare, sr1.Nota, pr1.Nume_Profesor, pr1.Prenume_Profesor
	FROM studenti_reusita as sr1
	JOIN profesori as pr1
	ON sr1.Id_Profesor = pr1.Id_Profesor)

SELECT distinct Id_Student
FROM examen_nume_profesor
WHERE Nota >= 5 and Tip_Evaluare = 'Examen' and (Nume_Profesor = 'Ion' OR Prenume_Profesor = 'Ion')

/* 35.Gasiti denuumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari ca 7.0. */

SELECT distinct dis.Disciplina, (SELECT AVG(CAST(sr1.NOTA AS FLOAT)) 
FROM studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) as Media
FROM studenti_reusita AS sr
JOIN discipline AS dis
ON sr.Id_Disciplina = dis.Id_Disciplina
WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) from studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7

WITH mediile_la_discipline
(Id_Disciplina, Nota, Disciplina) as (
	SELECT sr1.Id_Disciplina, sr1.Nota, dis.Disciplina
	FROM studenti_reusita as sr1
	JOIN discipline as dis
	ON sr1.Id_Disciplina = dis.Id_Disciplina)

SELECT distinct Disciplina, AVG(CAST(NOTA as FLOAT)) as Media
FROM mediile_la_discipline
GROUP BY Disciplina
HAVING AVG(CAST(NOTA as FLOAT)) > 7


```

<p><b><h2> Task 6 </h2></b></p> 
<p>Se consideră un graf orientat, precum cel din figura de mai jos și fie că se dorește parcursă calea
de la nodul cu id = 3 la nodul unde id = 0. Să se facă reprezentarea grafului orientat in formă de
expresie-tabel recursiv.
Să se observe instrucțiunea de după UNION ALL a membrului recursiv, precum și partea de
până la UNION ALL reprezentata de membrul-ancora.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab7/Screens/Ex6.PNG"  />

```declare @graf table(
	id int, 
	next_node int
); 

insert @GRAF
select 0, null union all
select 1, 0 union all
select 2, 1 union all
select 3, 2 union all
select 4, 2 union all
select 5, 0;
 
;with way(N, id, next_node) as (
	select 0, gf1.id, gf1.next_node 
	from @graf as gf1
	where gf1.id = 3
union all
	select N + 1, gf2.id, gf2.next_node
	from @graf as gf2 inner join way on gf2.id = way.next_node
	where gf2.id < 3
)
select * from way;

select * from @graf;
```

