/*

618. Students Report By Geography
Hard

107

125

Add to List

Share
SQL Schema
Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
There is no primary key for this table. It may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.
 

A school has students from Asia, Europe, and America.

Write an SQL query to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The query result format is in the following example.

 

Example 1:

Input: 
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output: 
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+
 

["CONTINENT", "America", "Europe", "Asia"], 
[["America", "Jane", null, null], 
["Europe", null, "Pascal", null], 
["Asia", null, null, "Xi"]]}

Follow up: If it is unknown which continent has the most students, could you write a query to generate the student report?

*/

SELECT 
    MIN(CASE WHEN CONTINENT='America' THEN NAME END) AS America,
    MIN(CASE WHEN CONTINENT='Asia' THEN NAME END) AS Asia,
    MIN(CASE WHEN CONTINENT='Europe' THEN NAME END) AS Europe
FROM (select *,row_number() over(partition by continent order by name) as row_NUM 
from student) A
GROUP BY row_NUM
