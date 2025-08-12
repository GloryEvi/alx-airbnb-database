-- Database Indexing Strategy for AirBnB Database
-- High-usage columns identified for indexing based on common query patterns

-- PERFORMANCE MEASUREMENT: Test queries BEFORE adding indexes
-- These EXPLAIN ANALYZE statements measure baseline performance

-- Test query 1: Property search by location and price
EXPLAIN ANALYZE
SELECT * FROM Property 
WHERE location = 'New York' AND price_per_night BETWEEN 100 AND 300;

-- Test query 2: User bookings with date range
EXPLAIN ANALYZE
SELECT b.*, p.name FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 1 AND b.start_date >= '2024-01-01';

-- Test query 3: Property reviews with ratings
EXPLAIN ANALYZE
SELECT p.name, r.rating, r.comment FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location = 'California' AND r.rating >= 4;

-- USER TABLE INDEXES
-- Email is already unique (has implicit index), but adding explicit index for login queries
CREATE INDEX idx_user_email ON User(email);

-- Role-based queries for filtering users by type (guest, host, admin)
CREATE INDEX idx_user_role ON User(role);

-- Date-based queries for user registration analysis
CREATE INDEX idx_user_created_at ON User(created_at);

-- PROPERTY TABLE INDEXES
-- Host lookup - frequently used in JOIN operations
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Location-based searches - high frequency filter
CREATE INDEX idx_property_location ON Property(location);

-- Price range filtering - common in property searches
CREATE INDEX idx_property_price_per_night ON Property(price_per_night);

-- Composite index for location and price filtering (common search pattern)
CREATE INDEX idx_property_location_price ON Property(location, price_per_night);

-- Date-based queries for property listings
CREATE INDEX idx_property_created_at ON Property(created_at);

-- BOOKING TABLE INDEXES
-- User bookings lookup - frequently used in JOINs
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Property bookings lookup - frequently used in JOINs
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Status filtering - common for booking management
CREATE INDEX idx_booking_status ON Booking(status);

-- Date range queries - critical for availability checking
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for date range queries (availability checking)
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Date-based booking analysis
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- REVIEW TABLE INDEXES
-- Property reviews lookup - frequently used in JOINs
CREATE INDEX idx_review_property_id ON Review(property_id);

-- User reviews lookup
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Rating-based filtering and sorting
CREATE INDEX idx_review_rating ON Review(rating);

-- Composite index for property rating analysis
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Date-based review analysis
CREATE INDEX idx_review_created_at ON Review(created_at);

-- PAYMENT TABLE INDEXES
-- Booking payment lookup - frequently used in JOINs
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Payment method analysis
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Date-based payment analysis
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- MESSAGE TABLE INDEXES
-- Sender message lookup
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Recipient message lookup
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Message timestamp for chronological ordering
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- PERFORMANCE MEASUREMENT: Test the same queries AFTER adding indexes
-- These EXPLAIN ANALYZE statements measure improved performance

-- Test query 1: Property search by location and price (should use idx_property_location_price)
EXPLAIN ANALYZE
SELECT * FROM Property 
WHERE location = 'New York' AND price_per_night BETWEEN 100 AND 300;

-- Test query 2: User bookings with date range (should use idx_booking_user_id and idx_booking_start_date)
EXPLAIN ANALYZE
SELECT b.*, p.name FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 1 AND b.start_date >= '2024-01-01';

-- Test query 3: Property reviews with ratings (should use idx_property_location and idx_review_property_rating)
EXPLAIN ANALYZE
SELECT p.name, r.rating, r.comment FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location = 'California' AND r.rating >= 4;

-- Additional performance test: Booking availability check
EXPLAIN ANALYZE
SELECT p.property_id, p.name FROM Property p
WHERE p.property_id NOT IN (
    SELECT DISTINCT b.property_id FROM Booking b
    WHERE b.start_date <= '2024-12-31' AND b.end_date >= '2024-12-01'
    AND b.status = 'confirmed'
);