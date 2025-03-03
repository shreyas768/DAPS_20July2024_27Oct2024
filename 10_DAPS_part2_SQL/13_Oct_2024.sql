-- Unions: Combining Rows (and not columns like we did in Joins)

USE  Parks_and_Recreation;

SELECT first_name, last_name
FROM employee_demographics
UNION -- UNION is actually shorthand for UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


DROP TABLE flights;

SELECT occupation FROM employee_salary
UNION SELECT department_name FROM parks_departments;


-- List unique employees working in the PR dept with their first_name and last name from employee_salary and employee_demographics tables


SELECT first_name, last_name FROM employee_demographics WHERE employee_id IN (SELECT employee_id FROM employee_salary WHERE dept_id = 1)
UNION
SELECT first_name, last_name FROM employee_salary WHERE dept_id =1;


-- List first_name, department_name of employees employee_salary an parks_dept table

SELECT e.first_name, IFNULL(p.department_name, 'No Dept Assigned')
FROM employee_salary e
LEFT JOIN parks_departments p
ON e.dept_id = p.department_id;



SELECT e.first_name, p.department_name
FROM employee_salary e
JOIN parks_departments p
ON e.dept_id = p.department_id
UNION
SELECT e.first_name, 'No Department Assigned'
FROM employee_salary e
LEFT JOIN parks_departments p
ON e.dept_id = p.department_id
WHERE e.dept_id IS NULL;


-- String Functions


-- LENGTH
SELECT first_name, LENGTH(first_name) as f_len FROM employee_salary;

-- UPPER

SELECT first_name, UPPER(first_name) as u_name FROM employee_salary;

-- LOWER
SELECT first_name, LOWER(first_name) as u_name FROM employee_salary;

-- TRIM
SELECT TRIM('  s k.   y.     ');

-- LTRIM
SELECT LTRIM('  s k.   y.     ');

-- RTRIM
SELECT RTRIM('  s k.   y.     ');


-- LEFT
SELECT LEFT('Shreyas',4);

SELECT LEFT(first_name,3) FROM employee_demographics;

-- Right
SELECT RIGHT(first_name,3) FROM employee_demographics;

-- SUBSTRING
SELECT SUBSTRING('SHREYAS',2,4);

-- REPLACE
SELECT 
    REPLACE(first_name, 'a', 'Z')
FROM
    employee_demographics;

-- LOCATE
SELECT first_name, LOCATE('ar', first_name);


-- EXISTS
USE ecommerce;

-- Find customer who have placed atleast one order

SELECT customer_id, first_name, last_name
FROM Customers c
WHERE EXISTS(
SELECT 1
FROM Orders o
WHERE o.customer_id = c.customer_id
);

-- List all the products that have been ordered by any customer

SELECT product_name
FROM Products p
WHERE EXISTS(
SELECT 1
FROM Order_Details od
WHERE od.product_id = p.product_id
);

-- Sakila Database WITH clause Exercise

USE sakila;

SELECT * FROM film;
SELECT DISTINCT(YEAR(rental_date)) FROM rental;

-- Get the list of all the films that have not been rented in 2024
WITH Rented2024 AS
(SELECT DISTINCT film_id, YEAR(r.rental_date)
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2024)
SELECT
film.title
FROM film 
WHERE film.film_id NOT IN (SELECT film_id FROM Rented2024);

-- CTE to find actors who have appeared in both Action and Comedy Films (tables: film_actor, film_category, category, actor)

WITH CTE1 AS (
SELECT category.category_id AS cat_id, film_category.film_id AS F_id, category.name as G_Name 
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
WHERE category.name = 'Action' OR category.name = 'Comedy'
),
CTE2 AS (
SELECT CONCAT(first_name, ' ', last_name) AS actor_name, film_actor.film_id AS F_id 
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id
)
SELECT CTE2.actor_name,CTE2.F_id as FILM_ID, ft.title
FROM CTE1
JOIN CTE2
ON CTE1.F_id = CTE2.F_id
JOIN film_text ft
ON ft.film_id = CTE2.F_id;

/*
1. Find top 3 actors who have acted in most number of movies
2. Find city which generated most revenue
3. write a query to determine how many times a particular movie category is rented
4. Find number of movies rented across each country (atleast one movie being rented in a country)
5. Find customers (full name) who have rented sctioj movies more than 3 times.
*/


