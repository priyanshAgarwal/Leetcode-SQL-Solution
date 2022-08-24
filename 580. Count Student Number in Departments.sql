/*

580. Count Student Number in Departments
Medium

A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.

Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.

The student is described as follow:

| Column Name  | Type      |
|--------------|-----------|
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |
where student_id is the student's ID number, student_name is the student's name, gender is their gender, and dept_id is the department ID associated with their declared major.

And the department table is described as below:

| Column Name | Type    |
|-------------|---------|
| dept_id     | Integer |
| dept_name   | String  |
where dept_id is the department's ID number and dept_name is the department name.

Here is an example input:
student table:

| student_id | student_name | gender | dept_id |
|------------|--------------|--------|---------|
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
department table:

| dept_id | dept_name   |
|---------|-------------|
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
The Output should be:

| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |

*/



SELECT DISTINCT A.DEPT_NAME AS dept_name , COUNT(B.STUDENT_ID) OVER(PARTITION BY A.DEPT_NAME) AS student_number 
FROM DEPARTMENT A
LEFT JOIN STUDENT B
ON A.DEPT_ID=B.DEPT_ID
ORDER BY 2 DESC,1

-- METHOD 1

SELECT D.dept_name, ISNULL(B.student_number,0) AS student_number FROM
department D LEFT JOIN (
SELECT dept_id, COUNT(student_name) AS student_number  FROM student 
GROUP BY dept_id) B
ON D.dept_id=B.dept_id
ORDER BY student_number DESC, D.dept_name ASC

-- METHOD 2
SELECT A.DEPT_NAME, IFNULL(COUNT(STUDENT_ID),0) AS STUDENT_NUMBER FROM DEPARTMENT A
LEFT JOIN STUDENT B
ON A.DEPT_ID=B.DEPT_ID
GROUP BY 1
ORDER BY 2 DESC, 1