
#World life Expectancy EDA

SELECT * 
FROM world_life_expectancy;

#Guardiamo i valori massimi e minimi dei paesi e consideriamo se negli anni questi valori sono cambiati


SELECT country,
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_in_15_Years
FROM world_life_expectancy
GROUP BY country 
HAVING MIN(`Life expectancy`) != 0
AND MAX(`Life expectancy`) != 0
ORDER BY Life_Increase_in_15_Years ASC;

SELECT year,
 ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` != 0
AND `Life expectancy` != 0
GROUP BY year
ORDER BY year;

#Notiamo che l'aspettatica di vita media globale è cresciuta negli ultimi anni

#Cercheremo adesso qualche correlazione con altre variabili del dataset

SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp,
ROUND(AVG(GDP),2) AS  GDP
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0
AND GDP > 0 
ORDER BY GDP DESC
;

# Osservando i dati appare piuttosto evidente una correlazione positiva tra aumento del GDP e aspettativa di vita


SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy
;

SELECT status, ROUND(AVG(`Life expectancy`),1)
FROM  world_life_expectancy
GROUP BY status;

SELECT status, 
COUNT(DISTINCT(country)),
ROUND(AVG(`Life expectancy`),1)
FROM  world_life_expectancy
GROUP BY status;

#I paesi sviluppati sono meno numerosi di quelli in via di sviluppo e la media della loro aspettativa di vita è molto maggiore

#Sono curioso di confrontare l'aspettativa di vita con l'indice di massa corporea

SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp,
ROUND(AVG(BMI),2) AS  BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0
AND BMI > 0 
ORDER BY BMI DESC
;

#Quello che viene fuori è molto interessante. Mi sarei aspettato di vedere una correlazione negativa tra aspettativa di vita e BMI, ma non è così
#I paesi meno sviluppati hanno una BMI inferiore probabilmente anche perchè sono quelli che hanno a disposizione meno cibo e risorse


SELECT*
FROM world_life_expectancy ;

#Osserviamo l'andamento di mortalità durante gli anni

SELECT country,
year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy 
WHERE country LIKE '%Ita%';

