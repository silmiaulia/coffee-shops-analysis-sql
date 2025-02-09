SELECT * FROM employees;
SELECT * FROM shops;
SELECT * FROM locations;
SELECT * FROM suppliers;

-- select some (3) columns of table
SELECT
	employee_id,
	first_name,
	last_name
FROM employees;

-- Select only the employees who make more than 50k
SELECT *
FROM employees
WHERE salary > 50000;

-- Select only the employees who work in Common Grounds coffeshop
SELECT * from employees 
WHERE coffeeshop_id = 1

-- Select all the employees who work in Common Grounds and make more than 50k
SELECT * from employees 
WHERE coffeeshop_id = 1 AND salary > 50000

-- Select all the employees who work in Common Grounds, make more than 50k and are male
SELECT * from employees 
WHERE coffeeshop_id = 1 AND salary > 50000 AND gender = 'M'

-- Select all rows from the suppliers table where the supplier is Beans and Barley
SELECT * from suppliers WHERE supplier_name = 'Beans and Barley'

-- Select all rows from the suppliers table where the supplier is NOT Beans and Barley

SELECT * from suppliers WHERE supplier_name <> 'Beans and Barley'

-- Select all Robusta and Arabica coffee types
SELECT * from suppliers WHERE coffee_type IN ('Robusta', 'Arabica')

SELECT *
FROM suppliers
WHERE
	coffee_type = 'Robusta'
	OR coffee_type = 'Arabica';

-- Select all coffee types that are not Robusta or Arabica
SELECT *
FROM suppliers
WHERE coffee_type NOT IN ('Robusta', 'Arabica');

SELECT *
FROM suppliers
WHERE coffee_type != 'Robusta' AND coffee_type != 'Arabica'

-- Select all employees with missing email addresses
SELECT * from employees WHERE email IS NULL

-- Select all employees whose emails are not missing

SELECT * from employees WHERE NOT email IS NULL

-- Select all employees who make between 35k and 50k
SELECT * from employees WHERE salary >= 35000 AND salary <= 50000

SELECT * from employees WHERE salary BETWEEN 35000 AND 50000

-- ORDER BY, LIMIT, DISTINCT, Renaming columns

-- Order by salary ascending 
SELECT * from employees ORDER BY salary ASC

-- Top 10 highest paid employees
SELECT * FROM employees ORDER BY salary DESC LIMIT 10

-- Return all unique coffeeshop ids
SELECT DISTINCT coffeeshop_id from employees

-- Return all unique countries
SELECT DISTINCT country
FROM locations;

-- Renaming columns
SELECT
	email,
	email AS email_address, 
	hire_date,
  hire_date AS date_joined,
	salary,
  salary AS pay
FROM employees;

--=========================================================

-- EXTRACT
SELECT
	hire_date as date,
	EXTRACT(YEAR from hire_date) AS years,
	EXTRACT(DAY from hire_date) AS days
FROM employees;

--=========================================================

-- UPPER, LOWER, LENGTH, TRIM

SELECT first_name,
	UPPER(first_name) as first_name_upper,
	LOWER(first_name)as first_name_lower
FROM employees

-- Return the email and the length of emails
SELECT email, LENGTH(email) from employees

-- TRIM
SELECT
    LENGTH('     HELLO     ') AS hello_with_spaces,
LENGTH('HELLO') AS hello_no_spaces,
    LENGTH(TRIM('     HELLO     ')) AS hello_trimmed;

--=========================================================

-- Concatenation, Boolean expressions, wildcards

-- Concatenate first and last names to create full names
SELECT first_name, last_name, CONCAT(first_name, ' ', last_name) from employees

SELECT
	first_name,
	last_name,
	first_name || ' ' || last_name AS full_name
FROM employees;

-- Concatenate columns to create a sentence
SELECT first_name, last_name, CONCAT(first_name, ' ', last_name, ' makes $', salary) from employees

-- Boolean expressios
-- if the person makes less than 50k, then true, otherwise false
SELECT CONCAT(first_name, ' ', last_name), salary,
	(salary < 50000) as less_than_50k
from employees

-- if the person is a female and makes less than 50k, then true, otherwise false
SELECT gender, salary, (gender = 'F' AND salary < 50000) AS less_than_50k_female 
from employees

-- Boolean expressions with wildcards (% subString)
-- if email has '.com', return true, otherwise false
SELECT email, (email like '%.com%') as dotcom_flag
from employees

