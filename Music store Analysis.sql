use [MusicStore_P];

--Detect Null value and replace null value
SELECT *
FROM [dbo].[album]
WHERE [album_id] IS NULL OR 
      [title] IS NULL OR 
	  [artist_id] IS NULL;

SELECT *
FROM [dbo].[artist]
WHERE [artist_id] IS NULL OR 
      [name] IS NULL;

	  
SELECT *
FROM [dbo].[customer]
WHERE [customer_id] IS NULL OR [first_name] IS NULL OR 
[last_name] IS NULL OR 
[company] IS NULL OR
[address] IS NULL OR 
[city] IS NULL OR 
[state] IS NULL OR 
[country] IS NULL OR 
[postal_code]IS NULL OR 
[phone] IS NULL OR 
[fax] IS NULL OR 
[email] IS NULL OR 
[support_rep_id]  IS NULL;

UPDATE [dbo].[customer]
SET [company] = COALESCE([company], 'UnKnown')
WHERE [company] IS NULL;

UPDATE [dbo].[customer]
SET [state] = COALESCE([state], 'UnKnown')
WHERE [state] IS NULL;

UPDATE [dbo].[customer]
SET [postal_code] = COALESCE([postal_code], 'UnKnown')
WHERE [postal_code] IS NULL;

UPDATE [dbo].[customer]
SET  [phone]= COALESCE([phone], '000000000000')
WHERE [phone] IS NULL;

UPDATE [dbo].[customer]
SET [fax] = COALESCE([fax], [phone])
WHERE [fax] IS NULL ;

SELECT *
FROM [dbo].[employee]
WHERE [employee_id] 
IS NULL OR [last_name] 
IS NULL OR [first_name]
IS NULL OR [title] 
IS NULL OR [reports_to]
IS NULL OR [levels] 
IS NULL OR  [birthdate]
IS NULL OR [hire_date] 
IS NULL OR [address] 
IS NULL OR [city]
IS NULL OR [state] 
IS NULL OR  [country] 
IS NULL OR [postal_code] 
IS NULL OR [phone] 
IS NULL OR [fax] 
IS NULL OR [email] IS NULL;

SELECT *
FROM [dbo].[genre]
WHERE  [genre_id]IS NULL OR [name] IS NULL;

SELECT *
FROM [dbo].[invoice]
WHERE  [invoice_id]
IS NULL OR [customer_id]
IS NULL OR [invoice_date]
IS NULL OR [billing_address]
IS NULL OR [billing_city]
IS NULL OR [billing_state]
IS NULL OR [billing_country]
IS NULL OR [billing_postal_code]
IS NULL OR [total] IS NULL;


SELECT *
FROM [dbo].[invoice_line]
WHERE  [invoice_line_id]
IS NULL OR [invoice_id]
IS NULL OR [track_id]
IS NULL OR [unit_price] 
IS NULL OR [quantity] IS NULL;


SELECT *
FROM [dbo].[media_type]
WHERE [media_type_id]
IS NULL OR [name] IS NULL;

SELECT *
FROM [dbo].[playlist]
WHERE [playlist_id]
IS NULL OR [name] IS NULL;

SELECT *
FROM [dbo].[playlist_track]
WHERE [playlist_id]
IS NULL OR [track_id] IS NULL;

SELECT *
FROM [dbo].[track]
WHERE  [track_id]
IS NULL OR [name]
IS NULL OR [album_id]
IS NULL OR [media_type_id] 
IS NULL OR [genre_id]
IS NULL OR [composer]
IS NULL OR [milliseconds] 
IS NULL OR [bytes]
IS NULL OR [unit_price] IS NULL;

UPDATE [dbo].[track]
SET  [composer] = COALESCE([composer], 'UnKnown')
WHERE [composer] IS NULL;



