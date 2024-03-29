/*

579. Find Cumulative Salary of an Employee

Hard


Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| Id          | int  |
| Month       | int  |
| Salary      | int  |
+-------------+------+
(Id, Month) is the primary key for this table.
Each row in the table indicates the salary of an employee in one month during the year 2020.
 

Write an SQL query to calculate the cumulative salary summary for every employee in a single unified table.

The cumulative salary summary for an employee can be calculated as follows:

For each month that the employee worked, sum up the salaries in that month and the previous two months. This is their 3-month sum for that month. If an employee did not work for the company in previous months, their effective salary for those months is 0.
Do not include the 3-month sum for the most recent month that the employee worked for in the summary.
Do not include the 3-month sum for any month the employee did not work.
Return the result table ordered by Id in ascending order. In case of a tie, order it by Month in descending order.

The query result format is in the following example:

 

Employee table:
+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
| 1  | 7     | 90     |
| 1  | 8     | 90     |
+----+-------+--------+

Result table:
+----+-------+--------+
| id | month | Salary |
+----+-------+--------+
| 1  | 4     | 130    |
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
+----+-------+--------+

Employee '1' has five salary records excluding their most recent month '8':
- 90 for month '7'.
- 60 for month '4'.
- 40 for month '3'.
- 30 for month '2'.
- 20 for month '1'.
So the cumulative salary summary for this employee is:
+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 1  | 7     | 90     |  (90 + 0 + 0)
| 1  | 4     | 130    |  (60 + 40 + 30)
| 1  | 3     | 90     |  (40 + 30 + 20)
| 1  | 2     | 50     |  (30 + 20 + 0)
| 1  | 1     | 20     |  (20 + 0 + 0)
+----+-------+--------+
Note that the 3-month sum for month '7' is 90 because they did not work during month '6' or month '5'.

Employee '2' only has one salary record (month '1') excluding their most recent month '2'.
+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 2  | 1     | 20     |  (20 + 0 + 0)
+----+-------+--------+

Employee '3' has two salary records excluding their most recent month '4':
- 60 for month '3'.
- 40 for month '2'.
So the cumulative salary summary for this employee is:
+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 3  | 3     | 100    |  (60 + 40 + 0)
| 3  | 2     | 40     |  (40 + 0 + 0)
+----+-------+--------+

*/

with recursive cte() as (
select 1 AS month
    union all
select month + 1 from cte where month < 12
),

cte1 as (
select distinct id, cte.month from Employee, cte
)

select id, month, salary
from
(select 
cte1.id, 
cte1.month, 
sum(coalesce(salary, 0)) over (partition by cte1.id order by cte1.month rows between 2 preceding and current row) as salary,
max(e.month) over (partition by e.id) as max_month,
e.month as mon
from Employee e
right join cte1 on e.month = cte1.month and e.id = cte1.id
order by cte1.id, cte1.month desc) a
where mon is not null
and mon != max_month


-- Very Short Code
WITH CUM_SALARY AS (
SELECT 
    ID,
    MONTH,
    SUM(SALARY) OVER(PARTITION BY ID ORDER BY MONTH RANGE BETWEEN 2 PRECEDING AND CURRENT ROW) AS SALARY_CUM,
    DENSE_RANK() OVER(PARTITION BY ID ORDER BY MONTH DESC) AS MOST_RECENT
FROM EMPLOYEE
ORDER BY 1)

SELECT id, month, SALARY_CUM AS Salary FROM CUM_SALARY
WHERE MOST_RECENT!=1
ORDER BY 1,2 DESC 

-- Long Method but Explainable 
WITH RECURSIVE CTE AS (
    SELECT 
        ID,
        MIN(MONTH) AS MIN_MONTH,
        MAX(MONTH) AS MAX_MONTH
    FROM EMPLOYEE GROUP BY ID
    UNION ALL
    SELECT ID, MIN_MONTH+1 AS MIN_MONTH, MAX_MONTH
    FROM CTE WHERE MIN_MONTH<MAX_MONTH
),

CTE_2 AS ( 
SELECT 
        A.ID,
        A.MIN_MONTH AS MONTH,
        IFNULL(B.SALARY,0) AS SALARY
FROM CTE A
LEFT JOIN EMPLOYEE B
ON A.ID=B.ID AND A.MIN_MONTH=B.MONTH),


CUM_SALARY AS (
SELECT 
    ID,
    MONTH,
    SUM(SALARY) OVER(PARTITION BY ID ORDER BY MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS SALARY
FROM CTE_2
ORDER BY 1),

FINAL_RESULT AS (
SELECT ID, MONTH, SALARY FROM (
SELECT *, DENSE_RANK() OVER(PARTITION BY ID ORDER BY MONTH DESC) AS MOST_RECENT FROM CUM_SALARY) A WHERE A.MOST_RECENT!=1)

SELECT A.ID, A.MONTH, B.SALARY FROM EMPLOYEE A
INNER JOIN FINAL_RESULT B ON A.ID=B.ID AND A.MONTH=B.MONTH 
ORDER BY ID, MONTH DESC