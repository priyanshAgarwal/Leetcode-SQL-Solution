/*

1369. Get the Second Most Recent Activity

Table: UserActivity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
This table does not contain primary key.
This table contain information about the activity performed of each user in a period of time.
A person with username performed a activity from startDate to endDate.

Write an SQL query to show the second most recent activity of each user.

If the user only has one activity, return that one. 

A user can't perform more than one activity at the same time. Return the result table in any order.

The query result format is in the following example:

UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+

Result table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+

The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
Bob only has one record, we just take that one.


*/

WITH CTE AS (
SELECT 
    USERNAME,
    ACTIVITY,
    STARTDATE,
    ENDDATE,
    DENSE_RANK() OVER(PARTITION BY USERNAME ORDER BY STARTDATE DESC) AS ACTIVITY_RANK,
    COUNT(USERNAME) OVER(PARTITION BY USERNAME) AS NUM_ACTIVITY
FROM USERACTIVITY )


SELECT 
    username,
    activity,
    startDate, 
    endDate 
FROM CTE WHERE ACTIVITY_RANK=(CASE WHEN NUM_ACTIVITY>1 THEN 2 ELSE 1 END) 