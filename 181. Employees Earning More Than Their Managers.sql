/*
181. Employees Earning More Than Their Managers

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+

*/

SELECT C.NAME AS Employee FROM (SELECT 
    A.ID,
    A.Name, 
    A.Salary, 
    A.ManagerId, 
    B.Name AS ManagerName, 
    B.Salary AS ManagerSalary
FROM Employee A, Employee B
WHERE A.ManagerId=B.ID
AND A.SALARY>B.Salary) C;


-- UPDATED METHOD
SELECT A.NAME AS Employee 
FROM EMPLOYEE A
INNER JOIN EMPLOYEE B
ON B.ID=A.MANAGERID
WHERE A.SALARY>B.SALARY

-- OTHER WAY ROUND
SELECT B.NAME AS Employee 
FROM EMPLOYEE A
INNER JOIN EMPLOYEE B
ON A.ID=B.MANAGERID
WHERE B.SALARY>A.SALARY

