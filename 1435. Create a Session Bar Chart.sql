/*

1435. Create a Session Bar Chart

Table: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the primary key for this table.
duration is the time in seconds that a user has visited the application.
 

You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

Write an SQL query to report the (bin, total) in any order.

The query result format is in the following example.

Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 199           |
| 3           | 299           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+

Result table:
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+

For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater or equal than 15 minutes.

*/

SELECT '[0-5>' AS BIN, COUNT(SESSION_ID) AS total FROM SESSIONS WHERE DURATION/60<5
UNION ALL
SELECT '[5-10>' AS BIN, COUNT(SESSION_ID) AS total FROM SESSIONS WHERE DURATION/60 BETWEEN 5 AND 10
UNION ALL
SELECT '[10-15>' AS BIN, COUNT(SESSION_ID) AS total FROM SESSIONS WHERE DURATION/60 BETWEEN 10 AND 15
UNION ALL
SELECT '15 or more' AS BIN, COUNT(SESSION_ID) AS total FROM SESSIONS WHERE DURATION/60>15

-- METHOD 2
WITH cte AS(
SELECT session_id, ROUND(duration*1.0/60,2) AS mins
FROM Sessions)

SELECT '[0-5>' AS bin,
SUM(CASE WHEN mins BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS TOTAL
FROM cte
UNION ALL
SELECT '[5-10>' AS bin,
       SUM(CASE WHEN mins>=5 AND mins<10 THEN 1 ELSE 0 END) AS total
FROM cte
UNION ALL
SELECT '[10-15>' AS bin,
       SUM(CASE WHEN mins>=10 AND mins<15 THEN 1 ELSE 0 END) AS total
FROM cte
UNION ALL
SELECT '15 or more' AS bin,
       SUM(CASE WHEN mins>=15 THEN 1 ELSE 0 END) AS total
FROM cte


-- METHOD 3
# Write your MySQL query statement below
WITH CTE_1 AS(
SELECT session_id, ROUND(duration*1.0/60,2) AS duration
FROM Sessions),

CTE_2 AS (
    SELECT 
        session_id,
        CASE 
            WHEN duration BETWEEN 0 AND 5 THEN '[0-5>'
            WHEN duration BETWEEN 5 AND 10 THEN '[5-10>'
            WHEN duration BETWEEN 10 AND 15 THEN '[10-15>'
            ELSE '15 OR MORE'
        END AS BIN
    FROM CTE_1
),

CTE_3 AS (
    SELECT '[0-5>' AS BIN 
     UNION ALL
    SELECT '[5-10>' AS BIN
     UNION ALL
    SELECT '[10-15>' AS BIN
     UNION ALL
    SELECT '15 or more' AS BIN
)

SELECT A.BIN, IFNULL(COUNT(session_id),0) AS TOTAL
FROM CTE_3 A
LEFT JOIN CTE_2 B
ON A.BIN=B.BIN
GROUP BY A.BIN 
