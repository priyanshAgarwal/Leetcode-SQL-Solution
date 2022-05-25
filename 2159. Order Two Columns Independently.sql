/*

2159. Order Two Columns Independently
Medium

13

10

Add to List

Share
SQL Schema
Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
There is no primary key for this table and it may contain duplicates.
 

Write an SQL query to independently:

order first_col in ascending order.
order second_col in descending order.
The query result format is in the following example.

 

Example 1:

Input: 
Data table:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
Output: 
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+


*/

WITH CTE AS (
SELECT 
*, 
ROW_NUMBER() OVER( ORDER BY FIRST_COL) AS FIRST_SORT,
ROW_NUMBER() OVER( ORDER BY SECOND_COL DESC) AS SECOND_SORT
FROM DATA)


SELECT A.FIRST_COL,B.SECOND_COL 
FROM CTE A 
INNER JOIN  CTE B 
ON A.FIRST_SORT=B.SECOND_SORT
ORDER BY 1, 2 DESC