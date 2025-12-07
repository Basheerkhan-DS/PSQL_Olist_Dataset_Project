--CREATE DATABASE

CREATE DATABASE olist_db;

-- CREATING THE TABLES FOR EACH DATASET BY GOING INTO THE CREATED DATABASE

--1.olist_customer_dataset Table

CREATE TABLE customer(
customer_id TEXT PRIMARY KEY,
customer_unique_id TEXT,
customer_zip_code_prefix INT,
customer_city TEXT,
customer_state TEXT
);

--2.olist_geolocation_dataset Table

CREATE TABLE geolocation(
geolocation_zip_code_prefix INT,
geolocation_lat NUMERIC,
geolocation_lng NUMERIC,
geolocation_city TEXT, 
geolocation_state TEXT
);

--3.olit_order_item_dataset Table

CREATE TABLE order_items(
order_id TEXT,
order_item_id INT,
product_id TEXT,
seller_id TEXT,
shipping_limit_date TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
price NUMERIC,
freight_value NUMERIC
);

--4.olist_order_payments_dataset Table 

CREATE TABLE payments(
order_id TEXT,
payment_sequential INT,
payment_type TEXT,
payment_installments INT,
payment_value NUMERIC
);

--5.olist_orde_review_dataset Table

CREATE TABLE order_review(
review_id TEXT,
order_id TEXT,
review_score INT,
review_comment_title TEXT,
review_comment_message TEXT,
review_creation_date TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
review_answer_timestamp TEXT -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
);


--6.olist_order_dataset Table 

CREATE TABLE orders(
order_id TEXT PRIMARY KEY,
customer_id TEXT,
order_status TEXT,
order_purchase_timestamp TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
order_approved_at TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
order_delivered_carrier_date TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
order_delivered_customer_date TEXT, -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
order_estimated_delivery_date TEXT -- AS the format is in dd-mm-yyyy hh:mm in the dataset we will imprt as text later convert it 
);

--7.olist_product_dataset Table

CREATE TABLE products(
product_id VARCHAR(40) PRIMARY KEY,
product_category_name VARCHAR(100),
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT
);

--8.olist_seller_dataset Table

CREATE TABLE sellers(
seller_id VARCHAR(40) PRIMARY KEY,
seller_zip_code_prefix INT,
seller_city VARCHAR(100),
seller_state VARCHAR(10)
);

--9. Product_category_name_translation

CREATE TABLE product_category_translation(
product_category_name VARCHAR(100),
product_category_name_english VARCHAR(100)
);

/*
=================================================================================
-- 2) IMPORT DATA (Manual step)
-- =================================================================================
/*
  Use pgAdmin Import/Export UI for each CSV:
  - Format = CSV
  - Header = true
  - Delimiter = ,
  - Quote = "
  - Encoding = UTF8

  Files and suggested table mapping (your filenames may differ):
  - olist_customers_dataset.csv              -> customer
  - olist_geolocation_dataset.csv            -> geolocation
  - olist_order_items_dataset.csv            -> order_items
  - olist_order_payments_dataset.csv         -> payments
  - olist_order_review_dataset.csv           -> order_review
  - olist_orders_dataset.csv                 -> orders
  - olist_products_dataset.csv               -> products
  - olist_sellers_dataset.csv                -> sellers
  - product_category_name_translation.csv    -> product_category_translation*/*/

---ALTERING TIMESTAMPS IN ALL THE TABLE AS THE DATE AND TIME ARE IN TEXT AT THE MOMENT 

-------------------------------------Fixing TIMESTAMP Orders Table--------------------------------------------
--ADDING NEW COLUMS WITH TIMESTAMP DATATYPE

ALTER TABLE orders
ADD COLUMN order_purchase_ts TIMESTAMP,
ADD COLUMN order_approved_ts TIMESTAMP,
ADD COLUMN order_delivered_carrier_ts TIMESTAMP,
ADD COLUMN order_delivered_customer_ts TIMESTAMP,
ADD COLUMN order_estimated_delivery_ts TIMESTAMP;

