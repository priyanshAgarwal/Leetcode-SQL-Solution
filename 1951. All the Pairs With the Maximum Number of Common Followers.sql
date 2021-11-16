/*

1951. All the Pairs With the Maximum Number of Common Followers
Medium

SQL Schema
Table: Relations

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key for this table.
Each row of this table indicates that the user with ID follower_id is following the user with ID user_id.
 

Write an SQL query to find all the pairs of users with the maximum number of common followers. In other words, if the maximum number of common followers between any two users is maxCommon, then you have to return all pairs of users that have maxCommon common followers.

The result table should contain the pairs user1_id and user2_id where user1_id < user2_id.

Return the result table in any order.

The query result format is in the following example:

 

Relations table:
+---------+-------------+
| user_id | follower_id |
+---------+-------------+
| 1       | 3           |
| 2       | 3           |
| 7       | 3           |
| 1       | 4           |
| 2       | 4           |
| 7       | 4           |
| 1       | 5           |
| 2       | 6           |
| 7       | 5           |
+---------+-------------+

Result table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 7        |
+----------+----------+

Users 1 and 2 have 2 common followers (3 and 4).
Users 1 and 7 have 3 common followers (3, 4, and 5).
Users 2 and 7 have 2 common followers (3 and 4).
Since the maximum number of common followers between any two users is 3, we return all pairs of users with 3 common followers, which is only the pair (1, 7). We return the pair as (1, 7), not as (7, 1).
Note that we do not have any information about the users that follow users 3, 4, and 5, so we consider them to have 0 followers.


*/


WITH CTE AS (
SELECT 
    USER1_ID,
    USER2_ID,
    DENSE_RANK() OVER(ORDER BY COMMON_USER DESC) AS USER_RANK
FROM (
SELECT 
    A.USER_ID AS USER1_ID,
    B.USER_ID AS USER2_ID,
    COUNT(A.FOLLOWER_ID) AS COMMON_USER
FROM RELATIONS A
INNER JOIN RELATIONS B
WHERE A.FOLLOWER_ID=B.FOLLOWER_ID AND A.USER_ID<B.USER_ID
GROUP BY 1,2
ORDER BY COUNT(A.FOLLOWER_ID) DESC) AS A)

SELECT 
USER1_ID,
USER2_ID
FROM CTE
WHERE USER_RANK=1