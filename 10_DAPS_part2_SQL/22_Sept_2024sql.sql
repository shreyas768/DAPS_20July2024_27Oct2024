USE daps;

SHOW TABLES;


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

-- Aggregation Functions

-- COUNT

SELECT COUNT(*) FROM books;

SELECT COUNT(stock_quantity) FROM books;

SELECT COUNT( DISTINCT(author_lname)) FROM books;

SELECT SUM(pages) FROM books;

SELECT AVG(pages) FROM books;

SELECT VARIANCE(pages) FROM books;

SELECT STDDEV(pages) FROM books;

SELECT MAX(pages) FROM books;

SELECT title, MAX(pages) FROM books
GROUP BY title
ORDER BY MAX(pages) DESC
LIMIT 1;


-- GROUP BY
SELECT * FROM books;

SELECT
CONCAT(author_fname, ' ',author_lname) AS author_name,
COUNT(*) AS no_of_books
FROM books
GROUP BY author_lname, author_fname;


-- Top 5 years with most books released in that year
SELECT
released_year AS yr, 
COUNT(*) AS no_of_books
FROM books
GROUP BY yr
ORDER BY COUNT(*) DESC -- ORDER BY -->> Sorting
LIMIT 5;


-- author_name, books_written, latest release, earliest release, longest_page_count
SELECT
CONCAT (author_fname, ' ', author_lname) AS author_name,
COUNT(*) AS books_written,
MAX(released_year) AS latest_release,
MIN(released_year) AS earliest_release,
MAX(pages) AS longest_pages_count
FROM books
GROUP BY author_lname, author_fname;


-- released year and sum of stock quantity in that year
SELECT
released_year,
SUM(stock_quantity)
FROM books
GROUP BY released_year;


-- 3 most recent years and number of books published in each of them and avg number of pages in that year.
SELECT
released_year, 
COUNT(*) AS no_of_books,
AVG(pages) AS AVG_Pages
FROM books
GROUP BY released_year
ORDER BY released_year DESC
LIMIT 3;


-- Revisiting DataTypes

CREATE TABLE people(
Name VARCHAR(25),
birthdate DATE,
birthtime TIME,
birthdt DATETIME);

DESC people;

INSERT INTO people (Name, birthdate, birthtime, birthdt)
VALUES ('Elliot' , '2024-09-22', '01:22:39', '2024-09-22 01:22:39');
INSERT INTO people (Name, birthdate, birthtime, birthdt)
VALUES ('Rishabh' , '2001-12-02', '19:32:49', '2001-12-02 19:32:49');
SELECT * FROM people;

INSERT INTO people (Name, birthdate, birthtime, birthdt)
VALUES ('Rahul', CURDATE(),CURTIME(),NOW());


SELECT 
birthdate,
DAY(birthdt),
HOUR(birthdt)
FROM people;


-- Insert 2 rows based on above 
INSERT INTO people (Name, birthdate, birthtime, birthdt)
VALUES ('Ram', CURDATE(),CURTIME(),NOW());
INSERT INTO people (Name, birthdate, birthtime, birthdt)
VALUES ('Shan' , '1991-07-13', '20:12:45', '1991-07-13 20:12:45');

-- Name, which day in a year, month name, hour, minute, day of the week

SELECT
Name,
DAYOFYEAR(birthdt),
MONTHNAME(birthdt) AS Month_Name,
HOUR(birthdt) AS hour_of_arrival,
MINUTE(birthdt),
DAYOFWEEK(birthdt)
FROM people;


CREATE TABLE people2(
Name VARCHAR(25),
Age INT,
Birthdetails TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

INSERT INTO people2(Name, Age)
VALUES ('Shreyas', 32);

SELECT * FROM people2;

INSERT INTO people2(Name, Age)
VALUES ('Rahul',41);

DESC people2;


SELECT *, DATE_FORMAT(Birthdetails, '%a %b %D'), 
DATE_FORMAT(Birthdetails, '%H:%i'),
DATE_FORMAT(Birthdetails, 'Working on: %r')
 FROM people2;
 
-- Explore and create atleast 1 column per dt function