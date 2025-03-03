USE daps;


-- Q1
CREATE TABLE sales 
(
    order_date date,
    customer VARCHAR(512),
    qty INT
);

INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C1', '20');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C2', '30');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C1', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C3', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C5', '19');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C4', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C3', '13');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C5', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C6', '10');

SELECT * FROM sales;

SELECT order_date, COUNT(DISTINCT customer) as count_new_customer
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer ORDER BY order_date) as rnk
FROM sales) t1
WHERE rnk = 1
GROUP BY order_date;


-- Q2

CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

-- delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

SELECT * FROM events;

WITH cte AS (
SELECT gold as player_name, 'gold' AS medal_type FROM events
UNION ALL SELECT silver as player_name, 'silver' AS medal_type FROM events
UNION ALL SELECT bronze as player_name, 'bronze' AS medal_type FROM events)
SELECT player_name, COUNT(*) AS no_of_medals
FROM cte
GROUP BY player_name
HAVING COUNT(DISTINCT medal_type) =1 AND MAX(medal_type) = 'gold';

-- Q3

create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

SELECT * FROM hospital;

WITH cte AS(
SELECT *, RANK() OVER(PARTITION BY emp_id ORDER BY time DESC) AS rnk
FROM hospital
)
SELECT *
FROM CTE
WHERE rnk = 1 AND action = 'in';

-- Q4

DROP TABLE employee;
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);

insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

SELECT * FROM employee;

SELECT dep_id, 
(SELECT emp_name FROM employee e1
WHERE e1.dep_id = e.dep_id
ORDER BY salary DESC
LIMIT 1) AS max_sal_emp,
(SELECT emp_name FROM employee e2
WHERE e2.dep_id = e.dep_id
ORDER BY salary ASC
LIMIT 1) AS min_sal_emp
FROM employee e
GROUP BY dep_id;


WITH MaxMinSalaries AS (
    SELECT 
        dep_id,
        FIRST_VALUE(emp_name) OVER (PARTITION BY dep_id ORDER BY salary DESC) AS max_sal_emp,
        FIRST_VALUE(emp_name) OVER (PARTITION BY dep_id ORDER BY salary ASC) AS min_sal_emp
    FROM employee
)
SELECT DISTINCT
    dep_id,
    max_sal_emp,
    min_sal_emp
FROM MaxMinSalaries;

-- Q5
DROP TABLE icc_world_cup;
create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup values(13,'SA','IND','DRAW');

SELECT * FROM icc_world_cup;


WITH cte AS
(
SELECT team, SUM(match_played) AS match_played,
SUM(win_flag) AS wins, SUM(draw_flag) AS NR
FROM
(SELECT team_1 as team, count(*) as match_played,
SUM(CASE WHEN winner = team_1 THEN 1 ELSE 0 END) as win_flag,
SUM(CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END) as draw_flag
FROM iCC_world_cup GROUP BY team_1
UNION ALL
SELECT team_2 as team, count(*) as match_played,
SUM(CASE WHEN winner = team_2 THEN 1 ELSE 0 END) as win_flag,
SUM(CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END) as draw_flag
FROM iCC_world_cup GROUP BY team_2) table1
GROUP BY team
)
SELECT team,
 match_played, 
 wins,
 NR, 
 match_played - wins AS loss, 
 wins*2+NR*1 AS pts
 FROM cte
 ORDER BY pts DESC;
 
 -- Alternative solution
 WITH CTE AS (
 SELECT team_1 , CASE WHEN team_1 = winner THEN 1 ELSE 0 END as win_flag
FROM iCC_world_cup 
UNION ALL
SELECT team_2 , CASE WHEN team_2 = winner THEN 1 ELSE 0 END as win_flag
FROM iCC_world_cup)
SELECT t1.*, (t1.no_of_matches - no_of_wins) no_of_loss
 FROM
(SELECT team_1 AS team, COUNT(*) no_of_matches, SUM(win_flag) no_of_wins
FROM CTE
GROUP BY team_1) t1;



-- 6 

DROP TABLE movies;
DROP TABLE reviews;
CREATE TABLE movies (
id INT PRIMARY KEY,
genre VARCHAR(50),
title VARCHAR(100)
);
-- Create reviews table
CREATE TABLE reviews (
    movie_id INT,
    rating DECIMAL(3,1),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Insert sample data into movies table
INSERT INTO movies (id, genre, title) VALUES
(1, 'Action', 'The Dark Knight'),
(2, 'Action', 'Avengers: Infinity War'),
(3, 'Action', 'Gladiator'),
(4, 'Action', 'Die Hard'),
(5, 'Action', 'Mad Max: Fury Road'),
(6, 'Drama', 'The Shawshank Redemption'),
(7, 'Drama', 'Forrest Gump'),
(8, 'Drama', 'The Godfather'),
(9, 'Drama', 'Schindler''s List'),
(10, 'Drama', 'Fight Club'),
(11, 'Comedy', 'The Hangover'),
(12, 'Comedy', 'Superbad'),
(13, 'Comedy', 'Dumb and Dumber'),
(14, 'Comedy', 'Bridesmaids'),
(15, 'Comedy', 'Anchorman: The Legend of Ron Burgundy');

-- Insert sample data into reviews table
INSERT INTO reviews (movie_id, rating) VALUES
(1, 4.5),
(1, 4.0),
(1, 5.0),
(2, 4.2),
(2, 4.8),
(2, 3.9),
(3, 4.6),
(3, 3.8),
(3, 4.3),
(4, 4.1),
(4, 3.7),
(4, 4.4),
(5, 3.9),
(5, 4.5),
(5, 4.2),
(6, 4.8),
(6, 4.7),
(6, 4.9),
(7, 4.6),
(7, 4.9),
(7, 4.3),
(8, 4.9),
(8, 5.0),
(8, 4.8),
(9, 4.7),
(9, 4.9),
(9, 4.5),
(10, 4.6),
(10, 4.3),
(10, 4.7),
(11, 3.9),
(11, 4.0),
(11, 3.5),
(12, 3.7),
(12, 3.8),
(12, 4.2),
(13, 3.2),
(13, 3.5),
(13, 3.8),
(14, 3.8),
(14, 4.0),
(14, 4.2),
(15, 3.9),
(15, 4.0),
(15, 4.1);


SELECT * FROM movies;
SELECT * FROM reviews;

WITH CTE AS (
SELECT m.genre, m.title, AVG(r.rating) AS avg_rating,
ROW_NUMBER() OVER(PARTITION BY m.genre ORDER BY AVG(r.rating) DESC) as rnk
FROM movies m
JOIN reviews r
ON m.id = r.movie_id
GROUP BY m.genre, m.title
)
SELECT genre, title, ROUND(avg_rating, 0) AS avg_ratings,
REPEAT('*',ROUND(avg_rating, 0)) AS stars
FROM cte
WHERE rnk = 1;
