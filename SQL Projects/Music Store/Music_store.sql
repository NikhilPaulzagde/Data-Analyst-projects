CREATE DATABASE Music_store;

use music_store;

CREATE TABLE album (
	album_id DECIMAL(38, 0) NOT NULL, 
	title VARCHAR(95) NOT NULL, 
	artist_id DECIMAL(38, 0) NOT NULL
);
CREATE TABLE artist (
	artist_id Int NOT NULL, 
	name VARCHAR(1000)NOT NULL
) DEFAULT CHARSET=utf8mb4;

drop table artist;

CREATE TABLE track (
	track_id DECIMAL(38, 0) NOT NULL, 
	name VARCHAR(123) NOT NULL, 
	album_id DECIMAL(38, 0) NOT NULL, 
	media_type_id DECIMAL(38, 0) NOT NULL, 
	genre_id DECIMAL(38, 0) NOT NULL, 
	composer VARCHAR(188), 
	milliseconds DECIMAL(38, 0) NOT NULL, 
	bytes DECIMAL(38, 0) NOT NULL, 
	unit_price DECIMAL(38, 2) NOT NULL
);
CREATE TABLE playlist_track (
	playlist_id DECIMAL(38, 0) NOT NULL, 
	track_id DECIMAL(38, 0) NOT NULL
);
CREATE TABLE customer (
	customer_id DECIMAL(38, 0) NOT NULL, 
	first_name VARCHAR(9) NOT NULL, 
	last_name VARCHAR(12) NOT NULL, 
	company VARCHAR(48), 
	address VARCHAR(40) NOT NULL, 
	city VARCHAR(19) NOT NULL, 
	state VARCHAR(6), 
	country VARCHAR(14) NOT NULL, 
	postal_code VARCHAR(10), 
	phone VARCHAR(19), 
	fax VARCHAR(18), 
	email VARCHAR(29) NOT NULL, 
	support_rep_id DECIMAL(38, 0) NOT NULL
);
CREATE TABLE employee (
	employee_id DECIMAL(38, 0) NOT NULL, 
	last_name VARCHAR(8) NOT NULL, 
	first_name VARCHAR(8) NOT NULL, 
	title VARCHAR(22) NOT NULL, 
	reports_to DECIMAL(38, 0), 
	levels VARCHAR(2) NOT NULL, 
	birthdate VARCHAR(16) NOT NULL, 
	hire_date VARCHAR(16) NOT NULL, 
	address VARCHAR(27) NOT NULL, 
	city VARCHAR(10) NOT NULL, 
	state VARCHAR(2) NOT NULL, 
	country VARCHAR(6) NOT NULL, 
	postal_code VARCHAR(7) NOT NULL, 
	phone VARCHAR(17) NOT NULL, 
	fax VARCHAR(17) NOT NULL, 
	email VARCHAR(27) NOT NULL
);
CREATE TABLE genre (
	genre_id DECIMAL(38, 0) NOT NULL, 
	name VARCHAR(18) NOT NULL
);
CREATE TABLE invoice (
	invoice_id DECIMAL(38, 0) NOT NULL, 
	customer_id DECIMAL(38, 0) NOT NULL, 
	invoice_date TIMESTAMP NULL, 
	billing_address VARCHAR(40) NOT NULL, 
	billing_city VARCHAR(19) NOT NULL, 
	billing_state VARCHAR(6), 
	billing_country VARCHAR(14) NOT NULL, 
	billing_postal_code VARCHAR(10), 
	total DECIMAL(38, 16) NOT NULL
);
CREATE TABLE invoice_line (
	invoice_line_id DECIMAL(38, 0) NOT NULL, 
	invoice_id DECIMAL(38, 0) NOT NULL, 
	track_id DECIMAL(38, 0) NOT NULL, 
	unit_price DECIMAL(38, 2) NOT NULL, 
	quantity BOOL NOT NULL
);
CREATE TABLE media_type (
	media_type_id DECIMAL(38, 0) NOT NULL, 
	name VARCHAR(27) NOT NULL
);
CREATE TABLE playlist (
	playlist_id DECIMAL(38, 0) NOT NULL, 
	name VARCHAR(26) NOT NULL
);

load data infile 
'D:\\music store data\\track.csv'
into table track
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

------------------------------------------------------------------------------------------------------------------------------------------------------------

