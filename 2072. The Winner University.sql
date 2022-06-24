/*

2072. The Winner University
Easy

31

2

Add to List

Share
SQL Schema
Table: NewYork

+-------------+------+
| Column Name | Type |
+-------------+------+
| student_id  | int  |
| score       | int  |
+-------------+------+
student_id is the primary key for this table.
Each row contains information about the score of one student from New York University in an exam.
 

Table: California

+-------------+------+
| Column Name | Type |
+-------------+------+
| student_id  | int  |
| score       | int  |
+-------------+------+
student_id is the primary key for this table.
Each row contains information about the score of one student from California University in an exam.
 

There is a competition between New York University and California University. The competition is held between the same number of students from both universities. The university that has more excellent students wins the competition. If the two universities have the same number of excellent students, the competition ends in a draw.

An excellent student is a student that scored 90% or more in the exam.

Write an SQL query to report:

"New York University" if New York University wins the competition.
"California University" if California University wins the competition.
"No Winner" if the competition ends in a draw.
The query result format is in the following example.

 

Example 1:

Input: 
NewYork table:
+------------+-------+
| student_id | score |
+------------+-------+
| 1          | 90    |
| 2          | 87    |
+------------+-------+
California table:
+------------+-------+
| student_id | score |
+------------+-------+
| 2          | 89    |
| 3          | 88    |
+------------+-------+
Output: 
+---------------------+
| winner              |
+---------------------+
| New York University |
+---------------------+
Explanation:
New York University has 1 excellent student, and California University has 0 excellent students.
Example 2:

Input: 
NewYork table:
+------------+-------+
| student_id | score |
+------------+-------+
| 1          | 89    |
| 2          | 88    |
+------------+-------+
California table:
+------------+-------+
| student_id | score |
+------------+-------+
| 2          | 90    |
| 3          | 87    |
+------------+-------+
Output: 
+-----------------------+
| winner                |
+-----------------------+
| California University |
+-----------------------+
Explanation:
New York University has 0 excellent students, and California University has 1 excellent student.
Example 3:

Input: 
NewYork table:
+------------+-------+
| student_id | score |
+------------+-------+
| 1          | 89    |
| 2          | 90    |
+------------+-------+
California table:
+------------+-------+
| student_id | score |
+------------+-------+
| 2          | 87    |
| 3          | 99    |
+------------+-------+
Output: 
+-----------+
| winner    |
+-----------+
| No Winner |
+-----------+
Explanation:
Both New York University and California University have 1 excellent student.



*/

WITH CTE AS(
SELECT 
    COUNT(CASE WHEN A.SCORE>=90 THEN A.STUDENT_ID END) AS NUM_STUDENT_NEW_YORK,
    COUNT(CASE WHEN B.SCORE>=90 THEN B.STUDENT_ID END) AS NUM_STUDENT_CALI
FROM NEWYORK A, CALIFORNIA B)


SELECT 
    CASE 
        WHEN NUM_STUDENT_NEW_YORK>NUM_STUDENT_CALI THEN 'New York University'
        WHEN NUM_STUDENT_NEW_YORK<NUM_STUDENT_CALI THEN 'California University'
        ELSE 'No Winner'
    END AS winner
FROM CTE