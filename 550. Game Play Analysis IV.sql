/*

550. Game Play Analysis IV

Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int
     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

 

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

*/

-- SINGLE QUERY
SELECT ROUND((COUNT(DISTINCT PLAYER_ID)/(SELECT COUNT(DISTINCT PLAYER_ID) FROM ACTIVITY)),2) AS FRACTION
FROM (SELECT 
    PLAYER_ID,
    EVENT_DATE,               
    DENSE_RANK() OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS DATE_RANK,
    LEAD(EVENT_DATE,1) OVER(PARTITION BY PLAYER_ID) AS NEXT_DATE
FROM ACTIVITY) A 
WHERE A.DATE_RANK=1 AND DATEDIFF(A.NEXT_DATE,A.EVENT_DATE)=1




--Method 1

WITH CTE AS (SELECT DISTINCT PLAYER_ID FROM (
    SELECT 
        PLAYER_ID,
        EVENT_DATE,
        RANK() OVER (PARTITION BY player_id ORDER BY event_date) AS LOGIN_RANK,
        LEAD(EVENT_DATE,1) OVER(PARTITION BY PLAYER_ID) AS NEXT_DAY
        FROM ACTIVITY) A
WHERE NEXT_DAY IS NOT NULL
AND NEXT_DAY - event_date = 1
AND LOGIN_RANK=1)


SELECT  
    ROUND((SELECT COUNT(*) FROM CTE)/ COUNT(DISTINCT player_id),2) AS FRACTION
FROM ACTIVITY


-- Method 2
WITH CTE AS (
    SELECT 
    PLAYER_ID,
    EVENT_DATE,
    LEAD(EVENT_DATE,1) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS NEXT_LOGIN,
    DENSE_RANK() OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS LOGIN_RANK
    FROM ACTIVITY 
),


CTE2 AS (
    SELECT DISTINCT PLAYER_ID
    FROM CTE 
    WHERE LOGIN_RANK=1 AND (NEXT_LOGIN-EVENT_DATE)=1
)


SELECT ROUND((SELECT COUNT(*) FROM CTE2)/COUNT(DISTINCT PLAYER_ID),2) AS FRACTION
FROM ACTIVITY