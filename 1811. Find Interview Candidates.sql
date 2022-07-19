/*

1811. Find Interview Candidates

Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the primary key for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the primary key for this table.
This table contains information about the users.
 

Write an SQL query to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

The query result format is in the following example:

 

Contests table:
+------------+------------+--------------+--------------+
| contest_id | gold_medal | silver_medal | bronze_medal |
+------------+------------+--------------+--------------+
| 190        | 1          | 5            | 2            |
| 191        | 2          | 3            | 5            |
| 192        | 5          | 2            | 3            |
| 193        | 1          | 3            | 5            |
| 194        | 4          | 5            | 2            |
| 195        | 4          | 2            | 1            |
| 196        | 1          | 5            | 2            |
+------------+------------+--------------+--------------+

Users table:
+---------+--------------------+-------+
| user_id | mail               | name  |
+---------+--------------------+-------+
| 1       | sarah@leetcode.com | Sarah |
| 2       | bob@leetcode.com   | Bob   |
| 3       | alice@leetcode.com | Alice |
| 4       | hercy@leetcode.com | Hercy |
| 5       | quarz@leetcode.com | Quarz |
+---------+--------------------+-------+

Result table:
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
| Bob   | bob@leetcode.com   |
| Alice | alice@leetcode.com |
| Quarz | quarz@leetcode.com |
+-------+--------------------+

Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
    - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.
 

Follow up:

What if the first condition changed to be "any medal in n or more consecutive contests"? How would you change your solution to get the interview candidates? Imagine that n is the parameter of a stored procedure.
Some users may not participate in every contest but still perform well in the ones they do. How would you change your solution to only consider contests where the user was a participant? Suppose the registered users for each contest are given in another table.


["NAME", "MAIL", "CURRENT_CONTEST", "NEXT_CONTEST", "PREV_CONTEST"], 
["Alice", "alice@leetcode.com", 192, 193, 191], 
["Alice", "alice@leetcode.com", 193, null, 192], 
["Alice", "alice@leetcode.com", 191, 192, null], 
["Bob", "bob@leetcode.com", 190, 191, null], 
["Bob", "bob@leetcode.com", 191, 192, 190], 
["Bob", "bob@leetcode.com", 192, 194, 191], 
["Bob", "bob@leetcode.com", 194, 195, 192], 
["Bob", "bob@leetcode.com", 195, 196, 194], 
["Bob", "bob@leetcode.com", 196, null, 195], 
["Hercy", "hercy@leetcode.com", 195, null, 194], 
["Hercy", "hercy@leetcode.com", 194, 195, null], 
["Quarz", "quarz@leetcode.com", 190, 191, null], 
["Quarz", "quarz@leetcode.com", 191, 192, 190], 
["Quarz", "quarz@leetcode.com", 192, 193, 191], 
["Quarz", "quarz@leetcode.com", 193, 194, 192], 
["Quarz", "quarz@leetcode.com", 194, 196, 193], 
["Quarz", "quarz@leetcode.com", 196, null, 194], 
["Sarah", "sarah@leetcode.com", 190, 193, null], 
["Sarah", "sarah@leetcode.com", 193, 195, 190], ["Sarah", "...
*/

-- METHOD 1 CONSIQUTIVE QUESTION 
WITH ALL_USERS AS (
SELECT CONTEST_ID, GOLD_MEDAL AS USER_ID
FROM CONTESTS
UNION ALL
SELECT CONTEST_ID, SILVER_MEDAL AS USER_ID
FROM CONTESTS
UNION ALL
SELECT CONTEST_ID, BRONZE_MEDAL AS USER_ID
FROM CONTESTS
),

THREE_MEDALS AS (
    SELECT *, 
    LEAD(CONTEST_ID) OVER(PARTITION BY USER_ID ORDER BY CONTEST_ID) AS NEXT_CONTEST_MEDAL,
    LAG(CONTEST_ID) OVER(PARTITION BY USER_ID ORDER BY CONTEST_ID) AS PREVIOUS_CONTEST_MEDAL
    FROM ALL_USERS
),

THREE_GOLD AS (
    SELECT GOLD_MEDAL AS USR_ID FROM CONTESTS
    GROUP BY 1
    HAVING COUNT(DISTINCT CONTEST_ID)>=3
),

ALL_USES AS (
SELECT USER_ID FROM THREE_MEDALS
WHERE CONTEST_ID+1=NEXT_CONTEST_MEDAL AND CONTEST_ID-1=PREVIOUS_CONTEST_MEDAL
UNION ALL
SELECT USR_ID FROM THREE_GOLD) 

SELECT DISTINCT B.MAIL, B.NAME FROM ALL_USES A
INNER JOIN USERS B
ON A.USER_ID=B.USER_ID