#1.Who is the senior most employee based on job title?

Select * from employee 
order by levels desc
limit 1 ;

#2. Which countries have the most Invoices?

Select count(*) as c,billing_country from invoice
GROUP BY billing_country
order by c desc limit 1;

#What are top 3 values of totalinvoice?
Select *  from invoice
order by total desc  limit 3;

# 4.Which city has the best customers? We would like to throw a promotional Music 
#Festival in the city we made the most money. Write a query that returns one city that 
#has the highest sum of invoice totals. Return both the city name & sum of all invoice 
# totals

select billing_city,sum(total)as Total from invoice
group by billing_city
order by Total desc 
;

#5. Who is the best customer? The customer who has spent the most money will be 
#declared the best customer. Write a query that returns the person who has spent the 
#most money?
Select c.customer_id,c.first_name, c.last_name ,sum(i.total) as Total   from customer c  inner join invoice i
on c.customer_id=i.customer_id
group by c.customer_id
order by total desc
limit 1 ;
------------------------------------------------------------------------------------------------------------------------------------------------------------
# 6.Write query to return the email, first name, last name, & Genre of all Rock Music 
#listeners. Return your list ordered alphabetically by email starting with A

Select DISTINCT(email) ,first_name , last_name  from  customer 
join  invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id = (Select track_id from track
join genre on track.track_id=genre.genre_id
where genre.name REGEXP "^Rock$"
)
order by email;

Select distinct(email) as Email, first_name , last_name  , genre.name 
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id =invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name REGEXP "^Rock$"
order by email;



#7.Let's invite the artists who have written the most rock music in our dataset. Write a 
# query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id , artist.`name`, count(artist.artist_id) as no_of_songs  from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on genre.genre_id= track.genre_id
where genre.name REGEXP "^Rock$"
gROUP BY artist.artist_id
ORDER BY NO_OF_songs desc 
limit 10;

# Return all the track names that have a song length longer than the average song length. 
#Return the Name and Milliseconds for each track. Order by the song length with the 
#longest songs listed first

SELECT name , milliseconds
 from track
 where milliseconds >
				(Select avg(milliseconds)
                from track )
order by milliseconds desc ; 
-------------------------------------------------------------------------------------------------------------------------------------------
#. Find how much amount spent by each customer on artists? Write a query to return
# customer name, artist name and total spent

with best_selling_artist as (
	SELECT artist.artist_id as artist_id , artist.name as `Name`, 
	sum(invoice_line.quantity*invoice_line.unit_price) as Total_sale
	from invoice_line
	join track on track.track_id = invoice_line.invoice_line_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 desc
	limit 1
)
SELECT c.customer_id ,c.first_name , c.last_name , bsa.name,
sum(il.quantity*il.unit_price) as Amount_spend from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id = il.track_id 
join album alb on alb.album_id = t.track_id
join best_selling_artist bsa on alb.artist_id = bsa.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 desc;

#We want to find out the most popular music Genre for each country. We determine the 
#most popular genre as the genre with the highest amount of purchases. Write a query 
#that returns each country along with the top Genre. For countries where the maximum 
#number of purchases is shared return all Genres

 with popular_genre as (
 SELECT COUNT(invoice_line.quantity) AS purchases, customer.country ,genre.name ,genre.genre_id, 
 ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
FROM invoice_line
 JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
 JOIN customer ON customer.customer_id = invoice.customer_id
 JOIN track ON track.track_id = invoice_line.track_id
 JOIN genre ON genre.genre_id = track.genre_id
 GROUP BY 2,3,4
 ORDER BY 2 ASC, 1 DESC)
 SELECT * FROM popular_genre WHERE RowNo <= 1;
 
#Write a query that determines the customer that has spent the most on music for each 
#country. Write a query that returns the country along with the top customer and how
#much they spent. For countries where the top amount spent is shared, provide all 
#customers who spent this amount

With Country_with_customer as (
		Select customer.customer_id , customer.first_name  ,customer.last_name , invoice.billing_country ,sum(invoice.total) as Total_amount,
        ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY Sum(total) Desc) as Rowno
        from invoice
        join customer on customer.customer_id =invoice.customer_id
        GROUP BY 1,2,3,4
        order by 4 Asc , 5 Desc)
Select * from Country_with_customer where Rowno <=1;
        