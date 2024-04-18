-- Data Cleaning

SELECT *
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove any columns 

-- MAKE A COPY OF THE DATASET
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;




SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, 
industry, total_laid_off, percentage_laid_off, `date`,stage
,country,funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company='Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- Trovare e rimuovere i duplicati

INSERT INTO layoffs_staging2
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, 
industry, total_laid_off, percentage_laid_off, `date`,stage
,country,funds_raised_millions) as row_num
FROM layoffs_staging
);

DELETE 
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;

-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- La industry selezionata sembra essere la stessa, quindi ho standardizzato tutto ad un solo riferimento 'crypto'

-- Un'occhiata alle varie colonne per vedere se riscontriamo altri problemi 

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Il country United States è presente due volte perchè c'è un '.' presente alla fine del nome

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Errore corretto!

-- La colonna 'date' è formato 'text' e va sistemata

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET  `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- La colonna risulta ancora 'text' ma il suo contenuto è formattato correttamente in una data

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- FIXATO! Adesso anche la definition della colonna 'date' risulta in formato 'date'

-- Ora cerchiamo i valori nulli 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off  IS NULL
AND percentage_laid_off IS NULL;

-- La colonna industry contiente alcuni elementi vuoti che in effetti è possibile completare con l'industry effettiva, quando conosciuta. es. Airbnb

-- Provo a unire la tabella con sè stessa utilizzando match di company e location

-- Il processo non funziona perchè le caselle vuote non vengono trovate come 'null', quindi le converto in valori 'null' 

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON  t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS  NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

-- Ha funzionato! E' rimasta solo una company con valore industry null, 'bally's interactive'. Non ci sono abbastanza informazioni per ripopolare gli altri valori nulli. 

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- Quelle colonne hanno tantissimi valori nulli e non credo saranno utili in futuro quindi decido di eliminarle

DELETE
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- Ripulisco la tabella togliendo la colonna che ho utilizzato precedentemente per controllare i duplicati

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 1. Remove Duplicates FATTO!
-- 2. Standardize the Data FATTO!
-- 3. Null Values or blank values FATTO!
-- 4. Remove any columns FATTO!