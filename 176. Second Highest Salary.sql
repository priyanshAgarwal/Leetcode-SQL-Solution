/*
176. Second Highest Salary
Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

*/
-- Import Point to understand here is inner query will take care of the NULL values if the table is empty.
-- This solution only took 154ms


SELECT (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1)  AS SecondHighestSalary;


-- Use of Rank, Query took 854ms, Remember ISNULL is important in case there is no Data.
-- Dense Rank is much more usefull here, because Dense Rank won't skip the number. 

SELECT ISNULL( (SELECT SALARY FROM 
(SELECT  DISTINCT SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS SAL_RANK from Employee) AS SR 
WHERE SR.SAL_RANK=2) ,NULL) AS SecondHighestSalary ;


