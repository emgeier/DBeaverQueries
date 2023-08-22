--which dealership IS selling the fewest models OF cars?

SELECT DISTINCT
	v.dealership_id
	d.business_name,
	COUNT(v2.model) OVER(PARTITION BY v.dealership_id) AS models_per_dealership
FROM vehicles v
NATURAL JOIN dealerships d
NATURAL JOIN vehicletypes v2

--What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
--What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
--What are the top 5 dealerships with the most customers?

SELECT DISTINCT 
	d.state,
	COUNT(s.customer_id) OVER(PARTITION BY d.state) AS number_of_customers_per_state
FROM dealerships d 
NATURAL JOIN sales s 
WHERE s.sales_type_id =1
ORDER BY number_of_customers_per_state DESC
LIMIT 5;

--to limit the count to distinct counts of customers, rather than all purchases by customers
 
SELECT 
	d.state,
	COUNT(DISTINCT s.customer_id)  AS number_of_customers_per_state
FROM dealerships d 
NATURAL JOIN sales s 
WHERE s.sales_type_id =1
GROUP BY d.state
ORDER BY number_of_customers_per_state DESC
LIMIT 5;
SELECT DISTINCT 
	c.zipcode,
	COUNT(s.customer_id) OVER(PARTITION BY c.zipcode) AS number_of_customers_per_zipcode
FROM dealerships d 
NATURAL JOIN sales s 
JOIN customers c ON s.customer_id = c.customer_id 
WHERE s.sales_type_id =1
ORDER BY number_of_customers_per_zipcode DESC
LIMIT 5;

SELECT 
	d.business_name,
	COUNT(DISTINCT s.customer_id)  AS number_of_customers_per_dealership
FROM dealerships d 
NATURAL JOIN sales s 
JOIN customers c ON s.customer_id = c.customer_id 
GROUP BY d.business_name 
ORDER BY number_of_customers_per_dealership DESC
LIMIT 5;