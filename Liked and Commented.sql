/*


Liked and Commented
8
Have you seen this question before?
Question
You’re given two tables, users and events. The events table holds values of all of the user events in the action column (‘like’, ‘comment’, or ‘post’).

Write a query to get the percentage of users that have never liked or commented. Round to two decimal places.


*/

-- BASIC METHOD
select round(count(distinct id)/(select count(distinct id) from users),2) as percent_never
from users  
where id not in 
(select distinct user_id from events 
where action in ('like', 'comment'))

-- SMART SOLUTION 
SELECT 
ROUND(COUNT(DISTINCT CASE WHEN B.USER_ID IS NULL THEN A.ID END)*1.0/COUNT(DISTINCT A.ID),2) AS percent_never 
FROM users  A
LEFT JOIN (SELECT
        USER_ID
    FROM events
    WHERE ACTION IN ('like', 'comment')
    GROUP BY user_id) B
ON A.ID=B.USER_ID 

-- METHOD 1
SELECT 
ROUND(COUNT(DISTINCT CASE WHEN ACTION_TYPE=0 THEN ID END)*1.0/COUNT(DISTINCT ID),2) AS percent_never 
FROM 
(SELECT 
    A.ID,
    CASE 
        WHEN B.action='like' THEN 1 
        WHEN B.action='comment' THEN 1 
        ELSE 0 
    END 'ACTION_TYPE'
FROM users A
LEFT JOIN events B
ON A.ID=B.USER_ID AND action IN ('like','comment')
GROUP BY 1
ORDER BY 1) AS A


-- METHOD 2
SELECT ROUND(COUNT(DISTINCT CASE WHEN NOTHING=1 THEN ID END)/COUNT(DISTINCT ID),2) AS percent_never
FROM 
(SELECT 
    A.ID,
    MAX(CASE WHEN B.action='like' OR B.action='comment' THEN 1 ELSE 0 END) AS 'LIKE_COMMENT',
    MAX(CASE WHEN B.action IS NULL THEN 1 ELSE 0 END) AS 'NOTHING'
FROM users A
LEFT JOIN events B
ON A.ID=B.USER_ID AND action IN ('like','comment')
GROUP BY 1) AS A