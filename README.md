# Airbnb Clone Database Advanced Scripts

This directory contains advanced SQL scripts and documentation for optimizing and analyzing the **Airbnb Clone** database. The tasks focus on mastering joins, subqueries, aggregations, indexing, optimization, partitioning, and performance monitoring.

---

## 📂 Contents
- `joins_queries.sql` – SQL queries demonstrating various join types.
- `subqueries.sql` – Correlated and non-correlated subquery examples.
- `aggregations_and_window_functions.sql` – Aggregations and window functions for data analysis.
- `database_index.sql` – Index creation for query performance optimization.
- `index_performance.md` – Performance comparison before and after indexing.
- `perfomance.sql` – Initial complex query for bookings and related data.
- `optimization_report.md` – Analysis and refactoring of complex queries for speed improvements.
- `partitioning.sql` – Table partitioning for the `bookings` table.
- `partition_performance.md` – Report on partitioning performance improvements.
- `performance_monitoring.md` – Continuous database performance monitoring and tuning report.

---

## 1️⃣ Master SQL Joins
**Objective:** Write complex queries using different types of joins.

**Tasks:**
- **INNER JOIN:** Retrieve all bookings with their respective users.
- **LEFT JOIN:** Retrieve all properties and their reviews, including properties without reviews.
- **FULL OUTER JOIN:** Retrieve all users and bookings, even if no relation exists.

📄 **File:** `joins_queries.sql`

---

## 2️⃣ Practice Subqueries
**Objective:** Implement correlated and non-correlated subqueries.

**Tasks:**
- Find properties with an average rating greater than 4.0.
- Find users who have made more than 3 bookings.

📄 **File:** `subqueries.sql`

---

## 3️⃣ Apply Aggregations & Window Functions
**Objective:** Use aggregation and window functions for data insights.

**Tasks:**
- Count total bookings per user using `COUNT` and `GROUP BY`.
- Rank properties based on the total number of bookings using `ROW_NUMBER` or `RANK`.

📄 **File:** `aggregations_and_window_functions.sql`

---

## 4️⃣ Implement Indexes for Optimization
**Objective:** Identify and create indexes to improve query speed.

**Tasks:**
- Create indexes on high-usage columns in `User`, `Booking`, and `Property` tables.
- Measure query performance before and after indexing.

📄 **Files:**
- `database_index.sql`
- `index_performance.md`

---

## 5️⃣ Optimize Complex Queries
**Objective:** Refactor queries to improve performance.

**Tasks:**
- Create a query joining bookings, users, properties, and payments.
- Use `EXPLAIN` to find inefficiencies and refactor.

📄 **Files:**
- `perfomance.sql`
- `optimization_report.md`

---

## 6️⃣ Partition Large Tables
**Objective:** Improve query performance using table partitioning.

**Tasks:**
- Partition `bookings` table by `start_date`.
- Test performance improvements for date range queries.

📄 **Files:**
- `partitioning.sql`
- `partition_performance.md`

---

## 7️⃣ Monitor & Refine Database Performance
**Objective:** Continuously monitor and tune database performance.

**Tasks:**
- Use `SHOW PROFILE` or `EXPLAIN ANALYZE` to monitor query performance.
- Identify bottlenecks and make schema adjustments.
- Document performance improvements.

📄 **File:** `performance_monitoring.md`

---

## 📌 Notes
- All SQL scripts were tested in MySQL environment.
- Performance comparisons are based on execution time and query cost analysis.
- Indexes and partitioning strategies are tailored to Airbnb Clone’s dataset structure.


