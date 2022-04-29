/*

New And Existing Users


Interview Question Date: February 2021

Microsoft
Hard
Active Interview
ID 2028
1
0
Calculate the share of new and existing users for each month in the table. Output the month, share of new users, and share of existing users as a ratio.
New users are defined as users who started using services in the current month (there is no usage history in previous months). Existing users are users who used services in current month, but they also used services in any previous month. 
Assume that the dates are all from the year 2020.


To Do Again (Difficult Question) Got Confused
*/


-- Method 1
WITH CTE AS (
    SELECT USER_ID, MONTH(TIME_ID) AS TIME_MONTH ,DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY MONTH(TIME_ID)) AS LOGIN_RANK FROM fact_events
)

SELECT TIME_MONTH, 
    COUNT(DISTINCT CASE WHEN LOGIN_RANK=1 THEN USER_ID ELSE NULL END)*1.0/COUNT(DISTINCT USER_ID) AS NEW_USER_COUNT,
    COUNT(DISTINCT CASE WHEN LOGIN_RANK<>1 THEN USER_ID ELSE NULL END)*1.0/COUNT(DISTINCT USER_ID) AS EXISTING_USER_COUNT
FROM CTE
GROUP BY 1;
    

-- Method 2

-- If you don't use MONTH(TIME_ID) and use TIME_ID then your answer will be wrong, because dense_rank will also
-- calculate login where user loged in same moth but after first login then those logins will be counted towrds old login 

WITH CTE AS (
    SELECT 
        USER_ID,
        MONTH(TIME_ID) AS CURRENT_MONTH,
        MIN(MONTH(TIME_ID)) OVER(PARTITION BY USER_ID ORDER BY MONTH(TIME_ID)) AS FIRST_MONTH FROM fact_events
)

SELECT 
    CURRENT_MONTH,
    COUNT(DISTINCT CASE WHEN CURRENT_MONTH=FIRST_MONTH THEN USER_ID ELSE NULL END)*1.0/COUNT(DISTINCT USER_ID) AS NEW_USER,
    COUNT(DISTINCT CASE WHEN CURRENT_MONTH!=FIRST_MONTH THEN USER_ID ELSE NULL END)*1.0/COUNT(DISTINCT USER_ID) AS OLD_USER
FROM CTE
GROUP BY 1