/*

511. Game Play Analysis I

Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports the first login date for each player.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+

*/

SELECT player_id, event_date AS first_login
FROM (SELECT 
PLAYER_ID, 
EVENT_DATE, 
DENSE_RANK() OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS FIRST_LOGIN 
FROM Activity) A
WHERE A.FIRST_LOGIN=1

-- METHOD 2
SELECT 
    PLAYER_ID AS player_id,
    MIN(EVENT_DATE) AS first_login
FROM ACTIVITY 
GROUP BY 1

-- METHOD 3
SELECT 
    DISTINCT
    PLAYER_ID AS player_id,
    FIRST_VALUE(EVENT_DATE) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS first_login 
FROM ACTIVITY