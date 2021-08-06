/*

1355. Activity Participants

Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.
Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.
 

Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

The query result format is in the following example:

Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)

{"headers": {"Friends": ["id", "name", "activity"], "Activities": ["id", "name"]}, "rows": 
{"Friends": 
    [[1, "Maria C.", "Eating"], 
    [2, "Jade W.", "Horse Riding"], 
    [3, "Jonathan D.", "Eating"], 
    [4, "Claire C.", "Singing"], 
    [5, "Will W.", "Eating"], 
    [6, "Anna A.", "Horse Riding"], 
    [7, "Daniel D.", "Singing"]],
     "Activities": 
    [[1, "Eating"], [2, "Singing"], [3, "Horse Riding"]]}}

*/

-- LONG MEthod

With activity_count AS (
SELECT DISTINCT activity, COUNT(*) OVER(PARTITION BY ACTIVITY) AS NUM_PAR FROM FRIENDS),

activity_max as (
SELECT NUM_PAR FROM activity_count
ORDER BY NUM_PAR DESC LIMIT 1    
),

activity_min as (
SELECT NUM_PAR FROM activity_count
    ORDER BY NUM_PAR
LIMIT 1
)

SELECT activity AS activity FROM activity_count 
WHERE NUM_PAR NOT IN (SELECT * FROM activity_max)
AND NUM_PAR NOT IN (SELECT * FROM  activity_min); 


-- SHORT METHOD Good For Finding MIN and MAX

WITH CTE AS (
SELECT activity,
        COUNT(ID) AS COUNT_ACTIVITY,
        MAX(COUNT(ID)) OVER() AS MAX_RANK,
        MIN(COUNT(ID)) OVER() AS MIN_RANK
FROM Friends
GROUP BY activity)


SELECT activity FROM CTE
WHERE COUNT_ACTIVITY NOT IN (MAX_RANK,MIN_RANK)