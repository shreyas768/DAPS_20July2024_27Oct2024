-- Creating Databases

CREATE DATABASE daps;

CREATE DATABASE customers;

-- List all the databases

SHOW DATABASES;

-- Dropping a Database
DROP DATABASE daps;
SHOW DATABASES;

-- Using a Database

USE customers;

-- Creating a Table

CREATE TABLE cust_info(
Name VARCHAR(25),
Age INT
);

CREATE TABLE dogs(
Name VARCHAR(10),
Breed VARCHAR(20),
Age INT);


-- Show Tables in current database

SHOW TABLES;

-- Display Column Names

SHOW COLUMNS FROM cust_info;

DESC cust_info;

-- Dropping a Table

DROP TABLE cust_info;

SHOW TABLES;

-- Inserting Data to Table

INSERT INTO dogs(name,age,breed) VALUES ('Tuffy',12,'Breed 1');
INSERT INTO dogs(name,age,breed) VALUES ('Tiger',10,'Breed alpha');


SELECT * FROM dogs;

INSERT INTO dogs (name,breed,age) VALUES
('Jackie','Breed Beta',14),
('Liger','Breed 4',8);

-- Create database sample_db and then create table people with columns: First name, Last name, Age and insert any 3 rows. 
CREATE DATABASE sample_db;
USE sample_db;
CREATE TABLE people(
first_name VARCHAR(25),
last_name VARCHAR(25),
age INT);

INSERT INTO people(first_name,last_name,age) VALUES
('Shreyas','Shukla',23),
('Virat','Kohli',30),
('Rohit','Sharma',31);
SELECT * FROM people;

DESC people;

-- Not null and default

CREATE TABLE cats(
Name VARCHAR(20) NOT NULL,
Age INT NOT NULL);

DESC cats;

CREATE TABLE cats3(
Name VARCHAR(20) DEFAULT 'no name given',
AGE INT DEFAULT 99);

DESC cats3;

INSERT INTO cats3(age) VALUES(13);

SELECT * FROM cats3;

INSERT INTO cats3() VALUES();

-- Combine Not Null and Default

CREATE TABLE cats4(
Name VARCHAR(20) NOT NULL DEFAULT 'unnamed',
Age INT NOT NULL DEFAULT 99);


INSERT INTO cats4() VALUES();
SELECT * FROM cats4;

INSERT INTO cats4(Age) VALUES (NULL);
INSERT INTO cats3(Age) VALUES (NULL);

-- Creating a Primary Key

CREATE TABLE cats_details(
cat_id INT PRIMARY KEY,
name VARCHAR(25) NOT NULL,
age INT NOT NULL);

DESC cats_details;

-- Another way to create a Primary Key

CREATE TABLE cats_details2(
cat_id INT,
name VARCHAR(25) NOT NULL,
age INT NOT NULL,
PRIMARY KEY (cat_id));

DESC cats_details2;

INSERT INTO cats_details(cat_id,name,age) VALUES
(101,'Tom',12),
(102,'Tom2',14);


SELECT * FROM cats_details;

INSERT INTO cats_details(cat_id,name,age) VALUES(103,'Tom',12);

-- Auto Increment

CREATE TABLE cats_details3(
cat_id INT AUTO_INCREMENT,
name VARCHAR(14) NOT NULL,
age INT NOT NULL,
PRIMARY KEY (cat_id));


INSERT INTO cats_details3(cat_id,name,age) VALUES(101,'Tom',12);
SELECT * FROM cats_details3;

INSERT INTO cats_details3(name,age) VALUES ('Mickey',19);

-- Create a Table 'Employee' : id,first_name,last_name,middle_name,age,current_status. 
-- conditions: first_name, last_name are required fields, id is PK, default value for current status is 'employed'
-- 3 records in which One record should have null value in current status column

CREATE TABLE employees(
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(15) NOT NULL,
middle_name VARCHAR(15),
last_name VARCHAR(15) NOT NULL,
age INT,
current_status VARCHAR(20) DEFAULT 'employed'
);

INSERT INTO employees(id,first_name,middle_name,last_name,age,current_status) VALUES
(1,'Mahendra','Singh','Dhoni',42,NULL);

SELECT * FROM employees;
INSERT INTO employees(first_name,last_name) VALUES
('Shreyas','Shukla');

INSERT INTO employees(id,first_name,middle_name,last_name,age,current_status) VALUES
(3,'Mahendra','Singh','Dhoni',42,'');