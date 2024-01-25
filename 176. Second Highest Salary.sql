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
-- Use of Rank, Query took 854ms, Remember ISNULL is important in case there is no Data.
-- Dense Rank is much more usefull here, because Dense Rank won't skip the number. 

/*
Why RANK() won't work 

| id | salary | Sal_Rank |
| -- | ------ | -------- |
| 1  | 100    |    1     |
| 2  | 100    |    1     |
| 3  | 50     |    3     |

So you are missing rank number 2 even thought it is there. 

ROW_NUMBER()

| id | salary | Sal_Rank |
| -- | ------ | -------- |
| 1  | 100    |    1     |
| 2  | 100    |    2     |
| 3  | 50     |    3     |

Your Second Highest becomes third highest 

*/

SELECT ISNULL( (SELECT SALARY FROM 
(SELECT  DISTINCT SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS SAL_RANK from Employee) AS SR 
WHERE SR.SAL_RANK=2) ,NULL) AS SecondHighestSalary ;


-- If Data can't find the second highest then NUll would be returned for NULL
SELECT MAX(SALARY) AS SecondHighestSalary 
FROM (SELECT SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS SAL_RANK
FROM EMPLOYEE) AS A
WHERE A.SAL_RANK=2
