-- Data Analysis
-- Using data from January 2024 to February 2024
-- https://data.police.uk/data/ 

--  1. Exploring the data

Select *
from policecrimedata_staging2 ;

Select Distinct Reported_by
from policecrimedata_staging2 ;

Select Distinct Crime_type
from policecrimedata_staging2 ;

Select Distinct Last_outcome_category
from policecrimedata_staging2 ;

-- 2. Which month had the most crime?

SELECT Month, CASE WHEN Month = '2024-01' THEN 'January'
 WHEN Month = '2024-02' THEN 'February'
END AS Month_name,
COUNT(*) as monthly_count
FROM policecrimedata_staging2
GROUP BY Month
ORDER BY Month ;

-- 3. Number of arrests by police force? (With the highest on top and in descending order)

Select Distinct Reported_by,
    COUNT(*) as total_crimes_reported
FROM policecrimedata_staging2
GROUP BY Reported_by
ORDER BY COUNT(*) DESC ;

-- 4. Which type of crime occurs the most?

Select Crime_type,
    COUNT(*) as 'Crime_Count'
FROM policecrimedata_staging2
GROUP BY Crime_type
ORDER BY COUNT(*) DESC ;

-- 5. Percentage of  police forces making arrests?

Select Reported_by,
COUNT(*) as 'Count',
Round((Count(*) * 100.0 / (Select Count(*) from policecrimedata_staging2)), 2) as Percentage
FROM policecrimedata_staging2
GROUP BY Reported_by
ORDER BY Percentage DESC ;

-- 6. Crime that happens the most often show in percentage?

Select Crime_type,
COUNT(*) as 'Count',
Round((Count(*) * 100.0 / (Select Count(*) from policecrimedata_staging2)), 2) as Percentage
FROM policecrimedata_staging2
GROUP BY Crime_type
ORDER BY Percentage DESC ;

-- 7. Which outcome of investigation is most likely?

Select Last_outcome_category,
    COUNT(*) as 'Count'
FROM policecrimedata_staging2
GROUP BY Last_outcome_category
ORDER BY COUNT(*) DESC ;

-- 8. Percentage of outcome of investigation?

Select Last_outcome_category,
COUNT(*) as 'Count',
Round((Count(*) * 100.0 / (Select Count(*) from policecrimedata_staging2)), 2) as Percentage
FROM policecrimedata_staging2
GROUP BY Last_outcome_category
ORDER BY Percentage DESC ;

-- 9. Most likely outcome if there is a case for shoplifting for Essex Police?

Select Last_outcome_category,
COUNT(*) as 'Count'
FROM policecrimedata_staging2
where reported_by = 'Essex Police'
and crime_type = 'shoplifting'
GROUP BY Last_outcome_category
ORDER BY Count(*) DESC ;

-- 10. Number of cases per month

SELECT Month, 
COUNT(*) as 'Count'
FROM policecrimedata_staging2
GROUP BY Month
ORDER BY Count(*) DESC;

-- 11. Rolling number of cases per month

WITH DATE_CTE AS 
(
SELECT Month, 
COUNT(*) as 'Count'
FROM policecrimedata_staging2
GROUP BY Month
ORDER BY Count(*) DESC
)
SELECT Month, SUM(Count) OVER (ORDER BY Month ASC) as rolling_total_crime
FROM DATE_CTE
ORDER BY Month ASC;

-- 12. Which police force had the most cases in a specific month?

  SELECT reported_by, Month, Count(*)
  FROM policecrimedata_staging2
  GROUP BY reported_by, Month
  ORDER BY Count(*) DESC
