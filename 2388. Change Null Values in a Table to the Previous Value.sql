/*
2388. Change Null Values in a Table to the Previous Value
Medium
76
26
Deloitte
SQL Schema
Pandas Schema
Table: CoffeeShop

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| drink       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row in this table shows the order id and the name of the drink ordered. Some drink rows are nulls.
 

Write a solution to replace the null values of the drink with the name of the drink of the previous row that is not null. It is guaranteed that the drink on the first row of the table is not null.

Return the result table in the same order as the input.

The result format is shown in the following example.

 

Example 1:

Input: 
CoffeeShop table:
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | null              |
| 7  | null              |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | null              |
+----+-------------------+
Output: 
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | Rum and Coke      |
| 7  | Rum and Coke      |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | Orange Margarita  |
+----+-------------------+
Explanation: 
For ID 6, the previous value that is not null is from ID 9. We replace the null with "Rum and Coke".
For ID 7, the previous value that is not null is from ID 9. We replace the null with "Rum and Coke;.
For ID 2, the previous value that is not null is from ID 1. We replace the null with "Orange Margarita".
Note that the rows in the output are the same as in the input.

*/



WITH CTE AS (
SELECT *, ROW_NUMBER() OVER() AS ORDER_P
-- HERE WE WON'T ANYTHING INSIDE OVER() CLAUSE BECAUSE WE WANT TO PRESERVE THE ORDER, NAHI TO ORDER WILL CHANGE
 FROM CoffeeShop),

 CTE2 AS(
    SELECT *, COUNT(drink) OVER(ORDER BY ORDER_P) AS GROUPING
    FROM CTE
 ),

 SELECT ID, MAX(DRINK) OVER(PARTITION BY GROUPING) AS MAX_DRINK
FROM CTE2


-- Same logic another approach using sum function

with cte as (
    select id, drink, row_number() over() as rn
    from CoffeeShop
),

cte2 as (
    select id, drink, rn, sum(case when drink is NULL then 0 else 1 end) over (order by rn) as group_id
    from cte
)

select id , MAX(drink) over(partition by group_id) as drink             
from cte2
order by rn

