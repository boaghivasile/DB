UPDATE grupe
SET Profesor_Indrumator = (SELECT TOP 1 topul.Id_Profesor
FROM ( SELECT DISTINCT TOP 1 sr.Id_Profesor, (SELECT COUNT(DISTINCT sr1.Id_Profesor)
									   FROM studenti_reusita as sr1
									   WHERE sr1.Id_Profesor = sr.Id_Profesor
									   ) as Nr_Discipline
	   FROM studenti_reusita as sr
	   WHERE grupe.Id_Grupa = sr.Id_Grupa 
	   ORDER BY Nr_Discipline DESC
	   ) as topul
)

SELECT *
FROM grupe