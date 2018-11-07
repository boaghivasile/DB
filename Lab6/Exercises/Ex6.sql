CREATE TABLE orarul(
Ziua char(10) default 'Luni',
[Ora] time,
Bloc char(1) default 'B',
[Auditoriu] int,
[Id_Disciplina] int,
[Id_Profesor] int,
Id_Grupa int default 1,

PRIMARY KEY(Id_Disciplina, Id_Profesor, Id_Grupa)
);
drop table orarul

INSERT INTO orarul(Ora, Auditoriu, Id_Disciplina, Id_Profesor)
		VALUES('08:00', 202, 107, 101),
			  ('11:30', 501, 108, 101),
		      ('13:00', 501, 119, 117);

SELECT * 
FROM orarul