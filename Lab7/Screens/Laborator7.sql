/*Ex.3
La diagrama construită, să se adauge și tabelul orarul definit in capitolul 6 al acestei lucrări:
tabelul orarul conține identificatorul disciplinei (ld_Disciplina), identificatorul profesorului
(Id_Profesor) și blocul de studii (Bloc). Cheia tabelului este constituită din trei câmpuri:
identificatorul grupei (Id_ Grupa), ziua lecției (Z1), ora de început a lectiei (Ora) , sala unde
are loc lecția (Auditoriu).
*/

CREATE TABLE orarul(
Ziua char(10),
[Ora] time,
Bloc char(1),
[Auditoriu] int,
[Id_Disciplina] int,
[Id_Profesor] int,
Id_Grupa smallint,

PRIMARY KEY(Ziua, Id_Disciplina, Id_Profesor, Id_Grupa)
);



/*Ex.6
Creați, țn baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii și studenti.
Transferați tabelul profesori din schema dbo în schema cadre didactice, ținând cont de
dependențelor definite asupra tabelului menționat. În același mod să se trateze tabelele orarul,
discipline care aparțin schemei plan_studii și tabelele studenti, studenti_reusita, care aparțin
schemei studenti. Să se scrie instrucțiunile SQL respective.
*/

CREATE SCHEMA cadre_didactice
GO
ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori

GO
CREATE SCHEMA plan_studii
GO
ALTER SCHEMA plan_studii TRANSFER dbo.orarul
ALTER SCHEMA plan_studii TRANSFER dbo.discipline

GO
CREATE SCHEMA studenti
GO
ALTER SCHEMA studenti TRANSFER dbo.studenti
ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita

CREATE SCHEMA grupe
GO
ALTER SCHEMA grupe TRANSFER dbo.grupe

/*Ex.7
Modificați 2-3 interogări asupra bazei de date universitatea prezentate în capitolul 4 astfel ca
numele tabelelor accesate să fie descrise în mod explicit, ținînd cont de faptul că tabelele au
fost mutate în scheme noi.
*/

/* 27.Afisati studentii (identificatorii) care au sustinut (evaluarea examen) la toate disciplinele predate de prof.Ion. */

SELECT distinct sr.Id_Student
FROM studenti.studenti_reusita as sr
JOIN cadre_didactice.profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')

/* 22.Sa se obtina numarul de discipline predate de fiecare profesor (Nume_Profesor, Prenume_Profesor). */

SELECT distinct pr.Nume_Profesor, Prenume_Profesor,
(SELECT count(distinct Id_Disciplina) FROM studenti.studenti_reusita as sr1 where sr.Id_Profesor = sr1.Id_Profesor) as [Nr_Obiecte]
FROM studenti.studenti_reusita as sr
JOIN cadre_didactice.profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor

/* 35.Gasiti denuumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari ca 7.0. */

SELECT distinct dis.Disciplina, (SELECT AVG(CAST(sr1.NOTA AS FLOAT)) 
FROM studenti.studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) as Media
FROM studenti.studenti_reusita AS sr
JOIN plan_studii.discipline AS dis
ON sr.Id_Disciplina = dis.Id_Disciplina

WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) from studenti.studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7


/*Ex.8
Creați sinonimele respective pentru a simplifica interogările construite în exercițiul precedent
și reformulați interogările, folosind sinonimele create.
*/

CREATE SYNONYM studenti_reusita FOR studenti.studenti_reusita;
CREATE SYNONYM profesori FOR cadre_didactice.profesori;
CREATE SYNONYM discipline FOR plan_studii.discipline;
CREATE SYNONYM studenti FOR studenti.studenti;

/* 35.Gasiti denuumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari ca 7.0. */

SELECT distinct dis.Disciplina, (SELECT AVG(CAST(sr1.NOTA AS FLOAT)) 
FROM studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) as Media
FROM studenti_reusita AS sr
JOIN discipline AS dis
ON sr.Id_Disciplina = dis.Id_Disciplina

WHERE (SELECT AVG(CAST(sr1.Nota AS FLOAT)) from studenti_reusita AS sr1 WHERE sr.Id_Disciplina = sr1.Id_Disciplina) > 7

/* 27.Afisati studentii (identificatorii) care au sustinut (evaluarea examen) la toate disciplinele predate de prof.Ion. */

SELECT distinct sr.Id_Student
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor
WHERE sr.Nota >=5 AND sr.Tip_Evaluare = 'Examen' AND (pr.Nume_Profesor = 'Ion' OR pr.Prenume_Profesor = 'Ion')

/* 22.Sa se obtina numarul de discipline predate de fiecare profesor (Nume_Profesor, Prenume_Profesor). */

SELECT distinct pr.Nume_Profesor, Prenume_Profesor,
(SELECT count(distinct Id_Disciplina) FROM studenti_reusita as sr1 where sr.Id_Profesor = sr1.Id_Profesor) as [Nr_Obiecte]
FROM studenti_reusita as sr
JOIN profesori as pr
ON sr.Id_Profesor = pr.Id_Profesor






