-- Total number of bookings made by each user using COUNT and GROUP BY
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_bookings DESC;

-- Rank properties based on total number of bookings using window functions
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.price_per_night,
    booking_count,
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS row_number_rank,
    RANK() OVER (ORDER BY booking_count DESC) AS rank_position
FROM (
    SELECT 
        p.property_id,
        p.name,
        p.location,
        p.price_per_night,
        COUNT(b.booking_id) AS booking_count
    FROM Property p
    LEFT JOIN Booking b ON p.property_id = b.property_id
    GROUP BY p.property_id, p.name, p.location, p.price_per_night
) AS property_bookings
ORDER BY booking_count DESC;