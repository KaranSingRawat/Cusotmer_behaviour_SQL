use [E-Commerce_sales_insight]

select* from Customers

--Task 1 : Analyze how revenue has changed month-over-month and year-over-year.

with date_revenue as
(
Select YEAR(order_date) as Year_orderdate,
	   month(order_date) as Month_orderdate,
	   sum(total_amount) as Revenue
from orders 
where order_status = 'Completed'
group by YEAR(order_date),
	     month(order_date)
),
pv_date as
(
select Year_orderdate,
	   Month_orderdate,
	   Revenue,
	lag(revenue) over(partition by year_orderdate order by year_orderdate,month_orderdate) as pv_date_revenue
from date_revenue
),
Revenue_change as
(
select Year_orderdate,
	   Month_orderdate,
	   Revenue,
	   pv_date_revenue,
	 case 
	    when pv_date_revenue is null then revenue
	    else revenue - pv_date_revenue
	   end as revenue_change
from pv_date
)
select Year_orderdate,
	   Month_orderdate,
	   Revenue,
	   pv_date_revenue,
	   revenue_change,
	Case 
	    when revenue_change = revenue then 'No change'
		when revenue_change > 0 then 'Go UP'
		when revenue_change < 0 then 'Go Down'
	end as Revenue_status
from revenue_change

--Task 2 : Customer Lifetime Value (LTV)
--Goal: Calculate total revenue each customer has contributed over time, and categorize them.

with customer_detail as
(
select c.customer_id ,
       concat(first_name,' ',last_name) as Customer_name,
	   cast(sum(Total_amount) as decimal (10,2) )as Total_amount
from customers c
join orders o
on c.customer_id = o.customer_id
where order_status = 'completed'
group by c.customer_id ,
       concat(first_name,' ',last_name)
),
rnk_temp as
(
select customer_id,
       Customer_name,
	   Total_amount,
	rank() over(order by total_amount desc) as rnk
from customer_detail
)
select customer_id,
       Customer_name,
	   Total_amount,
	   rnk,
	case 
	   when total_amount between 0 and 1200 then 'LOW LTV'
	   when total_amount between 1300 and 2200 then 'Medium LTV'
	   when total_amount > 2200 then 'High LTV'
	end as Customer_category
from rnk_temp

--Task 3 : RFM Segmentation
--Goal: Classify customers based on how recently, how often, and how much they purchase (RFM = Recency, Frequency, Monetary). 

with Base_table as
(
select c.customer_id ,
	   c.first_name,
	   c.last_name,
	   count(o.order_id) as Total_orders,
	   max(o.order_date) as Last_date,
	   sum(o.total_amount) as Total_amount
from customers c
join orders o
on c.customer_id = o.customer_id
where order_status = 'Completed'
group by c.customer_id ,
	   c.first_name,
	   c.last_name
), 
rec_pr as
(
select customer_id ,
	   first_name,
	   last_name,
	   Total_orders,
	   Last_date,
	   Total_amount,
	datediff(month,last_date,getdate()) as recency
from base_table
)
select customer_id ,
	   first_name,
	   last_name,
	   Total_orders,
	   Last_date,
	   Total_amount,
	case 
	   when recency < 1 then 'Frequently Visited' 
	   when recency between 1 and 5 then 'Sometime Visited'
	   when recency > 5 then 'Blue Moon'
	 end as Visit_status,
   case 
       when Total_orders < 7 then 'Low'
	   when Total_orders between 7 and 12 then 'Medium'
	   when Total_orders > 12 then 'High'
	 end as Order_value,
   case 
       when Total_amount < 1200 then 'Low Profile'
	   when Total_amount between 1200 and 2200 then 'Standard profile'
	   when Total_amount > 2200 then 'Premium profile'
	 end as Customer_Segment
from rec_pr

--Task 4: Cohort Analysis (SQL)
--Goal: Analyze customer retention over time by signup/purchase cohort.

-- Step 1: Identify the first purchase date for each customer
WITH cohort_data AS (
    SELECT customer_id,
           MIN(order_date) AS first_order_date  -- First purchase date for each customer
    FROM orders
    GROUP BY customer_id
),
-- Step 2: Assign each customer to a cohort based on their first purchase month
cohort_month AS (
    SELECT customer_id,
           first_order_date,  -- Include this line
           YEAR(first_order_date) AS cohort_year,
           MONTH(first_order_date) AS cohort_month
    FROM cohort_data
),
-- Step 3: Calculate the month-on-month retention rate for each cohort
retention_data AS (
    SELECT c.cohort_year, 
           c.cohort_month,
           COUNT(DISTINCT o.customer_id) AS retained_customers,  -- Number of customers from cohort who made purchases in the current month
           DATEDIFF(MONTH, c.first_order_date, o.order_date) AS months_since_first_purchase  -- Months since the first purchase
    FROM cohort_month c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_date >= c.first_order_date  -- Only consider orders after the first purchase
    GROUP BY c.cohort_year, c.cohort_month, DATEDIFF(MONTH, c.first_order_date, o.order_date)
)
-- Step 4: Final Output - Showing the number of customers in each cohort and how many are retained in each month
SELECT cohort_year, 
       cohort_month, 
       months_since_first_purchase,
       retained_customers,
       concat(cast((1.0 * retained_customers) / 
             (SELECT COUNT(DISTINCT customer_id) 
              FROM cohort_month 
              WHERE cohort_year = c.cohort_year 
              AND cohort_month = c.cohort_month) * 100 as decimal (5,2)),'%') AS retention_rate_percentage
FROM retention_data c
ORDER BY cohort_year, cohort_month, months_since_first_purchase;


--Task 5: Customer Churn Prediction Prep (Behavioral Flags)
--Goal: Identify patterns that might indicate which customers are likely to stop purchasing — a first step toward churn analysis.
with rec_temp as
(
select customer_id,
	   datediff(day,max(order_date),getdate()) as recency
 from orders
group by customer_id
),
select customer_id,
	   year(order_Date) as Year_Date,
	   month(order_date) as month_date,
	   count(*) as total_order 
 from orders
 where order_status = 'completed'
group by year(order_Date),
	   month(order_date),
	   customer_id
order by customer_id,year(order_Date),
	   month(order_date)
	   



select * from orders       










	   







