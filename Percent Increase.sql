/*



*/

WITH CTE AS (
SELECT PLAYER_ID, EVENT_DATE, GAMES_PLAYED, IFNULL(LEAD(GAMES_PLAYED,1) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE),NULL) AS GAMES_PLAYED_NEXT_DAY,
IFNULL((IFNULL(LEAD(GAMES_PLAYED,1) OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE),NULL)-GAMES_PLAYED),NULL) AS CHANGE_IN_GAMES
FROM ACTIVITY)

SELECT PLAYER_ID, EVENT_DATE,(CHANGE_IN_GAMES*100.0/GAMES_PLAYED) AS PERCENT_CHANGE
FROM CTE 
GROUP BY 1,2,3