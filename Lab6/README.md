

<p><b><h2> Ex.1 </h2></b></p>
<p>Să se scrie o instrucțiune T-SQL, care ar popula coloana Adresa_Postala_Profesor din tabelul
profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscută.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex1.png"  />

<p><b><h2> Task 2 </h2></b></p> 
<p>Să se modifice schema tabelului grupe, ca să corespundă urmatoarelor cerințe:</p>
<p>a) Câmpul Cod_Grupa să accepte numai valorile unice și să nu accepte valori necunoscute.</p>
<p>b) Să se țină cont de cheile primare, deja, sunt definite asupra coloanei Id_ Grupa.  </p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex2.png" />

<p><b><h2> Task 3 </h2></b></p> 
<p>La tabelul grupe, să se adauge 2 coloane noi Sef_grupa și Prof_Indrumator, ambele de tip
INT. Și să se populeze câmpurile nou-create cu cele mai potrivite candidaturi în baza criteriilor
de mai jos:
<p>a) Șeful grupei trebuie să aibă cea mai bună reușită (medie) din grupă la toate formele de
evaluare și la toate disciplinele. Un student nu poate fi șef de grupă la mai multe grupe.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex3a.png" />

<p>b) Profesorul îndrumător trebuie să predea un număr maximal posibil de discipline la grupa
dată. Dacă nu există o singură candidatură, care corespunde primei cerințe, atunci este
ales din grupul de candidați acel cu identificatorul (Id_Profesor) minimal. Un profesor nu
poate fi indrumător la mai multe grupe.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex3b.png" />

<p><b><h2> Task 4 </h2></b></p> 
<p>Să se scrie o instrucțiune T-SQL, care ar mări toate notele de evaluare șefilor de grupe cu un
punct. Nota maximală (10) nu poate fi mărită.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex4.png" />

<p><b><h2> Task 5 </h2></b></p> 
<p>Să se creeze un tabel profesori_new, care include următoarele coloane: Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex5.png" />

 ```sql
 CREATE TABLE profesori_new(
	Id_Profesor int,
	Nume_Profesor char(60) NOT NULL,
	Prenume_Profesor char(60) NOT NULL,
	Localitatea varchar(60) DEFAULT 'mun. Chisinau',
	Adresa_1 varchar(255),
	Adresa_2 varchar(255),
	PRIMARY KEY ([Id_Profesor])
);

INSERT INTO profesori_new
([Id_Profesor], [Nume_Profesor], [Prenume_Profesor], Localitatea, [Adresa_1], [Adresa_2])
(SELECT Id_Profesor, Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor, Adresa_Postala_Profesor, Adresa_Postala_Profesor
FROM profesori)

DROP table profesori_new

UPDATE profesori_new
SET Localitatea = CASE
				WHEN CHARINDEX('bd.', Localitatea) > 0 THEN 
					SUBSTRING(Adresa_1, 1, PATINDEX('%, bd%',Localitatea)-1) 
				WHEN CHARINDEX('str.', Adresa_1) > 0 THEN 
					SUBSTRING(Adresa_1, 1, PATINDEX('%, str%',Localitatea)-1) 
				WHEN CHARINDEX('nau', Localitatea) > 0 THEN
					SUBSTRING(Adresa_1, 1, CHARINDEX('nau',Localitatea)+2)
				END
UPDATE profesori_new
SET Adresa_1 = CASE
					WHEN CHARINDEX('str', Adresa_1) > 0 THEN 
						SUBSTRING(Adresa_1, CHARINDEX('str', Adresa_1), 
								PATINDEX('%, [0-9]%',Adresa_1) - CHARINDEX('str', Adresa_1)) 
					WHEN CHARINDEX('bd', Adresa_1) > 0 THEN 
						SUBSTRING(Adresa_1, CHARINDEX('bd', Adresa_1), 
								PATINDEX('%, [0-9]%',Adresa_1) - CHARINDEX('bd', Adresa_1)) 
			   END
UPDATE profesori_new
SET Adresa_2 = CASE
					WHEN PATINDEX('%, [0-9]%', Adresa_2) > 0 THEN
						SUBSTRING(Adresa_2, PATINDEX('%, [0-9]%',Adresa_2) + 1,  LEN(Adresa_2) - PATINDEX('%, [0-9]%', Adresa_2) + 1)
			   END
SELECT *  
FROM profesori_new
```
<p><b><h2> Task 6 </h2></b></p> 
<p>Să se insereze datele in tabelul orarul pentru Grupa='CIB171' (Id_ Grupa= 1) pentru ziua de
luni. Toate lecțiile vor avea loc în blocul de studii 'B'.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex6.png" />

<p><b><h2> Task 7 </h2></b></p> 
<p>Să se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INFl71,
ziua de luni. </p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex7.png" />

```sql
CREATE TABLE orarul(
Ziua char(10) default 'Luni',
[Ora] time,
Bloc char(1) default 'B',
[Auditoriu] int,
[Id_Disciplina] int,
[Id_Profesor] int,
Id_Grupa int ,

PRIMARY KEY(Id_Disciplina, Id_Profesor, Id_Grupa)
);
drop table orarul

INSERT INTO orarul(Id_Disciplina, Id_Profesor, Id_Grupa, Ora, Auditoriu)
SELECT DISTINCT dis.Id_Disciplina, pr.Id_Profesor, gr.Id_Grupa,
	CASE
		WHEN pr.Nume_Profesor = 'Bivol' AND pr.Prenume_Profesor = 'Ion' THEN '08:00'
		WHEN pr.Nume_Profesor = 'Mircea' AND pr.Prenume_Profesor = 'Sorin' THEN '11:30'
		WHEN pr.Nume_Profesor = 'Micu' AND pr.Prenume_Profesor = 'Elena' THEN '13:00'
	END,
	502
FROM discipline as dis
	JOIN studenti_reusita as sr
ON dis.Id_Disciplina = sr.Id_Disciplina
	JOIN grupe as gr
ON gr.Id_Grupa = sr.Id_Grupa
	JOIN profesori as pr
ON pr.Id_Profesor = sr.Id_Profesor
	WHERE((dis.Disciplina = 'Structuri de date si algoritmi' AND pr.Nume_Profesor = 'Bivol' AND pr.Prenume_Profesor = 'Ion')
		OR
	  (dis.Disciplina = 'Programe aplicative' AND pr.Nume_Profesor = 'Mircea' AND pr.Prenume_Profesor = 'Sorin')
	    OR
      (dis.Disciplina = 'Baze de date' AND pr.Nume_Profesor = 'Micu' AND pr.Prenume_Profesor = 'Elena'))
	    AND
	  gr.Cod_Grupa = 'INF171'


SELECT * 
FROM orarul
```

<p><b><h2> Task 8 </h2></b></p> 
<p>Să se scrie interogările de creare a indecșilor asupra tabelelor din baza de date universitatea
pentru a asigura o performanță sporită la executarea interogărilor SELECT din Lucrarea
practica 4. Rezultatele optimizării să fie analizate în baza planurilor de execuție, până la și
după crearea indecșilor. </p> 

```SQL
CREATE NONCLUSTERED COLUMNSTORE INDEX id_student_column
ON studenti (Id_Student)

CREATE NONCLUSTERED INDEX id_student1
ON studenti (Id_Student)


SELECT distinct sr.Id_Student
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')
```
<p> Without Index </p>
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex8A.PNG" />
<p> With a nonclustered index </p>
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex8b.PNG" />
<p> Witha nonclstered column index </p>
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex8c.PNG" />




