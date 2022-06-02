/*

1454. Active Users
Medium

Table Accounts:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
the id is the primary key for this table.
This table contains the account id and the user name of each account.
 

Table Logins:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Write an SQL query to find the id and the name of active users.

Active users are those who logged in to their accounts for 5 or more consecutive days.

Return the result table ordered by the id.

The query result format is in the following example:

Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+

Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+

Result table:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.
Follow up question:
Can you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days?

Longest Streak

["ID", "NAME", "LOGIN_DATE", "GROUP_DATE"], 
[1, "Winston", "2020-05-30", 0],
[1, "Winston", "2020-06-07", 4], 
[7, "Jonathan", "2020-05-30", 0], 
[7, "Jonathan", "2020-05-31", 0], 
[7, "Jonathan", "2020-06-01", 0], 
[7, "Jonathan", "2020-06-02", 0], 
[7, "Jonathan", "2020-06-02", 0], 
[7, "Jonathan", "2020-06-03", 0], 
[7, "Jonathan", "2020-06-10", 1]]}
*/

-- Smart Way Use Lag (Remeber to first get distinct values)
WITH CTE AS (
    SELECT DISTINCT ID, LOGIN_DATE FROM LOGINS ),
    
CTE_2 AS (
    SELECT ID, LOGIN_DATE,LEAD(LOGIN_DATE,4) OVER(PARTITION BY ID ORDER BY LOGIN_DATE) AS FIFT_LOGIN  FROM CTE
)


SELECT DISTINCT B.* FROM CTE_2 A
INNER JOIN ACCOUNTS B
ON A.ID=B.ID
WHERE DATEDIFF(FIFT_LOGIN,LOGIN_DATE)=4
ORDER BY 1

-- Method 2 (Gap and Island)
WITH CTE AS (
SELECT DISTINCT ID, 
LOGIN_DATE,
DENSE_RANK() OVER(PARTITION BY ID ORDER BY LOGIN_DATE) AS ROW_NUM     
FROM LOGINS),

CTE_2 AS (
    SELECT ID,LOGIN_DATE, DATE_ADD(LOGIN_DATE, INTERVAL -ROW_NUM DAY) AS DATE_GROUP FROM CTE
)

SELECT * FROM ACCOUNTS WHERE ID IN ( SELECT ID FROM CTE_2
GROUP BY ID,DATE_GROUP
HAVING  COUNT(*)>=5)
ORDER BY 1

-- Method 3 (Gap and Island)
WITH CTE AS (
SELECT DISTINCT *, 
    DENSE_RANK() OVER(ORDER BY LOGIN_DATE) AS ROW_NUM,
    DENSE_RANK() OVER(PARTITION BY ID ORDER BY LOGIN_DATE) AS ROW_RANK
FROM LOGINS  
),

CTE1 AS 
(
SELECT A.ID, B.NAME, A.LOGIN_DATE, ROW_NUM-ROW_RANK AS GROUP_DATE 
FROM CTE A
INNER JOIN ACCOUNTS B
ON A.ID=B.ID)


SELECT * FROM Accounts WHERE ID IN(SELECT ID FROM CTE1
GROUP BY ID,GROUP_DATE
HAVING COUNT(*)>4)
ORDER BY 1



