# Database Performance Monitoring and Optimization

This document outlines the continuous monitoring, analysis, and optimization process for improving the **Airbnb Clone** database performance.

---

## 📊 1. Monitoring Queries

We used `EXPLAIN ANALYZE` and `SHOW PROFILE` to analyze frequently executed queries and detect potential bottlenecks.

**Example Query Analysis:**
```sql
EXPLAIN ANALYZE
SELECT p.id, p.name, p.location, p.price
FROM properties p
JOIN bookings b ON p.id = b.property_id
WHERE b.start_date >= '2025-08-01';
