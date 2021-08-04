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


(SELECT A.NAME 'results' FROM
(SELECT U.NAME, M.USER_ID, COUNT(M.USER_ID), DENSE_RANK() OVER (ORDER BY COUNT(M.USER_ID) DESC, U.NAME) AS 'RANK'
FROM USERS U
RIGHT JOIN MOVIE_RATING M
ON U.USER_ID = M.USER_ID
GROUP BY U.NAME) A
WHERE A.RANK = 1)
UNION
(SELECT B.TITLE FROM
(SELECT MO.TITLE, AVG(M.RATING), DENSE_RANK() OVER (ORDER BY AVG(M.RATING) DESC, MO.TITLE) AS 'RATING'
FROM MOVIES MO
RIGHT JOIN MOVIE_RATING M
ON MO.MOVIE_ID = M.MOVIE_ID
WHERE DATE_FORMAT(CREATED_AT, '%Y-%m') = '2020-02'
GROUP BY M.MOVIE_ID) B
WHERE B.RATING = 1)

