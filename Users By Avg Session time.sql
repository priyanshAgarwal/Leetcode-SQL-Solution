/*

Users By Avg Session time
Calculate each user's average session time. A session is defined as the time difference between a page_load and page_exit. For simplicity, assume an user has only 1 session per day and if there are multiple of the same events in that day, consider only the latest page_load and earliest page_exit. Output the user_id and their average session time.

Dense Rank Can't be used everywhere

*/



WITH CTE2 AS (
SELECT 
    USER_ID,DATE(timestamp),
    MAX(CASE WHEN action='page_load'THEN TIMESTAMP END) AS PAGE_LOAD,
    MAX(CASE WHEN action='page_exit'THEN TIMESTAMP END) AS PAGE_EXIT
FROM FACEBOOK_WEB_LOG
WHERE action IN ('page_exit','page_load')
GROUP BY 1,2)

SELECT USER_ID,AVG(page_exit-page_load)  FROM CTE2
WHERE PAGE_LOAD IS NOT NULL AND PAGE_EXIT IS NOT NULL
GROUP BY 1

-- METHOD 2 (LONG BUT EXPALIN)
WITH PAGE_LOAD AS (
SELECT USER_ID, DATE(TIMESTAMP), MAX(TIMESTAMP) AS LOAD_TIME FROM FACEBOOK_WEB_LOG WHERE ACTION='page_load'
    GROUP BY 1,2
),

PAGE_exit AS (
SELECT USER_ID, DATE(TIMESTAMP), MIN(TIMESTAMP) AS EXIT_TIME FROM FACEBOOK_WEB_LOG WHERE ACTION='page_exit'
    GROUP BY 1,2
)

SELECT A.USER_ID, AVG(EXIT_TIME-LOAD_TIME) FROM PAGE_LOAD A
INNER JOIN PAGE_EXIT B
ON A.USER_ID=B.USER_ID AND A.DATE=B.DATE
GROUP BY 1