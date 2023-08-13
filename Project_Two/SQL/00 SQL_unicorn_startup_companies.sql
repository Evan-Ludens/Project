-- *****Data cleaning*****
-- Find columns with NULL 
SELECT * 
FROM unicorn_startup_companies
WHERE Company IS NULL OR Valuation IS NULL OR Date_Joined IS NULL OR Country IS NULL OR City IS NULL OR Industry IS NULL OR Select_Investors IS NULL OR Company = '' OR Valuation = '' OR Date_Joined = '' OR Country = '' OR City = '' OR Industry = '' OR Select_Investors = '';

-- Since only two null values are at "Select_Investors" column, replace NULL values to "NA"
UPDATE unicorn_startup_companies
SET Select_Investors = 'NA'
WHERE Select_Investors IS NULL OR Select_Investors = '';

-- Update "City" column with null values 
UPDATE unicorn_startup_companies
SET City = 'Singapore' 
WHERE Country = 'Singapore';

UPDATE unicorn_startup_companies
SET City = 'Hong Kong' 
WHERE Country = 'Hong Kong';

UPDATE unicorn_startup_companies
SET Country = 'China' 
WHERE City = 'Hong Kong';

UPDATE unicorn_startup_companies
SET City = 'Victoria' 
WHERE Country = 'Seychelles';

-- Find possible invalid information in critical columns
SELECT Company FROM unicorn_startup_companies ORDER BY Company;
SELECT Valuation FROM unicorn_startup_companies ORDER BY Valuation;
SELECT Country FROM unicorn_startup_companies ORDER BY Country;
SELECT City FROM unicorn_startup_companies ORDER BY City;
SELECT Industry FROM unicorn_startup_companies ORDER BY Industry;

-- Clear data in "Valuation" to make it can be used correclty as number comparing later
UPDATE unicorn_startup_companies
SET Valuation = CAST(REPLACE(Valuation,'$','') AS DECIMAL(10,2));

-- Clear data in "Date_Joined" to make it to date format
UPDATE unicorn_startup_companies
SET Date_Joined = STR_TO_DATE(Date_Joined,'%m/%d/%Y');

-- *****Data analyzing*****
-- Valuation Distribution as per Country
SELECT Country, 
COUNT(CASE WHEN Valuation <= 10 THEN 1 END) AS '(0,10]',
COUNT(CASE WHEN 10 < Valuation AND Valuation <= 20 THEN 1 END) AS '(10,20]',
COUNT(CASE WHEN 20 < Valuation AND Valuation <= 30 THEN 1 END) AS '(20,30]',
COUNT(CASE WHEN 30 < Valuation AND Valuation <= 40 THEN 1 END) AS '(30,40]',
COUNT(CASE WHEN 40 < Valuation AND Valuation <= 50 THEN 1 END) AS '(40,50]',
COUNT(CASE WHEN 50 < Valuation THEN 1 END) AS '(50,∞)',
COUNT(Valuation) AS 'Total_Amount_of_Company',
FORMAT(SUM(Valuation),2) as 'Total_Valuation($B)', FORMAT(AVG(Valuation),2) as 'Average_Valuation($B)' 
FROM unicorn_startup_companies
GROUP BY Country
ORDER BY Total_Amount_of_Company DESC;

-- Valuation Distribution as per Industry
SELECT Industry, 
COUNT(CASE WHEN Valuation <= 10 THEN 1 END) AS '(0,10]',
COUNT(CASE WHEN 10 < Valuation AND Valuation <= 20 THEN 1 END) AS '(10,20]',
COUNT(CASE WHEN 20 < Valuation AND Valuation <= 30 THEN 1 END) AS '(20,30]',
COUNT(CASE WHEN 30 < Valuation AND Valuation <= 40 THEN 1 END) AS '(30,40]',
COUNT(CASE WHEN 40 < Valuation AND Valuation <= 50 THEN 1 END) AS '(40,50]',
COUNT(CASE WHEN 50 < Valuation THEN 1 END) AS '(50,∞)',
COUNT(Valuation) AS 'Total_Amount_of_Company',
FORMAT(SUM(Valuation),2) as 'Total_Valuation($B)', FORMAT(AVG(Valuation),2) as 'Average_Valuation($B)' 
FROM unicorn_startup_companies
GROUP BY Industry
ORDER BY Total_Amount_of_Company DESC;

-- General Joined Year Distribution
SELECT YEAR(Date_Joined) AS 'Year', COUNT(Company) AS 'Total_Amount_of_Company', CONCAT(ROUND((COUNT(Company)/(SELECT COUNT(Company) FROM unicorn_startup_companies))*100,2),'%') AS 'Percentage_to_Total'
FROM unicorn_startup_companies
GROUP BY Year
ORDER BY Year;

