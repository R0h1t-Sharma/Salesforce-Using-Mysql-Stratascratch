create database  Salesforce;
use Salesforce;
-- 1 You are given a table of product launches by company by year. Write a query to count the net difference between the
--  number of products companies launched in 2020 with the number of products companies launched in the previous year.
--  Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.
SELECT 
    company_name,
    COUNT(CASE WHEN year = 2020 THEN product_name END) -
    COUNT(CASE WHEN year = 2019 THEN product_name END) AS net_difference
FROM car_launches
WHERE year IN (2019, 2020)
GROUP BY company_name
HAVING net_difference <> 0;  -- Only include companies with a non-zero difference

-- 2 What is the total sales revenue of Samantha and Lisa?
SELECT 
    sum(sales_revenue) AS total_revenue 
FROM sales_performance 
WHERE salesperson = 'Samantha' OR salesperson = 'Lisa';

-- 3 Find employees in the Sales department who achieved a target greater than 150.
-- Output first names of employees.
-- Sort records by the first name in descending order.
SELECT 
  first_name 
FROM employee 
WHERE department = 'Sales' AND 
target > 150 
ORDER BY first_name DESC;

-- 4 Find the highest salary among salaries that appears only once.
SELECT MAX(salary) AS highest_unique_salary
FROM employee
WHERE salary IN (
    SELECT salary
    FROM employee
    GROUP BY salary
    HAVING COUNT(*) = 1);
    
    -- 5 Compare each employee's salary with the average salary of the corresponding department.
-- Output the department, first name, and salary of employees along with the average salary of that department.
SELECT e.department,e.first_name,e.salary,avg_dept_salary.avg_salary 
FROM employee e 
JOIN (SELECT department,AVG(salary) AS avg_salary FROM employee GROUP BY department) avg_dept_salary 
ON e.department=avg_dept_salary.department;
--- 6 Find departments with at more than or equal 5 employees.
SELECT department 
FROM employee 
GROUP BY department 
HAVING COUNT(DISTINCT id) >= 5;

-- 7 Find employees that are not referred by the manager id 1.
-- Output the first name of the employee.
SELECT 
        first_name
FROM employee
WHERE manager_id <> 1 OR manager_id IS NULL;

-- 8 Find the number of employees in each department.
-- Output the department name along with the corresponding number of employees.
-- Sort records based on the number of employees in descending order.
SELECT
        department,
        COUNT(id) AS number_of_employees
FROM employee
GROUP BY department
ORDER BY number_of_employees DESC , department;
-- 9 Find the highest target achieved by the employee or employees who works under the manager id 13. Output the first name of the employee and target achieved. 
-- The solution should show the highest target achieved under manager_id=13 and which employee(s) achieved it.
SELECT first_name,
       target
FROM salesforce_employees
WHERE target IN
    (SELECT MAX(target)
     FROM salesforce_employees
     WHERE manager_id = 13)
  AND manager_id = 13;
-- 10 Find the employee who has achieved the highest target.
-- Output the employee's first name along with the achieved target and the bonus.
SELECT first_name, target, bonus 
FROM employee 
WHERE target = (SELECT MAX(target) FROM employee);

--- 11 Find employees whose bonus is less than $150.
-- Output the first name along with the corresponding bonus.
SELECT
        first_name, 
        bonus 
FROM employee
WHERE bonus < 150 OR bonus IS NULL;

-- 12 Find all emails with duplicates.
SELECT 
        email
FROM employee 
GROUP BY email
HAVING count(email) > 1;
-- 13 The company for which you work is reviewing its 2021 monthly sales.
-- For each month of 2021, calculate what percentage of restaurants have reached at least 100$ or more in monthly sales.
-- Note: Please remember that if an order has a blank value for actual_delivery_time,
--  it has been canceled and therefore does not count towards monthly sales.
SELECT 
    MONTH(do.order_placed_time) AS month,
    COUNT(DISTINCT CASE WHEN ov.sales_amount >= 100 THEN do.restaurant_id END) * 100.0 / COUNT(DISTINCT do.restaurant_id) AS percentage
FROM 
    delivery_orders do
JOIN 
    order_value ov ON do.delivery_id = ov.delivery_id
WHERE 
    YEAR(do.order_placed_time) = 2021 
    AND do.actual_delivery_time IS NOT NULL  -- Exclude canceled orders
GROUP BY MONTH(do.order_placed_time)
ORDER BY month;



