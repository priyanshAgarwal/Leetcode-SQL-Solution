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