-----------------------------------------------------------
--Find duplicated row and delete it
WITH cte AS (
    SELECT 
        [album_id],
        ROW_NUMBER() OVER (
            PARTITION BY [album_id]
            ORDER BY [album_id]) row_num
    FROM 
        [dbo].[album]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [artist_id],
        ROW_NUMBER() OVER (
            PARTITION BY [artist_id]
            ORDER BY [artist_id]) row_num
    FROM 
        [dbo].[artist]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [customer_id],
        ROW_NUMBER() OVER (
            PARTITION BY [customer_id]
            ORDER BY [customer_id]) row_num
    FROM 
        [dbo].[customer]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [employee_id],
        ROW_NUMBER() OVER (
            PARTITION BY [employee_id]
            ORDER BY [employee_id]) row_num
    FROM 
        [dbo].[employee]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [genre_id],
        ROW_NUMBER() OVER (
            PARTITION BY [genre_id]
            ORDER BY [genre_id]) row_num
    FROM 
        [dbo].[genre]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [invoice_id],
        ROW_NUMBER() OVER (
            PARTITION BY [invoice_id]
            ORDER BY [invoice_id]) row_num
    FROM 
        [dbo].[invoice]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [invoice_line_id],
        ROW_NUMBER() OVER (
            PARTITION BY [invoice_line_id]
            ORDER BY [invoice_line_id]) row_num
    FROM 
        [dbo].[invoice_line]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [media_type_id],
        ROW_NUMBER() OVER (
            PARTITION BY [media_type_id]
            ORDER BY [media_type_id]) row_num
    FROM 
        [dbo].[media_type]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [playlist_id],
        ROW_NUMBER() OVER (
            PARTITION BY [playlist_id]
            ORDER BY [playlist_id]) row_num
    FROM 
        [dbo].[playlist]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [playlist_id],
        ROW_NUMBER() OVER (
            PARTITION BY [playlist_id]
            ORDER BY [playlist_id]) row_num
    FROM 
        [dbo].[playlist]
) 
SELECT * FROM cte 
WHERE row_num > 1;

WITH cte AS (
    SELECT 
        [track_id],
        ROW_NUMBER() OVER (
            PARTITION BY [track_id]
            ORDER BY [track_id]) row_num
    FROM 
        [dbo].[track]
) 
SELECT * FROM cte 
WHERE row_num > 1;

-----------------------------------------------------------
--What is the average duration of tracks in each genre?
SELECT g.[name],t.[genre_id], AVG(t.[milliseconds]) AS "Average_duration"
FROM [dbo].[track] t JOIN [dbo].[genre] g
     ON t.[genre_id] = g.[genre_id]
GROUP BY g.[name],t.[genre_id];

--Which genre has the highest average unit price for its tracks?
SELECT TOP 1 g.[name], AVG(t.[unit_price]) AS "Highest_average_unit_price" 
FROM [dbo].[track] t JOIN [dbo].[genre] g
     ON t.[genre_id] = g.[genre_id]
GROUP BY g.[name]
ORDER BY Highest_average_unit_price DESC;

--How many invoices were issued per country?
SELECT * FROM [dbo].[invoice];

SELECT [billing_country] , 
       COUNT([invoice_id]) AS "Number_of_invoices"
FROM [dbo].[invoice]
GROUP BY [billing_country]
ORDER BY Number_of_invoices DESC;

--How many invoices were issued per city?
SELECT [billing_city] , 
       COUNT([invoice_id]) AS "Number_of_invoices"
FROM [dbo].[invoice]
GROUP BY [billing_city]
ORDER BY Number_of_invoices DESC;

--How many invoices were issued per state?
SELECT [billing_state] , 
       COUNT([invoice_id]) AS "Number_of_invoices"
FROM [dbo].[invoice]
GROUP BY [billing_state]
ORDER BY Number_of_invoices DESC;

--What is the total revenue generated by each artist?
SELECT ar.[artist_id] , ar.[name] , 
       SUM(inl.[unit_price]*inl.[quantity]) AS "Total_revenue"
FROM [dbo].[artist] ar join [dbo].[album] al
     on ar. [artist_id] = al.[artist_id] join [dbo].[track] t
	 on al.[album_id] = t.[album_id] join [dbo].[invoice_line] inl
	 on t.[track_id] = inl.[track_id];
GROUP BY ar.[artist_id] , ar.[name]
ORDER BY Total_revenue DESC;

