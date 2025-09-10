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

