/*
1164. Product Price at a Given Date
Medium

257

68

Add to List

Share
SQL Schema
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+



*/


WITH CTE AS (
SELECT PRODUCT_ID, NEW_PRICE AS PRICE FROM (SELECT DISTINCT *, 
DENSE_RANK() OVER(PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) AS CHANGE_RANK
FROM PRODUCTS
WHERE CHANGE_DATE<='2019-08-16') AS A
WHERE A.CHANGE_RANK=1)

SELECT DISTINCT A.PRODUCT_ID, COALESCE(PRICE,10) AS PRICE
FROM Products A
LEFT JOIN CTE B 
ON A.PRODUCT_ID=B.PRODUCT_ID

-- First Value
SELECT 
    A.PRODUCT_ID AS product_id,
    COALESCE(B.FIRST_PRICE,10) AS price
FROM PRODUCTS A 
LEFT JOIN 
(SELECT 
    PRODUCT_ID,
    NEW_PRICE, 
    FIRST_VALUE(NEW_PRICE) OVER(PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) AS FIRST_PRICE
FROM PRODUCTS
WHERE CHANGE_DATE<='2019-08-16') B
ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY 1,2

-- Without CTE
SELECT 
    A.PRODUCT_ID AS product_id,
    COALESCE(B.NEW_PRICE,10) AS price
FROM PRODUCTS A 
LEFT JOIN (SELECT PRODUCT_ID,NEW_PRICE
FROM 
(SELECT 
    PRODUCT_ID,
    NEW_PRICE, 
    DENSE_RANK() OVER(PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) AS CHANGE_RANK
FROM PRODUCTS
WHERE CHANGE_DATE<='2019-08-16') AS A
WHERE A.CHANGE_RANK=1) B
ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY 1,2