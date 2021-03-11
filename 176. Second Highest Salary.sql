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

select ISNULL( (select salary from 
(select  distinct salary, DENSE_RANK() over(ORDER BY SALARY DESC) as SAL from Employee) AS S_R 
where S_R.sal=2) ,NULL) AS SecondHighestSalary ;


