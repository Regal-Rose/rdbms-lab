CREATE DATABASE IF NOT EXISTS employee_exp3;
USE employee_exp3;

DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- 1. DEPARTMENT TABLE
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

-- 2. PROJECT TABLE
CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    Dept_ID INT NOT NULL,
    FOREIGN KEY (Dept_ID)
        REFERENCES Department(Dept_ID)
);

-- 3. EMPLOYEE TABLE
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Hire_Date DATE NOT NULL,
    Dept_ID INT NOT NULL,
    Manager_ID INT NULL,

    FOREIGN KEY (Dept_ID)
        REFERENCES Department(Dept_ID),

    FOREIGN KEY (Manager_ID)
        REFERENCES Employee(Emp_ID)
        ON DELETE SET NULL
);

-- 4. EMPLOYEE-PROJECT MAPPING TABLE
CREATE TABLE Employee_Project (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours_Worked INT NOT NULL DEFAULT 0,

    PRIMARY KEY (Emp_ID, Project_ID),

    FOREIGN KEY (Emp_ID)
        REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Project_ID)
        REFERENCES Project(Project_ID)
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
(101, 'AI Chatbot', 500000.00, 1),
(102, 'Website Development', 300000.00, 1),
(103, 'Recruitment Portal', 150000.00, 2),
(104, 'Payroll Automation', 200000.00, 3),
(105, 'Market Analysis', 250000.00, 4),
(106, 'Customer Analytics', 350000.00, 4),
(107, 'Machine Learning Model', 600000.00, 5),
(108, 'Research Database', 400000.00, 5);

-- INSERT 30 EMPLOYEES
-- Manager_ID values reference employees inserted earlier.
-- Top-level managers have Manager_ID = NULL.

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

-- ASSIGN EMPLOYEES TO PROJECTS
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
-- 1. DISPLAY ALL EMPLOYEES
-- Demonstrates SELECT
-- =====================================================
SELECT * FROM Employee;

-- =====================================================
-- 2. DISPLAY SELECTED COLUMNS
-- Demonstrates PROJECTION
-- =====================================================
SELECT Emp_ID, Emp_Name, Salary
FROM Employee;

-- =====================================================
-- 3. SELECTION USING WHERE
-- Display employees earning more than 60000
-- =====================================================
SELECT *
FROM Employee
WHERE Salary > 60000;

-- =====================================================
-- 4. MULTIPLE CONDITIONS
-- =====================================================
SELECT Emp_Name, Salary, Dept_ID
FROM Employee
WHERE Salary >= 55000 AND Dept_ID = 1;

-- =====================================================
-- 5. DISTINCT
-- Display unique department IDs
-- =====================================================
SELECT DISTINCT Dept_ID
FROM Employee;

-- =====================================================
-- 6. AGGREGATE FUNCTIONS
-- =====================================================
SELECT
    COUNT(*) AS Total_Employees,
    SUM(Salary) AS Total_Salary,
    AVG(Salary) AS Average_Salary,
    MAX(Salary) AS Maximum_Salary,
    MIN(Salary) AS Minimum_Salary
FROM Employee;

-- =====================================================
-- 7. GROUP BY
-- Employee count and average salary per department
-- =====================================================
SELECT
    d.Dept_Name,
    COUNT(e.Emp_ID) AS Employee_Count,
    ROUND(AVG(e.Salary), 2) AS Average_Salary
FROM Department d
JOIN Employee e ON d.Dept_ID = e.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name;

-- =====================================================
-- 8. HAVING
-- Departments whose average salary exceeds 60000
-- =====================================================
SELECT
    d.Dept_Name,
    AVG(e.Salary) AS Average_Salary
FROM Department d
JOIN Employee e ON d.Dept_ID = e.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name
HAVING AVG(e.Salary) > 60000;

-- =====================================================
-- 9. CASE EXPRESSION
-- Classify employees by salary
-- =====================================================
SELECT
    Emp_Name,
    Salary,
    CASE
        WHEN Salary >= 80000 THEN 'High Salary'
        WHEN Salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS Salary_Category
FROM Employee;

-- =====================================================
-- 10. ORDER BY
-- Sort employees by salary, highest first
-- =====================================================
SELECT Emp_Name, Salary
FROM Employee
ORDER BY Salary DESC;

-- =====================================================
-- 11. ORDER BY MULTIPLE COLUMNS
-- =====================================================
SELECT Emp_Name, Dept_ID, Salary
FROM Employee
ORDER BY Dept_ID ASC, Salary DESC;

-- =====================================================
-- 12. PROJECT SUMMARY
-- Demonstrates JOIN, GROUP BY and aggregates
-- =====================================================
SELECT
    p.Project_Name,
    COUNT(ep.Emp_ID) AS Assigned_Employees,
    COALESCE(SUM(ep.Hours_Worked), 0) AS Total_Hours
FROM Project p
LEFT JOIN Employee_Project ep
    ON p.Project_ID = ep.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY Total_Hours DESC;

-- =====================================================
-- 13. EMPLOYEES EARNING ABOVE THEIR DEPARTMENT AVERAGE
-- =====================================================
SELECT Emp_Name, Salary, Dept_ID
FROM Employee e
WHERE Salary > (
    SELECT AVG(e2.Salary)
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
)
ORDER BY Dept_ID, Salary DESC;

-- =====================================================
-- 14. VERIFY RECORD COUNTS
-- Expected: 30 employees, 5 departments, 8 projects
-- =====================================================
SELECT COUNT(*) AS Total_Employees FROM Employee;
SELECT COUNT(*) AS Total_Departments FROM Department;
SELECT COUNT(*) AS Total_Projects FROM Project;
SELECT COUNT(*) AS Project_Assignments FROM Employee_Project;
```