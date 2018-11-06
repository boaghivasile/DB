UPDATE profesori
SET Adresa_Postala_Profesor = 'Mun. Chisinau'
WHERE Adresa_Postala_Profesor IS NULL

SELECT *
FROM profesori