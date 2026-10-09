CREATE DATABASE IF NOT EXISTS employee_exp5;
USE employee_exp5;

DROP VIEW IF EXISTS Department_Salary_Summary;
DROP VIEW IF EXISTS Employee_Hierarchy;
DROP VIEW IF EXISTS Employee_Public_View;

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

    FOREIGN KEY (Dept_ID)
        REFERENCES Department(Dept_ID),

    FOREIGN KEY (Manager_ID)
        REFERENCES Employee(Emp_ID)
        ON DELETE SET NULL
);

-- 4. EMPLOYEE_PROJECT
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
-- 1. DEPARTMENT SALARY SUMMARY VIEW
-- =====================================================
CREATE VIEW Department_Salary_Summary AS
SELECT
    d.Dept_ID,
    d.Dept_Name,
    COUNT(e.Emp_ID) AS Employee_Count,
    COALESCE(SUM(e.Salary), 0) AS Total_Salary,
    COALESCE(ROUND(AVG(e.Salary), 2), 0) AS Average_Salary,
    COALESCE(MAX(e.Salary), 0) AS Maximum_Salary,
    COALESCE(MIN(e.Salary), 0) AS Minimum_Salary
FROM Department d
LEFT JOIN Employee e
    ON d.Dept_ID = e.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name;

-- DISPLAY DEPARTMENT SALARY SUMMARY
SELECT * FROM Department_Salary_Summary;

-- =====================================================
-- 2. EMPLOYEE HIERARCHY VIEW
-- Displays employees alongside their direct managers
-- =====================================================
CREATE VIEW Employee_Hierarchy AS
SELECT
    e.Emp_ID,
    e.Emp_Name AS Employee_Name,
    e.Dept_ID,
    e.Salary,
    e.Manager_ID,
    m.Emp_Name AS Manager_Name
FROM Employee e
LEFT JOIN Employee m
    ON e.Manager_ID = m.Emp_ID;

-- DISPLAY EMPLOYEE HIERARCHY
SELECT * FROM Employee_Hierarchy
ORDER BY Dept_ID, Emp_ID;

-- =====================================================
-- 3. SIMPLE VIEW TO TEST UPDATABILITY
-- This view selects columns from one base table only.
-- It is normally updatable in MySQL.
-- =====================================================
CREATE VIEW Employee_Public_View AS
SELECT Emp_ID, Emp_Name, Salary, Dept_ID
FROM Employee;

SELECT * FROM Employee_Public_View
WHERE Emp_ID = 6;

-- Update through the simple view
UPDATE Employee_Public_View
SET Salary = 66000
WHERE Emp_ID = 6;

-- Verify the base table was updated
SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Emp_ID = 6;

-- Restore the original salary
UPDATE Employee_Public_View
SET Salary = 65000
WHERE Emp_ID = 6;

-- =====================================================
-- 4. TEST UPDATABILITY OF AGGREGATE VIEW
-- Aggregate views containing GROUP BY are not updatable.
-- The following is an expected error; run separately.
-- =====================================================
-- UPDATE Department_Salary_Summary
-- SET Average_Salary = 70000
-- WHERE Dept_ID = 1;

-- =====================================================
-- 5. TEST UPDATABILITY OF JOIN VIEW
-- A view containing a join may allow some updates, but
-- updating a column from a non-updatable view is restricted.
-- Try this statement separately to observe MySQL behavior.
-- =====================================================
-- UPDATE Employee_Hierarchy
-- SET Manager_ID = 1
-- WHERE Emp_ID = 7;

-- =====================================================
-- 6. RECURSIVE CTE
-- Displays complete reporting chains starting from
-- employees who have no manager.
-- =====================================================
WITH RECURSIVE Reporting_Chain AS (
    -- Anchor: top-level managers
    SELECT
        Emp_ID,
        Emp_Name,
        Manager_ID,
        Dept_ID,
        0 AS Hierarchy_Level,
        CAST(Emp_Name AS CHAR(1000)) AS Reporting_Path
    FROM Employee
    WHERE Manager_ID IS NULL

    UNION ALL

    -- Recursive step: find direct reports
    SELECT
        e.Emp_ID,
        e.Emp_Name,
        e.Manager_ID,
        e.Dept_ID,
        rc.Hierarchy_Level + 1,
        CAST(
            CONCAT(rc.Reporting_Path, ' -> ', e.Emp_Name)
            AS CHAR(1000)
        ) AS Reporting_Path
    FROM Employee e
    INNER JOIN Reporting_Chain rc
        ON e.Manager_ID = rc.Emp_ID
)
SELECT
    Emp_ID,
    Emp_Name,
    Manager_ID,
    Dept_ID,
    Hierarchy_Level,
    Reporting_Path
FROM Reporting_Chain
ORDER BY Dept_ID, Reporting_Path;

-- =====================================================
-- 7. DISPLAY HIERARCHY FOR A SINGLE DEPARTMENT
-- =====================================================
WITH RECURSIVE Department_Hierarchy AS (
    SELECT
        Emp_ID,
        Emp_Name,
        Manager_ID,
        Dept_ID,
        0 AS Hierarchy_Level
    FROM Employee
    WHERE Manager_ID IS NULL
      AND Dept_ID = 1

    UNION ALL

    SELECT
        e.Emp_ID,
        e.Emp_Name,
        e.Manager_ID,
        e.Dept_ID,
        dh.Hierarchy_Level + 1
    FROM Employee e
    INNER JOIN Department_Hierarchy dh
        ON e.Manager_ID = dh.Emp_ID
)
SELECT *
FROM Department_Hierarchy
ORDER BY Hierarchy_Level, Emp_ID;

-- =====================================================
-- 8. VIEW METADATA
-- =====================================================
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- =====================================================
-- 9. FINAL VERIFICATION
-- =====================================================
SELECT COUNT(*) AS Total_Employees FROM Employee;
SELECT COUNT(*) AS Total_Departments FROM Department;
SELECT COUNT(*) AS Total_Projects FROM Project;

SELECT * FROM Department_Salary_Summary;
```