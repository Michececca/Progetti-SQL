-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Diamo un'occhiata in giro

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Tantissime persone sono state licenziate in una volta sola, nella colonna' percentage_laid_off' il valore 1 corrisponde al 100%

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- AMAZON, GOOGLE E META sono le compagnie che hanno liceziato più persone

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- CONSUMER E RETAIL sono le industrie che hanno licenziato più persone

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- GLi USA hanno di gran lunga il maggior numero di licenziamenti

-- Da approfondire gli anni di questi licenziamenti

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- L'anno peggiore è stato il 2022, ma va considerato che i dati del 2023 sono solo dei primi 3 mesi dell'anni e la quntità di licenziamenti è comunque impressionante

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Analizzio l'andamento dei licenziamenti nel tempo, raggruppandoli per mese

SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_Total AS 
(
SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- In questo modo ho una colonna che mostra i licenziamenti totali per mese e un'altra che ne mostra la somma cumulativa

-- Questor mostra che l'hanno 2022 è stato sicuramente quello in cui sono avvenuti più licenziamenti, anche se il 2023 è sulla buona strada per essere il peggior anno per quanto riguarda i licenziamenti

-- Adesso un'occhiata alla 'company' per 'year'

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Adesso vorrei vedere quale compagnia ha licenziato più persone per anno

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

-- Adesso abbiamo un elenco delle aziende che hanno liceziato più persone, in un ranking delle "migliori 5 per ogni anno"

-- Riporto i risultati di seguito: 
/* 
Uber	2020	7525	1
Booking.com	2020	4375	2
Groupon	2020	2800	3
Swiggy	2020	2250	4
Airbnb	2020	1900	5
Bytedance	2021	3600	1
Katerra	2021	2434	2
Zillow	2021	2000	3
Instacart	2021	1877	4
WhiteHat Jr	2021	1800	5
Meta	2022	11000	1
Amazon	2022	10150	2
Cisco	2022	4100	3
Peloton	2022	4084	4
Carvana	2022	4000	5
Philips	2022	4000	5
Google	2023	12000	1
Microsoft	2023	10000	2
Ericsson	2023	8500	3
Amazon	2023	8000	4
Salesforce	2023	8000	4
Dell	2023	6650	5
 */












