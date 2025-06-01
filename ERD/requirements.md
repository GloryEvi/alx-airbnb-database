
# Requirements.md

## Project: AirBnB Clone – Database Specification

### Overview
This document outlines the database schema design for this AirBnB platform, covering entities, attributes, constraints, and indexing for essential functionalities such as user management, property listings, bookings, payments, reviews, and messaging.

---

## Entities and Attributes

### 1. **User**
- **user_id**: UUID, Primary Key, Indexed
- **first_name**: VARCHAR, NOT NULL
- **last_name**: VARCHAR, NOT NULL
- **email**: VARCHAR, UNIQUE, NOT NULL
- **password_hash**: VARCHAR, NOT NULL
- **phone_number**: VARCHAR, NULL
- **role**: ENUM(`guest`, `host`, `admin`), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 2. **Property**
- **property_id**: UUID, Primary Key, Indexed
- **host_id**: UUID, Foreign Key → `User(user_id)`
- **name**: VARCHAR, NOT NULL
- **description**: TEXT, NOT NULL
- **location**: VARCHAR, NOT NULL
- **pricepernight**: DECIMAL, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

### 3. **Booking**
- **booking_id**: UUID, Primary Key, Indexed
- **property_id**: UUID, Foreign Key → `Property(property_id)`
- **user_id**: UUID, Foreign Key → `User(user_id)`
- **start_date**: DATE, NOT NULL
- **end_date**: DATE, NOT NULL
- **total_price**: DECIMAL, NOT NULL
- **status**: ENUM(`pending`, `confirmed`, `canceled`), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 4. **Payment**
- **payment_id**: UUID, Primary Key, Indexed
- **booking_id**: UUID, Foreign Key → `Booking(booking_id)`
- **amount**: DECIMAL, NOT NULL
- **payment_date**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **payment_method**: ENUM(`credit_card`, `paypal`, `stripe`), NOT NULL

### 5. **Review**
- **review_id**: UUID, Primary Key, Indexed
- **property_id**: UUID, Foreign Key → `Property(property_id)`
- **user_id**: UUID, Foreign Key → `User(user_id)`
- **rating**: INTEGER, CHECK (`rating >= 1 AND rating <= 5`), NOT NULL
- **comment**: TEXT, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 6. **Message**
- **message_id**: UUID, Primary Key, Indexed
- **sender_id**: UUID, Foreign Key → `User(user_id)`
- **recipient_id**: UUID, Foreign Key → `User(user_id)`
- **message_body**: TEXT, NOT NULL
- **sent_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Relationship Descriptions
### User-Property Relationship
A User (with role 'host') can list many Properties.
A Property belongs to exactly one User (host).
Cardinality: One-to-Many (1)

### User-Booking Relationship
A User (with role 'guest') can make many Bookings.
A Booking is made by exactly one User.
Cardinality: One-to-Many (1)

### Property-Booking Relationship
A Property can have many Bookings.
A Booking is for exactly one Property.
Cardinality: One-to-Many (1)

### Booking-Payment Relationship
A Booking can have one or more Payments.
A Payment is associated with exactly one Booking.
Cardinality: One-to-Many (1)

### User-Review Relationship
A User can submit many Reviews.
A Review is written by exactly one User.
Cardinality: One-to-Many (1)

### Property-Review Relationship
A Property can have many Reviews.
A Review is about exactly one Property.
Cardinality: One-to-Many (1)

### User-Message Relationship
A User can send many Messages.
A User can receive many Messages.
A Message has exactly one sender and one recipient.
Cardinality:
User as Sender to Message: One-to-Many (1)
User as Recipient to Message: One-to-Many (1)

## Constraints

### **User Table**
- Unique constraint on `email`
- NOT NULL constraint on: `first_name`, `last_name`, `email`, `password_hash`, `role`

### **Property Table**
- Foreign Key: `host_id` → `User(user_id)`
- NOT NULL constraint on: `name`, `description`, `location`, `pricepernight`

### **Booking Table**
- Foreign Keys: `property_id`, `user_id`
- Enum `status` restricted to: `pending`, `confirmed`, `canceled`
- NOT NULL constraint on: `start_date`, `end_date`, `total_price`, `status`

### **Payment Table**
- Foreign Key: `booking_id`
- NOT NULL constraint on: `amount`, `payment_method`

### **Review Table**
- CHECK constraint on `rating` (1 to 5)
- Foreign Keys: `property_id`, `user_id`
- NOT NULL constraint on: `rating`, `comment`

### **Message Table**
- Foreign Keys: `sender_id`, `recipient_id`
- NOT NULL constraint on: `message_body`

### Data Integrity Constraints

- Primary Keys: All tables have a unique identifier as a primary key.
- Foreign Keys: Relationships between tables are maintained through foreign key constraints.
- Not Null Constraints: Essential fields are marked as NOT NULL.
 -Unique Constraints: Email addresses in the User table must be unique.

### Business Rules

- A User with role 'guest' can book properties but cannot list properties.
- A User with role 'host' can list properties and can also book properties (acting as a guest).
- A User with role 'admin' has administrative privileges across the application.
- Booking dates cannot overlap for the same property.
- Payment must be associated with a valid booking.
- Reviews can only be submitted by users who have completed a stay at the property.
- Rating values must be between 1 and 5 inclusive.

### Indexing Strategy
- Primary Keys: All primary keys are indexed for efficient retrieval.
- Foreign Keys: Foreign keys are indexed to speed up join operations.
- Email: User email is indexed for fast user lookups.

### Automatic Indexes
- Primary Keys (`user_id`, `property_id`, `booking_id`, `payment_id`, `review_id`, `message_id`) are indexed by default.

### Additional Indexes
- `email` in `User` table
- `property_id` in `Property` and `Booking` tables
- `booking_id` in `Booking` and `Payment` tables

##ER DIAGRAM
Link: https://drive.google.com/file/d/1DK7o0nwBi9WDLQWIwtH__ycHl7fZNRRh/view?usp=drive_link