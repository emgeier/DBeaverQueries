--Total purchase sales income per dealership

SELECT DISTINCT
	s.dealership_id,
	d.business_name,
	SUM(s.price) OVER(PARTITION BY s.dealership_id) AS total_sales_income
FROM sales s
NATURAL JOIN dealerships d
ORDER BY s.dealership_id;
	
	
SELECT 
    s.dealership_id,
    d.business_name,
    SUM(s.price) AS total_sales_income 
FROM sales s
NATURAL JOIN dealerships d
GROUP BY s.dealership_id, d.business_name
ORDER BY s.dealership_id ;