/*

1613. Find the Missing IDs

Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The query result format is in the following example.

 

Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+

Result table:
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.


*/

WITH CTE AS (
    SELECT 1 AS VALUE, max(customer_id) as MAX_CUST
    FROM Customers   -- This is the first and initial condition where we write the base case
    UNION ALL
    SELECT VALUE+1 AS VALUE, MAX_CUST -- This is where we iterate the condition
    FROM CTE 
    WHERE VALUE<MAX_CUST -- This to break the condition, So we got the max number and
    -- we are only running the value till the max customer id
)
