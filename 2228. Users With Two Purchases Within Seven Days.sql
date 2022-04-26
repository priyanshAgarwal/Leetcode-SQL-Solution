/*

2228. Users With Two Purchases Within Seven Days
Medium

10

3

Add to List

Share
SQL Schema
Table: Purchases

+---------------+------+
| Column Name   | Type |
+---------------+------+
| purchase_id   | int  |
| user_id       | int  |
| purchase_date | date |
+---------------+------+
purchase_id is the primary key for this table.
This table contains logs of the dates that users purchased from a certain retailer.
 

Write an SQL query to report the IDs of the users that made any two purchases at most 7 days apart.

Return the result table ordered by user_id.

The query result format is in the following example.

 

Example 1:

Input: 
Purchases table:
+-------------+---------+---------------+
| purchase_id | user_id | purchase_date |
+-------------+---------+---------------+
| 4           | 2       | 2022-03-13    |
| 1           | 5       | 2022-02-11    |
| 3           | 7       | 2022-06-19    |
| 6           | 2       | 2022-03-20    |
| 5           | 7       | 2022-06-19    |
| 2           | 2       | 2022-06-08    |
+-------------+---------+---------------+
Output: 
+---------+
| user_id |
+---------+
| 2       |
| 7       |
+---------+
Explanation: 
User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the second purchase is within 7 days of the first purchase, we add their ID.
User 5 had only 1 purchase.
User 7 had two purchases on the same day so we add their ID.



*/

-- METHOD 1
SELECT DISTINCT USER_ID FROM (SELECT 
    USER_ID,
    COUNT(PURCHASE_ID) OVER(PARTITION BY USER_ID ORDER BY PURCHASE_DATE RANGE BETWEEN CURRENT ROW AND INTERVAL 7 DAY FOLLOWING) AS CNT 
FROM PURCHASES) AS A
WHERE CNT=2

-- METHOD 2
WITH CTE AS(
    SELECT DISTINCT USER_ID,PURCHASE_DATE, 
LEAD(PURCHASE_DATE,1) OVER(PARTITION BY USER_ID ORDER BY PURCHASE_DATE) AS NEXT_SHOPPIN,
DATE_ADD(PURCHASE_DATE, INTERVAL 7 DAY) AS NEXT_7_DAY FROM PURCHASES)


SELECT USER_ID FROM CTE WHERE
DATEDIFF(NEXT_SHOPPIN,PURCHASE_DATE)<=7