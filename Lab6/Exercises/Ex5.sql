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