select * from shops

select * from shops where coffeeshop_name like '%Early%'


SELECT
	email,
	(email like '%.gov%') AS dotgov_flag
FROM employees;

-- return only government employees
SELECT first_name, email from employees where email like '%.gov%'

SELECT first_name, email, (email like '%.gov%') from employees where email like '%.gov%'


--==========================================================

-- SUBSTRING, POSITION, COALESCE

-- SUBSTRING
-- Get the email from the 5th character
SELECT 
	email,
	SUBSTRING(email FROM 5)
FROM employees;


-- POSITION
-- Find the position of '@' in the email
SELECT email, POSITION('@' IN email) as position_at from employees

-- SUBSTRING & POSITION to find the email client
SELECT 
	email,
	SUBSTRING(email FROM POSITION('@' IN email))
FROM employees;


SELECT 
	email,
	SUBSTRING(email FROM POSITION('@' IN email) + 1)
FROM employees;

-- COALESCE to fill missing emails with custom value
SELECT 
	email,
	COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees WHERE email IS NULL;


--===================================================

-- MIN, MAX, AVG, SUM, COUNT
-- Select the minimum salary
SELECT MIN(salary) as salary from employees

-- Select the maximum salary
SELECT MAX(salary) as max_sal
FROM employees;

-- Select difference between maximum and minimum salary
SELECT MAX(salary) - MIN(salary) from employees

-- Select the average salary
SELECT AVG(salary), MIN(salary) from employees

-- Round average salary to nearest integer
SELECT ROUND(AVG(salary), 0) from employees

-- Sum up the salaries
SELECT sum(salary) from employees

-- Count the number of entries
SELECT COUNT(*)
FROM employees;

SELECT COUNT(salary)
FROM employees WHERE salary < 50000;

SELECT COUNT(email)
FROM employees;

-- summary
SELECT
  MIN(salary) as min_sal,
  MAX(salary) as max_sal,
  MAX(salary) - MIN(salary) as diff_sal,
  round(avg(salary), 0) as average_sal,
  sum(salary) as total_sal,
  count(*) as num_of_emp
FROM employees;

--=========================================================

-- GROUP BY & HAVING

-- Return the number of employees for each coffeeshop
SELECT coffeeshop_id, COUNT(*) as number_employee
from employees GROUP BY coffeeshop_id


-- Return the total salaries for each coffeeshop
SELECT coffeeshop_id, SUM(salary) as total_salary
from employees GROUP BY coffeeshop_id

-- Return the number of employees, the avg & min & max & total salaries for each coffeeshop
SELECT coffeeshop_id, COUNT(*) as number_employee, ROUND(AVG(salary), 0), MIN(salary), MAX(salary), SUM(salary) as total_salary
from employees GROUP BY coffeeshop_id

-- HAVING
-- After GROUP BY, return only the coffeeshops with more than 200 employees
SELECT coffeeshop_id, COUNT(*) as number_employee, ROUND(AVG(salary), 0), MIN(salary), MAX(salary), SUM(salary) as total_salary
from employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200


-- After GROUP BY, return only the coffeeshops with a minimum salary of less than 10k
SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING MIN(salary) < 10000
ORDER BY num_of_emp DESC;

-- CASE
-- If pay is less than 50k, then low pay, otherwise high pay
SELECT
	employee_id,
	first_name, 
	salary,
	CASE
		WHEN salary < 50000 THEN 'low pay'
		WHEN salary >= 50000 THEN 'high pay'
		ELSE 'no pay'
	END as pay_category
FROM employees
ORDER BY salary DESC;

-- If pay is less than 20k, then low pay
-- if between 20k-50k inclusive, then medium pay
-- if over 50k, then high pay
SELECT
	employee_id,
	first_name || ' ' || last_name as full_name,
	salary,
	CASE
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END as pay_category
FROM employees
ORDER BY salary DESC;

-- CASE & GROUP BY 
-- Return the count of employees in each pay category
SELECT a.pay_category, COUNT(*)
FROM(
	SELECT
		employee_id,
    CASE
			WHEN salary < 20000 THEN 'low pay'
			WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
			WHEN salary > 50000 THEN 'high pay'
			ELSE 'no pay'
		END as pay_category
	FROM employees
	ORDER BY salary DESC
) a
GROUP BY a.pay_category;


