-- Initial Query: Retrieve all bookings with user details, property details, and payment details
-- This query demonstrates potential performance issues before optimization

-- INITIAL QUERY (Before Optimization)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.price_per_night,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- PERFORMANCE ANALYSIS QUERY
-- Use this to analyze the initial query performance
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.price_per_night,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- OPTIMIZED QUERY (After Analysis and Refactoring)
-- Improvements:
-- 1. Reduced unnecessary columns in SELECT
-- 2. Added WHERE clause to limit result set
-- 3. Optimized JOIN order based on selectivity
-- 4. Added LIMIT for pagination

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    -- Essential user details only
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.name AS property_name,
    p.location,
    p.price_per_night,
    
    -- Host name only
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    -- Payment details
    pay.amount AS payment_amount,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status IN ('confirmed', 'pending')
  AND b.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
ORDER BY b.created_at DESC
LIMIT 100;

-- PERFORMANCE ANALYSIS FOR OPTIMIZED QUERY
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    -- Essential user details only
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.name AS property_name,
    p.location,
    p.price_per_night,
    
    -- Host name only
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    -- Payment details
    pay.amount AS payment_amount,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status IN ('confirmed', 'pending')
  AND b.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
ORDER BY b.created_at DESC
LIMIT 100;

-- ALTERNATIVE OPTIMIZED QUERY WITH CONDITIONAL JOINS
-- Further optimization for cases where payment details are optional
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    p.name AS property_name,
    p.location,
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    CASE 
        WHEN pay.payment_id IS NOT NULL 
        THEN CONCAT('$', pay.amount, ' via ', pay.payment_method)
        ELSE 'Payment Pending'
    END AS payment_info
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status IN ('confirmed', 'pending')
  AND b.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
ORDER BY b.created_at DESC
LIMIT 50;