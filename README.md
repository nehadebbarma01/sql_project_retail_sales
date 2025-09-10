# Retail Sales Analysis - SQL

## Overview
This project performs comprehensive analysis on retail sales data using SQL. It includes data cleaning, exploration, and key business insights to understand customer behavior, sales trends, and product performance.

## Dataset
The `retail_sales` table contains the following columns:  
- `transactions_id` : INT, primary key  
- `sale_date` : DATE  
- `sale_time` : TIME  
- `customer_id` : INT  
- `gender` : VARCHAR  
- `age` : INT  
- `category` : VARCHAR  
- `quantiy` : INT  
- `price_per_unit` : FLOAT  
- `cogs` : FLOAT  
- `total_sale` : FLOAT  

## Key Analyses
- Total sales, unique customers, and category count  
- Daily, monthly, and shift-wise sales trends  
- Top customers and high-value transactions  
- Profit calculation and average profit margins  
- Category-wise performance and quantity insights  
- Time-based insights: peak hours, day-of-week sales  

## Queries
The project includes SQL queries for:  
1. Filtering and retrieving transactions by date or category  
2. Aggregating total and average sales  
3. Ranking months and customers based on sales  
4. Calculating profits and profit margins  
5. Shift-wise and hourly transaction analysis  

## Usage
- Import the dataset into a PostgreSQL database  
- Run the provided SQL scripts to perform analysis  
- Modify queries as needed for further insights  

## Insights
- Identifies best-selling categories and months  
- Highlights top customers and high-value transactions  
- Provides profit and revenue trends for decision making  
- Helps in understanding customer demographics and purchasing patterns  

## SQL Retail Sales Analysis - P1
## CREATE TABLE
```sql
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
```
## Data Cleaning

```sql
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
```
## Data Exploration 

#### How many sales we have?
```sql
Select count(*) as total_sales from retail_sales
```
#### How many customers customers we have?
```sql
Select count(DISTINCT(customer_id)) as total_customers from retail_sales
```
#### How many category we have?
```sql
Select count(DISTINCT(category)) as total_category from retail_sales;
```

## Data Analysis & Business key problems & Answers

### My Analysis & findings

#### Q1. Write a SQL query to retrive all columns for sales made on '2022-11-05'
```sql
	SELECT * from retail_sales where sale_date = '2022-11-05'
```

#### Q2. Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than it 4 in the month of Nov-2022
```sql
	SELECT 
		*
	FROM retail_sales
	WHERE category = 'Clothing'
		AND 
		TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
		AND 
		quantiy >= 4
```

#### Q3. Write a SQL query to calculate the total sales (total_sale) for each category
```sql
  SELECT
		category,
		SUM(total_sale) as net_sale,
		Count(*) as total_orders
	from retail_sales
	GROUP BY 1
```

#### Q4. Write a SQL query to find the average age of customers who purchasedd items from the 'Beauty' categorty.
```sql
	SELECT 
		ROUND(AVG(age),2) as avg_age
	FROM retail_sales
	where category = 'Beauty'
```

#### Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
 ```sql
	SELECT * from retail_sales
	where total_sale > 1000
 ```

#### Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category.
 ```sql
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
```

#### Q7. Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
 ```sql
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
```

#### Q8. Write a SQL query to find the top 5 customers based on the heighest total sales
 ```sql
	SELECT 
		customer_id,
		SUM(total_sale) as total_sales
	from retail_sales 
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5
```

#### Q9. Write a SQL query to find the number of unique customers who purchased items for each category.
 ```sql
	SELECT 
		category,
		COUNT(DISTINCT(customer_id)) as UNIQUE_CUSTOMERS
	FROM retail_sales
	GROUP BY 1
```

#### Q10. Write a SQL query to create each shift and number of orders(Example Morning <= 12 & 17,Evening > 17)
 ```sql
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
```

### Sales Performance & Trends 

#### Q11.Find the daily total sales trend for the month of November 2022
 ```sql
  SELECT 
  		sale_date,
		SUM(total_sale) as total_sales
	FROM retail_sales 
		WHERE
			to_char(sale_date,'YYYY-MM') = '2022-11'
			GROUP BY 1
			ORDER BY 1
```

 #### Q12. Find the top 3 best-selling categories based on total sales 
  ```sql
	SELECT 
		category,
		SUM(total_sale) as total_sales
	FROM retail_sales
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 3
```

#### Q13. Find the worst-selling category (least revenue)
  ```sql
	SELECT 
		category,
		SUM(total_sale) as total_sales
	FROM retail_sales 
	GROUP BY 1
	ORDER BY 2 
	LIMIT 1
 ```

## Customer Insights
#### Q14. Find customers who made more than 5 products 
  ```sql
	SELECT 
		customer_id,
		COUNT(transactions_id) as total_purchase
	FROM retail_sales
	GROUP BY 1
	HAVING COUNT(transactions_id) > 5
	ORDER BY 2 DESC
```

#### Q15. Find the gender-wise average spending per transaction
  ```sql
	SELECT 
		gender,
		ROUND(AVG(total_sale),2) as average_spending
	FROM retail_sales
	GROUP BY 1
 ```

#### Q16. Find the heighest spending customer(max lifetime sales).
  ```sql
	SELECT 
		customer_id,
		SUM(total_sale) as lifetime_sales
	from retail_sales
		GROUP BY 1 
		ORDER BY 2 DESC
		LIMIT 1
```

#### Q17. Calculate profit for each transaction (total sales - cogs)
  ```sql
	SELECT 
		transactions_id,
		(total_sale - cogs) as Profit
	FROM retail_sales
```

#### Q18. Find the category that generated the heighest profit 
  ```sql
	SELECT 
		category,
		ROUND(SUM(total_sale - cogs)) as Total_Profit
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1
```

#### Q19. Find average profit margin for each category
  ```sql
	SELECT 
		category,
		ROUND(AVG(total_sale - cogs/total_sale * 100)) as Average_Profit_Margin
	FROM retail_Sales 
		GROUP BY category
		ORDER BY 2 DESC
  ```

## Time-based Analysis

#### Q20. Find sales distribution by day of week (Sunday-Saturday)
  ```sql
	SELECT 
		to_char(sale_date,'Day') as "Day of week",
		SUM(total_sale) as "Total_sales"
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
```

#### Q21. Find peak shopping hour(Most transactions by hour)
  ```sql
	SELECT 
		EXTRACT(HOUR from sale_time) as "Shopping Hour",
		COUNT(transactions_id) as "Total_transactions"
	FROM retail_sales 
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1
```

## Product/Quantity Insights

#### Q22. Find the average order value(AOV).
  ```sql
	SELECT
		ROUND(AVG(total_sale)) as "Average sales"
	FROM retail_sales
 ```

#### Q23. Find transactions where customers bought more than 10 items (quantity > 10)
  ```sql
	SELECT * 
	FROM retail_sales
	WHERE quantiy > 10
 ```

#### Q24. Find the category with the heighest average quantity sold per order 
  ```sql
	SELECT 
		category,
		ROUND(AVG(quantiy),2) as "Average_Quantity"
	FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1
```
## Conclusion
This project provides a structured approach to retail sales analysis using SQL. It helps identify top-performing products, peak sales periods, high-value customers, and profit margins. The insights can support data-driven decision-making, optimize sales strategies, and improve customer engagement.  

## END OF PROJECT
