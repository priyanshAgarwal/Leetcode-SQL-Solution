/*
1132. Reported Posts II

Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action such as a reason for report or a type of reaction. 
Table: Removals

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| post_id       | int     |
| remove_date   | date    | 
+---------------+---------+
post_id is the primary key of this table.
Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

The query result format is in the following example:

Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 2       | 2019-07-04  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-03  | view   | null   |
| 5       | 2       | 2019-07-03  | report | racism |
| 5       | 5       | 2019-07-03  | view   | null   |
| 5       | 5       | 2019-07-03  | report | racism |
+---------+---------+-------------+--------+--------+

Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 3       | 2019-07-18  |
+---------+-------------+

Result table:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
The other days had no spam reports so the average is (50 + 100) / 2 = 75%
Note that the output is only one number and that we do not care about the remove dates.


SELECT *
    FROM ACTIONS A
LEFT JOIN REMOVALS B
ON A.POST_ID=B.POST_ID AND  A.ACTION='report'

Only benefit is case me condition nahi lagani padegi

 ["user_id", "post_id", "action_date", "action", "extra", "post_id", "remove_date"], 
 [2, 2, "2019-07-04", "view", null, null, null], 
 [2, 2, "2019-07-04", "report", "spam", 2, "2019-07-20"], 
 [3, 4, "2019-07-04", "view", null, null, null], 
 [3, 4, "2019-07-04", "report", "spam", null, null], 
 

["user_id", "post_id", "action_date", "action", "extra", "post_id", "remove_date"], 
[2, 2, "2019-07-04", "view", null, 2, "2019-07-20"], 
[2, 2, "2019-07-04", "report", "spam", 2, "2019-07-20"], 
[3, 4, "2019-07-04", "view", null, null, null], 
[3, 4, "2019-07-04", "report", "spam", null, null], 

*/

--Didn't used distinct got wrong answer. Struggled very much with this answer.

WITH CTE AS (
SELECT 
    Action_date,
    COUNT(DISTINCT A.post_id) Total_Spam,
    COUNT(DISTINCT B.post_id) Removed_Spam
FROM Actions A
LEFT JOIN Removals B
ON A.post_id=B.post_id
WHERE EXTRA = 'spam'
GROUP BY Action_date)

SELECT ROUND(AVG(Removed_Spam/Total_Spam)*100,2) AS average_daily_percent
FROM cte


-- METHOD 2 
SELECT ROUND(AVG(REMOVAL_RATE)*100,2) AS average_daily_percent
FROM (
SELECT 
    ACTION_DATE,
    COUNT(DISTINCT CASE WHEN EXTRA='spam' THEN B.POST_ID ELSE NULL END)/COUNT(DISTINCT CASE WHEN EXTRA='spam' THEN A.POST_ID ELSE NULL END) AS REMOVAL_RATE   
FROM ACTIONS A
LEFT JOIN REMOVALS B ON 
A.POST_ID=B.POST_ID
GROUP BY 1) AS A