--Which artist has the highest total sales revenue?
SELECT TOP 1 ar.[artist_id] , ar.[name] , 
       SUM(inl.[unit_price]*inl.[quantity]) AS "Total_revenue"
FROM [dbo].[artist] ar join [dbo].[album] al
     on ar. [artist_id] = al.[artist_id] join [dbo].[track] t
	 on al.[album_id] = t.[album_id] join [dbo].[invoice_line] inl
	 on t.[track_id] = inl.[track_id]
GROUP BY ar.[artist_id] , ar.[name]
ORDER BY Total_revenue DESC;

--What is the distribution of track durations across each albums?
SELECT al.[album_id] , al.[title] ,
       COUNT(t.[album_id]) AS "Number_of_tracks",
	   MAX(t.[milliseconds]) AS "MAX_track_duration",
	   MIN(t.[milliseconds]) AS "MIN_track_duration",
	   AVG(t.[milliseconds]) AS "AVG_track_duration"
FROM [dbo].[track] t join [dbo].[album] al
     on t.[album_id] = al.[album_id]
GROUP BY al.[album_id] , al.[title];

--Identify the top-selling album in of revenue.
SELECT TOP 10 al.[album_id] ,al.[title], 
       SUM(inl.[unit_price]*inl.[quantity]) AS "Total_revenue"
FROM [dbo].[album] al join [dbo].[track] t
	 on al.[album_id] = t.[album_id] join [dbo].[invoice_line] inl
	 on t.[track_id] = inl.[track_id]
GROUP BY al.[album_id] ,al.[title]
ORDER BY Total_revenue DESC;

--How many customers (purches) in each countries?
SELECT [billing_country] , 
       COUNT([customer_id]) AS "Number_of_customer"
FROM [dbo].[invoice]
GROUP BY [billing_country]
ORDER BY Number_of_customer DESC;

--Find the average number of tracks per invoice.
SELECT inn.[invoice_id] , 
       AVG(inl.[track_id]) AS "Average_number_of_tracks"
FROM [dbo].[invoice] inn join [dbo].[invoice_line] inl
     on inn.[invoice_id] = inl.[invoice_id]
GROUP BY inn.[invoice_id];

--Identify the top 5 customers with the highest total spending.
SELECT TOP 5 c.[customer_id] , 
       CONCAT(c.[first_name] , c.[last_name] )AS "Full_Name",
	   SUM(inl.[unit_price] * inl.[quantity]) AS "Tatal_revenue"
FROM  [dbo].[customer] c join [dbo].[invoice] inn 
      on c.[customer_id] = inn.[customer_id] join [dbo].[invoice_line] inl
	  on inn.[invoice_id] = inl.[invoice_id]
GROUP BY c.[customer_id] , c.[first_name] , c.[last_name] 
ORDER BY Tatal_revenue DESC;

--Analyze the distribution of sales over different months.
SELECT FORMAT([invoice_date] , 'MMMM') AS "Month_NAME" , 
       COUNT([invoice_id]) AS "Number_of_invoices" ,
	   SUM([total]) AS "Total_sales"
FROM [dbo].[invoice]
GROUP BY FORMAT([invoice_date] , 'MMMM');

--Identify the most popular genre in terms of total sales.
SELECT TOP 1 g.[genre_id] , g.[name] , 
       SUM(inl.[unit_price]*inl.[quantity]) AS "Total_revenue"
FROM [dbo].[genre] g join [dbo].[track] t 
     on g.[genre_id] = t.[genre_id] join [dbo].[invoice_line] inl
	 on inl.[track_id] = t.[track_id]
GROUP BY g.[genre_id] , g.[name]
ORDER BY Total_revenue DESC;

--Determine the average number of tracks in playlists.
SELECT pl.[playlist_id] , pl.[name] ,
       AVG(t.[track_id]) AS "Number_of_tracks"
FROM [dbo].[playlist] pl join [dbo].[playlist_track] plt
     on pl.[playlist_id] = plt.[playlist_id] join [dbo].[track] t
	 on t.[track_id] = plt.[track_id]
GROUP BY pl.[playlist_id] , pl.[name] ;

