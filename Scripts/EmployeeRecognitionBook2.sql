--How many emloyees are there for each role?
--How many finance managers work at each dealership?
--Get the names of the top 3 employees who work shifts at the most dealerships?
--Get a report on the top two employees who has made the most sales through leasing vehicles.

SELECT DISTINCT 
	e.employee_type_id ,
	e2.employee_type_name ,
	COUNT(e.employee_id) OVER(PARTITION BY e.employee_type_id) AS total_employees_of_type
	FROM employees e 
	NATURAL JOIN employeetypes e2 
	ORDER BY e.employee_type_id ;

--How many finance managers work at each dealership?

WITH all_finance_managers AS 
(
SELECT
	e.employee_id
	FROM employees e 
	NATURAL JOIN employeetypes e2 
	WHERE e.employee_type_id = 2
)	
SELECT DISTINCT 
	d2.business_name ,
	COUNT(d.employee_id) OVER(PARTITION BY d.dealership_id) AS total_finance_managers_per_dealership
	FROM all_finance_managers e
	NATURAL JOIN dealershipemployees d  
	NATURAL JOIN dealerships d2 
	ORDER BY d2.business_name ;
--	
--Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT DISTINCT
	e.first_name || ' ' || e.last_name,
	COUNT(d.dealership_id) OVER (PARTITION BY d.employee_id) AS dealerships_worked_at
	FROM dealershipemployees d 	
	NATURAL JOIN employees e 
	ORDER BY dealerships_worked_at DESC
	LIMIT 3;

SELECT 
	*
	FROM dealershipemployees d 
	NATURAL JOIN employees e 
	WHERE e.employee_id  = 54;
--
--OR????? To Get the actual top three ranked, which would be all the employees, if the above thing worked

WITH number_of_dealerships_worked AS
(
SELECT DISTINCT
	e.first_name || ' ' || e.last_name AS whole_name,
	COUNT(d.dealership_id) OVER (PARTITION BY d.employee_id) AS dealerships_worked_at
	FROM dealershipemployees d 	
	NATURAL JOIN employees e 
	ORDER BY dealerships_worked_at DESC

)
SELECT DISTINCT 
	d.whole_name,
	d.dealerships_worked_at
	, RANK() OVER (ORDER BY d.dealerships_worked_at DESC) AS rank_of_employee
	FROM number_of_dealerships_worked d
	ORDER BY rank_of_employee;
--OR for the top 3 ranked
WITH number_of_dealerships_worked AS
(
SELECT DISTINCT
	e.first_name || ' ' || e.last_name AS whole_name,
	COUNT(d.dealership_id) OVER (PARTITION BY d.employee_id) AS dealerships_worked_at
	FROM dealershipemployees d 	
	NATURAL JOIN employees e 
	ORDER BY dealerships_worked_at DESC

)
SELECT DISTINCT 
	whole_name,
	dealerships_worked_at,
	rank_of_employee
	FROM (SELECT
		d.whole_name,
		d.dealerships_worked_at,
		RANK() OVER (ORDER BY d.dealerships_worked_at DESC) AS rank_of_employee
		FROM number_of_dealerships_worked d ) ranked_employees
		WHERE rank_of_employee BETWEEN 1 AND 3
	ORDER BY rank_of_employee;
--
--
--SELECT DISTINCT 
--	e.first_name || ' ' || e.last_name AS name_of_employee,
--	COUNT(d.dealership_id) OVER (PARTITION BY d.employee_id) AS dealerships_worked_at,
--	RANK() OVER (PARTITION BY d.employee_id ORDER BY COUNT(d.dealership_id) DESC) 
--	FROM dealershipemployees d 	
--	NATURAL JOIN employees e
--	GROUP BY name_of_employee, d.dealership_id,  d.employee_id;
--Get a report on the top two employees who has made the most sales through leasing vehicles.

WITH amount_sales_leasing AS
(
SELECT 
	s.employee_id ,
	SUM(s.price) AS total_leasing_sales
FROM sales s
WHERE s.sales_type_id = 2
GROUP BY s.employee_id 
)

SELECT 
	e.first_name || ' '|| e.last_name AS whole_name,
	sl.total_leasing_sales
FROM amount_sales_leasing sl
Natural JOIN employees e 
ORDER BY total_leasing_sales DESC 
LIMIT 2;