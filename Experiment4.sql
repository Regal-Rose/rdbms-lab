CREATE DATABASE IF NOT EXISTS employee_exp4;
USE employee_exp4;

DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- 1. DEPARTMENT
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

-- 2. PROJECT
CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    Dept_ID INT NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- 3. EMPLOYEE
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Hire_Date DATE NOT NULL,
    Dept_ID INT NOT NULL,
    Manager_ID INT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID),
    FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID)
        ON DELETE SET NULL
);

-- 4. EMPLOYEE_PROJECT
CREATE TABLE Employee_Project (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours_Worked INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
        ON DELETE CASCADE
);

-- INSERT 5 DEPARTMENTS
INSERT INTO Department VALUES
(1, 'IT', 'Chandigarh'),
(2, 'HR', 'Delhi'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Bengaluru'),
(5, 'Research', 'Hyderabad');

-- INSERT 8 PROJECTS
INSERT INTO Project VALUES
(101, 'AI Chatbot', 500000, 1),
(102, 'Website Development', 300000, 1),
(103, 'Recruitment Portal', 150000, 2),
(104, 'Payroll Automation', 200000, 3),
(105, 'Market Analysis', 250000, 4),
(106, 'Customer Analytics', 350000, 4),
(107, 'Machine Learning Model', 600000, 5),
(108, 'Research Database', 400000, 5);

-- INSERT 30 EMPLOYEES
INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 'Male', 90000, '2022-01-10', 1, NULL),
(2, 'Priya Verma', 'Female', 85000, '2022-03-15', 2, NULL),
(3, 'Rahul Singh', 'Male', 88000, '2021-07-20', 3, NULL),
(4, 'Ananya Gupta', 'Female', 92000, '2021-11-05', 4, NULL),
(5, 'Arjun Mehta', 'Male', 95000, '2020-06-12', 5, NULL),
(6, 'Sneha Kapoor', 'Female', 65000, '2023-02-01', 1, 1),
(7, 'Rohan Das', 'Male', 58000, '2023-04-12', 1, 1),
(8, 'Ishita Roy', 'Female', 62000, '2023-06-18', 1, 1),
(9, 'Karan Malhotra', 'Male', 55000, '2024-01-08', 1, 6),
(10, 'Meera Joshi', 'Female', 52000, '2024-03-14', 1, 6),
(11, 'Vikram Patel', 'Male', 60000, '2023-01-19', 2, 2),
(12, 'Kavya Nair', 'Female', 57000, '2023-05-23', 2, 2),
(13, 'Aditya Rao', 'Male', 54000, '2023-08-11', 2, 11),
(14, 'Riya Sethi', 'Female', 50000, '2024-02-17', 2, 11),
(15, 'Manav Khanna', 'Male', 48000, '2024-05-21', 2, 12),
(16, 'Neha Bansal', 'Female', 68000, '2022-09-09', 3, 3),
(17, 'Dev Shah', 'Male', 61000, '2023-02-25', 3, 3),
(18, 'Pooja Iyer', 'Female', 59000, '2023-07-07', 3, 16),
(19, 'Yash Arora', 'Male', 53000, '2024-01-16', 3, 16),
(20, 'Simran Kaur', 'Female', 51000, '2024-04-30', 3, 17),
(21, 'Kabir Sood', 'Male', 70000, '2022-05-13', 4, 4),
(22, 'Tanya Bose', 'Female', 64000, '2023-03-22', 4, 4),
(23, 'Nikhil Jain', 'Male', 58000, '2023-10-02', 4, 21),
(24, 'Aditi Mishra', 'Female', 55000, '2024-02-09', 4, 21),
(25, 'Sahil Verma', 'Male', 52000, '2024-06-15', 4, 22),
(26, 'Ira Chawla', 'Female', 78000, '2022-04-06', 5, 5),
(27, 'Dhruv Menon', 'Male', 69000, '2023-01-28', 5, 5),
(28, 'Naina Paul', 'Female', 66000, '2023-06-10', 5, 26),
(29, 'Reyansh Gill', 'Male', 60000, '2024-02-19', 5, 26),
(30, 'Myra Fernandes', 'Female', 57000, '2024-07-01', 5, 27);

-- INSERT EMPLOYEE-PROJECT ASSIGNMENTS
INSERT INTO Employee_Project VALUES
(1, 101, 120),
(6, 101, 100),
(7, 102, 90),
(8, 101, 110),
(9, 102, 80),
(10, 102, 75),
(2, 103, 100),
(11, 103, 90),
(12, 103, 85),
(13, 103, 70),
(14, 103, 60),
(3, 104, 120),
(16, 104, 110),
(17, 104, 95),
(18, 104, 85),
(19, 104, 80),
(4, 105, 100),
(21, 105, 95),
(22, 106, 90),
(23, 105, 80),
(24, 106, 75),
(25, 106, 70),
(5, 107, 130),
(26, 107, 120),
(27, 108, 100),
(28, 107, 95),
(29, 108, 85),
(30, 108, 75),
(15, 103, 65);

