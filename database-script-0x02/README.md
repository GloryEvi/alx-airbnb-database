# ALX Airbnb Sample Data (seed.sql)

This script populates the ALX Airbnb database with realistic sample data for testing and development purposes.

## 📋 Overview

The `seed.sql` file contains INSERT statements that populate all database tables with representative data that mimics real-world usage patterns of an Airbnb-like platform.

## 🎯 Purpose

- **Testing** - Provides data for application testing and validation
- **Development** - Enables developers to work with realistic datasets
- **Demo** - Sample data for presentations and demonstrations
- **Learning** - Examples of proper data relationships and constraints

## 📊 Sample Data Contents

### Users (7 records)
- **3 Hosts** - John Doe, Alice Johnson, Michael Brown
- **3 Guests** - Jane Smith, Bob Wilson, Emma Davis  
- **1 Admin** - System administrator account
- All users have encrypted passwords and valid contact information

### Locations (5 records)
- **Miami, FL** - Beachfront location with coordinates
- **New York, NY** - Manhattan urban setting
- **San Francisco, CA** - Golden Gate area
- **Los Angeles, CA** - Hollywood Hills
- **Chicago, IL** - Downtown location
- All locations include full addresses and GPS coordinates

### Properties (5 records)
- **Beachfront Condo** (Miami) - $200/night
- **Manhattan Loft** (NYC) - $300/night  
- **Victorian House** (San Francisco) - $250/night
- **Hollywood Hills Villa** (LA) - $400/night
- **Downtown Apartment** (Chicago) - $150/night

### Amenities & Assignments
Each property has realistic amenity combinations:
- **WiFi** - Available in all properties
- **Kitchen** - In residential-style properties
- **Pool** - In luxury properties (Beachfront, Villa)
- **Parking** - In suburban locations
- **Pet Friendly** - Victorian House
- **Gym Access** - Urban properties

### Bookings (5 records)
- **Confirmed** - 3 successful bookings with payments
- **Pending** - 1 awaiting confirmation
- **Canceled** - 1 canceled reservation
- Date ranges: July 2024 - November 2024

### Payments (3 records)
- **Credit Card** - $1,000 payment
- **Stripe** - $1,200 payment
- **PayPal** - $450 payment
- Only confirmed bookings have corresponding payments

### Reviews (3 records)
- **5-star** - Beachfront Condo (excellent experience)
- **4-star** - Manhattan Loft (good but noisy)
- **4-star** - Downtown Apartment (convenient location)

### Messages (5 records)
- Host-guest check-in coordination
- Post-stay thank you messages
- Pet inquiry conversations
- Realistic communication patterns

## 🚀 Usage

### Prerequisites
- Database schema must be created first (run `schema.sql`)
- PostgreSQL database with UUID extension enabled

### Installation
```bash
# Navigate to your project directory
cd /path/to/alx-airbnb-database

# Run the seed script
psql -d alx_airbnb -f seed.sql
```

### Alternative Method
```sql
-- Connect to your database and run:
\i seed.sql
```

## ✅ Verification

After running the seed script, verify the data was inserted correctly:

```sql
-- Check record counts
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
```

Expected output:
```
table_name | count
-----------|------
Users      |     7
Locations  |     5
Properties |     5
Bookings   |     5
Payments   |     3  
Reviews    |     3
Messages   |     5
```

## 🔍 Sample Queries

### View All Properties with Locations
```sql
SELECT p.name, p.price_per_night, l.city, l.state
FROM property p
JOIN location l ON p.location_id = l.location_id
ORDER BY p.price_per_night DESC;
```

### Check Property Amenities
```sql
SELECT p.name, a.name as amenity
FROM property p
JOIN property_amenity pa ON p.property_id = pa.property_id
JOIN amenity a ON pa.amenity_id = a.amenity_id
ORDER BY p.name, a.name;
```

### Booking Summary
```sql
SELECT u.first_name || ' ' || u.last_name as guest,
       p.name as property,
       b.start_date, b.end_date, b.status, b.total_price
FROM booking b
JOIN "user" u ON b.user_id = u.user_id
JOIN property p ON b.property_id = p.property_id
ORDER BY b.start_date;
```

## 🔧 Customization

### Adding More Sample Data

To add additional sample data, follow the same pattern:

```sql
-- Add new user
INSERT INTO "user" (first_name, last_name, email, password_hash, phone_number, role) VALUES
('New', 'User', 'new.user@email.com', '$2b$12$...', '+1234567899', 'guest');

-- Add new location
INSERT INTO location (street_address, city, state, postal_code, country, latitude, longitude) VALUES
('123 New Street', 'Boston', 'Massachusetts', '02101', 'USA', 42.3601, -71.0589);
```

### Modifying Existing Data

```sql
-- Update property price
UPDATE property 
SET price_per_night = 275.00 
WHERE name = 'Victorian House';

-- Add new amenity to property
INSERT INTO property_amenity (property_id, amenity_id)
SELECT p.property_id, a.amenity_id
FROM property p, amenity a
WHERE p.name = 'Beachfront Condo' AND a.name = 'Hot Tub';
```

## ⚠️ Important Notes

- **UUIDs** - All IDs are hardcoded UUIDs for consistency across environments
- **Passwords** - All passwords are bcrypt hashed (placeholder hashes in sample)
- **Relationships** - All foreign key relationships are properly maintained
- **Realistic Data** - Prices, dates, and locations reflect real-world scenarios
- **Clean Data** - No orphaned records or constraint violations

## 🧹 Cleanup

To remove all sample data (keep schema):

```sql
-- Delete in correct order to avoid FK constraint violations
DELETE FROM message;
DELETE FROM review;
DELETE FROM payment;
DELETE FROM booking;
DELETE FROM property_amenity;
DELETE FROM property;
DELETE FROM location;
DELETE FROM "user";
-- Amenity table can be kept as it contains standard amenities
```

## 📝 File Information

- **Filename**: `seed.sql`
- **Created**: June 1, 2025
- **Records**: 37 total across all tables
- **Dependencies**: Requires `schema.sql` to be run first
- **Compatibility**: PostgreSQL 12+

---

