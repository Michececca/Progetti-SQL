
# Life Exptectancy DATA CLEANING

#Creare una copia backup del dataset
#Cercare ed eliminare duplicati utilizzando PARTITION BY e ROW_NUMBER 

SELECT Country,
 year, 
 CONCAT(country, year), 
 COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1
 ;
 
 
 DELETE FROM world_life_expectancy
 WHERE row_id IN ( 
 SELECT row_id
 FROM 
 (SELECT row_id, 
 CONCAT(country, year),
 ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) as row_num
 FROM world_life_expectancy) AS row_table
 WHERE row_num > 1
 );
 
 # Nella colonna dello status del paese ci sono alcuni valori vuoti. Utilizzando il SELF JOIN sovrappongo i paesi con i rispettivi status per riempire i valori mancanti 
 
 SELECT DISTINCT(country)
 FROM world_life_expectancy
 WHERE status = 'Developing';
 
 UPDATE world_life_expectancy
 SET status = 'Developing'
 WHERE country IN (
 SELECT DISTINCT(country)
 FROM world_life_expectancy
 WHERE status = 'Developing');

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status != ''
AND t2.status ='Developing' 
; 

SELECT country, status
FROM world_life_expectancy
WHERE status = '';

#Tutti i valori status dei paesi in via di sviluppo sono stati inseriti correttamente, adesso manca solo inserire uno status mancante in un paese sviluppato

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status != ''
AND t2.status ='Developed' 
; 

SELECT country, status
FROM world_life_expectancy
WHERE status = '';
 
#Tutto ha funzionato correttamente e nella colonna status non ci sono più valori vuoti. Passiamo alla colonna 'life expectancy'

SELECT country, year, `Life expectancy`
FROM world_life_expectancy
;

#Per ripopolare i valori mancanti dell'aspettativa di vita faremo una media del valore dell'anno precedente e successivo

SELECT t1.country, t1.year, t1.`Life expectancy`,
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t3.year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN  world_life_expectancy t2
	ON t1.country = t2.country 
    AND t1.Year = t2.year -1
JOIN  world_life_expectancy t3
	ON t1.country = t3.country 
    AND t1.Year = t3.year +1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN  world_life_expectancy t2
	ON t1.country = t2.country 
    AND t1.Year = t2.year -1
JOIN  world_life_expectancy t3
	ON t1.country = t3.country 
    AND t1.Year = t3.year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '';

# I valori bianchi sono stati sostituiti correttmente
 
 SELECT *
 FROM world_life_expectancy
 
 #Sembra che il dataset sia pulito!
 