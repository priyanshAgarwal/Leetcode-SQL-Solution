/*

1412. Find the Quiet Students in All Exams
Hard

129

9

Add to List

Share
SQL Schema
Table: Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key for this table.
student_name is the name of the student.
 

Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key for this table.
Each row of this table indicates that the student with student_id had a score points in the exam with id exam_id.
 

A quiet student is the one who took at least one exam and did not score the high or the low score.

Write an SQL query to report the students (student_id, student_name) being quiet in all exams. Do not return the student who has never taken any exam.

Return the result table ordered by student_id.

The query result format is in the following example.

 

Example 1:

Input: 
Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+
Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+
Output: 
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+
Explanation: 
For exam 1: Student 1 and 3 hold the lowest and high scores respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high scores respectively.
Student 2 and 5 have never got the highest or lowest in any of the exams.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.

*/



WITH MAX_MIN_SCORE AS (
SELECT 
*,
MAX(SCORE) OVER(PARTITION BY EXAM_ID) AS MAX_SCORE,
MIN(SCORE) OVER(PARTITION BY EXAM_ID) AS MIN_SCORE
FROM EXAM),

-- ["exam_id", "student_id", "score", "MAX_SCORE", "MIN_SCORE"], 
-- [10, 1, 70, 90, 70],
-- [10, 2, 80, 90, 70],
-- [10, 3, 90, 90, 70], 
-- [20, 1, 80, 80, 80], 
-- [30, 1, 70, 90, 70], 
-- [30, 3, 80, 90, 70], 
-- [30, 4, 90, 90, 70], 
-- [40, 1, 60, 80, 60], 
-- [40, 2, 70, 80, 60],
-- [40, 4, 80, 80, 60]


GET_STUDENT AS (
SELECT 
    DISTINCT STUDENT_ID
FROM MAX_MIN_SCORE
WHERE SCORE>MIN_SCORE
    AND SCORE<MAX_SCORE 
    AND STUDENT_ID NOT IN (
        SELECT STUDENT_ID FROM MAX_MIN_SCORE
        WHERE SCORE=MAX_SCORE OR SCORE=MIN_SCORE ))
        
SELECT B.* FROM GET_STUDENT A
INNER JOIN STUDENT B
ON A.STUDENT_ID=B.STUDENT_ID