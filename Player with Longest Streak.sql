/*

GAP AND ISLAND

Player with Longest Streak
You are given a table of tennis players and their matches that they could either win (W) or lose (L). Find the longest streak of wins. A streak is a set of consecutive won matches of one player. The streak ends once a player loses their next match. Output the ID of the player or players and the length of the streak.


*/


WITH CTE AS (select *, 
    DENSE_RANK() over (partition by player_id order by match_date)
  - DENSE_RANK() over (partition by player_id,match_result order by match_date) AS STREAK_RANK from PLAYERS_RESULTS
ORDER BY PLAYER_ID,MATCH_DATE),

CTE2 AS(
SELECT PLAYER_ID, streak_rank, COUNT(*) AS COUNT_WIN FROM CTE 
WHERE match_result='W'
GROUP BY 1,2),

CTE3 AS (
SELECT *, DENSE_RANK() OVER( 
ORDER BY COUNT_WIN DESC) AS CNT_RANK FROM CTE2)

SELECT player_id,count_win FROM CTE3
WHERE CNT_RANK=1