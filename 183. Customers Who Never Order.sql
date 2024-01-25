/*

183. Customers Who Never Order
Easy

1126

82

Add to List

Share
SQL Schema
Table: Customers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID and name of a customer.
 

Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key column for this table.
customerId is a foreign key of the ID from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
 

Write an SQL query to report all customers who never order anything.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Output: 
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+

Lets Learn from different joins

SELECT * FROM CUSTOMERS A
INNER JOIN ORDERS B
ON A.ID = B.CUSTOMERID WHERE B.CUSTOMERID IS NULL

| id | name | id | customerId |
| -- | ---- | -- | ---------- |

Because after joining there are no customerID that are NULL (Remember order of operations)

| ------ | ------ | ------ | ------ | ------ | ------ | ------ |


SELECT * FROM CUSTOMERS A
LEFT JOIN ORDERS B
ON A.ID = B.CUSTOMERID AND B.CUSTOMERID IS NULL

| id | name  | id   | customerId |
| -- | ----- | ---- | ---------- |
| 1  | Joe   | null | null       |
| 2  | Henry | null | null       |
| 3  | Sam   | null | null       |
| 4  | Max   | null | null       |


You get everything from Left table and ther are no null customer id so everything from left table is null

| ------ | ------ | ------ | ------ | ------ | ------ | ------ |

Final Answer 

SELECT * FROM CUSTOMERS A
LEFT JOIN ORDERS B
ON A.ID = B.CUSTOMERID 

| id | name  | id   | customerId |
| -- | ----- | ---- | ---------- |
| 1  | Joe   | 2    | 1          |
| 2  | Henry | null | null       |
| 3  | Sam   | 1    | 3          |
| 4  | Max   | null | null       |

We get everything from right table, but only values that were present from left, which we can filter using where clause.  


SELECT * FROM CUSTOMERS A
LEFT JOIN ORDERS B
ON A.ID = B.CUSTOMERID 
WHERE B.CUSTOMERID IS NULL

| id | name  | id   | customerId |
| -- | ----- | ---- | ---------- |
| 2  | Henry | null | null       |
| 4  | Max   | null | null       |

So According to order of operations, when we apply the join condition, So don't think where clause from left table in left join becomes inner join 

*/

SELECT NAME AS Customers 
FROM CUSTOMERS A
LEFT JOIN ORDERS B
ON A.ID=B.CUSTOMERID
WHERE CUSTOMERID IS NULL
