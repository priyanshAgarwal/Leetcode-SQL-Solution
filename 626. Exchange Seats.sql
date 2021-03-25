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

{"headers": ["id", "student", "ID_NEW"],
 "values": [[1, "Abbot", 2],
            [2, "Doris", 1],
            [3, "Emerson", 4],
            [4, "Green", 3],
            [5, "Jeames", 6]]}
*/


--Method 1 (Smart use of ROW_NUMBER())
SELECT ROW_NUMBER() OVER( ORDER BY (IF(ID%2=1,id+1,ID-1))) AS ID, STUDENT FROM SEAT;
