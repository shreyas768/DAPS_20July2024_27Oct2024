-- JOINS

USE daps;

CREATE TABLE customers (

id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(25),
last_name VARCHAR(25),
email VARCHAR(50));

CREATE TABLE orders (
id INT PRIMARY KEY AUTO_INCREMENT,
order_date DATE,
amount DECIMAL(6,2),
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(id));


INSERT INTO customers (first_name,last_name, email)
VALUES ('Bob','George', 'georger@gmail.com'),
('George','Michel', 'gmichel@gmail.com'),
('Dave', 'Brown', 'dave@gmail.com'),
('Billie','Singh', 'bsingh@gmail.com'),
('Beckie','David', 'bd@yahoo.com');

INSERT INTO customers (first_name,last_name, email)
VALUES ('Bob','George', 'bgeorge@gmail.com')

SELECT * FROM customers;

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2024-01-10', 12.78,1),
('2024-12-19', 35.58,1),
('2004-09-20', 812.83,2),
('2015-01-03', 12.08,2),
('1999-04-11', 450.98,5);

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2014-01-10', 02.38,6)


-- CROSS JOINS

SELECT id FROM customers WHERE last_name = 'George';

SELECT * FROM orders WHERE customer_id = 1;

SELECT * FROM orders WHERE customer_id =(SELECT id FROM customers WHERE last_name = 'George');

SELECT * FROM customers, orders;

-- INNER JOINS

SELECT * FROM customers
JOIN orders 
ON orders.customer_id = customers.id;


SELECT * FROM orders
JOIN customers
ON customers.id = orders.customer_id;

SELECT orders.id AS order_id, order_date, first_name, last_name,  customers.id AS cutomer_id FROM orders
JOIN customers
ON customers.id = orders.customer_id;

-- INNER JOIN with GROUP BY

SELECT orders.customer_id, first_name, last_name, SUM(amount)
FROM customers
INNER JOIN orders
ON orders.customer_id = customers.id
GROUP BY orders.customer_id;


SELECT first_name, last_name, SUM(amount)
FROM customers
INNER JOIN orders
ON orders.customer_id = customers.id
GROUP BY first_name, last_name;

-- LEFT JOIN

SELECT * 
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id;


SELECT  first_name, last_name, order_date, amount
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id;


SELECT  first_name, last_name, COUNT(order_date) as no_of_orders, IFNULL(SUM(amount), 0) AS Amount_spent
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id
GROUP BY first_name, last_name;

-- Right Join

SELECT * 
FROM customers
RIGHT JOIN orders
ON customers.id = orders.customer_id;


SELECT * FROM orders;


-- Create two table 1
-- Table 1 (students): id (PK and AI), first_name
-- Table 2 (papers): title, grade int, student_id FK referencing PK in table 1

CREATE TABLE students(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50));

CREATE TABLE papers (
   title VARCHAR(50),
   grade INT,
   student_id INT,
   FOREIGN KEY (student_id)
       REFERENCES students (id)
);

INSERT INTO students (first_name) VALUES
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) VALUES (1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT * FROM students;

SELECT * FROM papers;

-- name, grade and title of the projects of top 3 students
SELECT first_name AS name, title, grade
FROM students
JOIN papers
ON  papers.student_id = students.id
ORDER BY grade DESC;

-- name, title, grade of all the students. If a student has not submitted any project, write 'missing' in place of 
-- title and 0 inplace of grade

SELECT first_name, IFNULL(title,'MISSING') AS title, IFNULL(grade,0) AS grade
FROM students
LEFT JOIN papers
ON papers.student_id = students.id;


-- name, passing status based on:  pass if avg grade >= 75 otherwise fail

SELECT first_name, IFNULL(AVG(grade),0) as avg_grade,
CASE WHEN 
IFNULL(AVG(grade),0) >= 75 THEN 'PASS' ELSE 'FAIL' 
END AS passing_status
FROM students
LEFT JOIN papers
ON papers.student_id = students.id
GROUP BY first_name
ORDER BY avg_grade DESC;
