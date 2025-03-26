
CREATE TABLE album2 (
                    album_id INT PRIMARY KEY,
                    title VARCHAR(60),
                    artist_id INT
                    );
SELECT*FROM album2;

CREATE TABLE artist (
                    artist_id INT PRIMARY KEY,
					name VARCHAR (100)
                    );

SELECT * FROM artist;

CREATE TABLE customer (
                    customer_id INT PRIMARY KEY,
					first_name VARCHAR (35),
					last_name VARCHAR (35),
					company VARCHAR(50),
					address VARCHAR (100),
					city VARCHAR(100),
					state VARCHAR (30),
					country VARCHAR (30),
					postal_code VARCHAR (30),
					phone VARCHAR (40),
					fax	 VARCHAR (40),
					email VARCHAR (100),
					support_rep_id INT
                    );

SELECT * FROM customer;

CREATE TABLE employee(
                     employee_id INT PRIMARY KEY,
					 last_name VARCHAR (40),
					 first_name	 VARCHAR (40),
					 title VARCHAR (40),
					 reports_to INT,
					 levels VARCHAR (10),
					 birthdate DATE,
					 hire_date DATE,
					 address VARCHAR (50),
					 city VARCHAR(50),
					 state VARCHAR (10),
					 country VARCHAR (30),
					 postal_code VARCHAR (30),
					 phone VARCHAR (40),
					 fax VARCHAR (40),
					 email VARCHAR (100)
                    );

SELECT * FROM employee;

CREATE TABLE genre(
                   genre_id INT PRIMARY KEY,
				   name VARCHAR (80)
                   ); 
				   
SELECT * FROM genre;	

CREATE TABLE invoice(
                   invoice_id INT PRIMARY KEY,
				   customer_id	INT,
				   invoice_date DATE,
				   billing_address	VARCHAR (50),
				   billing_city VARCHAR(50),
				   billing_state VARCHAR(10),
				   billing_country VARCHAR(50),
				   billing_postal_code VARCHAR (100),
				   total FLOAT
                   ); 
				   
SELECT * FROM invoice;

CREATE TABLE invoice_line(
                   invoice_line_id	INT PRIMARY KEY,
				   invoice_id INT,
				   track_id INT,
				   unit_price FLOAT,
				   quantity INT
                   ); 

SELECT * FROM invoice_line;

CREATE TABLE media_type(
                        media_type_id INT PRIMARY KEY,
						name VARCHAR (50)
						); 

SELECT * FROM media_type;

CREATE TABLE playlist(
                      playlist_id INT PRIMARY KEY,
					  name VARCHAR (50)
					  ); 
					  
SELECT * FROM playlist;

CREATE TABLE playlist_track(
                           playlisttrack_id INT,
					       track_id INT
					       ); 
					  
SELECT * FROM playlist_track;

CREATE TABLE track(
                   track_id	INT PRIMARY KEY,
				   name VARCHAR (200),
				   album_id INT,
				   media_type_id INT,
				   genre_id INT,
				   composer VARCHAR (200),
				   milliseconds INT,
				   bytes INT,
				   unit_price FLOAT
				   );

SELECT * FROM track;

--Q1: Who is the senior most employee based on job title?

SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;

--Q2: Which countries have the most Invoices?

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC;

--Q3: What are top 3 values of total invoice?

SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

--Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals

SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

--Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money.

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;

--Question Set 2 
--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A.

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--Q2: Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


--Q3: Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

SELECT name,milLiseconds
FROM track
WHERE milLiseconds > (
	SELECT AVG(miLliseconds) AS avg_track_length
	FROM track )
ORDER BY milLiseconds DESC;