# SQL Joins Queries

## 📝 Objective
Practice SQL joins by writing queries that combine data from multiple tables in the **Airbnb Clone** database.

---

## 1️⃣ INNER JOIN – Bookings and Users
Retrieve all bookings along with the respective users who made those bookings.

```sql
SELECT b.*, u.*
FROM bookings b
INNER JOIN users u
ON b.user_id = u.id;
