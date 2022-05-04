/*

Longest Streak Users

Given a table with event logs, find the top five users with the longest continuous streak of visiting the platform in 2020.

Important Concept

Gaps and Island
*/

WITH CTE AS (SELECT 
    DISTINCT
    USER_ID,
    DATE(CREATED_AT) AS CREATED_AT,
    DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY DATE(CREATED_AT)) AS ACTIVITY_RANK
FROM events),

CTE2 AS (
SELECT *, DATE_ADD(CREATED_AT, INTERVAL -ACTIVITY_RANK DAY) AS DAY_GROUP
FROM CTE)

SELECT USER_ID AS user_id, MAX(streak_length) AS streak_length FROM (
SELECT 
    USER_ID,
    COUNT(*) AS streak_length,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS STREAK_RANK
 FROM CTE2
GROUP BY USER_ID, DAY_GROUP) AS A
GROUP BY USER_ID 
LIMIT 5