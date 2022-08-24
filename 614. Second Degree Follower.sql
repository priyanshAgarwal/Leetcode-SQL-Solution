/*

614. Second Degree Follower

In facebook, there is a follow table with two columns: followee, follower.

Please write a sql query to get the amount of each follower’s follower if he/she has one.

For example:

+-------------+------------+
| followee    | follower   |
+-------------+------------+
|     A       |     B      |
|     B       |     C      |
|     B       |     D      |
|     D       |     E      |
+-------------+------------+
should output:
+-------------+------------+
| follower    | num        |
+-------------+------------+
|     B       |  2         |
|     D       |  1         |
+-------------+------------+



Explaination:
Both B and D exist in the follower list, when as a followee, B's follower is C and D, 
and D's follower is E. A does not exist in follower list.
 

Note:
Followee would not follow himself/herself in all cases.
Please display the result in follower's alphabet order.

["followee", "follower", "followee", "follower"], 
["Alice", "Bob", "Bob", "Cena"], 
["Alice", "Bob", "Bob", "Donald"], 
["Bob", "Donald", "Donald", "Edward"]]}

*/

-- Ask Interviewer if there for distinct cases, Ki if same user is following again or not

SELECT 
    B.followee AS follower, 
    COUNT(DISTINCT B.follower) AS NUM 
FROM FOLLOW A
INNER JOIN FOLLOW B
On A.follower=B.followee 
GROUP BY B.followee