-- Joined Year Distribution as per Industry
SELECT Industry,
COUNT(CASE WHEN YEAR(Date_Joined) <= 2011 THEN 1 END) AS 'Before_2011',
COUNT(CASE WHEN YEAR(Date_Joined) = 2012 THEN 1 END) AS '2012',
COUNT(CASE WHEN YEAR(Date_Joined) = 2013 THEN 1 END) AS '2013',
COUNT(CASE WHEN YEAR(Date_Joined) = 2014 THEN 1 END) AS '2014',
COUNT(CASE WHEN YEAR(Date_Joined) = 2015 THEN 1 END) AS '2015',
COUNT(CASE WHEN YEAR(Date_Joined) = 2016 THEN 1 END) AS '2016',
COUNT(CASE WHEN YEAR(Date_Joined) = 2017 THEN 1 END) AS '2017',
COUNT(CASE WHEN YEAR(Date_Joined) = 2018 THEN 1 END) AS '2018',
COUNT(CASE WHEN YEAR(Date_Joined) = 2019 THEN 1 END) AS '2019',
COUNT(CASE WHEN YEAR(Date_Joined) = 2020 THEN 1 END) AS '2020',
COUNT(CASE WHEN YEAR(Date_Joined) = 2021 THEN 1 END) AS '2021',
COUNT(CASE WHEN YEAR(Date_Joined) = 2022 THEN 1 END) AS '2022',
COUNT(CASE WHEN YEAR(Date_Joined) = 2023 THEN 1 END) AS '2023',
COUNT(Date_Joined) AS 'Total_Amount_of_Company',
CONCAT(ROUND(COUNT(Date_Joined)/(SELECT COUNT(Date_Joined) FROM unicorn_startup_companies)*100,2),'%') AS 'Percentage_to_Total'
FROM unicorn_startup_companies
GROUP BY Industry
ORDER BY Total_Amount_of_Company DESC;

-- Joined Year Distribution as per Country
SELECT Country,
COUNT(CASE WHEN YEAR(Date_Joined) <= 2011 THEN 1 END) AS 'Before_2011',
COUNT(CASE WHEN YEAR(Date_Joined) = 2012 THEN 1 END) AS '2012',
COUNT(CASE WHEN YEAR(Date_Joined) = 2013 THEN 1 END) AS '2013',
COUNT(CASE WHEN YEAR(Date_Joined) = 2014 THEN 1 END) AS '2014',
COUNT(CASE WHEN YEAR(Date_Joined) = 2015 THEN 1 END) AS '2015',
COUNT(CASE WHEN YEAR(Date_Joined) = 2016 THEN 1 END) AS '2016',
COUNT(CASE WHEN YEAR(Date_Joined) = 2017 THEN 1 END) AS '2017',
COUNT(CASE WHEN YEAR(Date_Joined) = 2018 THEN 1 END) AS '2018',
COUNT(CASE WHEN YEAR(Date_Joined) = 2019 THEN 1 END) AS '2019',
COUNT(CASE WHEN YEAR(Date_Joined) = 2020 THEN 1 END) AS '2020',
COUNT(CASE WHEN YEAR(Date_Joined) = 2021 THEN 1 END) AS '2021',
COUNT(CASE WHEN YEAR(Date_Joined) = 2022 THEN 1 END) AS '2022',
COUNT(CASE WHEN YEAR(Date_Joined) = 2023 THEN 1 END) AS '2023',
COUNT(Date_Joined) AS 'Total_Amount_of_Company',
CONCAT(ROUND(COUNT(Date_Joined)/(SELECT COUNT(Date_Joined) FROM unicorn_startup_companies)*100,2),'%') AS 'Percentage_to_Total'
FROM unicorn_startup_companies
GROUP BY Country
ORDER BY Total_Amount_of_Company DESC;

-- Joined Year Distribution as per City
SELECT City,
COUNT(CASE WHEN YEAR(Date_Joined) <= 2011 THEN 1 END) AS 'Before_2011',
COUNT(CASE WHEN YEAR(Date_Joined) = 2012 THEN 1 END) AS '2012',
COUNT(CASE WHEN YEAR(Date_Joined) = 2013 THEN 1 END) AS '2013',
COUNT(CASE WHEN YEAR(Date_Joined) = 2014 THEN 1 END) AS '2014',
COUNT(CASE WHEN YEAR(Date_Joined) = 2015 THEN 1 END) AS '2015',
COUNT(CASE WHEN YEAR(Date_Joined) = 2016 THEN 1 END) AS '2016',
COUNT(CASE WHEN YEAR(Date_Joined) = 2017 THEN 1 END) AS '2017',
COUNT(CASE WHEN YEAR(Date_Joined) = 2018 THEN 1 END) AS '2018',
COUNT(CASE WHEN YEAR(Date_Joined) = 2019 THEN 1 END) AS '2019',
COUNT(CASE WHEN YEAR(Date_Joined) = 2020 THEN 1 END) AS '2020',
COUNT(CASE WHEN YEAR(Date_Joined) = 2021 THEN 1 END) AS '2021',
COUNT(CASE WHEN YEAR(Date_Joined) = 2022 THEN 1 END) AS '2022',
COUNT(CASE WHEN YEAR(Date_Joined) = 2023 THEN 1 END) AS '2023',
COUNT(Date_Joined) AS 'Total_Amount_of_Company',
CONCAT(ROUND(COUNT(Date_Joined)/(SELECT COUNT(Date_Joined) FROM unicorn_startup_companies)*100,2),'%') AS 'Percentage_to_Total'
FROM unicorn_startup_companies
GROUP BY City
ORDER BY Total_Amount_of_Company DESC;

