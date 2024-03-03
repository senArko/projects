create database pizza_sales;
use pizza_sales;

select * from pizza_sales;


-- Total Revenue

SELECT 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM
    pizza_sales;


-- Average order value

SELECT 
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id),
            2) AS avg_order_value
FROM
    pizza_sales;


-- Total pizzas sold

select * from pizza_sales;

SELECT 
    SUM(quantity) AS total_pizzas_sold
FROM
    pizza_sales;
    
    
-- Total orders placed

SELECT 
    COUNT(DISTINCT order_id) AS total_order_placed
FROM
    pizza_sales;
    

-- Average pizzas per order

SELECT 
    ROUND(SUM(quantity) / COUNT(DISTINCT order_id),
            0) AS avg_pizzas_per_order
FROM
    pizza_sales;


-- Daily trend for total orders

select * from pizza_sales;

update pizza_sales set order_date = str_to_date(order_date, "%m-%d-%Y");
alter table pizza_sales change column order_date order_date date;

SELECT 
    DAYNAME(order_date) AS day_of_week,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    pizza_sales
GROUP BY day_of_week;


-- Monthly trend of orders

SELECT 
    MONTHNAME(order_date) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    pizza_sales
GROUP BY month;


-- Percentage of sales per pizza category

SELECT 
    pizza_category,
    (SUM(total_price) / (SELECT 
            SUM(total_price)
        FROM
            pizza_sales)) * 100 AS pct_of_total
FROM
    pizza_sales
GROUP BY pizza_category;


-- Top 5 sellers by revenue, total quantity and total orders 

select * from pizza_sales;

SELECT 
    pizza_name,
    SUM(total_price) AS revenue,
    SUM(quantity) total_quantity
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC , total_quantity DESC
LIMIT 5;


-- Bottom 5 sellers by revenue, total quantity and total orders 

SELECT 
    pizza_name,
    SUM(total_price) AS revenue,
    SUM(quantity) total_quantity
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY revenue, total_quantity 
LIMIT 5;


-- Total sales and percent of sales per pizza size

select * from pizza_sales;

SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS total_sales,
    CONCAT(ROUND((SUM(total_price) / (SELECT 
                            SUM(total_price)
                        FROM
                            pizza_sales)) * 100,
                    2),
            '%') AS pc_of_sales
FROM
    pizza_sales
GROUP BY pizza_size;


-- Hourly sales trends

select hour(order_time) , sum(total_price), sum(quantity)
from pizza_sales
group by hour(order_time);







