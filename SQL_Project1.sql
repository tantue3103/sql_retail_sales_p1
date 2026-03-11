-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
      transactions_id INT PRIMARY KEY,
      sale_date	DATE,
      sale_time	TIME,
      customer_id INT,	
      gender VARCHAR(15),	
      age INT,	
      category VARCHAR(15),
      quantiy INT,	
      price_per_unit FLOAT,	
      cogs FLOAT,
      total_sale FLOAT
);

INSERT INTO dbo.retail_sales(transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale)
SELECT transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale
FROM dbo.[SQL - Retail Sales Analysis_utf ];

SELECT *
FROM retail_sales AS rs

SELECT COUNT(*)
FROM retail_sales AS rs

-- 
SELECT *
FROM retail_sales AS rs
WHERE transactions_id IS NULL

SELECT *
FROM retail_sales AS rs
WHERE sale_date IS NULL

SELECT *
FROM retail_sales AS rs
WHERE sale_time IS NULL

SELECT *
FROM retail_sales AS rs
WHERE transactions_id IS NULL
      OR 
      sale_date IS NULL
      OR
      sale_time IS NULL
      OR
      gender IS NULL
      OR
      category IS NULL
      OR
      quantiy IS NULL
      OR
      price_per_unit IS NULL
      OR
      cogs IS NULL
      OR 
      total_sale IS NULL

-- Data Cleaning
DELETE FROM retail_sales
WHERE transactions_id IS NULL
      OR 
      sale_date IS NULL
      OR
      sale_time IS NULL
      OR
      gender IS NULL
      OR
      category IS NULL
      OR
      quantiy IS NULL
      OR
      price_per_unit IS NULL
      OR
      cogs IS NULL
      OR 
      total_sale IS NULL

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_sales
FROM retail_sales

SELECT DISTINCT category AS total_sales
FROM retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1:
SELECT *
FROM dbo.retail_sales AS rs
WHERE rs.sale_date = '2022-11-05';

-- Q.2:
-- C1:
SELECT rs.transactions_id, rs.quantiy, MONTH(rs.sale_date) AS Month
FROM dbo.retail_sales AS rs
WHERE rs.category = 'Clothing'
      AND 
      rs.quantiy > 10
      AND
      rs.sale_date BETWEEN '2022-11-01' AND '2022-11-30';
-- C2:
SELECT 
  *
FROM retail_sales AS rs
WHERE 
    rs.category = 'Clothing'
    AND 
    FORMAT(rs.sale_date, 'YYYY-MM') = '2022-11'
    AND
    rs.quantiy >= 10;

-- Q.3:
SELECT rs.category, SUM(rs.total_sale) AS net_sale, COUNT(*) AS total_orders
FROM dbo.retail_sales AS rs
GROUP BY rs.category;

-- Q.4:
-- C1:
SELECT AVG(rs.age) AS AvgAge
FROM dbo.retail_sales AS rs
WHERE rs.category = 'Beauty';

-- C2:
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5:
SELECT *
FROM dbo.retail_sales AS rs
WHERE rs.total_sale >1000;

-- Q.6:
SELECT rs.gender, rs.category, COUNT(rs.transactions_id) AS Numberoftransactions_id
FROM dbo.retail_sales AS rs
GROUP BY rs.gender, rs.category
ORDER BY rs.category;

-- Q.7:
-- C1 Subquery
SELECT
      year,
      month,
      avgtotalsale
FROM (
SELECT 
      YEAR(rs.sale_date) AS year,
      MONTH(rs.sale_date) AS month,
      AVG(rs.total_sale) AS avgtotalsale,
      RANK () OVER (PARTITION BY YEAR(rs.sale_date) ORDER BY AVG(rs.total_sale) DESC) AS rank
FROM dbo.retail_sales AS rs
GROUP BY YEAR(rs.sale_date), MONTH(rs.sale_date)
) AS t1
WHERE rank = 1

--C2 CTE
WITH t1 AS (
    SELECT 
      YEAR(rs.sale_date) AS year,
      MONTH(rs.sale_date) AS month,
      AVG(rs.total_sale) AS avgtotalsale,
      RANK () OVER (PARTITION BY YEAR(rs.sale_date) ORDER BY AVG(rs.total_sale) DESC) AS rank
    FROM dbo.retail_sales AS rs
    GROUP BY YEAR(rs.sale_date), MONTH(rs.sale_date)
)
SELECT year,
       month,
       avgtotalsale
FROM t1
WHERE rank =1

-- Q.8:
SELECT TOP 5 
       rs.customer_id,
       SUM(rs.total_sale) AS Sum_sale
FROM dbo.retail_sales AS rs
GROUP BY rs.customer_id
ORDER BY SUM(rs.total_sale) DESC

-- Q.9:
SELECT
      rs.category,
      COUNT(rs.customer_id) AS CountCustomerid
FROM dbo.retail_sales AS rs
GROUP BY rs.category

-- Q.10:
WITH hourly_sale AS (
    SELECT *,
         CASE 
             WHEN DATEPART (HOUR, rs.sale_time) < 12 THEN 'Morning'
             WHEN DATEPART (HOUR, rs.sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
             ELSE 'Evening'
         END AS Shift
    FROM dbo.retail_sales AS rs
)
SELECT Shift,
       COUNT(*) AS total_orders
FROM hourly_sale 
GROUP BY Shift

-- End of project

