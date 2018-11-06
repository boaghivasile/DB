ALTER TABLE grupe
ALTER COLUMN Cod_Grupa char(6) NOT NULL

ALTER TABLE grupe
ADD UNIQUE(Cod_Grupa)


SELECT * 
FROM grupe