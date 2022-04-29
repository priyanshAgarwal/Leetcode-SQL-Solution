/*
Calculate a rolling average of total revenue

For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. Output should contain date and revenue columns, sorted by the date. Remember to account for the possibility of a day having zero revenue. This one's a bit tough, so don't be afraid to check out the hint!


https://pgexercises.com/questions/aggregates/rollingavg.html


*/
WITH CTE AS (
SELECT A.DATE, COALESCE(REVENUE_DAILY,0) AS REVENUE_DAILY FROM (
  SELECT cast(generate_series(timestamp '2012-07-10', '2012-08-31','1 day') as date) AS DATE)
  AS A
  INNER JOIN 
  (SELECT 
	DATE(A.STARTTIME) AS DATE,
	SUM(CASE WHEN A.MEMID=0 THEN SLOTS*GUESTCOST ELSE SLOTS*MEMBERCOST END) AS REVENUE_DAILY
FROM CD.BOOKINGS A
INNER JOIN CD.FACILITIES B
ON A.FACID=B.FACID
GROUP BY 1
ORDER BY 1) B
ON A.DATE=B.DATE)

SELECT * FROM(SELECT DATE,
		AVG(REVENUE_DAILY) over(order by date rows 14 preceding) as avgrev
FROM CTE) AS A
WHERE A.DATE>='2012-08-01'






