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

["DATE", "STATE", "SEQ", "DATE_DROUP"],
["2019-01-04", "failed", 1, "2019-01-03"], 
["2019-01-05", "failed", 2, "2019-01-03"], 
["2019-01-01", "succeeded", 1, "2018-12-31"], 
["2019-01-02", "succeeded", 2, "2018-12-31"], 
["2019-01-03", "succeeded", 3, "2018-12-31"], 
["2019-01-06", "succeeded", 4, "2019-01-02"]]}

*/


-- My Code (Easy to Understand)

WITH CTE AS (
SELECT FAIL_DATE AS DATE, 'failed' AS STATUS FROM FAILED
UNION ALL
SELECT SUCCESS_DATE AS DATE, 'succeeded' AS STATUS FROM SUCCEEDED),

CTE2 AS (
SELECT *, 
    DENSE_RANK() OVER(ORDER BY DATE) AS COL1,
    DENSE_RANK() OVER(PARTITION BY STATUS ORDER BY DATE) AS COL2
FROM CTE
WHERE DATE BETWEEN '2019-01-01' AND '2019-12-31'
),

CTE3 AS (
    SELECT *, COL1-COL2 AS GROUPING_DATE FROM CTE2 
)

SELECT STATUS AS period_state , MIN(DATE) AS start_date, MAX(DATE) AS end_date     
FROM CTE3
GROUP BY STATUS,GROUPING_DATE
ORDER BY 2,3

--Shorter Answer
WITH CTE AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY STATE ORDER BY DATE) AS SEQ 
FROM(
SELECT FAIL_DATE AS DATE, 'failed' AS STATE FROM FAILED
UNION ALL
SELECT SUCCESS_DATE AS DATE, 'succeeded' AS STATE FROM SUCCEEDED) AS A
WHERE A.DATE BETWEEN '2019-01-01' AND '2019-12-31')


SELECT STATE AS PERIOD_STATE, MIN(DATE) AS START_DATE, MAX(DATE) AS END_DATE
FROM CTE
GROUP BY DATE_SUB(DATE,INTERVAL SEQ DAY),STATE
ORDER BY 2

-- 

