-- ALX Airbnb Database Schema (3NF Normalized)



-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create User table
CREATE TABLE "user" (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(10) NOT NULL CHECK (role IN ('guest', 'host', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster authentication
CREATE INDEX idx_user_email ON "user" (email);
CREATE INDEX idx_user_role ON "user" (role);

-- Create Location table (3NF normalization - extracted from Property)
CREATE TABLE location (
    location_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for location-based searches
CREATE INDEX idx_location_city ON location (city);
CREATE INDEX idx_location_country ON location (country);
CREATE INDEX idx_location_coordinates ON location (latitude, longitude);

-- Create Amenity table (3NF normalization - for standardized amenities)
CREATE TABLE amenity (
    amenity_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on amenity name for faster searches
CREATE INDEX idx_amenity_name ON amenity (name);

-- Create Property table (modified for 3NF compliance)
CREATE TABLE property (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    location_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL CHECK (price_per_night > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES "user" (user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES location (location_id) ON DELETE RESTRICT
);

-- Create indexes for property searches
CREATE INDEX idx_property_host_id ON property (host_id);
CREATE INDEX idx_property_location_id ON property (location_id);
CREATE INDEX idx_property_price ON property (price_per_night);

-- Create PropertyAmenity junction table (3NF normalization - many-to-many relationship)
CREATE TABLE property_amenity (
    property_id UUID NOT NULL,
    amenity_id UUID NOT NULL,
    PRIMARY KEY (property_id, amenity_id),
    FOREIGN KEY (property_id) REFERENCES property (property_id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenity (amenity_id) ON DELETE CASCADE
);

-- Create indexes for amenity searches
CREATE INDEX idx_property_amenity_property_id ON property_amenity (property_id);
CREATE INDEX idx_property_amenity_amenity_id ON property_amenity (amenity_id);

-- Create Booking table
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES property (property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE,
    CHECK (end_date > start_date)
);

-- Create indexes for booking queries
CREATE INDEX idx_booking_property_id ON booking (property_id);
CREATE INDEX idx_booking_user_id ON booking (user_id);
CREATE INDEX idx_booking_dates ON booking (start_date, end_date);
CREATE INDEX idx_booking_status ON booking (status);

-- Create Payment table
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')),
    FOREIGN KEY (booking_id) REFERENCES booking (booking_id) ON DELETE CASCADE
);

-- Create index for payment lookups
CREATE INDEX idx_payment_booking_id ON payment (booking_id);
CREATE INDEX idx_payment_date ON payment (payment_date);

-- Create Review table
CREATE TABLE review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES property (property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE
);

-- Create indexes for review queries
CREATE INDEX idx_review_property_id ON review (property_id);
CREATE INDEX idx_review_user_id ON review (user_id);
CREATE INDEX idx_review_rating ON review (rating);

-- Create Message table
CREATE TABLE message (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES "user" (user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES "user" (user_id) ON DELETE CASCADE
);

-- Create indexes for message queries
CREATE INDEX idx_message_sender_id ON message (sender_id);
CREATE INDEX idx_message_recipient_id ON message (recipient_id);
CREATE INDEX idx_message_sent_at ON message (sent_at);

-- Create trigger function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for Property table to update the updated_at timestamp
CREATE TRIGGER update_property_timestamp
BEFORE UPDATE ON property
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

-- Insert sample amenities for testing
INSERT INTO amenity (name, description) VALUES
('WiFi', 'Wireless internet access'),
('Pool', 'Swimming pool available'),
('Parking', 'Free parking space'),
('Kitchen', 'Full kitchen facilities'),
('Air Conditioning', 'Climate control system'),
('Pet Friendly', 'Pets are welcome'),
('Gym', 'Fitness center access'),
('Hot Tub', 'Private or shared hot tub');

-- Comments for 3NF Compliance:
-- 1. Location data extracted from Property table to eliminate redundancy
-- 2. Amenity data normalized to prevent repeating groups
-- 3. PropertyAmenity junction table implements proper many-to-many relationship
-- 4. All tables satisfy 3NF: no transitive dependencies, all non-key attributes depend only on primary keys