/*
184. Department Highest Salary

The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+

*/

SELECT 
    DEPT_NAME AS DEPARTMENT,
    NAME AS EMPLOYEE,
    SALARY
FROM 
    (SELECT 
        A.NAME, 
        A.SALARY, 
        B.NAME AS DEPT_NAME, 
        DENSE_RANK() OVER(PARTITION BY B.Name ORDER BY A.Salary DESC) AS SALARY_RANK
        FROM EMPLOYEE A
            INNER JOIN DEPARTMENT B
        ON A.DepartmentId=B.ID
    ) AS E_RANK
WHERE E_RANK.SALARY_RANK=1; 


