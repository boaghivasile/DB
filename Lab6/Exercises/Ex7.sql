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