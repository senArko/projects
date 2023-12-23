-- Using the Sakilla database

use sakila;

-- Task 1: Displaying the full name of the actors in the database

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name
FROM
    actor;


-- Task 2(i): Displaying the number of times each name appears in the database

SELECT 
    first_name, COUNT(first_name) AS total_occurance
FROM
    actor
GROUP BY first_name
ORDER BY total_occurance DESC;

-- Task 2(ii): Count of actors that have unique first names

SELECT 
    first_name, COUNT(first_name) AS total_count
FROM
    actor
GROUP BY first_name
HAVING total_count = 1;


-- Task 3(i): Number of times each last name appears in the database

SELECT 
    last_name, COUNT(last_name) AS total_count
FROM
    actor
GROUP BY last_name
ORDER BY total_count DESC;

-- Task 3(ii): Displaying the unique last names

SELECT DISTINCT
    last_name AS unique_last_names
FROM
    actor;
    
    
-- Task 4(i): Fetching the movies which are rated as "R"

SELECT 
    title, rating
FROM
    film
WHERE
    rating = 'R';
    
-- Task 4(ii): Fetching the movies that are not rated as "R"

SELECT 
    title, rating
FROM
    film
WHERE
    rating <> 'R';
    
-- Task 4(iii): Fetching the movies that are suitable for audience below 13 years

SELECT 
    title, rating
FROM
    film
WHERE
    rating = 'PG-13';
    
    
-- Task 5(i): Displaying the movies whose replacement cost is upto $11

SELECT 
    title, replacement_cost
FROM
    film
WHERE
    replacement_cost <= 11;
    
-- Task 5(ii): Displaying the movies whose replacement cost is between $11 and $20

SELECT 
    title, replacement_cost
FROM
    film
WHERE
    replacement_cost BETWEEN 11 AND 20;
    
-- Task 5(iii): Displaying the movies in the descending order of their replacement cost

SELECT 
    *
FROM
    film
ORDER BY replacement_cost DESC;


-- Task 6: Top 3 movies with the greatest number of actors

SELECT 
    f.title, COUNT(fa.actor_id) AS actor_count
FROM
    film f
        JOIN
    film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY actor_count DESC
LIMIT 3;


-- Task 7: Movies staring with "K" and "Q"

SELECT 
    title
FROM
    film
WHERE
    title LIKE 'K%' OR title LIKE 'Q%';
    
    
-- Task 8: names of actors who appeared in the film Agent Truman

SELECT 
    a.first_name, a.last_name, f.title
FROM
    actor a
        JOIN
    film_actor fa ON a.actor_id = fa.actor_id
        JOIN
    film f ON fa.film_id = f.film_id
WHERE
    f.title = 'Agent Truman';
    
    
-- Task 9: Fetching all the movies that are family movies


SELECT 
    f.title, c.name
FROM
    film f
        JOIN
    film_category fc ON f.film_id = fc.film_id
        JOIN
    category c ON fc.category_id = c.category_id
WHERE
    c.name = 'Family';
    

-- Task 10(i): Displaying minimum, maximum and average rental rates based on ratings

SELECT 
    rating,
    MIN(rental_rate) AS minimum_rental_rate,
    MAX(rental_rate) AS maximum_rental_rate,
    AVG(rental_rate) AS avg_rental_rate
FROM
    film
GROUP BY rating
ORDER BY avg_rental_rate DESC;


-- Task 10(ii): Displaying the movies in the descending order of their rental frequencies

SELECT 
    f.title, COUNT(r.inventory_id) AS total_rents
FROM
    film f
        JOIN
    inventory i ON f.film_id = i.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY total_rents DESC;


-- Task 11: Movie categories where the difference between average replacement cost and average rental rate in more than $15

SELECT 
    c.name,
    AVG(replacement_cost) AS avg_replacement_cost,
    AVG(rental_rate) AS avg_rental_rate,
    (AVG(replacement_cost) - AVG(rental_rate)) AS difference
FROM
    category c
        JOIN
    film_category fc ON c.category_id = fc.category_id
        JOIN
    film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING difference > 15;


-- Task 12: Movie categories in which number of movies are greater than 70

SELECT 
    c.name, COUNT(fc.category_id) AS total
FROM
    category c
        JOIN
    film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
HAVING total > 70;


-- TASK 13: CREATE A STORED PROCEDURE THAT WILL TAKE FILM ID AS IN PARAMETER AND GIVES OUT THE TITLE AND RENTAL RATE

DELIMITER $$
create procedure film(in p_film_id integer)
begin
select title, rental_rate
from film
where p_film_id = film_id;
end $$
DELIMITER ;


-- TASK 14: CREATE A CASE STATEMENT WHICH WILL CATEGORIZE THE RENTAL RATE IN TWO CATEGORIES

SELECT 
    title,
    rental_rate,
    CASE
        WHEN rental_rate > 2 THEN 'Rate more than 2'
        ELSE 'Rate less than 2'
    END AS rent
FROM
    film;
    

-- TASK 15: CREATE A TRIGGER WHICH WILL SET THE SALARY VALUE TO 0 IF THE SALARY VALUE IS LESS THAN 0


CREATE TABLE emp (
    emp_id INT,
    name VARCHAR(20),
    salary INT
);
insert into emp values(1,"Arko",20000),(2,"Krisha",25000);
select * from emp;

DELIMITER $$
create trigger salary
before insert on emp
for each row
begin
	if new.salary < 0 then
	set new.salary = 0;
	end if;
end $$ 
DELIMITER ;

insert into emp values(3,"Debasis",-4000);
select * from emp;


select * from film;