--NOW ADDING timestap data into the newly created columns 
UPDATE orders
SET 
    order_purchase_ts = to_timestamp(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI'),
    order_approved_ts = to_timestamp(order_approved_at, 'DD-MM-YYYY HH24:MI'),
    order_delivered_carrier_ts = to_timestamp(order_delivered_carrier_date, 'DD-MM-YYYY HH24:MI'),
    order_delivered_customer_ts = to_timestamp(order_delivered_customer_date, 'DD-MM-YYYY HH24:MI'),
    order_estimated_delivery_ts = to_timestamp(order_estimated_delivery_date, 'DD-MM-YYYY HH24:MI');

--Dropping old date columns as we have created the new timestamp coums for them above 

ALTER TABLE orders DROP COLUMN order_purchase_timestamp;
ALTER TABLE orders DROP COLUMN order_approved_at;
ALTER TABLE orders DROP COLUMN order_delivered_carrier_date;
ALTER TABLE orders DROP COLUMN order_delivered_customer_date;
ALTER TABLE orders DROP COLUMN order_estimated_delivery_date;

--NOW going to rename the new colums to the old columns name to aviod confusion wuith the original dataset

ALTER TABLE orders RENAME COLUMN order_purchase_ts TO order_purchase_timestamp;

ALTER TABLE orders RENAME COLUMN order_approved_ts TO order_approved_at;

ALTER TABLE orders RENAME COLUMN order_delivered_carrier_ts TO order_delivered_carrier_date;

ALTER TABLE orders RENAME COLUMN order_delivered_customer_ts TO order_delivered_customer_date;

ALTER TABLE orders RENAME COLUMN order_estimated_delivery_ts TO order_estimated_delivery_date;

-------------------------------------Fixing TIMESTAMP FOR ORDER items table----------------------------------------

SELECT Count(*) from order_items;

--CHECKING FOR NULL VALUE IN KEY FIELDS 

SELECT COUNT(*) FROM order_items WHERE product_id IS NULL;
SELECT COUNT(*) FROM order_items WHERE seller_id IS NULL;
SELECT COUNT(*) FROM order_items WHERE price IS NULL;
SELECT COUNT(*) FROM order_items WHERE freight_value IS NULL;

--Coverting the shipping_limit_date from text to TIMESTAMP column

--Creating a new column with TIMESTAMP DATATYPE

ALTER TABLE order_items
ADD COLUMN shipping_limit_date_ts TIMESTAMP;

--NOW converting the text time data into timestamp data and adding it into the new column created 

UPDATE order_items
SET shipping_limit_date_ts = TO_TIMESTAMP(shipping_limit_date,'DD-MM-YYYY HH24:MI');

--VALIDATING THE CHANGE

SELECT shipping_limit_date, shipping_limit_date_ts
FROM order_items
LIMIT 10;

--Dropping the old Column 

ALTER TABLE order_items
DROP COLUMN shipping_limit_date;

--Renaming the new column as the old column
ALTER TABLE order_items
RENAME COLUMN shipping_limit_date_ts TO shipping_limit_date;

-----------------------------Fixing timestamp for Order_review--------------------------------

--Adding new cloumn with timestamp datatype

ALTER TABLE order_review
ADD COLUMN review_creation_ts TIMESTAMP,
ADD COLUMN review_answer_ts TIMESTAMP;

--Adding the text date to timesatmp column created 

UPDATE order_review
SET review_creation_ts = TO_TIMESTAMP(review_creation_date,'DD-MM-YYYY HH24:MI'),
	review_answer_ts = TO_TIMESTAMP(review_answer_timestamp,'DD-MM-YYYY HH24:MI');

--Dropping the old date colum with text data type 

ALTER TABLE order_review
DROP COLUMN review_creation_date,
DROP Column review_answer_timestamp;

--Renaming the new columns back to old columns name for consistency

ALTER TABLE order_review
RENAME COLUMN review_creation_ts TO review_creation_date;

ALTER TABLE order_review
RENAME COLUMN review_answer_ts TO review_answer_timestamp;

--------------------------------------EDA for tables------------------------------------------

------------------------------------EDA OF PRODUCT TABLE -------------------------------------------

--CHECKING for NULL values

SELECT COUNT(*) FROM products WHERE product_category_name IS NULL;
SELECT COUNT(*) FROM products WHERE product_name_lenght IS NULL;
SELECT COUNT(*) FROM products WHERE product_description_lenght IS NULL;
SELECT COUNT(*) FROM products WHERE product_photos_qty IS NULL;
SELECT COUNT(*) FROM products WHERE product_weight_g IS NULL;
SELECT COUNT(*) FROM products WHERE product_length_cm IS NULL;
SELECT COUNT(*) FROM products WHERE product_height_cm IS NULL;
SELECT COUNT(*) FROM products WHERE product_width_cm IS NULL;

--CHECKING for Un-relaistic products like weight being 0 which is not possible for any product
SELECT COUNT(*) FROM products WHERE product_weight_g = 0;
SELECT COUNT(*) FROM products WHERE product_photos_qty = 0;
SELECT COUNT(*) FROM products WHERE product_length_cm = 0 OR product_height_cm = 0 OR product_width_cm = 0;

--POST checking dropping rows with NULL dimensions/weight 

DELETE FROM products
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

---NOW dropping rows with zero weigths 

DELETE FROM products
WHERE product_weight_g = 0;


----------------------------------EDA OF Customer Table --------------------------------------------

--Checking for NULL values

SELECT 
  COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS null_unique_id,
  COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS null_zip_prefix,
  COUNT(*) FILTER (WHERE customer_city IS NULL) AS null_city,
  COUNT(*) FILTER (WHERE customer_state IS NULL) AS null_state
FROM customer;

--Checking if customer_id is unique or not
SELECT COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customer_ids
FROM customer;

--CHecking if there are any wrong or incorrect State-codes 
SELECT DISTINCT customer_state
FROM customer
ORDER BY customer_state;

--Checking for invalid ZIP codes
SELECT *
FROM customer
WHERE customer_zip_code_prefix < 1000
   OR customer_zip_code_prefix > 99999;


--Checking city name capitalization patterns
SELECT DISTINCT customer_city
FROM customer
WHERE customer_city ~ '[A-Z]'  -- contains uppercase letter
ORDER BY customer_city;

-------------------------------EDA of Orders Table--------------------------------------------

--Knowing all the order status and then getting the countof each status within the dataset

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

--CHecking if all the delivered orders have delivered date or not 
SELECT COUNT(*)
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

--Since there are rows where the delivery happended but the delivered dat is null we will convert them to shipped to better consistency 

UPDATE orders
SET order_status = 'shipped'
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

--Checking if shipped orders have any NON null values in delivered date which should not be as the order is shipped not delivered yet
  SELECT COUNT(*)
FROM orders
WHERE order_status = 'shipped'
  AND order_delivered_customer_date IS NOT NULL;


---Checking if an cancled or un-available orsders have delivery timestamps which should not be the case 
  SELECT COUNT(*)
FROM orders
WHERE order_status IN ('canceled', 'unavailable')
  AND (
        order_delivered_customer_date IS NOT NULL OR
        order_delivered_carrier_date IS NOT NULL
      );

--Removing invalid delivery timestamps for canceled/unavailable orders

UPDATE orders
SET 
  order_delivered_customer_date = NULL,
  order_delivered_carrier_date = NULL
WHERE order_status IN ('canceled', 'unavailable')
  AND (
        order_delivered_customer_date IS NOT NULL
        OR order_delivered_carrier_date IS NOT NULL
      );

----------------------------------EDA FOR Order_review Table---------------------------------


SELECT
  COUNT(*) AS total_reviews,
  COUNT(DISTINCT order_id) AS distinct_orders_reviewed,
  COUNT(DISTINCT review_id) AS distinct_review_ids,
  COUNT(*) FILTER (WHERE review_score IS NULL) AS null_scores,
  COUNT(*) FILTER (WHERE review_comment_message IS NULL OR trim(review_comment_message) = '') AS null_messages,
  COUNT(*) FILTER (WHERE review_comment_title IS NULL OR trim(review_comment_title) = '') AS null_titles
FROM order_review;

--Reviewing the score Distribution

SELECT review_score, COUNT(*) AS cnt
FROM order_review
GROUP BY review_score
ORDER BY review_score;

--Reviewing response time (answer_ts - creation_ts) — avg/median/max

SELECT
  AVG(review_answer_timestamp - review_creation_date) AS avg_response_time,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY review_answer_timestamp - review_creation_date) AS median_response_time,
  MAX(review_answer_timestamp - review_creation_date)AS max_response_time,
  COUNT(*) FILTER (WHERE review_answer_timestamp IS NULL)AS unanswered_count
