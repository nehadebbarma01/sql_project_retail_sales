
--SQL Retail Sales Analysis - P1
--Create TABLE
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)
	Select * from retail_sales
	LIMIT 10

	Select 
		count(*)
	from retail_sales

	SELECT * from retail_sales
	where transactions_id is NULL

	SELECT * from retail_sales
	where sale_date is NULL

	SELECT * from retail_sales
	where sale_time is NULL

	SELECT * from retail_sales
	where customer_id is NULL

	SELECT * from retail_sales
	where gender is NULL

	SELECT * from retail_sales
	where age is NULL

--Data Cleaning
	SELECT * from retail_sales
	where 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR 
		customer_id IS NULL
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
		total_sale IS NULL

	DELETE from retail_sales 
	where 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR 
		customer_id IS NULL
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
		total_sale IS NULL

-- Data Exploration 

-- How many sales we have?
Select count(*) as total_sales from retail_sales;

-- How many customers customers we have?
Select count(DISTINCT(customer_id)) as total_customers from retail_sales;

-- How many category we have?
Select count(DISTINCT(category)) as total_category from retail_sales;

-- Data Analysis & Business key problems & Answers

-- My Analysis & findings
-- Q1. Write a SQL query to retrive all columns for sales made on '2022-11-05'
-- Q2. Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than it 4 in the month of Nov-2022
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
-- Q4. Write a SQL query to find the average age of customers who purchasedd items from the 'Beauty' categorty
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category.
-- Q7. Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
-- Q8. Write a SQL query to find the top 5 customers based on the heighest total sales
-- Q9. Write a SQL query to find the number of unique customers who purchased items for each category.
-- Q10. Write a SQL query to create each shift and number of orders(Example Morning <= 12 & 17,Evening > 17)

-- Q1. Write a SQL query to retrive all columns for sales made on '2022-11-05'
	SELECT * from retail_sales where sale_date = '2022-11-05'

-- Q2. Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than it 4 in the month of Nov-2022
	SELECT 
		*
	FROM retail_sales
	WHERE category = 'Clothing'
		AND 
		TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
		AND 
		quantiy >= 4
	

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
	SELECT
		category,
		SUM(total_sale) as net_sale,
		Count(*) as total_orders
	from retail_sales
	GROUP BY 1

-- Q4. Write a SQL query to find the average age of customers who purchasedd items from the 'Beauty' categorty
	SELECT 
		ROUND(AVG(age),2) as avg_age
	FROM retail_sales
	where category = 'Beauty'

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
	SELECT * from retail_sales
	where total_sale > 1000

-- Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category.
	SELECT 
		category,
		gender,
		COUNT(*) as total_transaction
	from retail_sales
	GROUP  
		BY 
		category,
		gender
	ORDER BY 1

-- Q7. Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
	SELECT 
		year,
		month,
		avg_sale
	from
	(
		 SELECT
			EXTRACT(YEAR FROM sale_date) as year,
			EXTRACT(MONTH FROM sale_date) as month,
			ROUND(AVG(total_sale)) as avg_sale,
			RANK() over(partition by EXTRACT(YEAR FROM sale_date) order by AVG(total_sale) DESC) as rank
		from retail_sales
		GROUP BY 1,2
	) as t1
	where rank = 1

-- Q8. Write a SQL query to find the top 5 customers based on the heighest total sales
	SELECT 
		customer_id,
		SUM(total_sale) as total_sales
	from retail_sales 
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

-- Q9. Write a SQL query to find the number of unique customers who purchased items for each category.
	SELECT 
		category,
		COUNT(DISTINCT(customer_id)) as UNIQUE_CUSTOMERS
	FROM retail_sales
	GROUP BY 1

-- Q10. Write a SQL query to create each shift and number of orders(Example Morning <= 12 & 17,Evening > 17)
	with hourly_sale 
	AS
	(
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as Shift
	from retail_sales 
	)
	Select 
		shift,
		COUNT(transactions_id) as total_transactions
	from hourly_sale 
	GROUP BY SHIFT
	ORDER BY 2 DESC

-- Sales Performance & Trends 

-- Q11.Find the daily total sales trend for the month of November 2022
  SELECT 
  		sale_date,
		SUM(total_sale) as total_sales
	FROM retail_sales 
		WHERE
			to_char(sale_date,'YYYY-MM') = '2022-11'
			GROUP BY 1
			ORDER BY 1

-- Q12. Find the top 3 best-selling categories based on total sales 
	SELECT 
		category,
		SUM(total_sale) as total_sales
	FROM retail_sales
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 3

-- Q13. Find the worst-selling category (least revenue)
	SELECT 
		category,
		SUM(total_sale) as total_sales
	FROM retail_sales 
	GROUP BY 1
	ORDER BY 2 
	LIMIT 1

-- Customer Insights
-- Q14. Find customers who made more than 5 products 
	SELECT 
		customer_id,
		COUNT(transactions_id) as total_purchase
	FROM retail_sales
	GROUP BY 1
	HAVING COUNT(transactions_id) > 5
	ORDER BY 2 DESC

-- Q15. Find the gender-wise average spending per transaction
	SELECT 
		gender,
		ROUND(AVG(total_sale),2) as average_spending
	FROM retail_sales
	GROUP BY 1

-- Q16. Find the heighest spending customer(max lifetime sales).
	SELECT 
		customer_id,
		SUM(total_sale) as lifetime_sales
	from retail_sales
		GROUP BY 1 
		ORDER BY 2 DESC
		LIMIT 1

-- Q17. Calculate profit for each transaction (total sales - cogs)
	SELECT 
		transactions_id,
		(total_sale - cogs) as Profit
	FROM retail_sales

-- Q18. Find the category that generated the heighest profit 
	SELECT 
		category,
		ROUND(SUM(total_sale - cogs)) as Total_Profit
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1

--Q19. Find average profit margin for each category
	SELECT 
		category,
		ROUND(AVG(total_sale - cogs/total_sale * 100)) as Average_Profit_Margin
	FROM retail_Sales 
		GROUP BY category
		ORDER BY 2 DESC

-- Time-based Analysis

--Q20. Find sales distribution by day of week (Sunday-Saturday)
	SELECT 
		to_char(sale_date,'Day') as "Day of week",
		SUM(total_sale) as "Total_sales"
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC

-- Q21. Find peak shopping hour(Most transactions by hour)
	SELECT 
		EXTRACT(HOUR from sale_time) as "Shopping Hour",
		COUNT(transactions_id) as "Total_transactions"
	FROM retail_sales 
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1

-- Product/Quantity Insights

--Q22. Find the average order value(AOV).
	SELECT
		ROUND(AVG(total_sale)) as "Average sales"
	FROM retail_sales

--Q23. Find transactions where customers bought more than 10 items (quantity > 10)
	SELECT * 
	FROM retail_sales
	WHERE quantiy > 10

--Q24. Find the category with the heighest average quantity sold per order 
	SELECT 
		category,
		ROUND(AVG(quantiy),2) as "Average_Quantity"
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1

-- END OF PROJECT