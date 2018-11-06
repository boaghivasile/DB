ALTER TABLE grupe
add Sef_Grupa int, Profesor_Indrumator int

UPDATE grupe
SET Sef_Grupa = (SELECT TOP 1 topul.Id_Student
FROM ( SELECT DISTINCT TOP 1 sr.Id_Student, (SELECT CAST(AVG(sr1.Nota*1.00) as decimal(3,2))
									   FROM studenti_reusita as sr1
									   WHERE sr1.Id_Student = sr.Id_Student
									   ) as media
	   FROM studenti_reusita as sr
	   WHERE grupe.Id_Grupa = sr.Id_Grupa
	   ORDER BY media DESC
	   ) as topul
)

SELECT * 
FROM grupe



