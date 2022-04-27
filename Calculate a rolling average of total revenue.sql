/*

For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. Output should contain date and revenue columns, sorted by the date. Remember to account for the possibility of a day having zero revenue. This one's a bit tough, so don't be afraid to check out the hint!


https://pgexercises.com/questions/aggregates/rollingavg.html


*/
WITH CTE AS (SELECT * FROM (select
			cast(generate_series(timestamp '2012-07-10', '2012-08-31','1 day') as date) as date
		)  as dategen
		left outer join
			-- left join to a table of per-day revenue
			(select cast(bks.starttime as date) as date,
				sum(case
					when memid = 0 then slots * facs.guestcost
					else slots * membercost
				end) as rev

				from cd.bookings bks
				inner join cd.facilities facs
					on bks.facid = facs.facid
				group by cast(bks.starttime as date)
			) as revdata
			on dategen.date = revdata.date)
			
			
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
GROUP BY 1) B
ON A.DATE=B.DATE)






