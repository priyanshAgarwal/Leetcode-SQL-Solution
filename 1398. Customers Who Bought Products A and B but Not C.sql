/*

1398. Customers Who Bought Products A and B but Not C

Table: Customers

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
customer_id is the primary key for this table.
customer_name is the name of the customer.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
order_id is the primary key for this table.
customer_id is the id of the customer who bought the product "product_name".
 

Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

Return the result table ordered by customer_id.

The query result format is in the following example.

 

Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+

Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+

Result table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
Only the customer_id with id 3 bought the product A and B but not the product C.



*/

-- Method 1

select customer_id, product_name  
from Orders 
where customer_id in
(
    select customer_id
    from Orders
    where product_name='A'
) and customer_id in
(
    select customer_id
    from Orders
    where product_name='B'
) and customer_id not in
(
    select customer_id
    from Orders
    where product_name='C'
) 


-- Method 2
-- sUM KE ANDAR BHI CONDITION DAL SAKTE HAI
WITH CTE AS (select 
    CUSTOMER_ID,
    PRODUCT_NAME,
    SUM(PRODUCT_NAME='A') OVER(PARTITION BY CUSTOMER_ID) AS 'BUY_A',
    SUM(PRODUCT_NAME='B') OVER(PARTITION BY CUSTOMER_ID) AS 'BUY_B',
    SUM(PRODUCT_NAME='C') OVER(PARTITION BY CUSTOMER_ID) AS 'BUY_C'
from Orders )


SELECT DISTINCT B.* FROM CTE A
INNER JOIN Customers B
ON A.CUSTOMER_ID=B.CUSTOMER_ID
WHERE BUY_A>0 
AND BUY_B>0
AND BUY_C=0