-- =====================================================
-- 1. INNER JOIN
-- Employees with their department names
-- =====================================================
SELECT
    e.Emp_ID,
    e.Emp_Name,
    d.Dept_Name
FROM Employee e
INNER JOIN Department d
    ON e.Dept_ID = d.Dept_ID
ORDER BY e.Emp_ID;

-- =====================================================
-- 2. LEFT JOIN
-- Show all departments, including those with no employees
-- =====================================================
SELECT
    d.Dept_Name,
    e.Emp_Name
FROM Department d
LEFT JOIN Employee e
    ON d.Dept_ID = e.Dept_ID
ORDER BY d.Dept_ID, e.Emp_ID;

-- =====================================================
-- 3. SELF JOIN
-- Show each employee and their manager
-- =====================================================
SELECT
    e.Emp_Name AS Employee,
    m.Emp_Name AS Manager
FROM Employee e
LEFT JOIN Employee m
    ON e.Manager_ID = m.Emp_ID
ORDER BY e.Emp_ID;

-- =====================================================
-- 4. THREE-WAY JOIN
-- Employees, departments and assigned projects
-- =====================================================
SELECT
    e.Emp_Name,
    d.Dept_Name,
    p.Project_Name,
    ep.Hours_Worked
FROM Employee e
INNER JOIN Department d
    ON e.Dept_ID = d.Dept_ID
INNER JOIN Employee_Project ep
    ON e.Emp_ID = ep.Emp_ID
INNER JOIN Project p
    ON ep.Project_ID = p.Project_ID
ORDER BY e.Emp_ID, p.Project_ID;

-- =====================================================
-- 5. CORRELATED SUBQUERY
-- Employees earning above their department's average
-- =====================================================
SELECT
    e.Emp_ID,
    e.Emp_Name,
    e.Salary,
    e.Dept_ID
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
)
ORDER BY e.Dept_ID, e.Salary DESC;

-- =====================================================
-- 6. EXISTS
-- Employees assigned to at least one project
-- =====================================================
SELECT e.Emp_ID, e.Emp_Name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- =====================================================
-- 7. NOT EXISTS
-- Employees not assigned to any project
-- =====================================================
SELECT e.Emp_ID, e.Emp_Name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- =====================================================
-- 8. SIMULATED INTERSECT
-- Employees whose department is IT and who earn >= 60000.
-- Both conditions are applied to the same employee.
-- =====================================================
SELECT Emp_ID, Emp_Name
FROM Employee
WHERE Dept_ID = 1

INTERSECT

SELECT Emp_ID, Emp_Name
FROM Employee
WHERE Salary >= 60000;

-- MySQL versions before 8.0.31 do not support INTERSECT.
-- Portable alternative using INNER JOIN:
SELECT e.Emp_ID, e.Emp_Name
FROM Employee e
INNER JOIN (
    SELECT Emp_ID
    FROM Employee
    WHERE Salary >= 60000
) high_earners ON e.Emp_ID = high_earners.Emp_ID
WHERE e.Dept_ID = 1;

-- =====================================================
-- 9. SIMULATED EXCEPT
-- Employees not assigned to any project
-- =====================================================
SELECT e.Emp_ID, e.Emp_Name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- Alternative using LEFT JOIN:
SELECT e.Emp_ID, e.Emp_Name
FROM Employee e
LEFT JOIN Employee_Project ep
    ON e.Emp_ID = ep.Emp_ID
WHERE ep.Emp_ID IS NULL
ORDER BY e.Emp_ID;

-- =====================================================
-- 10. EXPLAIN: EMPLOYEE FILTER QUERY
-- =====================================================
EXPLAIN
SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Dept_ID = 1;

-- =====================================================
-- 11. EXPLAIN: JOIN QUERY
-- =====================================================
EXPLAIN
SELECT e.Emp_Name, d.Dept_Name
FROM Employee e
INNER JOIN Department d
    ON e.Dept_ID = d.Dept_ID
WHERE d.Dept_ID = 1;

-- =====================================================
-- 12. COMPARE EXECUTION PLANS
-- =====================================================

-- Plan A: Correlated subquery
EXPLAIN
SELECT e.Emp_ID, e.Emp_Name, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
);

-- Plan B: Join with precomputed department averages
EXPLAIN
SELECT e.Emp_ID, e.Emp_Name, e.Salary
FROM Employee e
INNER JOIN (
    SELECT Dept_ID, AVG(Salary) AS Avg_Salary
    FROM Employee
    GROUP BY Dept_ID
) da
    ON e.Dept_ID = da.Dept_ID
WHERE e.Salary > da.Avg_Salary;

-- Optional detailed execution analysis.
-- EXPLAIN ANALYZE executes the query and is available in MySQL 8.0.18+.
EXPLAIN ANALYZE
SELECT e.Emp_ID, e.Emp_Name, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
);

-- =====================================================
-- 13. VERIFY DATA
-- =====================================================
SELECT COUNT(*) AS Total_Employees FROM Employee;
SELECT COUNT(*) AS Total_Departments FROM Department;
SELECT COUNT(*) AS Total_Projects FROM Project;
SELECT COUNT(*) AS Total_Assignments FROM Employee_Project;
```