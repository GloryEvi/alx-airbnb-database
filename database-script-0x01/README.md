# ALX Airbnb Database Schema

A comprehensive PostgreSQL database schema for an Airbnb-like rental platform, designed following Third Normal Form (3NF) principles for optimal data integrity and performance.

## Overview

This database schema supports a full-featured airbnb platform with user management, property listings, bookings, payments, reviews, and messaging capabilities. The schema is normalized to 3NF to eliminate data redundancy and ensure consistency.

## Database Requirements

- **PostgreSQL** (version 9.5 or higher)
- **uuid-ossp extension** for UUID generation

## Quick Setup

```sql
-- Run the schema.sql file in your PostgreSQL database
psql -U your_username -d your_database -f schema.sql
```

## Database Structure

### Core Tables

#### Users (`user`)
Stores all platform users including guests, hosts, and administrators.
- **Primary Key**: `user_id` (UUID)
- **Unique Constraints**: `email`
- **Check Constraints**: `role` must be 'guest', 'host', or 'admin'
- **Indexes**: Email and role for authentication and authorization queries

#### Properties (`property`)
Contains rental property listings with references to location and host information.
- **Primary Key**: `property_id` (UUID)
- **Foreign Keys**: `host_id` → user, `location_id` → location
- **Check Constraints**: `price_per_night` must be positive
- **Features**: Auto-updating timestamp trigger

#### Locations (`location`)
Normalized location data extracted from properties to eliminate redundancy.
- **Primary Key**: `location_id` (UUID)
- **Features**: Supports geospatial coordinates for mapping
- **Indexes**: Optimized for city, country, and coordinate-based searches

#### Amenities (`amenity`)
Standardized amenity definitions to ensure consistency.
- **Primary Key**: `amenity_id` (UUID)
- **Unique Constraints**: `name`
- **Pre-populated**: Common amenities like WiFi, Pool, Parking, etc.

### Relationship Tables

#### Property-Amenity Junction (`property_amenity`)
Implements many-to-many relationship between properties and amenities.
- **Composite Primary Key**: `(property_id, amenity_id)`
- **Purpose**: Allows properties to have multiple amenities without data duplication

### Transaction Tables

#### Bookings (`booking`)
Manages reservation data with comprehensive validation.
- **Primary Key**: `booking_id` (UUID)
- **Foreign Keys**: `property_id` → property, `user_id` → user
- **Check Constraints**: 
  - `end_date` must be after `start_date`
  - `total_price` must be non-negative
  - `status` must be 'pending', 'confirmed', or 'canceled'

#### Payments (`payment`)
Tracks payment transactions linked to bookings.
- **Primary Key**: `payment_id` (UUID)
- **Foreign Key**: `booking_id` → booking
- **Check Constraints**: `amount` must be positive
- **Supported Methods**: credit_card, paypal, stripe

#### Reviews (`review`)
User reviews and ratings for properties.
- **Primary Key**: `review_id` (UUID)
- **Foreign Keys**: `property_id` → property, `user_id` → user
- **Check Constraints**: `rating` must be between 1 and 5

#### Messages (`message`)
Direct messaging system between users.
- **Primary Key**: `message_id` (UUID)
- **Foreign Keys**: `sender_id` → user, `recipient_id` → user

## Key Features

### 3NF Normalization Benefits
1. **Location Normalization**: Prevents duplicate address data across properties
2. **Amenity Standardization**: Ensures consistent amenity naming and descriptions
3. **Junction Tables**: Proper many-to-many relationships without data redundancy
4. **No Transitive Dependencies**: All non-key attributes depend directly on primary keys

### Performance Optimizations
- **Strategic Indexing**: Indexes on frequently queried columns (email, location, price, dates)
- **Composite Indexes**: Multi-column indexes for complex search patterns
- **UUID Primary Keys**: Distributed-friendly identifiers for scalability

### Data Integrity
- **Referential Integrity**: Comprehensive foreign key constraints
- **Check Constraints**: Business rule enforcement at database level
- **Cascade Rules**: Proper cleanup when parent records are deleted

## Common Queries

### Find Available Properties
```sql
SELECT p.name, p.price_per_night, l.city, l.country
FROM property p
JOIN location l ON p.location_id = l.location_id
WHERE p.property_id NOT IN (
    SELECT property_id FROM booking 
    WHERE status = 'confirmed' 
    AND start_date <= '2024-07-15' 
    AND end_date >= '2024-07-10'
);
```

### Properties with Specific Amenities
```sql
SELECT p.name, array_agg(a.name) as amenities
FROM property p
JOIN property_amenity pa ON p.property_id = pa.property_id
JOIN amenity a ON pa.amenity_id = a.amenity_id
WHERE a.name IN ('WiFi', 'Pool')
GROUP BY p.property_id, p.name
HAVING count(*) = 2;
```

### User Booking History
```sql
SELECT b.booking_id, p.name, b.start_date, b.end_date, b.total_price, b.status
FROM booking b
JOIN property p ON b.property_id = p.property_id
WHERE b.user_id = 'user-uuid-here'
ORDER BY b.created_at DESC;
```

## Sample Data

The schema includes sample amenity data:
- WiFi, Pool, Parking, Kitchen
- Air Conditioning, Pet Friendly, Gym, Hot Tub

## Triggers and Functions

### Auto-Update Timestamp
- **Function**: `update_timestamp()`
- **Trigger**: Automatically updates `updated_at` field in the property table
- **Language**: PL/pgSQL

## Migration Notes

When deploying this schema:
1. Ensure PostgreSQL version compatibility
2. Install uuid-ossp extension before running schema
3. Consider adding additional indexes based on query patterns
4. Review cascade rules for your specific use case
5. Plan for data migration if upgrading from existing schema

## Security Considerations

- Password hashes should use strong hashing algorithms (bcrypt recommended)
- Implement proper access controls at application level
- Consider row-level security for multi-tenant scenarios
- Regular backup strategy for user and transaction data

## Contributing

When modifying this schema:
1. Maintain 3NF compliance
2. Add appropriate indexes for new query patterns
3. Include check constraints for data validation
4. Update this README with changes
5. Test migration scripts thoroughly