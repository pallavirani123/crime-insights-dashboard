/* 
====================================================
  Project: Crime Insights and Trends Dashboard
  Description: SQL queries for analyzing crime data, 
               including crime hotspots, crime types, 
               distribution patterns, and case closure rates.
  Data Source: crime_data_bucket1 (AWS Athena)
  Author: Velagala Pallavi Rani
  Date: 18-05-2023
====================================================
*/


-- ================================================
-- 1. Crime Hotspots (Top 10 Cities by Crime Count)
-- Description: Shows cities with the highest number of crime cases in 2020.
--              Useful for identifying areas requiring targeted law enforcement.
-- ================================================
SELECT 
    City, 
    COUNT(*) AS CrimeCount
FROM crime_data_bucket1
WHERE CAST(DateReported AS TIMESTAMP) BETWEEN TIMESTAMP '2020-01-01 00:00:00' 
AND TIMESTAMP '2020-12-31 23:59:59'
GROUP BY City
ORDER BY CrimeCount DESC
LIMIT 10;



-- ================================================
-- 2. Top Crime Types (Most Common Crimes in 2020)
-- Description: Lists the top 10 crime types based on frequency in 2020.
--              Helps law enforcement prioritize strategies for common crimes.
-- ================================================
SELECT 
    CrimeDescription, 
    COUNT(*) AS CrimeCount
FROM crime_data_bucket1
WHERE CAST(DateReported AS TIMESTAMP) BETWEEN TIMESTAMP '2020-01-01 00:00:00' 
AND TIMESTAMP '2020-12-31 23:59:59'
GROUP BY CrimeDescription
ORDER BY CrimeCount DESC
LIMIT 10;



-- ================================================
-- 3. Crime Distribution by Day of the Week
-- Description: Shows how crime incidents are distributed across weekdays.
--              Useful for identifying patterns and deploying resources accordingly.
-- ================================================
SELECT 
    EXTRACT(DOW FROM CAST(DateReported AS TIMESTAMP)) AS DayOfWeek, 
    COUNT(*) AS CrimeCount
FROM crime_data_bucket1
GROUP BY EXTRACT(DOW FROM CAST(DateReported AS TIMESTAMP))
ORDER BY DayOfWeek;



-- ================================================
-- 4. Seasonal Crime Patterns
-- Description: Analyzes crime distribution by season (Winter, Spring, Summer, Autumn).
--              Helps detect seasonal trends that can influence crime rates.
-- ================================================
SELECT 
    CASE 
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END AS Season, 
    COUNT(*) AS CrimeCount
FROM crime_data_bucket1
GROUP BY 
    CASE 
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(CAST(DateReported AS TIMESTAMP)) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Autumn'
    END
ORDER BY CrimeCount DESC;



-- ================================================
-- 5. Open vs. Closed Cases Analysis
-- Description: Shows the total number of cases, how many were closed, 
--              how many remain open, and the closure percentage.
--              Useful for understanding case resolution performance.
-- ================================================
SELECT
    COUNT(*) AS TotalCases,
    SUM(CASE WHEN LOWER(CaseClosed) = 'yes' THEN 1 ELSE 0 END) AS ClosedCases,
    SUM(CASE WHEN LOWER(CaseClosed) = 'no' THEN 1 ELSE 0 END) AS OpenCases,
    ROUND(
        (SUM(CASE WHEN LOWER(CaseClosed) = 'yes' THEN 1 ELSE 0 END) * 100.0) / 
        NULLIF(COUNT(*), 0), 2
    ) AS PercentageCasesClosed
FROM crime_data_bucket1;



-- ================================================
-- 6. Crime Rate Comparison Across Years
-- Description: Compares crime counts across multiple years.
--              Calculates year-over-year changes to detect crime spikes or reductions.
--              Useful for understanding long-term crime trends and their fluctuations.
-- ================================================
WITH YearlyCrime AS (
    SELECT 
        EXTRACT(YEAR FROM CAST(DateReported AS TIMESTAMP)) AS Year, 
        COUNT(*) AS CrimeCount
    FROM crime_data_bucket1
    GROUP BY EXTRACT(YEAR FROM CAST(DateReported AS TIMESTAMP))
)
SELECT 
    Year, 
    CrimeCount,
    LAG(CrimeCount) OVER (ORDER BY Year) AS PreviousYearCrimeCount,
    ROUND(
        (CrimeCount - LAG(CrimeCount) OVER (ORDER BY Year)) * 100.0 / 
        NULLIF(LAG(CrimeCount) OVER (ORDER BY Year), 0), 2
    ) AS CrimeRateChangePercentage
FROM YearlyCrime
ORDER BY Year;



/* 
====================================================
End of SQL Queries
These queries power the Tableau dashboard visualizing 
key crime trends, patterns, and insights.
====================================================
*/
