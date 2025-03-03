USE DAPS_project;

DESC orders_data;
DESC returns_data;

SELECT * FROM orders_data;

SELECT * FROM returns_data;

-- Retrieve all the orders and calculate total amount and discount at 10%
CREATE VIEW amount_discount_fp AS
SELECT order_id, ROUND(sales*quantity,2) AS total_amount, ROUND(0.1*sales*quantity,2) AS discount,
ROUND(0.9*sales*quantity,2) AS final_price
FROM orders_data;

SELECT * FROM amount_discount_fp;

-- Retreives orders that have not been returned
 
SELECT o.order_id, o.customer_name  , r.return_reason
FROM orders_data AS o
LEFT JOIN returns_data AS r
ON o.order_id = r.order_id
WHERE r.return_reason IS NULL;

-- Subquery
SELECT order_id, customer_name FROM orders_data
WHERE order_id IN
(SELECT order_id FROM returns_data);

-- Group By/Order By: Retruieves all the customer name and no of orders and total_spent for all the customers who made more than 1 order

SELECT customer_name, COUNT(order_ID) AS NO_OF_ORDERS,
ROUND(SUM(sales*quantity),2) AS total_spent
FROM orders_data
GROUP BY customer_name
HAVING COUNT(ORDER_ID) > 1
ORDER BY total_spent;

-- UNION

SELECT o.order_id, o.order_date
FROM orders_data AS o
JOIN returns_data AS r
ON o.order_id = r.order_id
UNION
SELECT o.order_id, o.order_date
FROM orders_data AS o
WHERE City = 'Los Angeles' AND category = 'Office Supplies';


-- Get all the orders details, with their return status which placed in 2021


SELECT o.*, r.return_reason  
FROM orders_data AS o
LEFT JOIN returns_data AS r
ON o.order_id = r.order_id
WHERE order_date BETWEEN '2021-01-01' AND '2021-12-31'
;
-- LIKE
SELECT * FROM Orders_data
WHERE order_id LIKE 'C%' AND category = 'Office Supplies';

-- CASE
SELECT order_id, category, sales, quantity, profit,
CASE
WHEN profit >= 0 THEN 'Profit'
ELSE 'Loss'
END AS business_status
FROM orders_data;


-- WITH Clause

WITH order_summary AS (
SELECT order_id, COUNT(order_id) AS total_orders
FROM orders_data
GROUP BY order_id
HAVING COUNT(order_id) > 1
)
SELECT os.order_id, rd.return_reason
FROM order_summary AS os
JOIN returns_data rd
ON os.order_id = rd.order_id;

-- Window Function



SELECT order_id, order_date,
SUM(sales*quantity) OVER (PARTITION BY order_date) AS order_total
FROM orders_data;


-- SHow total amounts by month for each order == Pivot Table Simulation

SELECT region,
SUM(CASE WHEN MONTH(order_date) = 1 THEN sales*quantity ELSE 0 END) AS January,
SUM(CASE WHEN MONTH(order_date) = 2 THEN sales*quantity ELSE 0 END) AS February,
SUM(CASE WHEN MONTH(order_date) = 3 THEN sales*quantity ELSE 0 END) AS March,
SUM(CASE WHEN MONTH(order_date) = 4 THEN sales*quantity ELSE 0 END) AS April,
SUM(CASE WHEN MONTH(order_date) = 5 THEN sales*quantity ELSE 0 END) AS May
FROM orders_data
GROUP BY region;


-- Rank
SELECT * FROM orders_data;

SELECT order_id, customer_name, ROUND(sales*quantity,2) AS total_amount,
RANK() OVER (PARTITION BY customer_name ORDER BY sales*quantity DESC) AS rank_order
FROM orders_data;

-- Handling null values

SELECT o.order_id, o.customer_name  , IFNULL(r.return_reason, 'No return') AS return_info
FROM orders_data AS o
LEFT JOIN returns_data AS r
ON o.order_id = r.order_id;

-- Using Case with Group By

SELECT region, COUNT(CASE WHEN sales*quantity > 500 THEN 1 END) AS high_value_order,
COUNT(CASE WHEN sales*quantity <= 500 THEN 1  END) AS low_value_order 
FROM orders_data
GROUP BY region;

-- DATE function

SELECT order_id, order_date,
DATE_SUB(order_date, INTERVAL 7 DAY) AS one_week_before
FROM orders_data;