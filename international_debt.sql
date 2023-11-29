-- Table: international_debt

CREATE TABLE international_debt
(
  country_name character varying(50),
  country_code character varying(50),
  indicator_name text,
  indicator_code text,
  debt numeric
);

-- Copy over data from CSV
\copy international_debt FROM 'international_debt.csv' DELIMITER ',' CSV HEADER;

-- Let's examine the table
%%sql
postgresql:///international_debt
SELECT *
FROM international_debt
LIMIT 10;

-- And count the number of country presented in the table
SELECT
    COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

-- Finding out the distinct debt indicators
SELECT DISTINCT indicator_code AS distinct_debt_indicators
FROM international_debt
ORDER BY distinct_debt_indicators;

-- Total global debt
SELECT
    ROUND(SUM(debt)/1000000, 2) AS total_debt
FROM international_debt;

-- Country bearing the highest debt
SELECT
    country_name,
    SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 1;

-- Average amount of debt across indicators
SELECT
    indicator_code AS debt_indicator,
    indicator_name,
    AVG(debt) AS average_debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY average_debt DESC
LIMIT 10;

-- The highest amount of principal repayments
SELECT
    country_name,
    indicator_name
FROM international_debt
WHERE debt = (SELECT
                 MAX(debt)
             FROM international_debt
             WHERE indicator_code ='DT.AMT.DLXF.CD'
GROUP BY country_name, indicator_code
ORDER BY MAX(debt) DESC
LIMIT 1);

-- The most common debt indicator
SELECT indicator_code, COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC
LIMIT 20;

--Other debt issues
SELECT country_name, MAX(debt) as maximum_debt
FROM international_debt
GROUP by country_name
ORDER BY maximum_debt DESC
LIMIT 10;
