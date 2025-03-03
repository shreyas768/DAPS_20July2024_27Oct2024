USE daps;

CREATE TABLE city_distance
(
 distance INT,
 source VARCHAR(512),
 destination VARCHAR(512)
);


INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');

SELECT * FROM city_distance;


SELECT c1.*
FROM city_distance c1
LEFT JOIN city_distance c2
ON c1.source = c2.destination
AND c1.destination = c2.source
WHERE c1.distance != c2.distance
OR c1.source > c1.destination
OR c2.distance IS NULL;

-- Write a query that prints the name of the child and his parents in individual columns respectively in the order of the name of the child.

DROP TABLE IF EXISTS people;
create table people
(id int primary key not null,
name varchar(20),
gender char(2));

create table relations
(
c_id int,
p_id int,
FOREIGN KEY (c_id) REFERENCES people(id),
foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
(107,'Days','F'),
(145,'Hawbaker','M'),
(155,'Hansel','F'),
(202,'Blackston','M'),
(227,'Criss','F'),
(278,'Keffer','M'),
(305,'Canty','M'),
(329,'Mozingo','M'),
(425,'Nolf','M'),
(534,'Waugh','M'),
(586,'Tong','M'),
(618,'Dimartino','M'),
(747,'Beane','M'),
(878,'Chatmon','F'),
(904,'Hansard','F');

insert into relations(c_id, p_id)
values
(145, 202),
(145, 107),
(278,305),
(278,155),
(329, 425),
(329,227),
(534,586),
(534,878),
(618,747),
(618,904);

SELECT * FROM people;
SELECT * FROM relations;

WITH cte AS(
SELECT r.c_id, MAX(f.name) AS Mother_Name, MAX(m.name) AS Father_Name
FROM relations r
LEFT JOIN people f ON r.p_id = f.id AND f.gender = 'F'
lEFT JOIN people m ON r.p_id = m.id AND m.gender = 'M'
GROUP BY r.c_id
)
SELECT p.name AS Child_Name, cte.Father_Name, cte.Mother_Name
FROM people p
JOIN cte
ON cte.c_id = p.id
ORDER BY Child_Name;



-- Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between ‘2013-10-01’ and ‘2013-10-03’ Round Cancellation rate to two decimal points
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Trips;
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');


SELECT * FROM Users;
SELECT * FROM Trips;

SELECT request_at AS DATE_OF_RIDE, ROUND(SUM(CASE WHEN t.status LIKE 'cancelled%' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS cancellation_rate
FROM Trips t
JOIN Users c
ON t.client_id = c.users_id AND c.banned = 'No' AND c.role = 'client'
JOIN Users d
ON t.driver_id = d.users_id AND d.banned = 'No' AND d.role = 'driver'
WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at;