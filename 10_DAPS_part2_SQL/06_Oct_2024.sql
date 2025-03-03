USE daps;

-- VIEWS

SELECT 
title, released_year, genre, rating, first_name, last_name
FROM reviews
JOIN series
ON series.id = reviews.series_id
JOIN reviewers
ON reviewers.id = reviews.reviewer_id;


-- Instead of writing above query all the time, you can Create a view

CREATE VIEW full_info AS
SELECT 
title, released_year, genre, rating, first_name, last_name
FROM reviews
JOIN series
ON series.id = reviews.series_id
JOIN reviewers
ON reviewers.id = reviews.reviewer_id;

SELECT * FROM full_info;

CREATE VIEW millenial AS
SELECT * FROM series WHERE released_year > 2000;


SELECT * FROM millenial;

ALTER VIEW millenial AS
SELECT * FROM series WHERE released_year > 2000 AND genre = 'Drama';

DROP VIEW millenial;

-- WITH ROLLUP

SELECT title, AVG(rating) FROM full_info
GROUP BY title WITH ROLLUP
;


SELECT title, COUNT(rating) FROM full_info
GROUP BY title WITH ROLLUP
;


SELECT released_year, genre, first_name, COUNT(rating)
FROM full_info
GROUP BY released_year, genre, first_name WITH ROLLUP;


CREATE TABLE employees (
   emp_no INT PRIMARY KEY AUTO_INCREMENT,
   department VARCHAR(20),
   salary INT
);
 
INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);

USE daps;
SELECT * FROM employees;


-- OVER

SELECT emp_no, department, salary, 
ROUND(AVG(salary) OVER(),2) as avg_salary,
MIN(salary) OVER() AS min_salary,
MAX(salary) OVER() AS max_salary
FROM employees;

-- OVER with PARTITION BY
SELECT emp_no, department, salary, 
ROUND(AVG(salary) OVER(),2) as avg_salary,
ROUND(AVG(salary) OVER(PARTITION BY department),2) as dept_avg
FROM employees;

SELECT
emp_no,
department,
salary,
MIN(salary) OVER(PARTITION BY department) AS dept_count
FROM employees;

-- employee_no, department, salary, dept_payroll, total_payroll
SELECT emp_no, department, salary,
SUM(salary) OVER(PARTITION BY department) AS dept_payroll,
SUM(salary) OVER() AS total_payroll
FROM employees;

-- ORDER BY with WINDOWS

SELECT emp_no, department, salary,
SUM(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rolling_dept_salary
FROM employees;

-- repeat it but not per department
SELECT emp_no, department, salary,
SUM(salary) OVER(ORDER BY salary DESC) AS rolling_salary
FROM employees;

-- Rank, Dense Rank, ROW NUMBER, NTILE
SELECT emp_no, department, 
NTILE(3) OVER(PARTITION BY department ORDER BY salary DESC) AS dept_salary_quartile,
NTILE(10) OVER( ORDER BY salary ASC) AS overall_salary_quartile,
salary,
RANK() OVER (ORDER BY SALARY DESC) AS salary_rank, 
DENSE_RANK() OVER (ORDER BY salary DESC) as overall_dense_rank,
SUM(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rolling_dept_salary,
SUM(salary) OVER(ORDER BY salary DESC) AS rolling_salary,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_row_no,
RANK() OVER (PARTITION BY department ORDER BY SALARY DESC) AS dept_salary_rank,
DENSE_RANK() OVER (PARTITION BY department ORDER BY SALARY DESC) AS dept_dense_rank
FROM employees;


USE ecommerce;
-- 1. List all the customers who placed orders but do not have any shipments yet


SELECT c.first_name, c.last_name, o.order_id
FROM customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id
LEFT JOIN Shipments s
ON o.order_id = s.order_id
WHERE s.shipment_id IS NULL;

-- 2.  Retrieve the total revenue generated from each category
SELECT c.category_name, SUM(od.price_per_unit*od.quantity) AS total_revenue
FROM Order_Details od
JOIN Products p
ON od.product_id = p.product_id
JOIN Categories c
ON c.category_id = p.category_id
GROUP BY c.category_name;


-- 3. Retrieve all the orders along with their shipment details
SELECT o.order_id, o.order_date, s.shipment_date, s.carrier, s.tracking_number 
FROM Orders o
JOIN Shipments s
ON o.order_id = s.order_id;

-- 4. List the most recent shipemnt information for each of the customers
SELECT c.first_name, c.last_name, s.shipment_date

FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Shipments s ON o.order_id = s.order_id
WHERE s.shipment_date = (
SELECT MAX(s2.shipment_date)
FROM Shipments s2
WHERE s2.order_id = o.order_id
);


-- 5. Find all the orders that include at least one product from the 'Books' Category
SELECT o.order_id, o.order_date
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON p.product_id = od.product_id
JOIN Categories cg ON cg.category_id = p.category_id
WHERE cg.category_name = 'Books';









