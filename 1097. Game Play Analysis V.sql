/*

1097. Game Play Analysis V
Hard

107

24

Add to List

Share
SQL Schema
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
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

The install date of a player is the first login day of that player.

We define day one retention of some date x to be the number of players whose install date is x and they logged back in on the day right after x, divided by the number of players whose install date is x, rounded to 2 decimal places.

Write an SQL query to report for each install date, the number of players that installed the game on that day, and the day one retention.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Explanation: 
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

*/

WITH CTE AS (
SELECT *, 
    DENSE_RANK() OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS ACTIVITY_RANK,
    LEAD(EVENT_DATE) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS NEXT_DATE,
    DATEDIFF(LEAD(EVENT_DATE) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE),EVENT_DATE) AS DATE_DIFFRENCE
FROM ACTIVITY)

SELECT 
    event_date AS INSTALL_DT,
    COUNT(player_id) AS INSTALLS,
    ROUND(SUM(CASE WHEN DATE_DIFFRENCE=1 THEN 1 ELSE 0 END)/COUNT(player_id),2)  AS Day1_retention 
FROM CTE
WHERE ACTIVITY_RANK=1
GROUP BY event_date
ORDER BY 1 
