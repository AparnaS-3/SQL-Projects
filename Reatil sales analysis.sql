-- SQL RETAIL SALES ANALYSIS - P1
-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE reatil_sales(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);
SELECT * FROM reatil_sales
LIMIT 10;

SELECT COUNT(*) FROM reatil_sales;

-- DATA CLEANING

SELECT * FROM reatil_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id	IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM public.reatil_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id	IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- DATA EXPLORATION

--How many sales we have?
SELECT COUNT(*) AS total_sales FROM public.reatil_sales;

-- How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM public.reatil_sales;

-- How many categories we have?

SELECT DISTINCT category FROM public.reatil_sales;

-- BUSINESS KEY PROBLEMS

--Q1) Write a SQL query to retrieve all columns for sales made on '2022-11-5'

SELECT * FROM public.reatil_sales
WHERE sale_date = '2022-11-5';

--Q2)Write a SQL query to retrieve all transactions where category is clothing and quantity is more than 10 at the month of Nov 2022

SELECT * FROM public.reatil_sales
WHERE
category = 'Clothing'
AND
quantiy >=4
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11';

--Q3)Write a SQL query to calculate the total sales(total sale) for each category

SELECT 
category,
SUM(total_sale) AS total_sale,
COUNT(*) as total_orders
FROM public.reatil_sales
GROUP BY category;

--q4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

Select 
ROUND(AVG(age),2) AS average_age
FROM public.reatil_sales
WHERE category='Beauty';

--Q5) Write a SQL query to find all transactions  where the total sale is greater than 1000

SELECT * FROM public.reatil_sales
WHERE total_sale>=1000;

-- Q6) Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category.

SELECT
category,
gender,
count(*) as total_transaction
FROM public.reatil_sales
GROUP BY category,gender
ORDER BY 1;

--Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month each year.

SELECT *
FROM
(SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
avg(total_sale) as average_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY avg(total_sale) DESC  ) AS rank
FROM public.reatil_sales
GROUP BY year,month
order by 1,3 ) AS t1
WHERE rank=1;

--Q8)Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
customer_id,
SUM(total_sale) AS total_sale
FROM public.reatil_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q9)Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,COUNT(DISTINCT(customer_id))
FROM public.reatil_sales
GROUP BY category;

--Q10)Write a SQL query to create each shift and number of orders(ex morning <=12,afternoon between 12 and 17, evening >17)

WITH hourly_sale 
as
(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS shift
FROM public.reatil_sales)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY 1

--End of the project--