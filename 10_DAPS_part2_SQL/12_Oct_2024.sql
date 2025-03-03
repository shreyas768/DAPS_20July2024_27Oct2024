USE daps;

-- FIRST_VALUE, LEAD,LAG
SELECT emp_no, department, 
NTILE(3) OVER(PARTITION BY department ORDER BY salary DESC) AS dept_salary_quartile,
NTILE(10) OVER( ORDER BY salary ASC) AS overall_salary_quartile,
FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid_department,
FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary ASC) AS lowest_paid_department,
FIRST_VALUE(emp_no) OVER( ORDER BY salary ASC) AS lowest_paid_org,
salary,
salary-LAG(salary) OVER(ORDER BY salary DESC) AS salary_diff,
salary - LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) as dept_salary_diff,
RANK() OVER (ORDER BY SALARY DESC) AS salary_rank, 
DENSE_RANK() OVER (ORDER BY salary DESC) as overall_dense_rank,
SUM(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rolling_dept_salary,
SUM(salary) OVER(ORDER BY salary DESC) AS rolling_salary,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_row_no,
RANK() OVER (PARTITION BY department ORDER BY SALARY DESC) AS dept_salary_rank,
DENSE_RANK() OVER (PARTITION BY department ORDER BY SALARY DESC) AS dept_dense_rank
FROM employees;

USE ecommerce;
-- 1. Create a view 'CustomerOrderSummary' that shows customers and their total number of orders.
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS customer_name,
COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
-- 2. Using CustomerOrderSummary, rank rustomers by the number of orders they have placed
SELECT *,
RANK() OVER(ORDER BY total_orders DESC) AS order_rank
FROM CustomerOrderSummary;

-- 3. Dense Rank Customers by the total amount spent 
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS customer_name,
SUM(o.total_amount) AS total_spent,
DENSE_RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS spend_rank
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 4. Assign a row number to each customer based on order date.
SELECT order_id, customer_id, order_date,
ROW_NUMBER()  OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
FROM Orders;
-- 5. Show the next order date for each customer

SELECT order_id, customer_id, order_date,
ROW_NUMBER()  OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number,
LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date
FROM Orders;

-- 6. Retrieve the first order date for each customer
SELECT order_id, customer_id, order_date,
FIRST_VALUE(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_order,
ROW_NUMBER()  OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number,
LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date
FROM Orders;

-- COMMON TABLE EXPRESSIONS / WITH clause

-- SYNTAX
/*
WITH cte_name AS (
SELECT columns
FROM table
JOIN table 2
on table.column1 = table2.columne2
)
SELECT columns FROM cte_name;

*/

WITH ProductSales AS (
SELECT p.product_id, p.product_name, 
SUM(od.quantity*p.price) AS total_sales
FROM Products p
JOIN Order_Details od
ON p.product_id = od.product_id
GROUP BY p.product_id
)
SELECT * FROM ProductSales 
WHERE total_sales > 600.00;


WITH CustomerOrders AS (
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS customer_name,
COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
)
SELECT * FROM CustomerOrders;


-- Using CTE, rank customer based on total spending

WITH CustomerSpend AS (
SELECT c.customer_id, c.first_name,
SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
)
SELECT customer_id,first_name, total_spent,
RANK() OVER(ORDER BY total_spent DESC) AS spend_rank
FROM CustomerSpend;

-- Using more than 1 CTEs

WITH CTE1 AS (
SELECT p.product_id, p.product_name, SUM(od.quantity*p.price) AS total_sales,
YEAR (o.order_date) AS order_year
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
JOIN Orders o On od.order_id = o.order_id
GROUP BY p.product_id, YEAR(o.order_date)
),
CTE2 AS (
SELECT product_id, SUM(quantity) AS total_quantity
FROM Order_Details
GROUP BY product_id
)

SELECT CTE1.product_id, CTE1.product_name, CTE1.total_sales, CTE2.total_quantity
FROM CTE1
JOIN CTE2
ON CTE1.product_id = CTE2.product_id;