-- Transpose above
SELECT
	SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS low_pay,
	SUM(CASE WHEN salary BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS medium_pay,
	SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) AS high_pay
FROM employees;

-- JOIN

-- Inserting values just for JOIN exercises
INSERT INTO locations VALUES (4, 'Paris', 'France');
INSERT INTO shops VALUES (6, 'Happy Brew', NULL);

-- Checking the values we inserted
SELECT * FROM shops;
SELECT * FROM locations;

-- "INNER JOIN" same as just "J0iN"
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
  shops s
  INNER JOIN locations l
  ON s.city_id = l.city_id;

-- LEFT JOIN
SELECT s.coffeeshop_name,
	l.city,
	l.country
FROM shops s
LEFT JOIN locations l
ON s.city_id = l.city_id

-- RIGHT JOIN
SELECT s.coffeeshop_name,
	l.city,
	l.country
FROM shops s
RIGHT JOIN locations l
ON s.city_id = l.city_id

-- FULL OUTER JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
shops s
FULL OUTER JOIN locations l
ON s.city_id = l.city_id;

-- Delete the values we created just for the JOIN exercises
DELETE FROM locations WHERE city_id = 4;
DELETE FROM shops WHERE coffeeshop_id = 6;

--========================================================
-- UNION (to stack data on top each other)

-- Return all cities and countries
SELECT city from locations UNION
SELECT country from locations

-- UNION removes duplicates
SELECT country FROM locations
UNION
SELECT country FROM locations;

-- UNION ALL keeps duplicates
SELECT country FROM locations
UNION ALL
SELECT country FROM locations;

-- Return all coffeeshop names, cities and countrie
SELECT coffeeshop_name FROM shops
UNION
SELECT city FROM locations
UNION
SELECT country FROM locations;

--=================================================

-- Subqueries
-- Basic subqueries with subqueries in the FROM clause
SELECT *
FROM (
	SELECT *
	FROM employees
	where coffeeshop_id IN (3,4)
) as a;

SELECT
  a.employee_id,
	a.first_name,
	a.last_name
FROM (
	SELECT *
	FROM employees
	where coffeeshop_id IN (3,4)
) a;

-- Basic subqueries with subqueries in the SELECT clause
SELECT
	first_name, 
	last_name, 
	salary,
	(
		SELECT MAX(salary)
		FROM employees
		LIMIT 1
	) as max_sal
FROM employees;

SELECT
	first_name, 
	last_name, 
	salary,
	(
		SELECT ROUND(AVG(salary), 0)
		FROM employees
		LIMIT 1
	) avg_sal
FROM employees;

SELECT
	first_name, 
	last_name, 
	salary, 
	salary - ( -- avg_sal
		SELECT ROUND(AVG(salary), 0)
		FROM employees
		LIMIT 1
	) avg_sal_diff
FROM employees;

-- Subqueries in the WHERE clause
-- Return employee work in coffeshop 'common grounds'
SELECT first_name, coffeeshop_id
FROM employees
WHERE coffeeshop_id = (
	SELECT coffeeshop_id
	FROM shops 
	WHERE coffeeshop_name = 'Common Grounds'
)

-- Return all US coffee shops
SELECT * FROM shops
WHERE city_id IN (
	SELECT city_id from locations
	WHERE country = 'United States'
)

-- Return all employees who work in US coffee shops
SELECT first_name, coffeeshop_id FROM employees
WHERE coffeeshop_id IN (
	SELECT coffeeshop_id from shops
	WHERE city_id IN (
		SELECT city_id FROM locations
		WHERE country = 'United States'
	)
);

-- Return all employees who make over 35k and work in US coffee shops
SELECT first_name, coffeeshop_id, salary FROM employees
WHERE coffeeshop_id IN (
	SELECT coffeeshop_id from shops
	WHERE city_id IN (
		SELECT city_id FROM locations
		WHERE country = 'United States'
	)
) AND salary > 35000;


-- 30 day moving total pay
-- The inner query calculates the total_salary of employees who were hired "within" the 30-day period before the hire_date of the current employee
SELECT
	hire_date,
	salary,
	(
		SELECT SUM(salary)
		FROM employees e2
		WHERE e2.hire_date BETWEEN e1.hire_date - 30 AND e1.hire_date
	) AS pay_pattern
FROM employees e1
ORDER BY hire_date;

select sum(salary) from employees

