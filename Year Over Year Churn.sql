/*
Year Over Year Churn
Find whether the number of drivers that have churned increased or decreased in each year compared to the previous one. Output the year (specifically, you can use the year the driver left Lyft) along with the corresponding number of churns in that year, the number of churns in the previous year, and an indication on whether the number has been increased (output the value 'increase') or decreased (output the value 'decrease'). Order records by the year in ascending order.



*/

with cte as (select *, LAG(n_churned,1,'0') OVER(ORDER BY YEAR) as n_churned_prev from(select EXTRACT(YEAR FROM end_date) AS YEAR, COUNT(DISTINCT index) as n_churned
from lyft_drivers
GROUP by 1) as s
WHERE S.YEAR IS NOT NULL)


select *, case 
            when n_churned_prev<n_churned then 'Increase' 
            else 'Decrease' end as case
from cte 