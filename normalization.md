# Database Normalization Analysis

## Schema Review and 3NF Achievement

### Current Schema Analysis

#### User Entity
* **Primary Key**: user_id (UUID)
* **Attributes**: first_name, last_name, email, password_hash, phone_number, role, created_at
* **3NF Status**: ✅ Compliant - All attributes depend directly on primary key

#### Property Entity
* **Primary Key**: property_id (UUID)
* **Foreign Keys**: host_id (references User)
* **Attributes**: name, description, location, price_per_night, created_at, updated_at
* **3NF Status**: ✅ Compliant - All attributes depend directly on primary key

#### Booking Entity
* **Primary Key**: booking_id (UUID)
* **Foreign Keys**: property_id, user_id
* **Attributes**: start_date, end_date, total_price, status, created_at
* **3NF Status**: ✅ Compliant - total_price stored for historical pricing purposes

#### Payment Entity
* **Primary Key**: payment_id (UUID)
* **Foreign Keys**: booking_id (references Booking)
* **Attributes**: amount, payment_date, payment_method
* **3NF Status**: ✅ Compliant

#### Review Entity
* **Primary Key**: review_id (UUID)
* **Foreign Keys**: property_id, user_id
* **Attributes**: rating, comment, created_at
* **3NF Status**: ✅ Compliant

#### Message Entity
* **Primary Key**: message_id (UUID)
* **Foreign Keys**: sender_id, recipient_id (both reference User)
* **Attributes**: message_body, sent_at
* **3NF Status**: ✅ Compliant

## Identified Redundancies and Violations

### Location Data Redundancy
* **Issue**: Property stores location as single VARCHAR field
* **Problem**: Leads to data inconsistency and inefficient location-based searches
* **Solution**: Extract location data into separate entity

### Missing Property Features Structure
* **Issue**: No proper handling of property amenities/features
* **Problem**: Would require repeating groups if added directly to Property table
* **Solution**: Create normalized many-to-many relationship

## Normalization Steps to Achieve 3NF

### Step 1: Extract Location Entity

**Before:**
```sql
Property(property_id, host_id, name, description, location, price_per_night, created_at, updated_at)
```

**After:**
```sql
Property(property_id, host_id, name, description, location_id, price_per_night, created_at, updated_at)
Location(location_id, street_address, city, state, postal_code, country, latitude, longitude)
```

### Step 2: Add Property Amenities Structure

**New entities:**
```sql
Amenity(amenity_id, name, description)
PropertyAmenity(property_id, amenity_id)
```

## Final Normalized Schema (3NF Compliant)

```sql
User(user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)

Property(property_id, host_id, name, description, location_id, price_per_night, created_at, updated_at)
Location(location_id, street_address, city, state, postal_code, country, latitude, longitude)

Amenity(amenity_id, name, description)
PropertyAmenity(property_id, amenity_id)

Booking(booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
Payment(payment_id, booking_id, amount, payment_date, payment_method)
Review(review_id, property_id, user_id, rating, comment, created_at)
Message(message_id, sender_id, recipient_id, message_body, sent_at)
```

## 3NF Compliance Summary

* **1NF**: ✅ All tables have atomic values and no repeating groups
* **2NF**: ✅ All non-key attributes fully depend on primary keys
* **3NF**: ✅ No transitive dependencies - all non-key attributes depend only on primary keys