FROM order_review;


--Top 10 longest review messages (inspect for encoding issues)

SELECT review_id, order_id, char_length(review_comment_message) AS len, review_comment_message
FROM order_review
WHERE review_comment_message IS NOT NULL
ORDER BY len DESC
LIMIT 10;

--Correlate review score with delivery delay (are late deliveries getting lower scores?)

SELECT r.review_score, COUNT(*) AS cnt, AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_time
FROM order_review r
JOIN orders o ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

--Find reviews with suspicious timestamps (answer before creation)

SELECT *
FROM order_review
WHERE review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date
LIMIT 20;

--Sample incomplete/empty reviews to inspect

SELECT *
FROM order_review
WHERE (review_comment_message IS NULL OR trim(review_comment_message) = '')
  AND (review_comment_title IS NULL OR trim(review_comment_title) = '')
LIMIT 20;

-----------------------------------EDA FOR Order_items---------------------------------------

--Checking total row_count
SELECT count(*) from order_items;

--Checking for NULL values in each column 
SELECT
 	(SELECT COUNT(*) FROM order_items WHERE order_id IS NULL) AS NULL_Order_ID,
	(SELECT COUNT(*) FROM order_items WHERE order_item_id IS NULL) AS NULL_order_item_id,
	(SELECT COUNT(*) FROM order_items WHERE product_id IS NULL) AS NULL_product_id,
	(SELECT COUNT(*) FROM order_items WHERE seller_id IS NULL) AS NULL_Seller_id,
	(SELECT COUNT(*) FROM order_items WHERE price IS NULL) AS NULL_price,
	(SELECT COUNT(*) FROM order_items WHERE freight_value IS NULL) AS NULL_freight;

