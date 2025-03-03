CREATE DATABASE daps;

USE daps;


-- CRUD - Create Rename Update Delete

CREATE TABLE cats (

cat_id INT AUTO_INCREMENT,
Name VARCHAR(50),
Breed VARCHAR(50),
Age INT,
PRIMARY KEY (cat_id));

INSERT INTO cats(Name,Breed,Age) VALUES
('Ring','Turkish Angora', 4),
('Cindy', 'Maine Coon',10),
('Dumby', 'Maine Coon', 11),
('Edgey', 'Persian',4),
('Mishy','Turkish Angora',13),
('George', 'Ragamuffin', 9),
('Jacky','Somali',7);

-- To get all the columns:
SELECT * FROM cats;

-- Get any particular column

SELECT Age FROM cats;

-- Selecting multiple columns

SELECT Name, Breed FROM cats;

-- Conditional Filtering

SELECT * FROM cats WHERE Age = 4;

SELECT * FROM cats WHERE Breed = 'Maine Coon';

SELECT cat_id, Name, Breed FROM cats WHERE Breed = 'Maine Coon';

SELECT cat_id, Name FROM cats WHERE Breed = 'Maine Coon';

-- catid of all the cats
SELECT cat_id FROM cats;
-- name and breed of all the cats
SELECT Name, Breed FROM cats;
-- name and age of all the cats whose breed is Turkish Angora
SELECT Name, Age FROM cats WHERE Breed = 'Turkish Angora';
-- name and breed of all the cats whose catid equals age
SELECT Name, Breed FROM cats WHERE cat_id = Age;



