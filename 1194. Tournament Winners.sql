/*

1194. Tournament Winners
Hard

81

34

Add to List

Share
SQL Schema
Table: Players

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key of this table.
Each row of this table indicates the group of each player.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     | 
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belong to the same group.
 

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+
Output: 
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |
+-----------+------------+

*/


WITH CTE AS (
SELECT PLAYER, SUM(SCORE) AS SCORE
FROM (
SELECT FIRST_PLAYER AS PLAYER, FIRST_SCORE AS SCORE FROM MATCHES
UNION ALL
SELECT SECOND_PLAYER, SECOND_SCORE FROM MATCHES) AS A
GROUP BY 1)

SELECT GROUP_ID AS group_id  ,PLAYER AS player_id 
FROM (
SELECT PLAYER, SCORE, GROUP_ID, ROW_NUMBER() OVER(PARTITION BY GROUP_ID ORDER BY SCORE DESC, PLAYER) AS PLAYER_RANK  FROM CTE A
INNER JOIN PLAYERS B
ON A.PLAYER=B.PLAYER_ID) AS A
WHERE A.PLAYER_RANK=1