--Checking for Duplicates
SELECT order_id,order_item_id,COUNT(*)
FROM order_items
GROUP BY order_id,order_item_id
HAVING COUNT(*)> 1;

--Validating Primary Key logic 

SELECT COUNT(*) AS Total_rows,
	COUNT(DISTINCT CONCAT(order_id,'-',order_item_id)) AS Unique_combinations
FROM order_items;

--Checking MIN AND MAX values for price and freigth value

SELECT 
	MIN(price) AS Min_price,
	MAX(price) AS max_price,
	MIN(freight_value) AS min_freight,
	MAX(freight_value) AS max_freight
FROM order_items;

--Identifying negative or zero values
SELECT * from order_items 
WHERE price <= 0 OR freight_value <0;

--Checking number of items per order to check for unrelaistic order item count
SELECT order_id,
	COUNT(*) as item_count
FROM order_items
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 10;

--Check freight_vlaue Proporation or ddistribution
SELECT
    MIN(freight_value) AS min_freight,
    MAX(freight_value) AS max_freight,
    AVG(freight_value) AS avg_freight,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY freight_value) AS median_freight
FROM order_items;

--Shipping date range checked 
SELECT
	MIN(shipping_limit_date) AS ealiest_date,
	MAX(shipping_limit_date) AS latest_date
FROM order_items;

----------------------------EDA for payments table-------------------------------------

Select * from payments;

---CHecking for NULL Values 

SELECT 
	COUNT(*) FILTER(WHERE order_id IS NULL) AS null_order_id,
	COUNT(*) FILTER(WHERE payment_sequential IS NULL) AS null_payment_seqeuntial,
	COUNT(*) FILTER(WHERE payment_type IS NULL) AS null_payment_type,
	COUNT(*) FILTER(WHERE payment_installments IS NULL) AS null_payment_installment,
	COUNT(*) FILTER(WHERE payment_value IS NULL) AS null_payment_values
FROM payments;

---Checking for invalid payment Types

Select payment_type,COUNT(*) 
FROM payments
GROUP BY payment_type;

--Checking for invalid payments(zero or < zero)

SELECT * from payments 
WHERE payment_value <= 0;

---Checking total_revenue

SELECT SUM(payment_value) as Total_revenue
FROM payments;

----------------------------------Creating clean views---------------------------------------
--Creating a view for Faster Queries 
---ORDERS CLEAN VIEW 

CREATE OR REPLACE VIEW orders_clean AS 
SELECT 
	order_id,
	customer_id,	
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date,
--Derived fields for just date 
	DATE(order_purchase_timestamp) AS order_purchase_date,
	DATE(order_delivered_customer_date) AS delivered_date,
	DATE(order_estimated_delivery_date) AS estimated_delivery_date
FROM orders
WHERE order_purchase_timestamp IS NOT NULL;


-----------Customer_analysis_VIEW 

CREATE OR REPLACE VIEW customer_analysis AS
SELECT c.customer_id,COUNT(o.order_id) AS total_no_orders,
SUM(p.payment_value) as total_revenue, AVG(p.payment_value),
MIN(o.order_purchase_timestamp) AS first_order_date,
MAX(o.order_purchase_timestamp) AS last_order_date
FROM customer c
JOIN orders_clean o ON c.customer_id = o.customer_id
JOIN payments p on o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id

--Product Analysis View



