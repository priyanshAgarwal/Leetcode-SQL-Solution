/*

1225. Report Contiguous Dates

Hard

Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.
Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

The query result format is in the following example:

Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+


Result table:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+

The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".

-- Consecutive Dates


*/


-- My Code (Easy to Understand)

WITH CTE AS (
SELECT *, DENSE_RANK() OVER(ORDER BY DATE)- DENSE_RANK() OVER(PARTITION BY STATE ORDER BY DATE) AS STATE_GROUP
FROM (
SELECT FAIL_DATE AS DATE, 'failed' AS STATE FROM FAILED
UNION ALL
SELECT SUCCESS_DATE AS DATE, 'succeeded' AS STATE FROM SUCCEEDED) A
WHERE DATE BETWEEN '2019-01-01' AND '2019-12-31'
ORDER BY STATE_GROUP)

SELECT STATE AS PERIOD_STATE, MIN(DATE) AS START_DATE, MAX(DATE) AS END_DATE
FROM CTE
GROUP BY STATE, STATE_GROUP
ORDER BY START_DATE

--Shorter Answer
WITH CTE AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY STATE ORDER BY DATE) AS SEQ FROM(
SELECT FAIL_DATE AS DATE, 'failed' AS STATE FROM FAILED
UNION ALL
SELECT SUCCESS_DATE AS DATE, 'succeeded' AS STATE FROM SUCCEEDED) AS A
WHERE A.DATE BETWEEN '2019-01-01' AND '2019-12-31')


SELECT STATE AS PERIOD_STATE, MIN(DATE) AS START_DATE, MAX(DATE) AS END_DATE
FROM CTE
GROUP BY DATE_SUB(DATE,INTERVAL SEQ DAY),STATE
ORDER BY 2


with a as (
(select fail_date as date,
'failed' as period_state
from failed
)
union all
(select success_date as date,
'succeeded' as period_state
from succeeded)
),

b as (
select date,
period_state,
dense_rank() over (partition by period_state order by date asc) as seq
from a where date between '2019-01-01' and '2019-12-31'
)

select period_state, min(date) as start_date, max(date) as end_date from b
group by DATE_SUB(date,INTERVAL seq DAY),period_state
order by start_date asc

