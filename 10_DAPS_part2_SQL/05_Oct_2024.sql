USE daps;

CREATE TABLE reviewers (
   id INT PRIMARY KEY AUTO_INCREMENT,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL
);
 
CREATE TABLE series (
   id INT PRIMARY KEY AUTO_INCREMENT,
   title VARCHAR(100),
   released_year YEAR,
   genre VARCHAR(100)
);
 
CREATE TABLE reviews (
   id INT PRIMARY KEY AUTO_INCREMENT,
   rating DECIMAL(2 , 1 ),
   series_id INT,
   reviewer_id INT,
   FOREIGN KEY (series_id)
       REFERENCES series (id),
   FOREIGN KEY (reviewer_id)
       REFERENCES reviewers (id)
);
 
INSERT INTO series (title, released_year, genre) VALUES
   ('Archer', 2009, 'Animation'),
   ('Arrested Development', 2003, 'Comedy'),
   ("Bob's Burgers", 2011, 'Animation'),
   ('Bojack Horseman', 2014, 'Animation'),
   ("Breaking Bad", 2008, 'Drama'),
   ('Curb Your Enthusiasm', 2000, 'Comedy'),
   ("Fargo", 2014, 'Drama'),
   ('Freaks and Geeks', 1999, 'Comedy'),
   ('General Hospital', 1963, 'Drama'),
   ('Halt and Catch Fire', 2014, 'Drama'),
   ('Malcolm In The Middle', 2000, 'Comedy'),
   ('Pushing Daisies', 2007, 'Comedy'),
   ('Seinfeld', 1989, 'Comedy'),
   ('Stranger Things', 2016, 'Drama');




INSERT INTO reviewers (first_name, last_name) VALUES
   ('Thomas', 'Stoneman'),
   ('Wyatt', 'Skaggs'),
   ('Kimbra', 'Masters'),
   ('Domingo', 'Cortes'),
   ('Colt', 'Steele'),
   ('Pinkie', 'Petit'),
   ('Marlon', 'Crafford');
  


INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
   (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
   (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
   (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
   (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
   (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
   (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
   (7,2,9.1),(7,5,9.7),
   (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
   (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
   (10,5,9.9),
   (13,3,8.0),(13,4,7.2),
   (14,2,8.5),(14,3,8.9),(14,4,8.9);
   
   
   SELECT * FROM reviewers;
   
SELECT * FROM reviews;

SELECT * FROM series;

-- Grab title and ratings
SELECT title, rating
FROM series
JOIN reviews
ON series.id = reviews.series_id;

-- title and average rating

SELECT reviews.series_id, title, ROUND(AVG(rating),2) AS avg_rating
FROM series
JOIN reviews
ON series.id = reviews.series_id
GROUP BY series.id
ORDER BY avg_rating;

-- first name last name and their ratings

SELECT first_name, last_name, rating
FROM reviews
JOIN reviewers
ON reviews.reviewer_id = reviewers.id;

-- full name of the reviewer and his/her avg rating regardless of the series
SELECT CONCAT(first_name, ' ',last_name) AS full_name, AVG(rating) as avg_rating
FROM reviews
JOIN reviewers
ON reviews.reviewer_id = reviewers.id
GROUP BY first_name, last_name;

-- unreviewed series

SELECT title AS unreviewed_series
FROM series
LEFT JOIN reviews
ON reviews.series_id = series.id
WHERE reviews.id is NULL;

SELECT title AS unreviewed_series
FROM reviews
RIGHT JOIN series
ON reviews.series_id = series.id
WHERE reviews.id is NULL;

-- firstname, last name, number of reviews , min, max, average, reviewer_status 
-- status: if >=10 reviews means he/she is 'POWERUSER'
-- if >0 then he/she is 'ACTIVE' and null means he/she is 'INACTIVE'

SELECT
first_name,
last_name,
COUNT(reviews.id) AS count,
IFNULL(MIN(rating),0) AS min,
IFNULL(MAX(rating),0) AS max,
ROUND(IFNULL(AVG(rating),0),2) AS average,
CASE
WHEN COUNT(reviews.id) >= 10 THEN 'POWERUSER'
WHEN COUNT(reviews.id) > 0 THEN 'ACTIVE'
ELSE 'INACTIVE'
END AS reviewers_status
FROM reviewers
LEFT JOIN reviews
ON reviewers.id = reviews.reviewer_id
GROUP BY first_name, last_name;

-- IF statement

SELECT
first_name,
last_name,
COUNT(reviews.id) AS count,
IFNULL(MIN(rating),0) AS min,
IFNULL(MAX(rating),0) AS max,
ROUND(IFNULL(AVG(rating),0),2) AS average,
IF(COUNT(reviews.id) >0, 'ACTIVE','INACTIVE') AS reviewers_status
FROM reviewers
LEFT JOIN reviews
ON reviewers.id = reviews.reviewer_id
GROUP BY first_name, last_name;

-- title, rating, reviewers_name

SELECT
title,
rating,
CONCAT(first_name,' ', last_name) AS reviewers_name
FROM reviews
JOIN series
ON reviews.series_id = series.id
JOIN reviewers
ON reviews.reviewer_id = reviewers.id;


-- HAVING CLAUSE
SELECT CONCAT(first_name, ' ',last_name) AS full_name, AVG(rating) as avg_rating
FROM reviews AS rw
JOIN reviewers AS rwr
ON rw.reviewer_id = rwr.id
GROUP BY first_name, last_name
HAVING AVG(rating) > 8;

-- HAVING + GROUP BY and only on aggregation column
-- WHERE AND HAVING: WHERE+SELECT 

-- series with atleast 7 rating and whose average rating from all the reviewers is atleast 8 on average

SELECT series_id, AVG(rating) FROM reviews
WHERE rating > 7
GROUP BY series_id
HAVING AVG(rating) > 8 ;


CREATE TABLE flights 
(
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    Destination VARCHAR(512)
);

INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f1', 'Idr', 'Hyd');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f2', 'Hyd', 'Del');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f3', 'Mum', 'Blr');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f4', 'Blr', 'Kol');

SELECT r.cid, s.origin AS 'origin',
r.Destination AS 'Final_Destination'
FROM flights r
JOIN flights s
ON r.origin = s.Destination;

-- Practice Questions

CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);



CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);


CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);


CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);



CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    shipment_date DATE NOT NULL,
    carrier VARCHAR(100),
    tracking_number VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

INSERT INTO Customers (customer_id, first_name, last_name, email, phone, address) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm Street'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak Avenue'),
(3, 'Alice', 'Johnson', 'alice.j@example.com', '2345678901', '789 Maple Road'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '9876543210', '321 Pine Lane'),
(5, 'Charlie', 'Wilson', 'charlie.w@example.com', '3456789012', '654 Cedar Way');


INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Books'),
(4, 'Clothing'),
(5, 'Groceries');


INSERT INTO Categories (category_id, category_name)
VALUES
(6, 'Home Appliances'),
(7, 'Books'),
(8, 'Clothing'),
(9, 'Toys'),
(10, 'Fitness Equipment');



INSERT INTO Products (product_id, product_name, category_id, price) VALUES
(1, 'Smartphone', 1, 699.99),
(2, 'Laptop', 1, 1299.99),
(3, 'Tablet', 1, 399.99),
(4, 'Sofa', 2, 899.99),
(5, 'Dining Table', 2, 499.99),
(6, 'Bookshelf', 2, 199.99),
(7, 'Fiction Book', 3, 9.99),
(8, 'Non-Fiction Book', 3, 19.99),
(9, 'Jeans', 4, 49.99),
(10, 'T-shirt', 4, 19.99),
(11, 'Milk', 5, 2.99),
(12, 'Eggs', 5, 1.99),
(13, 'Smartwatch', 1, 199.99),
(14, 'Headphones', 1, 149.99),
(15, 'Monitor', 1, 299.99),
(16, 'Desk Chair', 2, 149.99),
(17, 'Shoes', 4, 69.99),
(18, 'Apple', 5, 0.99),
(19, 'Orange', 5, 1.29),
(20, 'Banana', 5, 0.59);





INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-08-01', 699.99),
(2, 2, '2024-08-03', 49.99),
(3, 3, '2024-08-04', 119.97),
(4, 4, '2024-08-05', 899.99),
(5, 5, '2024-08-06', 69.99),
(6, 1, '2024-08-07', 199.99),
(7, 2, '2024-08-07', 1299.99),
(8, 3, '2024-08-08', 9.99),
(9, 4, '2024-08-09', 49.99),
(10, 5, '2024-08-10', 1.99);

INSERT INTO Order_Details (order_detail_id, order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 1, 699.99),
(2, 2, 9, 1, 49.99),
(3, 3, 7, 3, 9.99),
(4, 4, 4, 1, 899.99),
(5, 5, 17, 1, 69.99),
(6, 6, 13, 1, 199.99),
(7, 7, 2, 1, 1299.99),
(8, 8, 7, 1, 9.99),
(9, 9, 9, 1, 49.99),
(10, 10, 12, 1, 1.99);

INSERT INTO Shipments (shipment_id, order_id, shipment_date, carrier, tracking_number) VALUES
(1, 1, '2024-08-02', 'FedEx', 'TRK123456'),
(2, 2, '2024-08-04', 'UPS', 'TRK234567'),
(3, 3, '2024-08-06', 'USPS', 'TRK345678'),
(4, 4, '2024-08-07', 'FedEx', 'TRK456789'),
(5, 5, '2024-08-08', 'UPS', 'TRK567890');


-- List all the orders that DO NOT have any associated shipments
SELECT o.order_id, o.order_date, o.total_amount
FROM Orders o
LEFT JOIN Shipments s
ON o.order_id = s.order_id
WHERE s.shipment_id IS NULL;