CREATE OR REPLACE VIEW product_analysis AS
SELECT p.product_id,
	COUNT(o.order_id) AS total_orders,
	SUM(o.price) AS total_revenue,
	AVG(r.review_score) AS avg_review,
	COUNT(DISTINCT(oc.customer_id)) AS Distinct_customers,
	p.product_category_name
FROM products p 
JOIN order_items o ON p.product_id = o.product_id
JOIN orders_clean oc ON o.order_id = oc.order_id
LEFT JOIN order_review r ON o.order_id = r.order_id
GROUP BY p.product_id;


---SELLER PERFORMANCE VIEW 

CREATE OR REPLACE VIEW seller_performance AS
SELECT s.seller_id,
	COUNT(oi.order_id) AS total_orders,
	SUM(oi.price) AS total_revenue,
	AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_delay,
	100.00 * SUM(CASE WHEN o.order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)/COUNT(oi.order_id) AS percentage_of_late_deliveries
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders_clean o ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_id;		

---Category Analysis VIEW 

CREATE OR REPLACE VIEW category_analysis AS 
SELECT p.product_category_name,
	COUNT(oi.order_id) AS total_orders,
	SUM(oi.price) AS total_revenue,
	AVG(oi.price) AS avg_product_price,
	AVG(r.review_score) AS avg_review
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders_clean o ON oi.order_id = o.order_id
LEFT JOIN order_review r ON o.order_id = r.order_id
GROUP BY p.product_category_name;

--Payment and revenue VIEW 

CREATE OR REPLACE VIEW order_payment AS 
SELECT o.order_id,
	MAX(p.payment_type) As payment_type,
	MAX(p.payment_installments) AS payment_installments,
	SUM(p.payment_value) AS total_payment
FROM orders_clean o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_id;

--Delivery Performance View 

CREATE OR REPLACE VIEW delivery_performance AS 
SELECT order_id,
	order_purchase_timestamp,
	order_delivered_customer_date,
	order_estimated_delivery_date,
	(order_delivered_customer_date - order_estimated_delivery_date) AS delivery_delay_days,
	CASE 
		WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
		ELSE 'late'
	END AS Delivery_status
FROM orders_clean
WHERE order_delivered_customer_date IS NOT NULL;



--Review AND Rating view

CREATE OR REPLACE VIEW product_reviews AS
SELECT oi.product_id,
	COUNT(r.review_id) AS total_reviews,
	AVG(r.review_score) AS avg_review_score,
	AVG(r.review_answer_timestamp - r.review_creation_date) AS avg_response_time
FROM order_items oi
JOIN orders_clean o ON oi.order_id = o.order_id
LEFT JOIN order_review r ON o.order_id = r.order_id
GROUP BY oi.product_id;


---Monthly Sales/Time Based VIEW 

CREATE OR REPLACE VIEW monthly_sales AS
SELECT DATE_TRUNC('MONTH',order_purchase_timestamp) AS month_year,
	COUNT(DISTINCT(o.order_id)) AS total_orders,
	SUM(p.payment_value) AS total_revenue,
	AVG(payment_value) AS avg_order_value
FROM orders_clean o
JOIN payments p on o.order_id = p.order_id
GROUP BY DATE_TRUNC('MONTH',order_purchase_timestamp)
ORDER BY month_year;

----------------------------Business Questions And Insigths----------------------------------

--1. Who are the top 10 highest-spending customers?

Select * from customer_analysis;
SELECT customer_id,total_revenue
FROM customer_analysis
GROUP BY customer_id,total_revenue
ORDER BY total_revenue DESC
LIMIT 10;

--2. What percentage of revenue comes from repeat customers vs new customers?

WITH customer_group AS(
SELECT 
	CASE
		WHEN total_no_orders = 1 THEN 'New Customer'
		ELSE 'Repeat Customer'
	END AS customer_type,
	total_revenue
FROM customer_analysis
),
agg AS(
	SELECT 
	customer_type,
		SUM(total_revenue) AS revenue
	FROM customer_group
	GROUP BY customer_type
)

SELECT customer_type,revenue,
	ROUND((revenue/ SUM(revenue) OVER()) * 100, 2) percentage_share
FROM agg;


--3. Customers With Highest Spending Growth Over Time

