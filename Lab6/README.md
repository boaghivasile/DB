

<p><b><h2> Ex.1 </h2></b></p>
<p> Să se scrie o instrucțiune T-SQL, care ar popula coloana Adresa_Postala_Profesor din tabelul
profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscută.    </p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex1.png"  />

<p><b><h2> Task 2 </h2></b></p> 
<p>2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
a) Campul Cod_ Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute.
b) Sa se tina cont ca cheie primarii, deja, este definitii asupra coloanei Id_ Grupa.  </p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex2.png" />

<p><b><h2> Task 3 </h2></b></p> 
<p><b>  </b></p> 
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex3a.png" />
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex3b.png" />
  
<p><b><h2> Task 4 </h2></b></p> 

<p><b>  </b></p> 
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex4.png" />

<p><b><h2> Task 5 </h2></b></p> 

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
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex5.png" />

<p><b><h2> Task 6 </h2></b></p> 

<p><b>  </b></p> 
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex6.png" />

<p><b><h2> Task 7 </h2></b></p> 
<p><b>  </b></p> 
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
<img src="https://github.com/boaghivasile/DB/blob/master/Lab6/Exercises/Ex7.png" />