SELECT pl.[playlist_id] , pl.[name] ,
       AVG(plt.[track_id]) AS "Number_of_tracks"
FROM [dbo].[playlist] pl join [dbo].[playlist_track] plt
     on pl.[playlist_id] = plt.[playlist_id] 
GROUP BY pl.[playlist_id] , pl.[name]; 

--Identify the top-selling artist in of total quantity sold.
SELECT ar.[artist_id] , ar.[name] , 
       SUM(inl.[quantity]) AS "Total"
FROM [dbo].[artist] ar JOIN [dbo].[album] al
     ON ar.[artist_id] = al.[artist_id] JOIN [dbo].[track] t
	 ON t.[album_id] = al.[album_id] JOIN [dbo].[invoice_line] inl
	 ON t.[track_id] = inl.[track_id]
GROUP BY ar.[artist_id] , ar.[name]
ORDER BY Total DESC;

--Determine the quantity of tracks per album.
SELECT al.[album_id] , al.[title] , 
       COUNT(t.[track_id]) AS "Number_of_tracks"
FROM [dbo].[album] al join [dbo].[track] t
     on al.[album_id] = t.[album_id]
GROUP BY al.[album_id] , al.[title] 
ORDER BY Number_of_tracks DESC;

--Find the top 10 tracks with the highest unit prices.
SELECT TOP 10 [track_id] , [name] , [unit_price]
FROM [dbo].[track]
ORDER BY [unit_price] DESC;

--the artist with the highest unit price for tracks.
SELECT ar.[artist_id] , ar.[name] , MAX(t.[unit_price]) AS "MAXX"
FROM [dbo].[artist] ar JOIN [dbo].[album] al 
     on ar.[artist_id] = al.[artist_id] JOIN [dbo].[track] t
	 on t.[album_id] = al.[album_id]
GROUP BY ar.[artist_id] , ar.[name]
ORDER BY MAXX DESC;

--Find the number of tracks per album for each artist.
SELECT al.[title] , ar.[name] , COUNT(t.[track_id]) AS "AVg_number_tracks"
FROM [dbo].[artist] ar JOIN [dbo].[album] al 
     on ar.[artist_id] = al.[artist_id] JOIN [dbo].[track] t
	 on al.[album_id] = t.[album_id]
GROUP BY al.[title] , ar.[name];

--Identify the top 5 countries with the highest total spending.
SELECT TOP 5 [billing_country] , SUM([total]) AS "Total"
FROM [dbo].[invoice]
GROUP BY [billing_country]
ORDER BY Total DESC;

--Analyze the distribution of sales across different billing cities.
SELECT [billing_city] , 
       SUM([total]) AS "Total_Sales" , 
	   COUNT([invoice_id]) AS "Number_of_invoice"
FROM [dbo].[invoice]
GROUP BY [billing_city]
ORDER BY Total_Sales DESC;

--Determine the average unit price for each media type.
SELECT m.[media_type_id] , m.[name] , 
       AVG(t.[unit_price]) AS "Average_unit_price"
FROM [dbo].[media_type] m join [dbo].[track] t 
     on m.[media_type_id] = t.[media_type_id]
GROUP BY m.[media_type_id] , m.[name];

--Identify the top 10 tracks with the highest total revenue.
SELECT TOP 10  t.[track_id] , t.[name] , 
       SUM(inl.[unit_price]*inl.[quantity]) AS "Total_revenue"
FROM [dbo].[invoice_line] inl join [dbo].[track] t
     on t.[track_id] = inl.[track_id]
GROUP BY t.[track_id] , t.[name]
ORDER BY Total_revenue DESC;

--Find the customer who has purchased the most diverse range of genres.
SELECT c.[customer_id] , c.[first_name] ,  
       COUNT(DISTINCT t.[genre_id]) AS "Number_genre"
FROM [dbo].[customer] c join [dbo].[invoice] inn
     on c.[customer_id] = inn.[customer_id] join [dbo].[invoice_line] inl
	 on inn.[invoice_id] = inl.[invoice_id] join [dbo].[track] t
	 on inl.[track_id] = t.[track_id]
GROUP BY c.[customer_id] , c.[first_name];


