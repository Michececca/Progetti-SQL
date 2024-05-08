
#Us Income Household EDA

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

#Sono curioso di vedere come si configurano gli stati dal punti di vista delle Land e delle zone Water

SELECT state_name, county, city, ALand, AWater
FROM us_project.us_household_income;


SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 2 DESC
LIMIT 10;


#Lo stato del Texas è quello che ha più land

SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 3 DESC
LIMIT 10;

#Lo stato del Michigan è dove si trovano i Grandi Laghi, questo lo rende il primo nella classifica per quanto riguarda la presenza di acqua. Il Texas è in seconda posizione, sorprendentemente devo dire

SELECT * 
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id;

SELECT * 
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE u.id IS NULL;

#Ci sono un sacco di stati che non hanno un riscontro nella prima tabella e quindi un sacco di valori nulli per quanto rigurda i dati di riferimento


SELECT * 
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0;



SELECT u.state_name, county, type, `primary`, mean, median
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0;

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY u.state_name
ORDER BY 2
LIMIT 5;

# Le zone in cui è il reddito famiiare è più basso sono Puerto Rico, Mississippi, Arkansas, West Virginia e Alabama

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY u.state_name
ORDER BY 2 DESC
LIMIT 5;

# Le zone in cui è il reddito famiiare è più alto sono District of Columbia,Connecticut,New Jersey,Maryland e Massachusetts

#Ordino per la mediana


SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY u.state_name
ORDER BY 3 DESC
LIMIT 5;

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY u.state_name
ORDER BY 3 ASC
LIMIT 5;

#La classifica non cambia molto quindi la media è molto vicina alla mediana


SELECT type,COUNT(type),ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY type
ORDER BY 3 DESC
LIMIT 10;

#Type municipality ha un solo valore con media e mediana molto alti
#Urban and Community hanno dei redditi estremamente più bassi di tutti gli altri type

SELECT type,COUNT(type),ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY type
ORDER BY 4 DESC
LIMIT 10;

#Se ordino per la media il type CDP è quello con i valori più alti mentre urban e community si mantengono su valori molto bassi anche in questo caso. 
#Sono curioso di vedere quali sono gli stati che hanno urban e community


SELECT *
FROM us_household_income
WHERE type = 'community';

#Puerto rico

#Nel conteggio precedente comunque ci sono dei type che hanno pochissimi riscontri  e potrebbero essere outliers che confondono l'analisi

SELECT type,COUNT(type),ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean != 0
GROUP BY type
HAVING COUNT(type) > 100
ORDER BY 4 DESC
LIMIT 10;

SELECT u.state_name, city, ROUND(AVG(mean),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY city, state_name
ORDER BY ROUND(AVG(mean),1) desc;


#L'Alaska ha una media di redditi veramente enorme