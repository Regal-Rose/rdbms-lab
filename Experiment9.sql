
CREATE DATABASE IF NOT EXISTS railway_exp9;
USE railway_exp9;

DROP TABLE IF EXISTS Railway_Booking;
DROP PROCEDURE IF EXISTS GenerateBookings;

-- =========================================================
-- PART A: CREATE RAILWAY BOOKING TABLE
-- =========================================================

CREATE TABLE Railway_Booking (
    booking_id INT PRIMARY KEY,
    passenger_name VARCHAR(100) NOT NULL,
    train_no INT NOT NULL,
    source_station VARCHAR(50) NOT NULL,
    destination_station VARCHAR(50) NOT NULL,
    journey_date DATE NOT NULL,
    booking_status VARCHAR(20) NOT NULL,
    class_type VARCHAR(20) NOT NULL,
    fare DECIMAL(10,2) NOT NULL
) ENGINE = InnoDB;


-- =========================================================
-- PART B: GENERATE 5,000 RECORDS
-- =========================================================

DELIMITER //

CREATE PROCEDURE GenerateBookings()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 5000 DO
        INSERT INTO Railway_Booking (
            booking_id,
            passenger_name,
            train_no,
            source_station,
            destination_station,
            journey_date,
            booking_status,
            class_type,
            fare
        )
        VALUES (
            i,
            CONCAT('Passenger_', i),
            12000 + MOD(i, 100),
            ELT(
                MOD(i, 5) + 1,
                'Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Lucknow'
            ),
            ELT(
                MOD(i + 2, 5) + 1,
                'Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Lucknow'
            ),
            DATE_ADD(
                '2026-01-01',
                INTERVAL MOD(i, 365) DAY
            ),
            ELT(
                MOD(i, 3) + 1,
                'Confirmed', 'Waiting', 'Cancelled'
            ),
            ELT(
                MOD(i, 3) + 1,
                'Sleeper', '3AC', '2AC'
            ),
            300 + MOD(i * 37, 2500)
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL GenerateBookings();

SELECT COUNT(*) AS total_records
FROM Railway_Booking;

SELECT *
FROM Railway_Booking
LIMIT 10;


-- =========================================================
-- PART C: BENCHMARK BEFORE INDEXING
-- =========================================================

-- The primary key index on booking_id already exists.
-- The following queries use columns without indexes.

-- Query 1: Search by train number
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025;

-- Query 2: Search by source and journey date
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';

-- Query 3: Search by train, date, and status
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';


-- Measure execution time for Query 1
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025;

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query1_time_microseconds;


-- Measure execution time for Query 2
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query2_time_microseconds;


-- Measure execution time for Query 3
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query3_time_microseconds;


-- =========================================================
-- PART D: CREATE SINGLE-COLUMN INDEXES
-- =========================================================

CREATE INDEX idx_train_no
ON Railway_Booking(train_no);

CREATE INDEX idx_source_station
ON Railway_Booking(source_station);

CREATE INDEX idx_journey_date
ON Railway_Booking(journey_date);

-- Refresh optimizer statistics
ANALYZE TABLE Railway_Booking;


-- =========================================================
-- PART E: BENCHMARK AFTER SINGLE-COLUMN INDEXES
-- =========================================================

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025;

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';


-- Query 1 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025;

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query1_single_index_time_microseconds;


-- Query 2 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query2_single_index_time_microseconds;


-- Query 3 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query3_single_index_time_microseconds;


-- =========================================================
-- PART F: CREATE COMPOSITE INDEXES
-- =========================================================

CREATE INDEX idx_source_date
ON Railway_Booking(source_station, journey_date);

CREATE INDEX idx_train_date_status
ON Railway_Booking(train_no, journey_date, booking_status);

ANALYZE TABLE Railway_Booking;


-- =========================================================
-- PART G: BENCHMARK AFTER COMPOSITE INDEXES
-- =========================================================

-- Query 1: Single-column index on train_no can be used
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025;


-- Query 2: Composite index on source_station, journey_date
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';


-- Query 3: Composite index on train_no, journey_date, booking_status
EXPLAIN
SELECT *
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';


-- Query 1 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025;

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query1_composite_stage_time_microseconds;


-- Query 2 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE source_station = 'Delhi'
  AND journey_date = '2026-02-15';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query2_composite_stage_time_microseconds;


-- Query 3 timing
SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';

SELECT TIMESTAMPDIFF(
    MICROSECOND, @start_time, NOW(6)
) AS query3_composite_stage_time_microseconds;


-- =========================================================
-- PART H: DISPLAY INDEXES AND FINAL RECORD COUNT
-- =========================================================

SHOW INDEX FROM Railway_Booking;

SELECT COUNT(*) AS total_bookings
FROM Railway_Booking;

-- MySQL 8.0.18+: actual execution statistics
-- Run separately if supported:
EXPLAIN ANALYZE
SELECT *
FROM Railway_Booking
WHERE train_no = 12025
  AND journey_date = '2026-02-15'
  AND booking_status = 'Confirmed';

