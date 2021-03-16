/*
185. Department Top Three Salaries

The Employee table holds all employees. Every employee has an Id, and there is also a
column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. 
For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+

{"headers": ["NAME", "SALARY", "Name", "SALARY_RANK"], "values":
 [["Max", 90000, "IT", 1], ["Joe", 85000, "IT", 2], ["Randy", 85000, "IT", 2],
["Will", 70000, "IT", 3], ["Janet", 69000, "IT", 4],
 ["Henry", 80000, "Sales", 1],
 ["Sam", 60000, "Sales", 2]]}


*/



SELECT 
    DEPT_NAME AS DEPARTMENT,
    NAME AS EMPLOYEE,
    SALARY
FROM 
    (SELECT A.NAME, A.SALARY, B.NAME AS DEPT_NAME, 
        DENSE_RANK() OVER(PARTITION BY B.Name ORDER BY A.Salary DESC) AS SALARY_RANK
        FROM EMPLOYEE A
            LEFT JOIN DEPARTMENT B
        ON A.DepartmentId=B.ID
    ) AS E_RANK
WHERE E_RANK.SALARY_RANK<4; 
