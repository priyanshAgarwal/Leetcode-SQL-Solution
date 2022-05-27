/*

1127. User Purchase Platform
Hard

125

92

Add to List

Share
SQL Schema
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the history of the spending of users that make purchases from an online shopping website that has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').
 

Write an SQL query to find the total number of users and the total amount spent using the mobile only, the desktop only, and both mobile and desktop together for each date.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+
Output: 
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
Explanation: 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.



["user_id", "spend_date", "mobile_amount", "desktop_amount", "both"], 
[1, "2019-07-01", 100, 100, 200], 
[2, "2019-07-01", 100, 0, 0], 
[2, "2019-07-02", 100, 0, 0], 
[3, "2019-07-01", 0, 100, 0], 
[3, "2019-07-02", 0, 100, 0]]}

SELECT SPEND_DATE,  FROM TABLE
*/

WITH ALL_VALUES AS ( 
SELECT SPEND_DATE, 'mobile' AS PLATFORM FROM SPENDING 
UNION
SELECT SPEND_DATE, 'desktop' AS PLATFORM FROM SPENDING
UNION 
SELECT SPEND_DATE, 'both' AS PLATFORM FROM SPENDING
),

COUNT_SPENDING AS(
    SELECT
        USER_ID,
        SPEND_DATE,
        SUM(AMOUNT) AS AMOUNT,
        CASE WHEN COUNT(DISTINCT PLATFORM)=2 THEN 'both' ELSE PLATFORM END AS PLATFORM 
    FROM SPENDING
    GROUP BY 1,2  
)

SELECT 
    A.SPEND_DATE as spend_date,
    A.PLATFORM as platform,
    IFNULL(SUM(AMOUNT),0) AS total_amount,
    COUNT(USER_ID) AS total_users
FROM ALL_VALUES A 
LEFT JOIN COUNT_SPENDING B
ON A.SPEND_DATE=B.SPEND_DATE AND A.PLATFORM=B.PLATFORM
GROUP BY 1,2