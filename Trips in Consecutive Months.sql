/*
Trips in Consecutive Months
Find the IDs of the drivers who completed at least one trip in at least two consecutive months.



*/

-- METHOD 1
SELECT DISTINCT DRIVER_ID FROM (SELECT 
    DRIVER_ID,
    TRIP_DATE,
    LEAD(TRIP_DATE,1) OVER(PARTITION BY DRIVER_ID ORDER BY TRIP_DATE) AS NEXT_DATE
from uber_trips
where is_completed = 1) A
WHERE MONTH(NEXT_DATE)=MONTH(DATE_ADD(TRIP_DATE,interval 1 month));

-- METHOD 2
SELECT distinct
    a.driver_id
FROM
    uber_trips a
    JOIN uber_trips b
    ON a.driver_id = b.driver_id
    AND MONTH(DATE_ADD(a.trip_date, INTERVAL 1 MONTH)) = MONTH(b.trip_date)
WHERE a.is_completed = True AND b.is_completed = True

-- METHOD 3
with base as (
Select * from (
select  month(trip_date) a ,
driver_id, MONTH(lag(trip_date) over(partition by driver_id order by trip_date)) l
from uber_trips
where is_completed = 1
) b 
)

select  distinct driver_id from base where a-l=1 or a-l=-11