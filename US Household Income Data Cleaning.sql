
#US Household Income Data Cleaning

SELECT * FROM us_project.us_household_income_statistics;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT * 
FROM us_household_income_statistics;

SELECT * 
FROM us_household_income;

#Cerchiamo duplicati 

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;


DELETE FROM us_household_income
WHERE row_id IN (
SELECT row_id
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_household_income) as duplicates
WHERE row_num > 1)
;

#Duplicati eliminati dalla prima tabella. Adesso procediamo ad eliminarne dalla seconda se ce ne sono 

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

#Non ci sono duplcati in questa tabella
#Proceduamo con la pulizia


SELECT state_name, COUNT(state_name)
FROM us_household_income
GROUP BY state_name;

#Notiamo che 2 degli stati è ssono stati trascritti male. 'georia' invede di Georgia e infatti appare nel count una sola volta e 'alabama' invece di 'Alabama'


UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia' ;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama' ;

#Il nome è stato cambiato correttamente

SELECT * 
FROM us_household_income;

SELECT DISTINCT State_ab
FROM us_household_income
ORDER BY 1;

SELECT *
FROM us_household_income
WHERE place = '';

#è presente una riga in cui la colonna place ha valore nullo. si tratta della contea di Autauga County. Noto che appartiene alla città du Vinemnont

SELECT *
FROM us_household_income
WHERE county = 'Autauga County' AND city = 'Vinemont';

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE county = 'Autauga County' 
AND city = 'Vinemont';

#Il valore è stato inserito correttamente

SELECT type, COUNT(type)
FROM us_household_income
GROUP BY type;

#Credo che ci siano dei  piccoli errori nel type. 
#Il valore 'CDP' dovrebbe essere lo stesso di 'CPD'. 
#Il type Boroughs dovrebbe essere Borough
#Provvedo a correggerlo visto che in seguito all'osservazione del dataset sono piuttosto sicuro che si tratti di errori. Se non avessi questa sicurezza non cambierei niente

SELECT *
FROM us_household_income
WHERE type = 'CDP';


UPDATE us_household_income
SET type = 'CDP'
WHERE type = 'CPD' ;


UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs' ;

#Corretti

SELECT Aland, AWater
FROM us_household_income
;

#Ci sono valori 0 in queste colonne


SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
AND ALand = 0 OR Aland = '' OR ALand IS NULL
;

SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 OR Aland = '' OR ALand IS NULL
;

#Evidentemente ci sono delle aree in queste zone che sono totalmente acqua o totalmente terra e mi sembra plausibile. Non toccherò nulla di queste tabella

SELECT*
FROM us_household_income
;

#Il dataset mi sembra pulito
