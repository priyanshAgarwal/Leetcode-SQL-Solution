/*
1270. All People Report to the Given Manager

Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports
 his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.
 

Write an SQL query to find employee_id of all employees that directly or indirectly report their 
work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly. 

Using a SQL Server recursive CTE to query hierarchical data (When there is hierarchy in the data use this)

COUNT 1 TO 50
WITH   cte
AS     (SELECT 1 AS n -- anchor member
        UNION ALL
        SELECT n + 1 -- recursive member
        FROM   cte
        WHERE  n < 50 -- terminator
       )
SELECT n
FROM   cte;


*/

WITH RECURSIVE CTE AS(
    SELECT EMPLOYEE_ID, 1 AS LVL 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID!=1 AND MANAGER_ID=1
    UNION ALL
    SELECT B.EMPLOYEE_ID, LVL+1 AS LVL 
    FROM CTE A 
    INNER JOIN EMPLOYEES B 
    ON A.EMPLOYEE_ID=B.MANAGER_ID
)

SELECT employee_id
FROM CTE
