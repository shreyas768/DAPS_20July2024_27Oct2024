USE daps;

-- Current date, time etc.

SELECT CURDATE();

SELECT CURTIME();

SELECT DAYOFWEEK(CURDATE());

SELECT DAYOFWEEK(NOW());

SELECT DATE_FORMAT(NOW(), '%w');

SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y');

SELECT DATE_FORMAT(NOW(), 'I arrived here on %M %D at %k:%i');


CREATE TABLE tweets(
content VARCHAR(140),
username VARCHAR(20),
created_at TIMESTAMP DEFAULT now());

INSERT INTO tweets (content, username) VALUES ('This is my first tweet', 'shreyas.2024');

INSERT INTO tweets (content, username) VALUES ('This is my second tweet', 'shreyas.2024');

SELECT * FROM tweets;


-- Subqueries

SELECT * FROM books;


SELECT MAX(pages) from books;


SELECT title, book_id FROM books
WHERE pages = (SELECT MAX(pages) from books);


SELECT title, book_id FROM books
ORDER BY pages DESC
LIMIT 1;

SELECT title, stock_quantity, pages FROM books
WHERE stock_quantity = (SELECT MIN(stock_quantity) FROM books);


-- Comparison and Logical Operators

SELECT * FROM books
WHERE pages > 100;

SELECT * FROM books
WHERE released_year < 2005;


SELECT * FROM books
WHERE released_year != 2017;

SELECT * FROM books WHERE author_fname NOT LIKE 'Da%';

SELECT * FROM books
WHERE released_year > 2010
AND author_lname = 'Gaiman';


SELECT * FROM books WHERE author_fname NOT LIKE 'Da%' AND released_year > 2000;

SELECT * FROM books WHERE
CHAR_LENGTH(title) > 30 AND pages > 400;

SELECT * FROM books WHERE
CHAR_LENGTH(title) > 30 OR pages > 400;

SELECT * FROM books
WHERE pages < 200
OR title LIKE '%stories%';

SELECT * FROM people;

SELECT * FROM people 
WHERE birthtime BETWEEN CAST('09:00:00' AS TIME)
AND CAST('12:00:00' AS TIME);

SELECT * FROM people 
WHERE HOUR(birthtime) BETWEEN 00 AND 12;


SELECT * FROM books
WHERE author_lname = 'Lahiri'
OR author_lname = 'Carver'
OR author_lname = 'Steinbeck';

SELECT * FROM books
WHERE author_lname IN ('Lahiri','Carver','Steinbeck');

SELECT * FROM books
WHERE author_lname NOT IN ('Lahiri','Carver','Steinbeck');

-- CASE
-- Old , NEW
SELECT *,
CASE 
WHEN released_year >= 2000 THEN 'NEW'
ELSE '20th Century Fantasy'
END AS book_type
 FROM books;
 
-- bookid, title, pages, released year, 0-40 --> '*', 40-70 -->> '**', 70-100 '***', 100-140 '****', above 140 '****' stock
-- for all books with minimum 100 pages

SELECT book_id, title, pages, released_year,
CASE 
WHEN stock_quantity < 40 THEN '*'
WHEN stock_quantity < 70 THEN '**'
WHEN stock_quantity < 100 THEN '***'
WHEN stock_quantity < 140 THEN '****'
ELSE '*****'
END AS stock
FROM books;
-- books with pages between 100 to 200
SELECT * FROM books WHERE pages BETWEEN 100 AND 200;
-- title , last name for books whose author's last name starts with C or S
SELECT title, author_lname FROM books
WHERE author_lname LIKE 'C%' 
OR author_lname LIKE 'S%';

SELECT title, released_year,
CASE
WHEN title LIKE '%stories%' THEN 'Short Stories'
WHEN title = 'Just Kids' THEN 'Memoir'
WHEN title = 'Lincoln in The Bardo' THEN 'Memoir'
ELSE 'Novel'
END AS category
FROM books;


-- How many books written by Each of author
SELECT author_fname, author_lname,
CASE WHEN COUNT(*) =1 THEN '1 book'
ELSE CONCAT(COUNT(*), ' books')
END AS no_of_books
FROM books
WHERE author_lname is NOT NULL
GROUP BY author_fname, author_lname;


-- Constraints and Alter

CREATE TABLE contacts(
name VARCHAR(100) NOT NULL,
phone VARCHAR(11) NOT NULL UNIQUE);

INSERT INTO contacts(name, phone) 
VALUES ('shreyas', '8811210980');

INSERT INTO contacts(name,phone)
VALUES ('rahul', '8811210980');

-- Check Constraint

DROP TABLE users;
CREATE TABLE users(
username VARCHAR(20) NOT NULL,
age INT CHECK(age > 18),
name VARCHAR(20) CHECK(REVERSE(name) = name));

INSERT INTO users(username,age,name)
VALUES ('rahul07', 19, 'naman');


-- Named Constraint
CREATE TABLE users(
username VARCHAR(20) NOT NULL,
age INT ,
name VARCHAR(20),
CONSTRAINT age_is_not_negative CHECK (age >0) );

INSERT INTO users(username,age,name)
VALUES ('rahul07', -12, 'naman');

-- ALTER

ALTER TABLE users
ADD COLUMN phone VARCHAR(11);

DESC users;

ALTER TABLE users
DROP COLUMN phone;

ALTER TABLE users
MODIFY age INT DEFAULT 18;

ALTER TABLE users
ADD CONSTRAINT min_age CHECK(age > 10);

USE daps;
ALTER TABLE users
DROP CONSTRAINT min_age;


