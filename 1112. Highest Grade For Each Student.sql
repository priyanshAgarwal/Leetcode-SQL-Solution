/*

1112. Highest Grade For Each Student

Table: Enrollments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

The query result format is in the following example:

Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+

Result table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+


*/

SELECT 
    student_id, 
    course_id, 
    grade
FROM (SELECT *,
    DENSE_RANK() OVER(PARTITION BY STUDENT_ID ORDER BY GRADE DESC, COURSE_ID ASC) AS RNK
FROM ENROLLMENTS) AS A
WHERE A.RNK=1

-- ANOTHER WAY
SELECT 
    STUDENT_ID,
    MIN(COURSE_ID) AS COURSE_ID,
    GRADE
FROM 
(SELECT *,
    MAX(GRADE) OVER(PARTITION BY STUDENT_ID) AS MAX_GRADE
FROM ENROLLMENTS) AS A
WHERE A.MAX_GRADE=A.GRADE
GROUP BY STUDENT_ID 
-- Wierd that you can group by before or after the aggregation function
SELECT 
    STUDENT_ID,
    MIN(COURSE_ID) AS COURSE_ID,
    GRADE
FROM 
(SELECT *,
    MAX(GRADE) OVER(PARTITION BY STUDENT_ID) AS MAX_GRADE
FROM ENROLLMENTS) AS A
WHERE A.MAX_GRADE=A.GRADE
GROUP BY STUDENT_ID, GRADE