-- Use 'AS' to Alias a column in your results (caution: this doesn't change the column name in the original table)
SELECT Name AS cats_name, Breed FROM cats WHERE cat_id = Age;

SET SQL_SAFE_UPDATES = 0;
-- Update Data

-- Change Turkish Angora to TA 
UPDATE cats SET breed = 'TA' WHERE breed = 'Turkish Angora';
SELECT * FROM cats;

-- Set Name of the cats as 'Invalid' where age of the cats is more than 10
UPDATE cats SET Name = 'Invalid' WHERE Age > 10;

-- Rename Cat named 'Jacky' as 'Jackson'
UPDATE cats SET Name = 'Jackson' WHERE Name = 'Jacky';

-- Delete rows 

DELETE FROM cats WHERE Name = 'Invalid';

-- Delete all the rows in the cats table
DELETE FROM cats;


-- Exercise

CREATE DATABASE shirts_db;
 USE shirts_db;
 
 DROP TABLE shirts;
 CREATE TABLE shirts (
 shirt_id INT AUTO_INCREMENT PRIMARY KEY,
 article VARCHAR(50),
 color VARCHAR(50),
 shirt_size VARCHAR(5),
 last_worn INT
 );
 
 DESC shirts;
 INSERT INTO shirts (article, color, shirt_size, last_worn) VALUES
 ('t-shirt', 'white', 'S', 10),
 ('t-shirt', 'green', 'S', 200),
  ('polo shirt', 'black', 'M', 10),
  ('tank top', 'blue', 'S', 50),
 ('t-shirt', 'pink', 'S', 0),
 ('polo shirt', 'red', 'M', 5),
 ('tank top', 'white', 'S', 200),
  ('tank top', 'blue', 'M', 15);
  
  
  
  -- Select all the columns where shirt size is M
  
  SELECT * FROM shirts WHERE shirt_size = 'M';
  -- Update shirt size as 'L' in case of 'polo shirt'
  UPDATE shirts SET shirt_size = 'L' WHERE article = 'polo shirt';
  SELECT * FROM shirts;
  -- in case of white color update color as 'off white' and shirt size = 'XS'
  UPDATE shirts SET color = 'off white', shirt_size = 'XS' WHERE color = 'white';
  -- Delete rows where article = 'tank top'
  DELETE FROM shirts WHERE article = 'tank top';
  
  
CREATE TABLE books
	(
		book_id INT AUTO_INCREMENT,
		title VARCHAR(100),
		author_fname VARCHAR(100),
		author_lname VARCHAR(100),
		released_year INT,
		stock_quantity INT,
		pages INT,
		PRIMARY KEY(book_id)
	);
 
INSERT INTO books (title, author_fname, author_lname, released_year, stock_quantity, pages)
VALUES
('The Namesake', 'Jhumpa', 'Lahiri', 2003, 32, 291),
('Norse Mythology', 'Neil', 'Gaiman',2016, 43, 304),
('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
('Interpreter of Maladies', 'Jhumpa', 'Lahiri', 1996, 97, 198),
('A Hologram for the King: A Novel', 'Dave', 'Eggers', 2012, 154, 352),
('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
('The Amazing Adventures of Kavalier & Clay', 'Michael', 'Chabon', 2000, 68, 634),
('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
('A Heartbreaking Work of Staggering Genius', 'Dave', 'Eggers', 2001, 104, 437),
('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
('What We Talk About When We Talk About Love: Stories', 'Raymond', 'Carver', 1981, 23, 176),
("Where I'm Calling From: Selected Stories", 'Raymond', 'Carver', 1989, 12, 526),
('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
('Cannery Row', 'John', 'Steinbeck', 1945, 95, 181),
('Oblivion: Stories', 'David', 'Foster Wallace', 2004, 172, 329),
('Consider the Lobster', 'David', 'Foster Wallace', 2005, 92, 343);
INSERT INTO books
   (title, author_fname, author_lname, released_year, stock_quantity, pages)
   VALUES ('10% Happier', 'Dan', 'Harris', 2014, 29, 256),
          ('fake_book', 'Freida', 'Harris', 2001, 287, 428),
          ('Lincoln In The Bardo', 'George', 'Saunders', 2017, 1000, 367);
		
SELECT * FROM books;


-- Concatenation

SELECT CONCAT('pi',' ', 'ckle');

-- Create a new column 'Full Name' from books table

SELECT *, CONCAT(author_fname, ' ',author_lname) AS author_name FROM books;

-- Distinct Function

SELECT DISTINCT author_fname FROM books;
SELECT DISTINCT CONCAT(author_fname, ' ',author_lname) AS author_name FROM books;

-- Order by

SELECT * FROM books ORDER BY stock_quantity;

SELECT * FROM books ORDER BY stock_quantity DESC;

SELECT * FROM books ORDER BY released_year, pages;

SELECT title, released_year FROM books ORDER BY author_lname, author_fname ;

SELECT * FROM books ORDER BY 5;

-- Limit -- head in python

-- title and released year of 5 most recent books
SELECT title, released_year FROM books ORDER BY released_year DESC LIMIT 5;
SELECT title, released_year FROM books ORDER BY released_year DESC LIMIT 6,5;

-- Like

SELECT 
* 
FROM books
WHERE author_fname 
LIKE '%Da';
SELECT * FROM books WHERE author_fname LIKE 'Da%';

SELECT 
book_id, 
CONCAT(author_fname, ' ',author_lname) AS author_name
FROM books 
WHERE author_fname LIKE '%Da%' 
ORDER BY stock_quantity DESC 
LIMIT 5;


-- Exercise

/*
1. book Titles where 'stories' appear in the title
2. title and number of pages for book having most pages
3. column called as 'Yell' : 'My Favorite author is Jhumpa Lahiri !!
 */
USE shirts_db;
SELECT title FROM books WHERE title LIKE '%stories%';

SELECT * FROM books;

SELECT title, pages FROM books ORDER BY pages DESC LIMIT 1;

SELECT 
*, 
CONCAT('My Favourite Author is ', UPPER(author_fname), ' ', UPPER(author_lname), ' !!') AS yell
FROM books
WHERE pages > 100
ORDER BY stock_quantity
LIMIT 5;
