create database music;
use music;

select * from track;

select * from employee;

-- Who is the senior most employee based on the job title

SELECT 
    *
FROM
    employee
ORDER BY levels DESC
LIMIT 1;


-- Which countries have the most invoices

select * from invoice;

SELECT 
    billing_country AS country,
    COUNT(customer_id) AS total_invoice
FROM
    invoice
GROUP BY country
ORDER BY total_invoice DESC;


-- What are top 3 values of total invoices

SELECT 
    *
FROM
    invoice
ORDER BY total DESC
LIMIT 3;

/*
Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that return onr city that has the highest sum of invoice totals. Return both the city name and sum of all invoice totals.
*/

SELECT 
    billing_city, SUM(total) AS total_invoice
FROM
    invoice
GROUP BY billing_city
ORDER BY total_invoice DESC;


-- Who is the best customer? The customer who has spent the most money will be declared as the best customer. Write a query that returns the person who has spent the most money.

select * from customer;
select * from invoice;

SELECT 
    c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM
    customer c
        JOIN
    invoice i ON c.customer_id = i.customer_id
GROUP BY c.first_name , c.last_name
ORDER BY total_spent DESC;


/*
Write a query to return the email, first_name,last_name, and genre of all the rock music listeners. 
Return your list ordered alphabetically by email starting with A
*/

select * from genre;

select c.email, c.first_name, c.last_name, g.name as genre
from customer c 
join
invoice i on c.customer_id = i.customer_id
join 
invoice_line il on i.invoice_id = il.invoice_id
join
track t on il.track_id = t.track_id
join 
genre g on t.genre_id = g.genre_id
where g.name = "Rock"
order by c.email asc;


/*
Lets invite the artist who have written the most rock music in out dataset.
Write a query that returns the Artist name and total track of the top 10 rock bands.
*/

select * from artist;
select * from track;
select * from album2;

select a.name, count(a.artist_id) as total_tracks
from artist a 
join
album2 al on a.artist_id = al.artist_id
join 
track t on al.album_id = t.album_id
join 
genre g on t.genre_id = g.genre_id
where g.name = "Rock"
group by a.name
order by total_tracks desc
limit 10;


/*
Returb all the track that have a song length longer than the average song lenght. Return the name and milliseconds for each track.
Order by the song lenght with the longest songs listed first.
*/

select * from track;

with cte as(select avg(milliseconds) as avg_lenght from track)
select case when t.milliseconds > c.avg_lenght and t.name is not null then t.name end as track_name, t.milliseconds
from track t
cross join
cte c
where t.milliseconds > c.avg_lenght
order by t.milliseconds desc;

# Second way

SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS avg_lenght
        FROM
            track)
ORDER BY milliseconds DESC;


/*
Find how much amount spent by each customer on artis? Write a query to return customer name, artist name and total spent
*/

select * from customer;
select * from invoice;
select * from artist;
select * from invoice_line;

SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    a.name AS artist_name, 
    sum(il.quantity * il.unit_price) AS total_spent
FROM 
    customer c 
JOIN 
    invoice i ON c.customer_id = i.customer_id
JOIN 
    invoice_line il ON i.invoice_id = il.invoice_id
JOIN 
    track t ON il.track_id = t.track_id
JOIN 
    album2 al ON t.album_id = al.album_id
JOIN 
    artist a ON al.artist_id = a.artist_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    a.name
order by total_spent desc;


# Another way

with best_selling_artist as(select a.artist_id,a.name as artist_name, sum(il.quantity * il.unit_price) as total_sales
from invoice_line il
join
track t on t.track_id - il.track_id
join album2 al on al.album_id = t.album_id
join artist a on a.artist_id = al.artist_id
group by a.artist_id,a.name
order by total_sales desc
limit 1)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price * il.quantity) as amount_spent
from invoice i 
join 
customer c on c.customer_id = i.customer_id
join 
invoice_line il on il.invoice_id = i.invoice_id
join
track t on t.track_id = il.track_id
join
album2 al on al.album_id = t.album_id
join
best_selling_artist bsa on bsa.artist_id = al.artist_id
group by c.customer_id,c.first_name,c.last_name,bsa.artist_name
order by amount_spent desc;

select * from invoice_line;


/*
We want to find out the most popular music Genre for each country. We determine the most pupolar genre with the highest amount of purchases.
Write a query that returns each country along with the top genres. For countries where the maximum number of purchases is shared return all Genres.
*/

select * from customer;

with popular_genre as(select count(il.quantity) as purchases, c.country, g.name, g.genre_id,
row_number() over(partition by c.country order by count(il.quantity) desc) as row_num
from invoice_line il
join
invoice i on il.invoice_id = i.invoice_id
join customer c on i.customer_id = c.customer_id
join
track t on il.track_id = t.track_id
join
genre g on t.genre_id = g.genre_id
group by c.country, g.name, g.genre_id
order by c.country asc, purchases desc)
select * from popular_genre where row_num <=1;


/*
Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how 
much they spent. For the countires where the top amount spent is shared, provide all the customers who spent this amount.
*/

with spent as(select c.first_name, c.last_name, c.country, sum(i.total) as total_spent, g.name,
row_number() over(partition by c.country order by sum(i.total) desc) as row_num
from customer c
join
invoice i on c.customer_id = i.customer_id
join 
invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join
genre g on t.genre_id = g.genre_id
group by c.first_name,c.last_name,c.country, g.name
order by total_spent desc)
select first_name, last_name, total_spent, country from spent where row_num <=1;







