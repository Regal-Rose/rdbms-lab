CREATE DATABASE IF NOT EXISTS employee_exp6;
USE employee_exp6;

DROP TRIGGER IF EXISTS trg_salary_insert_validation;
DROP TRIGGER IF EXISTS trg_salary_update_validation;
DROP TRIGGER IF EXISTS trg_salary_audit;

DROP PROCEDURE IF EXISTS transfer_employee;

DROP TABLE IF EXISTS Salary_Audit;
DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- =====================================================
-- 1. CREATE TABLES
-- =====================================================

CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    Dept_ID INT NOT NULL,
    FOREIGN KEY (Dept_ID)
        REFERENCES Department(Dept_ID)
);

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

-- =====================================================
-- 2. INSERT 5 DEPARTMENTS
-- =====================================================

INSERT INTO Department VALUES
(1, 'IT', 'Chandigarh'),
(2, 'HR', 'Delhi'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Bengaluru'),
(5, 'Research', 'Hyderabad');

-- =====================================================
-- 3. INSERT 8 PROJECTS
-- =====================================================

INSERT INTO Project VALUES
(101, 'AI Chatbot', 500000, 1),
(102, 'Website Development', 300000, 1),
(103, 'Recruitment Portal', 150000, 2),
(104, 'Payroll Automation', 200000, 3),
(105, 'Market Analysis', 250000, 4),
(106, 'Customer Analytics', 350000, 4),
(107, 'Machine Learning Model', 600000, 5),
(108, 'Research Database', 400000, 5);

-- =====================================================
-- 4. INSERT 30 EMPLOYEES
-- =====================================================

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

-- =====================================================
-- 5. INSERT EMPLOYEE-PROJECT ASSIGNMENTS
-- =====================================================

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
-- 6. CREATE SALARY AUDIT TABLE
-- =====================================================

CREATE TABLE Salary_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL,
    Old_Salary DECIMAL(10,2) NOT NULL,
    New_Salary DECIMAL(10,2) NOT NULL,
    Changed_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Emp_ID)
        REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE
);

-- =====================================================
-- 7. SALARY VALIDATION TRIGGERS
-- Salary must be greater than zero.
-- =====================================================

DELIMITER $$

CREATE TRIGGER trg_salary_insert_validation
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END$$

CREATE TRIGGER trg_salary_update_validation
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END$$

-- =====================================================
-- 8. SALARY AUDIT TRIGGER
-- Logs changes only when the salary actually changes.
-- =====================================================

CREATE TRIGGER trg_salary_audit
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Salary_Audit
            (Emp_ID, Old_Salary, New_Salary)
        VALUES
            (OLD.Emp_ID, OLD.Salary, NEW.Salary);
    END IF;
END$$

-- =====================================================
-- 9. STORED PROCEDURE: TRANSFER EMPLOYEE
-- Validates employee and department.
-- Rolls back and returns an error if validation fails.
-- =====================================================

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_employee_count INT DEFAULT 0;
    DECLARE v_department_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE Emp_ID = p_emp_id;

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transfer failed: employee does not exist';
    END IF;

    SELECT COUNT(*)
    INTO v_department_count
    FROM Department
    WHERE Dept_ID = p_new_dept_id;

    IF v_department_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transfer failed: department does not exist';
    END IF;

    UPDATE Employee
    SET Dept_ID = p_new_dept_id
    WHERE Emp_ID = p_emp_id;

    COMMIT;
END$$

DELIMITER ;

-- =====================================================
-- 10. TEST A SUCCESSFUL EMPLOYEE TRANSFER
-- Employee 6 moves from IT (1) to HR (2).
-- =====================================================

SELECT Emp_ID, Emp_Name, Dept_ID
FROM Employee
WHERE Emp_ID = 6;

CALL transfer_employee(6, 2);

SELECT Emp_ID, Emp_Name, Dept_ID
FROM Employee
WHERE Emp_ID = 6;

-- Restore the original department for subsequent tests.
CALL transfer_employee(6, 1);

-- =====================================================
-- 11. TEST SALARY UPDATE AND AUDIT LOGGING
-- =====================================================

UPDATE Employee
SET Salary = 67000
WHERE Emp_ID = 6;

SELECT *
FROM Salary_Audit
WHERE Emp_ID = 6
ORDER BY Audit_ID;

-- Restore the original salary; this creates another audit row.
UPDATE Employee
SET Salary = 65000
WHERE Emp_ID = 6;

-- =====================================================
-- 12. EDGE-CASE TESTS
-- Execute each invalid test separately.
-- They should return SQLSTATE 45000 errors.
-- =====================================================

-- Invalid employee ID:
-- CALL transfer_employee(999, 2);

-- Invalid department ID:
-- CALL transfer_employee(6, 999);

-- Zero salary rejected by BEFORE UPDATE trigger:
-- UPDATE Employee SET Salary = 0 WHERE Emp_ID = 6;

-- Negative salary rejected by BEFORE UPDATE trigger:
-- UPDATE Employee SET Salary = -5000 WHERE Emp_ID = 6;

-- Zero salary rejected by BEFORE INSERT trigger:
-- INSERT INTO Employee VALUES
-- (31, 'Test Employee', 'Male', 0, '2026-01-01', 1, NULL);

-- Negative salary rejected by BEFORE INSERT trigger:
-- INSERT INTO Employee VALUES
-- (32, 'Test Employee', 'Male', -1000, '2026-01-01', 1, NULL);

-- Valid transfer to the employee's existing department:
-- CALL transfer_employee(6, 1);

-- =====================================================
-- 13. VERIFY FINAL DATA
-- =====================================================

SELECT COUNT(*) AS Total_Employees
FROM Employee;

SELECT COUNT(*) AS Total_Departments
FROM Department;

SELECT COUNT(*) AS Total_Projects
FROM Project;

SELECT Emp_ID, Emp_Name, Salary, Dept_ID
FROM Employee
ORDER BY Emp_ID;

SELECT *
FROM Salary_Audit
ORDER BY Audit_ID;

-- Show stored procedure and trigger definitions.
SHOW CREATE PROCEDURE transfer_employee;
SHOW TRIGGERS;
```