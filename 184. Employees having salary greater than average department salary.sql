/*
184. Employees having salary greater than average department salary
 
Medium

SQL Schema
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| Id           | int     |
| Name         | varchar |
| Salary       | int     |
| DepartmentId | int     |
+--------------+---------+
Id is the primary key column for this table.
DepartmentId is a foreign key of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| Id          | int     |
| Name        | varchar |
+-------------+---------+
Id is the primary key column for this table.
Each row of this table indicates the ID of a department and its name.
 

Write an SQL query to find employees who have the highest salary in each of the departments.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| Id | Name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+



["Id", "Name", "Salary", "DepartmentId", "SAL_RANK", "DEPT_BUDGET", "COMPANY_BUDGET", "NUM_EMP"]
[2, "Jim", 90000, 1, 1, 250000, 390000, 3], 
[5, "Max", 90000, 1, 1, 250000, 390000, 3], 
[1, "Joe", 70000, 1, 2, 250000, 390000, 3], 
[3, "Henry", 80000, 2, 1, 140000, 390000, 2], 
[4, "Sam", 60000, 2, 2, 140000, 390000, 2]]}
*/

WITH CTE AS (
SELECT *, 
    DENSE_RANK() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) SAL_RANK, 
    SUM(SALARY) OVER(PARTITION BY DEPARTMENTID) AS DEPT_BUDGET, -- This will get salary budget on department
    SUM(SALARY) OVER() AS COMPANY_BUDGET, -- This will give whole company budget
    COUNT(DEPARTMENTID) OVER(PARTITION BY DEPARTMENTID) AS NUM_EMP -- count number of employess in that department
FROM EMPLOYEE)

SELECT DepartmentId, NAME, SALARY, DEPT_BUDGET/NUM_EMP AS AVG_SPEND_ON_DEPT 
FROM CTE
WHERE SALARY>DEPT_BUDGET/NUM_EMP


/*
Result

["DepartmentId", "NAME", "SALARY", "AVG_SPEND_ON_DEPT"]
[1, "Jim", 90000, 83333.33], 
[1, "Max", 90000, 83333.33], 
[2, "Henry", 80000, 70000.00]
*/