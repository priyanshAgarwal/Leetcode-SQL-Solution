1225. Report Contiguous Dates

WITH CTE AS (
SELECT FAIL_DATE AS DATE, 'failed' AS STATE FROM FAILED 
UNION ALL
SELECT SUCCESS_DATE AS DATE, 'succeeded' AS STATE FROM SUCCEEDED ),


CTE2 AS (
    SELECT *,DENSE_RANK() OVER(PARTITION BY STATE ORDER BY DATE) AS SEQ 
    FROM CTE
    WHERE DATE BETWEEN '2019-01-01' AND '2019-12-31'
),

CTE3 AS (
SELECT *, DATE_ADD(DATE,INTERVAL -SEQ DAY) AS DATE_DROUP
FROM CTE2)

SELECT STATE AS PERIOD_STATE, MIN(DATE) AS START_DATE, MAX(DATE) AS END_DATE 
FROM CTE3
GROUP BY STATE,DATE_DROUP
ORDER BY 2

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

626. Exchange Seats

SELECT ROW_NUMBER() OVER(ORDER BY NEW_ID) AS ID, student FROM (SELECT
CASE 
    WHEN id%2=1 THEN id+1
    ELSE ID-1 END AS NEW_ID,student 
FROM SEAT) A
ORDER BY NEW_ID

-- 
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N=N-1;
  RETURN (
    --   # Write your MySQL query statement below.
    SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT 1 OFFSET N
  );
END