WITH ordered AS(
	SELECT
		ca.customer_id,
		o.order_id,
		o.order_purchase_timestamp,
		oi.price,
		ROW_NUMBER() OVER(PARTITION BY ca.customer_id ORDER BY o.order_purchase_timestamp) AS rn,
		COUNT(*) OVER(PARTITION BY ca.customer_id) AS total_orders
	FROM customer_analysis ca
	JOIN orders_clean o ON ca.customer_id = o.customer_id
	JOIN order_items oi ON o.order_id = oi.order_id
),
split AS(
	SELECT customer_id,
		CASE WHEN rn <= total_orders/2 THEN 'First_Half' ELSE 'Second_Half' END AS period,
		price
	FROM ordered
),
agg AS(
	SELECT customer_id,
		period,
		SUM(price) AS total_spending
	FROM split
	GROUP BY customer_id,period
),
pivoted AS(
	SELECT customer_id,
	MAX(CASE WHEN period = 'First_Half' THEN total_spending END) AS first_half_spending,
	MAX(CASE WHEN period = 'Second_Half' THEN total_spending END) AS second_half_spending
	FROM agg
	GROUP By customer_id
)
SELECT customer_id,
	first_half_spending,
	second_half_spending,
	ROUND(((second_half_spending - first_half_spending)/NULLIF(first_half_spending,0)) * 100,2)
	AS growth_percentage
FROM pivoted
WHERE ROUND(((second_half_spending - first_half_spending)/NULLIF(first_half_spending,0)) * 100,2) IS NOT NULL
ORDER BY growth_percentage DESC;

-----------------------------Product & Category Insights-------------------------------------

--Top 10 Best-Selling Products by Revenue

SELECT product_id,
	product_category_name,
	total_orders,
	total_revenue
FROM product_analysis
ORDER BY total_revenue DESC
LIMIT 10;

--Product Categories With Highest Average Review Score

SELECT product_category_name,
	avg_review,
	total_orders
FROM category_analysis
ORDER BY avg_review DESC;

--Products With High Views but Low Sales


SELECT pa.product_id,
	p.product_description_lenght,
	p.product_photos_qty,
	pa.total_orders
FROM products p
JOIN product_analysis pa ON p.product_id = pa.product_id
WHERE pa.total_orders < 5
	 AND(p.product_description_lenght > 40 OR p.product_photos_qty > 2)
ORDER BY p.product_photos_qty DESC , p.product_description_lenght DESC;

--Products Most Likely to Receive Bad Reviews

SELECT 
    product_id,
    product_category_name,
    avg_review,
    total_orders
FROM product_analysis
WHERE avg_review < 3
ORDER BY avg_review ASC;

------------------------------SELLER PERFORMANCE---------------------------------------------

--Top 10 Sellers by Revenue

SELECT seller_id,
	total_orders,
	total_revenue,
	avg_delivery_delay
FROM seller_performance
ORDER BY total_revenue DESC
LIMIT 10;

--Sellers With Highest Percentage of Late Deliveries

SELECT oi.seller_id,
	COUNT(*) as total_orders,
	SUM(CASE WHEN dp.delivery_status = 'late' THEN 1 ELSE 0 END) AS late_orders,
	ROUND(
		SUM(CASE WHEN dp.delivery_status = 'late' THEN 1 ELSE 0 END):: numeric/COUNT(*) * 100,2
	)AS late_percentage
FROM delivery_performance dp
JOIN order_items oi ON dp.order_id = oi.order_id
GROUP BY oi.seller_id
HAVING COUNT(*) >10 --Avoiding sellers with very few orders
ORDER BY late_percentage DESC;


--Month-over-Month Growth of Sellers
WITH monthly_seller_sales AS (
    SELECT
        oi.seller_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM order_items oi
    JOIN orders_clean o ON oi.order_id = o.order_id
    GROUP BY oi.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp)
),
growth AS (
    SELECT
        seller_id,
        month,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY seller_id ORDER BY month
        ) AS prev_revenue
    FROM monthly_seller_sales
)
SELECT
    seller_id,
    month,
    revenue,
    prev_revenue,
    ROUND(
        (revenue - prev_revenue) / NULLIF(prev_revenue, 0) * 100, 
        2
    ) AS mom_growth_percentage
FROM growth
WHERE prev_revenue IS NOT NULL
ORDER BY mom_growth_percentage DESC
LIMIT 10;

--Categories Sold by Top Sellers

WITH top_sellers AS (
    SELECT seller_id
    FROM seller_performance
    ORDER BY total_revenue DESC
    LIMIT 10
)
SELECT
    oi.seller_id,
    p.product_category_name,
    COUNT(*) AS total_orders_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.seller_id IN (SELECT seller_id FROM top_sellers)
GROUP BY oi.seller_id, p.product_category_name
ORDER BY oi.seller_id, total_orders_category DESC;