-- Company joined starts 2020 as per Industry
SELECT Industry,
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020',
COUNT(Date_Joined) AS 'Total_Amount_of_Company',
CONCAT(ROUND(COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END)/COUNT(Date_Joined)*100,2),'%') AS 'Comparing_to_Total'
FROM unicorn_startup_companies 
GROUP BY Industry
ORDER BY Company_Joined_Starts_2020 DESC;

-- Company joined starts 2020 as per Country
SELECT Country,
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020',
COUNT(Date_Joined) AS 'Total_Amount_of_Company',
CONCAT(ROUND(COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END)/COUNT(Date_Joined)*100,2),'%') AS 'Comparing_to_Total'
FROM unicorn_startup_companies
GROUP BY Country
ORDER BY Company_Joined_Starts_2020 DESC;

-- Company joined starts 2020 as per City
SELECT City,
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020',
COUNT(Date_Joined) AS 'Total_Company_Amount',
CONCAT(ROUND(COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END)/COUNT(Date_Joined)*100,2),'%') AS 'Comparing_to_Total'
FROM unicorn_startup_companies
GROUP BY City
ORDER BY Company_Joined_Starts_2020 DESC;

-- The Country starts to have unicorn startup starts 2020
SELECT Country,
COUNT(CASE WHEN YEAR(Date_Joined) < 2020 THEN 1 END) AS 'Before_2020',
COUNT(CASE WHEN YEAR(Date_Joined) = 2020 THEN 1 END) AS '2020',
COUNT(CASE WHEN YEAR(Date_Joined) = 2021 THEN 1 END) AS '2021',
COUNT(CASE WHEN YEAR(Date_Joined) = 2022 THEN 1 END) AS '2022',
COUNT(CASE WHEN YEAR(Date_Joined) = 2023 THEN 1 END) AS '2023',
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020'
FROM unicorn_startup_companies
GROUP BY Country
HAVING COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END)/COUNT(Date_Joined) = 1
ORDER BY Company_Joined_Starts_2020 DESC;

-- The Country stops to have unicorn startup starts 2020
SELECT Country,
COUNT(CASE WHEN YEAR(Date_Joined) <= 2015 THEN 1 END) AS 'Before_2015',
COUNT(CASE WHEN YEAR(Date_Joined) = 2016 THEN 1 END) AS '2016',
COUNT(CASE WHEN YEAR(Date_Joined) = 2017 THEN 1 END) AS '2017',
COUNT(CASE WHEN YEAR(Date_Joined) = 2018 THEN 1 END) AS '2018',
COUNT(CASE WHEN YEAR(Date_Joined) = 2019 THEN 1 END) AS '2019',
COUNT(CASE WHEN YEAR(Date_Joined) > 2019 THEN 1 END) AS 'After_2019',
COUNT(Date_Joined) AS 'Total_Amount_of_Company'
FROM unicorn_startup_companies
GROUP BY Country
HAVING COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END)/COUNT(Date_Joined) = 0
ORDER BY Total_Amount_of_Company DESC;

-- Valuation of companies joined starts 2020 as per industry
SELECT Industry,
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020',
FORMAT(SUM(Valuation),2) AS 'Total_Valuation_Starts_2020($B)',
FORMAT(AVG(Valuation),2) AS 'Average_Valuation_Starts_2020($B)',
FORMAT(MAX(Valuation),2) AS 'Higest_Valuation_Starts_2020($B)',
FORMAT(MIN(Valuation),2) AS 'Lowest_Valuation_Starts_2020($B)'
FROM unicorn_startup_companies
WHERE YEAR(Date_Joined) >= 2020
GROUP BY Industry
ORDER BY SUM(Valuation) DESC;

-- Valuation of companies joined starts 2020 as per country
SELECT Country,
COUNT(CASE WHEN YEAR(Date_Joined) >= 2020 THEN 1 END) AS 'Company_Joined_Starts_2020',
FORMAT(SUM(Valuation),2) AS 'Total_Valuation_Starts_2020($B)',
FORMAT(AVG(Valuation),2) AS 'Average_Valuation_Starts_2020($B)',
FORMAT(MAX(Valuation),2) AS 'Higest_Valuation_Starts_2020($B)',
FORMAT(MIN(Valuation),2) AS 'Lowest_Valuation_Starts_2020($B)'
FROM unicorn_startup_companies
WHERE YEAR(Date_Joined) >= 2020
GROUP BY Country
ORDER BY SUM(Valuation) DESC;