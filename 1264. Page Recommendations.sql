/*
1264. Page Recommendations
Medium

154

12

Add to List

Share
SQL Schema
Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
 

Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key for this table.
Each row of this table indicates that user_id likes page_id.
 

Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

Return result table in any order without duplicates.

The query result format is in the following example.

 

Example 1:

Input: 
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+
Output: 
+------------------+
| recommended_page |
+------------------+
| 23               |
| 24               |
| 56               |
| 33               |
| 77               |
+------------------+
Explanation: 
User one is friend with users 2, 3, 4 and 6.
Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
Page 77 is suggested from both user 2 and user 3.
Page 88 is not suggested because user 1 already likes it.
*/

WITH ALL_USERS 
AS (
SELECT user2_id AS USER_ID FROM friendship 
WHERE user1_id = 1 
    UNION ALL
SELECT user1_id AS USER_ID FROM friendship 
WHERE user2_id = 1 
)

SELECT DISTINCT B.page_id AS recommended_page FROM ALL_USERS A
INNER JOIN LIKES B
ON A.USER_ID=B.USER_ID 
WHERE B.page_id NOT IN (SELECT PAGE_ID FROM LIKES WHERE USER_ID=1)
ORDER BY 1