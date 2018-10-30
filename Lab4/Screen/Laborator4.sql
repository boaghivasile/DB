/* 1. Aflati toate datele despre grupele de studii de la facultate. */
SELECT *
FROM grupe
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
