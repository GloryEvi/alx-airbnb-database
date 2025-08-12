-- Partitioning Implementation for Booking Table


-- Create backup of existing data
CREATE TABLE Booking_backup AS SELECT * FROM Booking;

--  Drop existing Booking table
DROP TABLE IF EXISTS Booking;

-- Create partitioned Booking table
-- Using RANGE partitioning based on start_date
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) 
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Alternative: Monthly partitioning for more granular control
-- Uncomment this section if monthly partitioning is preferred
/*
DROP TABLE IF EXISTS Booking;

CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) 
PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p202401 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p202402 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p202403 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p202404 VALUES LESS THAN (TO_DAYS('2024-05-01')),
    PARTITION p202405 VALUES LESS THAN (TO_DAYS('2024-06-01')),
    PARTITION p202406 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p202407 VALUES LESS THAN (TO_DAYS('2024-08-01')),
    PARTITION p202408 VALUES LESS THAN (TO_DAYS('2024-09-01')),
    PARTITION p202409 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p202410 VALUES LESS THAN (TO_DAYS('2024-11-01')),
    PARTITION p202411 VALUES LESS THAN (TO_DAYS('2024-12-01')),
    PARTITION p202412 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

--Restore data from backup
INSERT INTO Booking SELECT * FROM Booking_backup;

--Create indexes on partitioned table
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_end_date ON Booking(end_date);
CREATE INDEX idx_booking_created_at ON Booking(created_at);

--Create composite indexes for common query patterns
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);
CREATE INDEX idx_booking_user_dates ON Booking(user_id, start_date);
CREATE INDEX idx_booking_status_dates ON Booking(status, start_date);

--Performance testing queries

-- Query 1: Date range query (should benefit from partition pruning)
EXPLAIN PARTITIONS
SELECT 
    booking_id, 
    property_id, 
    user_id, 
    start_date, 
    end_date, 
    total_price, 
    status
FROM Booking
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND status = 'confirmed';

-- Query 2: Single partition query
EXPLAIN PARTITIONS
SELECT 
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM Booking
WHERE start_date >= '2024-06-01' 
  AND start_date < '2024-07-01';

-- Query 3: Multi-partition query
EXPLAIN PARTITIONS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name as property_name
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2024-03-01' AND '2024-09-30'
  AND b.status IN ('confirmed', 'pending')
ORDER BY b.start_date;

-- Query 4: Property availability check (cross-partition)
EXPLAIN PARTITIONS
SELECT p.property_id, p.name
FROM Property p
WHERE p.property_id NOT IN (
    SELECT DISTINCT b.property_id
    FROM Booking b
    WHERE b.start_date <= '2024-08-15' 
      AND b.end_date >= '2024-08-10'
      AND b.status = 'confirmed'
);

-- Performance comparison queries

-- Before partitioning (using backup table)
EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM Booking_backup 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';

-- After partitioning
EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM Booking 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';

-- Partition management queries

-- View partition information
SELECT 
    TABLE_NAME,
    PARTITION_NAME,
    PARTITION_ORDINAL_POSITION,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_NAME = 'Booking' 
  AND TABLE_SCHEMA = DATABASE()
ORDER BY PARTITION_ORDINAL_POSITION;

-- Add new partition for future dates
ALTER TABLE Booking 
ADD PARTITION (PARTITION p2027 VALUES LESS THAN (2028));

-- Drop old partition (for data archival)
-- ALTER TABLE Booking DROP PARTITION p2022;

-- Reorganize partition to split busy periods
-- ALTER TABLE Booking 
-- REORGANIZE PARTITION p2024 INTO (
--     PARTITION p2024_h1 VALUES LESS THAN (TO_DAYS('2024-07-01')),
--     PARTITION p2024_h2 VALUES LESS THAN (2025)
-- );

-- Query to analyze partition distribution
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH/1024/1024, 2) as DATA_SIZE_MB,
    ROUND(INDEX_LENGTH/1024/1024, 2) as INDEX_SIZE_MB
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_NAME = 'Booking' 
  AND TABLE_SCHEMA = DATABASE()
  AND PARTITION_NAME IS NOT NULL;

-- Cleanup backup table after verification
-- DROP TABLE Booking_backup;