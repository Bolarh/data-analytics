select * from layoffs_staging2;

#Top 5 Companies that had the most layoffs_overall

select company, sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by company order by total_layoffs desc;

#unique companies in the dataset
select count(DISTINCT company) from layoffs_staging2;

#What are the top 10 companies by total number of laid-off employees?
select company, sum( total_laid_off) as total_layoffs from layoffs_staging2
group by company
order by total_layoffs desc limit 10;


#In which years or months did the most layoffs occur?
select year(`date` ) as year_trend, SUM(total_laid_off) as total_layoffs from 
layoffs_staging2 
group by year_trend order by total_layoffs desc limit 1;

select month(`date` ) as month_trend, SUM(total_laid_off) as total_layoffs from 
layoffs_staging2 
group by month_trend order by total_layoffs desc limit 1;

# Is there a trend of layoffs increasing or decreasing over time?

select `date` from layoffs_staging2;
select month(`date`) as Over_the_years , sum(total_laid_off) as total_layoffs
from layoffs_staging2 
GROUP BY Over_the_years order by total_layoffs desc;

#Which countries experienced the most layoffs?
select country, sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by country
order by total_layoffs desc ;

#Which location had the most layoffs?
select location, sum(total_laid_off) as total_layoffs
from layoffs_staging2 
GROUP BY location 
order by total_layoffs desc LIMIT 5;

#Which companies laid off 100% of their staff?
select company, percentage_laid_off from  layoffs_staging2 where percentage_laid_off = 1;
