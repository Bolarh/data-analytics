use world_layoffs;
select * from layoffs;

-- data cleaning project with sql

-- step 1 
-- remove duplicates

-- step 2 
-- standardize the data

-- step 3 
-- null values or blank values

-- step 4
-- remove any columns

-- step 1 removing duplicates 
CREATE  table layoffs_staging AS
SELECT * FROM layoffs;

select * from layoffs_staging;

-- finding duplicates, we assign row number to each the rows

WITH duplicates_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY company,stage, location, industry, country, `date`, total_laid_off, funds_raised_millions) AS
row_num FROM layoffs_staging
)
SELECT * FROM duplicates_cte where row_num > 1;

SELECT * FROM layoffs_staging WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `industry` text DEFAULT NULL,
  `total_laid_off` int(11) DEFAULT NULL,
  `percentage_laid_off` text DEFAULT NULL,
  `date` text DEFAULT NULL,
  `stage` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `funds_raised_millions` int(11) DEFAULT NULL,
  `row_num` int(11)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO layoffs_staging2 
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY company,stage, location, industry, country, `date`, total_laid_off, funds_raised_millions) AS
row_num FROM layoffs_staging;
SELECT * FROM layoffs_staging2 WHERE
row_num >1;

DELETE FROM layoffs_staging2 WHERE 
row_num >1;


-- standardizing
SELECT distinct industry from layoffs_staging2;

select * from layoffs_staging2 where industry like '%Crypto%' order by 1;

update layoffs_staging2 
set industry = 'Crypto' 
where industry like 'Crypto%';

select DISTINCT country from layoffs_staging2;

UPDATE layoffs_staging2 
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct `date` from layoffs_staging2;

select `date` , STR_TO_DATE(`date`, '%m/%d/%y') as new_date
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%y');

alter table layoffs_staging2
MODIFY column `date` DATE;

select * from layoffs_staging2
WHERE company = 'Airbnb';

select * from layoffs_staging2 
where industry is null or industry = '';

select * from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null; 

update layoffs_staging2
set industry = null where industry = '';

update layoffs_staging2 t1 
join layoffs_staging2 t2 
on t1.company =t2.company
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null;

select * from layoffs_staging2 
where total_laid_off is null 
and percentage_laid_off is null;

delete from layoffs_staging2 
where total_laid_off is null 
and percentage_laid_off is null;

select * from layoffs_staging2 ;

alter table layoffs_staging2
drop column row_num;
