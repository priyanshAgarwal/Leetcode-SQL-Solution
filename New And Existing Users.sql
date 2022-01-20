/*

New And Existing Users
Calculate the share of new and existing users. Output the month, share of new users, and share of existing users as a ratio.
New users are defined as users who started using services in the current month. Existing users are users who started using services in current month and used services in any previous month. 
Assume that the dates are all from the year 2020.

To Do Again (Difficult Question) Got Confused
*/


WITH CTE_A AS (
    SELECT DISTINCT USER_ID, EXTRACT(MONTH FROM TIME_ID) AS MONTH FROM FACT_EVENTS 
),

CTE_B AS (
    SELECT USER_ID, MONTH ,DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY MONTH) AS USE_RANK FROM CTE_A
)

SELECT MONTH, 
    SUM(CASE WHEN USE_RANK=1 THEN 1 ELSE 0 END)::DECIMAL/COUNT(*) AS share_new_users,
    SUM(CASE WHEN USE_RANK<>1 THEN 1 ELSE 0 END)::DECIMAL/COUNT(*) AS share_existing_users FROM CTE_B
    GROUP BY 1
    ORDER BY 1;
    