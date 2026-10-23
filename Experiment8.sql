
-- =====================================================
-- PART A: DATABASE AND TABLE SETUP
-- =====================================================

CREATE DATABASE IF NOT EXISTS banking_exp8;
USE banking_exp8;

DROP TABLE IF EXISTS Accounts;

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    CHECK (balance >= 0)
) ENGINE = InnoDB;

INSERT INTO Accounts VALUES
(101, 'Aarav', 10000.00),
(102, 'Diya',   5000.00),
(103, 'Kabir',  8000.00);

SELECT * FROM Accounts;


-- =====================================================
-- PART B: TRANSACTION USING BEGIN AND COMMIT
-- Transfer Rs. 2000 from account 101 to account 102
-- =====================================================

START TRANSACTION;

UPDATE Accounts
SET balance = balance - 2000
WHERE account_id = 101
  AND balance >= 2000;

UPDATE Accounts
SET balance = balance + 2000
WHERE account_id = 102;

COMMIT;

SELECT * FROM Accounts;


-- =====================================================
-- PART C: TRANSACTION USING ROLLBACK
-- Both changes will be cancelled
-- =====================================================

START TRANSACTION;

UPDATE Accounts
SET balance = balance - 1000
WHERE account_id = 101;

UPDATE Accounts
SET balance = balance + 1000
WHERE account_id = 103;

ROLLBACK;

-- Balances remain unchanged from before Part C
SELECT * FROM Accounts;


-- =====================================================
-- PART D: SAVEPOINT AND PARTIAL FAILURE
-- First transfer succeeds; later work is rolled back
-- =====================================================

START TRANSACTION;

-- Successful transfer of Rs. 500
UPDATE Accounts
SET balance = balance - 500
WHERE account_id = 101
  AND balance >= 500;

UPDATE Accounts
SET balance = balance + 500
WHERE account_id = 102;

SAVEPOINT after_first_transfer;

-- Simulate a failed operation: insufficient funds.
-- This UPDATE affects zero rows.
UPDATE Accounts
SET balance = balance - 20000
WHERE account_id = 101
  AND balance >= 20000;

-- Undo work after the savepoint.
-- The first transfer is preserved.
ROLLBACK TO SAVEPOINT after_first_transfer;

COMMIT;

SELECT * FROM Accounts;


-- =====================================================
-- PART E: DEMONSTRATE ISOLATION LEVELS
-- Run each example as a separate transaction
-- =====================================================

-- 1. READ UNCOMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 2. READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 3. REPEATABLE READ (MySQL InnoDB default)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 4. SERIALIZABLE
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;


-- =====================================================
-- PART F: CONCURRENCY ANOMALIES USING TWO SESSIONS
-- IMPORTANT: Execute these manually in two connections.
-- Do not run all statements below in one session.
-- =====================================================

-- -----------------------------------------------------
-- TEST 1: DIRTY READ
-- -----------------------------------------------------

-- SESSION 1:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- START TRANSACTION;
-- UPDATE Accounts SET balance = 3000 WHERE account_id = 101;
-- Do NOT commit yet.

-- SESSION 2:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- START TRANSACTION;
-- SELECT balance FROM Accounts WHERE account_id = 101;
-- Session 2 may see the uncommitted value 3000.

-- SESSION 1:
-- ROLLBACK;

-- SESSION 2:
-- ROLLBACK;


-- -----------------------------------------------------
-- TEST 2: NON-REPEATABLE READ
-- -----------------------------------------------------

-- SESSION 1:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- SELECT balance FROM Accounts WHERE account_id = 102;
-- Keep the transaction open.

-- SESSION 2:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- UPDATE Accounts SET balance = balance + 100
-- WHERE account_id = 102;
-- COMMIT;

-- SESSION 1:
-- SELECT balance FROM Accounts WHERE account_id = 102;
-- The value may differ from the first read.
-- COMMIT;


-- -----------------------------------------------------
-- TEST 3: REPEATABLE READ PREVENTS NON-REPEATABLE READ
-- -----------------------------------------------------

-- SESSION 1:
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT balance FROM Accounts WHERE account_id = 103;
-- Keep the transaction open.

-- SESSION 2:
-- UPDATE Accounts SET balance = balance + 200
-- WHERE account_id = 103;
-- COMMIT;

-- SESSION 1:
-- SELECT balance FROM Accounts WHERE account_id = 103;
-- Ordinary consistent reads see the same snapshot.
-- COMMIT;


-- -----------------------------------------------------
-- TEST 4: LOST UPDATE FROM STALE APPLICATION DATA
-- -----------------------------------------------------

-- For a clean demonstration, first ensure account 102
-- has balance 7500, then execute the following in order.

-- SESSION 1:
-- START TRANSACTION;
-- SELECT balance FROM Accounts WHERE account_id = 102;
-- Assume the application reads 7500.
-- Keep the transaction open.

-- SESSION 2:
-- START TRANSACTION;
-- UPDATE Accounts SET balance = balance + 300
-- WHERE account_id = 102;
-- COMMIT;

-- SESSION 1:
-- UPDATE Accounts SET balance = 7500 - 100
-- WHERE account_id = 102;
-- COMMIT;

-- The stale absolute update overwrites Session 2's change.
-- This illustrates unsafe application-level update logic.


-- =====================================================
-- PART G: FINAL VERIFICATION
-- =====================================================

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT
    account_id,
    account_holder,
    balance
FROM Accounts
ORDER BY account_id;

