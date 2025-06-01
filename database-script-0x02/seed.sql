-- ALX Airbnb Sample Data Population


-- Insert sample users (hosts, guests, admin)
INSERT INTO "user" (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Doe', 'john.doe@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567890', 'host'),
('550e8400-e29b-41d4-a716-446655440002', 'Jane', 'Smith', 'jane.smith@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567891', 'guest'),
('550e8400-e29b-41d4-a716-446655440003', 'Alice', 'Johnson', 'alice.johnson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567892', 'host'),
('550e8400-e29b-41d4-a716-446655440004', 'Bob', 'Wilson', 'bob.wilson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567893', 'guest'),
('550e8400-e29b-41d4-a716-446655440005', 'Admin', 'User', 'admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567894', 'admin'),
('550e8400-e29b-41d4-a716-446655440006', 'Emma', 'Davis', 'emma.davis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567895', 'guest'),
('550e8400-e29b-41d4-a716-446655440007', 'Michael', 'Brown', 'michael.brown@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lewdBkedUlP/1Qd.2', '+1234567896', 'host');

-- Insert sample locations
INSERT INTO location (location_id, street_address, city, state, postal_code, country, latitude, longitude) VALUES
('660e8400-e29b-41d4-a716-446655440001', '123 Ocean Drive', 'Miami', 'Florida', '33139', 'USA', 25.7617, -80.1918),
('660e8400-e29b-41d4-a716-446655440002', '456 Broadway', 'New York', 'New York', '10013', 'USA', 40.7128, -74.0060),
('660e8400-e29b-41d4-a716-446655440003', '789 Golden Gate Ave', 'San Francisco', 'California', '94102', 'USA', 37.7749, -122.4194),
('660e8400-e29b-41d4-a716-446655440004', '321 Sunset Blvd', 'Los Angeles', 'California', '90028', 'USA', 34.0522, -118.2437),
('660e8400-e29b-41d4-a716-446655440005', '654 Lake Shore Dr', 'Chicago', 'Illinois', '60611', 'USA', 41.8781, -87.6298);

-- Insert sample properties
INSERT INTO property (property_id, host_id, location_id, name, description, price_per_night) VALUES
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Beachfront Condo', 'Beautiful oceanview condo with direct beach access', 200.00),
('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', 'Manhattan Loft', 'Modern loft in the heart of NYC', 300.00),
('770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', 'Victorian House', 'Charming Victorian home near Golden Gate Park', 250.00),
('770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440004', 'Hollywood Hills Villa', 'Luxury villa with city views', 400.00),
('770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440005', 'Downtown Apartment', 'Modern apartment in downtown Chicago', 150.00);

-- Insert property amenities (many-to-many relationships)
INSERT INTO property_amenity (property_id, amenity_id) VALUES
-- Beachfront Condo amenities
('770e8400-e29b-41d4-a716-446655440001', (SELECT amenity_id FROM amenity WHERE name = 'WiFi')),
('770e8400-e29b-41d4-a716-446655440001', (SELECT amenity_id FROM amenity WHERE name = 'Pool')),
('770e8400-e29b-41d4-a716-446655440001', (SELECT amenity_id FROM amenity WHERE name = 'Air Conditioning')),
-- Manhattan Loft amenities
('770e8400-e29b-41d4-a716-446655440002', (SELECT amenity_id FROM amenity WHERE name = 'WiFi')),
('770e8400-e29b-41d4-a716-446655440002', (SELECT amenity_id FROM amenity WHERE name = 'Kitchen')),
('770e8400-e29b-41d4-a716-446655440002', (SELECT amenity_id FROM amenity WHERE name = 'Gym')),
-- Victorian House amenities
('770e8400-e29b-41d4-a716-446655440003', (SELECT amenity_id FROM amenity WHERE name = 'WiFi')),
('770e8400-e29b-41d4-a716-446655440003', (SELECT amenity_id FROM amenity WHERE name = 'Kitchen')),
('770e8400-e29b-41d4-a716-446655440003', (SELECT amenity_id FROM amenity WHERE name = 'Parking')),
('770e8400-e29b-41d4-a716-446655440003', (SELECT amenity_id FROM amenity WHERE name = 'Pet Friendly')),
-- Hollywood Hills Villa amenities
('770e8400-e29b-41d4-a716-446655440004', (SELECT amenity_id FROM amenity WHERE name = 'WiFi')),
('770e8400-e29b-41d4-a716-446655440004', (SELECT amenity_id FROM amenity WHERE name = 'Pool')),
('770e8400-e29b-41d4-a716-446655440004', (SELECT amenity_id FROM amenity WHERE name = 'Hot Tub')),
('770e8400-e29b-41d4-a716-446655440004', (SELECT amenity_id FROM amenity WHERE name = 'Air Conditioning')),
-- Downtown Apartment amenities
('770e8400-e29b-41d4-a716-446655440005', (SELECT amenity_id FROM amenity WHERE name = 'WiFi')),
('770e8400-e29b-41d4-a716-446655440005', (SELECT amenity_id FROM amenity WHERE name = 'Kitchen')),
('770e8400-e29b-41d4-a716-446655440005', (SELECT amenity_id FROM amenity WHERE name = 'Gym'));

-- Insert sample bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '2024-07-15', '2024-07-20', 1000.00, 'confirmed'),
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', '2024-08-01', '2024-08-05', 1200.00, 'confirmed'),
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', '2024-09-10', '2024-09-14', 1000.00, 'pending'),
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', '2024-10-05', '2024-10-08', 1200.00, 'canceled'),
('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', '2024-11-01', '2024-11-04', 450.00, 'confirmed');

-- Insert sample payments
INSERT INTO payment (payment_id, booking_id, amount, payment_method) VALUES
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 1000.00, 'credit_card'),
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 1200.00, 'stripe'),
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440005', 450.00, 'paypal');

-- Insert sample reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 5, 'Amazing beachfront location! Clean and comfortable.'),
('aa0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', 4, 'Great location in Manhattan, but a bit noisy at night.'),
('aa0e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', 4, 'Nice apartment, close to everything in downtown Chicago.');

-- Insert sample messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body) VALUES
('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Hi! Is the property available for check-in at 3 PM?'),
('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'Yes, 3 PM check-in works perfectly. Looking forward to hosting you!'),
('bb0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 'Thank you for the wonderful stay! The Victorian house was perfect.'),
('bb0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440007', 'Hello, do you allow pets at the Victorian House?'),
('bb0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440006', 'Yes, we are pet-friendly! Please let me know what type of pet you have.');

-- Verification queries (optional - run these to check data)
/*
SELECT 'Users' as table_name, COUNT(*) as count FROM "user"
UNION ALL
SELECT 'Locations', COUNT(*) FROM location
UNION ALL
SELECT 'Properties', COUNT(*) FROM property
UNION ALL
SELECT 'Bookings', COUNT(*) FROM booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM payment
UNION ALL
SELECT 'Reviews', COUNT(*) FROM review
UNION ALL
SELECT 'Messages', COUNT(*) FROM message;
*/