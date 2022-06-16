/*

Points Rating Of Wines Over Time


Interview Question Date: March 2020

Wine Magazine
Hard
Interview Questions
ID 10045
0
0
Find the average points difference between each and previous years starting from the year 2000. Output the year, average points, previous average points, and the difference between them.
If you're unable to calculate the average points rating for a specific year, use an 87 average points rating for that year (which is the average of all wines starting from 2000).



*/

with cte as
(SELECT 
    distinct 
    REGEXP_SUBSTR(title,"[0-9]{4}") as year,
    avg(points) avg_points
from winemag_p2 group by 1)

select 
    year, 
    avg_points, 
    lag(avg_points,1,87) over(order by year) AS prev_avg_points,
    avg_points-lag(avg_points,1,87) over(order by year) AS difference
from cte
where year >=2000