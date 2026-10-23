CREATE DATABASE IF NOT EXISTS query_optimization_exp10;
USE query_optimization_exp10;

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    sale_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL
) ENGINE = InnoDB;


-- =========================================================
-- PART A: GENERATE 10,000 RECORDS
-- =========================================================

DROP PROCEDURE IF EXISTS GenerateSalesData;

DELIMITER //

CREATE PROCEDURE GenerateSalesData()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 10000 DO
        INSERT INTO Sales VALUES (
            i,
            MOD(i, 1000) + 1,
            CONCAT('Customer_', MOD(i, 1000) + 1),
            CONCAT('Product_', MOD(i, 100) + 1),
            ELT(MOD(i, 5) + 1,
                'Electronics', 'Clothing', 'Books',
                'Furniture', 'Sports'),
            ELT(MOD(i, 4) + 1,
                'North', 'South', 'East', 'West'),
            MOD(i, 10) + 1,
            100 + MOD(i * 37, 5000),
            DATE_ADD('2024-01-01', INTERVAL MOD(i, 730) DAY),
            ELT(MOD(i, 3) + 1,
                'Completed', 'Pending', 'Cancelled')
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL GenerateSalesData();

SELECT COUNT(*) AS total_records FROM Sales;
SELECT * FROM Sales LIMIT 10;

-- Query 1: Filter by region and status
EXPLAIN
SELECT *
FROM Sales
WHERE region = 'North'
  AND status = 'Completed';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE region = 'North'
  AND status = 'Completed';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q1_before_microseconds;


-- Query 2: Filter by date range
EXPLAIN
SELECT *
FROM Sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-06-30';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-06-30';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q2_before_microseconds;


-- Query 3: Filter by category and region
EXPLAIN
SELECT *
FROM Sales
WHERE category = 'Electronics'
  AND region = 'West';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE category = 'Electronics'
  AND region = 'West';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q3_before_microseconds;


-- Query 4: Aggregation by region
EXPLAIN
SELECT region, SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE region,
       SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q4_before_microseconds;


-- Query 5: Customer sales aggregation with HAVING
EXPLAIN
SELECT customer_id,
       SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE customer_id,
       SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q5_before_microseconds;


-- =========================================================
-- PART C: OPTIMIZE USING INDEXING
-- =========================================================

CREATE INDEX idx_region_status
ON Sales(region, status);

CREATE INDEX idx_sale_date
ON Sales(sale_date);

CREATE INDEX idx_category_region
ON Sales(category, region);

CREATE INDEX idx_region
ON Sales(region);

CREATE INDEX idx_customer_id
ON Sales(customer_id);

ANALYZE TABLE Sales;


-- =========================================================
-- PART D: RECHECK EXECUTION PLANS
-- =========================================================

EXPLAIN
SELECT *
FROM Sales
WHERE region = 'North'
  AND status = 'Completed';

EXPLAIN
SELECT *
FROM Sales
WHERE sale_date >= '2025-01-01'
  AND sale_date < '2025-07-01';

EXPLAIN
SELECT *
FROM Sales
WHERE category = 'Electronics'
  AND region = 'West';

EXPLAIN
SELECT region, SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

EXPLAIN
SELECT customer_id,
       SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;


-- =========================================================
-- PART E: FIVE QUERIES AFTER OPTIMIZATION
-- =========================================================

-- Query 1: Composite index on region and status
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE region = 'North'
  AND status = 'Completed';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q1_after_microseconds;


-- Query 2: SARGable date range
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE sale_date >= '2025-01-01'
  AND sale_date < '2025-07-01';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q2_after_microseconds;


-- Query 3: Composite index on category and region
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE category = 'Electronics'
  AND region = 'West';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q3_after_microseconds;


-- Query 4: Index-assisted grouping may be possible
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE region,
       SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q4_after_microseconds;


-- Query 5: Index on customer_id can help grouping
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE customer_id,
       SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
    AS q5_after_microseconds;


-- =========================================================
-- PART F: QUERY REWRITING EXAMPLE
-- =========================================================

-- Original form: function applied to the indexed date column
-- (This expression cannot use a normal sale_date range scan
-- efficiently.)
EXPLAIN
SELECT COUNT(*)
FROM Sales
WHERE YEAR(sale_date) = 2025;

-- Optimized form: range condition on sale_date
EXPLAIN
SELECT COUNT(*)
FROM Sales
WHERE sale_date >= '2025-01-01'
  AND sale_date < '2026-01-01';


-- =========================================================
-- PART G: FINAL VERIFICATION
-- =========================================================

SHOW INDEX FROM Sales;

SELECT COUNT(*) AS total_sales_records FROM Sales;

SELECT
    region,
    COUNT(*) AS number_of_sales,
    SUM(quantity * unit_price) AS revenue
FROM Sales
GROUP BY region
ORDER BY revenue DESC;

-- MySQL 8.0.18+: actual execution plan and timing
EXPLAIN ANALYZE
SELECT *
FROM Sales
WHERE region = 'North'
  AND status = 'Completed';