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

-- Pandas

import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:

    result_df = pd.merge(employee, employee, left_on='managerId', right_on='id', how='inner').rename(   
        columns = 
            {'name_x':'employee_name',
            'salary_x':'employee_salary',
            'name_y':'manager_name',
            'salary_y':'manager_salary'})[['employee_name','employee_salary','manager_name','manager_salary']]
    
    emp=result_df[result_df['employee_salary']>result_df['manager_salary']][['employee_name']].rename(columns={'employee_name':'Employee'})
    return emp


import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    emp = pd.merge(employee, employee, 
                left_on='managerId', 
                right_on='id', 
                how='inner')\
            .query("salary_x>salary_y")[['name_x']]\
            .rename(columns={'name_x':'Employee'})
    return emp