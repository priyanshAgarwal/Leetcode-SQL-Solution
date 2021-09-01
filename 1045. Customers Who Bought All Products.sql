/*
1045. Customers Who Bought All Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
product_key is a foreign key to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.
 

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The query result format is in the following example:

 

Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+

Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

Result table:
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
The customers who bought all the products (5 and 6) are customers with id 1 and 3.
*/

-- Always put what you are counting, That will help you like DISTINCT C.product_key helped you here.

-- Method 1
SELECT CUSTOMER_ID 
FROM CUSTOMER C
INNER JOIN 
PRODUCT P
ON C.PRODUCT_KEY=P.PRODUCT_KEY
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT C.product_key)=(SELECT COUNT(*) FROM Product)

-- Method 2
SELECT customer_id FROM (SELECT customer_id, COUNT(DISTINCT product_key) AS Products_bought
FROM Customer 
GROUP BY customer_id 
HAVING Products_bought = (SELECT COUNT(*) FROM Product)) A