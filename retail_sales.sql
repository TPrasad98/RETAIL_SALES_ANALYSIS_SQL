set search_path to retail_sales_analysis;

select * from retail_sales
	limit 10;

select count(*)
from retail_sales_analysis.retail_sales;

-- data cleaning

select * from retail_sales
where 
	transactions_id is null
	or 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null;



-- lets delete the null values

delete  from retail_sales
where
	transactions_id is null
	or 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null;




-- data exploration

-- how many sales we have?

select count(*)
from retail_sales;


-- how many unique customers we have?
select count(distinct customer_id)
from retail_sales;


-- total num of category
select count(distinct category)
from retail_sales;

select distinct category
from retail_sales;


-- data analysis or businesss key problems

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select *
from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND
	quantity > 3
	;



-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.


SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select gender,category,round(avg(age),2) as avg_age
from retail_sales
group by gender,category
having category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail_sales
	where total_sale>1000;



-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,category,count(*) as total_transaction
from retail_sales
group by gender,category;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.


WITH AVG_SALE_PER_MONTH AS(
SELECT 
    EXTRACT(YEAR FROM sale_date) YEAR_EXTRACT,
    EXTRACT(MONTH FROM sale_date) MONTH_EXTRACT,
    CAST(AVG(total_sale) AS INT) avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
	ORDER BY CAST(AVG(total_sale) AS INT) desc) as rn
FROM retail_sales
GROUP BY 1, 2) 

select *
from AVG_SALE_PER_MONTH
where AVG_SALE_PER_MONTH.rn = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id,
	sum(quantity) sum_quantity,
	sum(total_sale) sum_total_sale
FROM retail_sales
	group by 1
	order by 3 desc
	limit 5;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;




-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sales 
	as(
		select *,
		case
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		end as shift
		from retail_sales
	)

select 
	shift,
	count(*) as total_orders
from hourly_sales
group by shift;



-- end ---
			