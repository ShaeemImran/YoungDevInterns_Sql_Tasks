-- TASK 1 | Basic tasks | week 1
-- 1 
CREATE DATABASE Internship_DB;
USE Internship_DB;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(1, 'HR', 'New York'),
(2, 'Engineering', 'San Deigo'),
(3, 'Marketing', 'Chicago'),
(4, 'Finance', 'Melbourne'),
(5, 'IT', 'Somalia');

INSERT INTO employees (emp_id, emp_name, position, salary, dept_id) VALUES
	(101, 'Samantha Kiu', 'Software Engineer', 75000, 2),
	(102, 'Mikasa Erm', 'HR Manager', 55000, 1),
	(103, 'Sasha Brown', 'Marketing Specialist', 48000, 3),
	(104, 'Saiki kuso', 'Financial Analyst', 62000, 4),
	(105, 'Rimla Noah', 'IT Support', 47000, 5);

-- 2 (Basic select Queries)
Select emp_name, position 
From employees;

Select dept_name, location 
From departments;

Select emp_id, emp_name
From employees
WHERE salary > 50000;

-- 3 (Filtering & sorting)
Select * From employees
ORDER BY emp_name ASC;

-- TASK2 | INTERMEDIATE | week 2-3

-- 1 Join Operation
SELECT e.emp_id, e.emp_name, d.dept_id, d.dept_name
FROM employees AS e
JOIN departments d ON e.dept_id = d.dept_id;
-- testing with no dept id
INSERT INTO employees (emp_id, emp_name, position, salary, dept_id) VALUES
(106, 'Hulli fiun', 'Product Manager', 75000, NULL);

SELECT e.emp_id, e.emp_name, d.dept_name
	FROM employees e
	LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Aggregate Functions
SELECT AVG(salary) AS Average_Salary_of_Employees
FROM employees;
-- total employees per department
SELECT COUNT(e.emp_id), d.dept_name
	FROM employees e
	JOIN departments d ON e.dept_id = d.dept_id
	GROUP BY d.dept_name;

-- testing
INSERT INTO employees (emp_id, emp_name, position, salary, dept_id) VALUES
	(108, 'Levi Ackerman', 'HR Assistant', 51000, 1),
	(109, 'Armin Arlert', 'HR Executive', 53000, 1);

-- calculate the highest salary
SELECT d.dept_name, max(e.salary) AS Highest_Salary
	FROM departments AS d
	JOIN employees e ON d.dept_id = e.dept_id
	GROUP BY d.dept_name;

-- SubQueries
SELECT emp_name, salary, dept_id
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id
);

-- Departs with more than 3 employees
SELECT dept_id
	FROM employees
	GROUP BY dept_id
	HAVING count(*) > 3;

-- testing
INSERT INTO employees (emp_id, emp_name, position, salary, dept_id) VALUES
	(110, 'Jean Kirschtein', 'HR Intern', 45000, 1),
	(111, 'Connie Springer', 'HR Trainee', 46000, 1),
	(112, 'Historia Reiss', 'HR Officer', 52000, 1);

-- EXPERT TASK | WEEK 4
CREATE TABLE managers (
    manager_id INT PRIMARY KEY,
    manager_name VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
INSERT INTO managers (manager_id, manager_name, dept_id) VALUES
	(1, 'Nile Dok', 1),(2, 'Pixis', 2),
	(3, 'Erwin Smith', 3),(4, 'Hange Zoe', 4),
	(5, 'Keith Shadis', 5);

-- JOIN
SELECT e.emp_name, d.dept_name, m.manager_name
FROM employees e
JOIN departments d ON e.dept_id = d. dept_id
JOIN  managers m ON d.dept_id = m.dept_id;

-- Window functions
SELECT emp_name, dept_id, salary,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;
--
SELECT emp_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS company_rank
FROM employees;

-- Data Modification & Transactions
-- before and after modification in the salaries

UPDATE employees
SET salary = salary + (salary * 0.10);
SELECT salary FROM employees;

START transaction;
	UPDATE employees
	SET salary = salary + (salary * 0.2);
    
    savepoint name1;
    
    UPDATE employees
    SET emp_name = "Jean Kirs"
    WHERE emp_id = 110;
    
    rollback to name1;
COMMIT;
SELECT emp_name from employees;
