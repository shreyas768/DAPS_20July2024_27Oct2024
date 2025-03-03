USE db2;

DESC tips_table2;

SELECT * FROM tips_table2;

USE sakila;

-- 1. Find top 3 actors who have acted in most number of movies

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movie_count 
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC
LIMIT 3;


-- 2. Find city which generated most revenue

SELECT city.city_id, city.city, SUM(payment.amount) AS total_revenue
FROM city
JOIN address USING(city_id)
JOIN customer USING(address_id)
JOIN payment USING(customer_id)
GROUP BY city.city_id
ORDER BY total_revenue DESC
LIMIT 1;


-- 3. write a query to determine how many times a particular movie category is rented

SELECT category.name as category_name, COUNT(rental.rental_id) AS Rental_Count
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY category.category_id;

-- 4. Find number of movies rented across each country (atleast one movie being rented in a country)
SELECT country, COUNT(rental.rental_id) AS rental_count
FROM country
JOIN city USING(country_id)
JOIN address USING(city_id)
JOIN customer USING(address_id)
JOIN rental USING(customer_id)
GROUP BY country.country_id
HAVING COUNT(rental.rental_id) > 0;

-- 5. Find customers (full name) who have rented action movies more than 3 times.


SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
JOIN customer USING(customer_id)
WHERE category.name = 'Action'
GROUP BY customer.customer_id
HAVING COUNT(rental_id)>3;