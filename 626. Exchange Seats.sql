/*
626. Exchange Seats

Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.

Mary wants to change seats for the adjacent students.

Can you write a SQL query to output the result for Mary?

 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:

If the number of students is odd, there is no need to change the last one's seat.

*/

SELECT L1.NUM AS ConsecutiveNums  
FROM
Logs L1,
Logs L2,
Logs L3
WHERE L1.ID=L2.ID-1 -- First two lines are to get consecutive we have to do                    
AND L2.ID=L3.ID-1   -- ID and next two lines to get the numbers
AND L1.NUM=L2.NUM
AND L2.NUM=L3.NUM;


