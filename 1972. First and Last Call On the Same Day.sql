/*

1972. First and Last Call On the Same Day
Hard

50

12

Add to List

Share
SQL Schema
Table: Calls

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| caller_id    | int      |
| recipient_id | int      |
| call_time    | datetime |
+--------------+----------+
(caller_id, recipient_id, call_time) is the primary key for this table.
Each row contains information about the time of a phone call between caller_id and recipient_id.
 

Write an SQL query to report the IDs of the users whose first and last calls on any day were with the same person. Calls are counted regardless of being the caller or the recipient.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Calls table:
+-----------+--------------+---------------------+
| caller_id | recipient_id | call_time           |
+-----------+--------------+---------------------+
| 8         | 4            | 2021-08-24 17:46:07 |
| 4         | 8            | 2021-08-24 19:57:13 |
| 5         | 1            | 2021-08-11 05:28:44 |
| 8         | 3            | 2021-08-17 04:04:15 |
| 11        | 3            | 2021-08-17 13:07:00 |
| 8         | 11           | 2021-08-17 22:22:22 |
+-----------+--------------+---------------------+
Output: 
+---------+
| user_id |
+---------+
| 1       |
| 4       |
| 5       |
| 8       |
+---------+
Explanation: 
On 2021-08-24, the first and last call of this day for user 8 was with user 4. User 8 should be included in the answer.
Similarly, user 4 on 2021-08-24 had their first and last call with user 8. User 4 should be included in the answer.
On 2021-08-11, user 1 and 5 had a call. This call was the only call for both of them on this day. Since this call is the first and last call of the day for both of them, they should both be included in the answer.


["user_id", "reciever_id", "call_time", "FIRST_VALUE_USER", "LAST_VALUE_USER"]
    
[1, 5, "2021-08-11", 5, 5], 
[3, 8, "2021-08-17", 8, 11], 
[3, 11, "2021-08-17", 8, 11], 
[4, 8, "2021-08-24", 8, 8], 
[5, 1, "2021-08-11", 1, 1], 
[8, 3, "2021-08-17", 3, 11], 
[8, 11, "2021-08-17", 3, 11], 
[8, 4, "2021-08-24", 4, 4], 
[11, 3, "2021-08-17", 3, 8], 
[11, 8, "2021-08-17", 3, 8]]}

Earlier I was using MAX and MIN instead of FIRST_VALUE and LAST_VALUE which was 
giving me max and min on the basis of user ID which was so stupid, so FIRST AND LAST VALUE

The conclusion here is simple - MAX() is useful, but do not conflate it with LAST_VALUE() in time-based data. You might be skewing your results.


*/

with all_Callers as (
select caller_id user_id, recipient_id as reciever_id  , call_time from Calls
union 
select recipient_id v, caller_id as  reciever_id ,call_time from Calls
),

CTE2 AS (
SELECT DISTINCT user_id, call_time,
LAST_VALUE(reciever_id) OVER(PARTITION BY user_id, DAY(call_time)) AS LAST_USER,
FIRST_VALUE(reciever_id) OVER(PARTITION BY user_id, DAY(call_time)) AS FIRST_USER 
FROM all_Callers)


SELECT user_id FROM CTE2
WHERE LAST_USER=FIRST_USER
GROUP BY 1