/*
Cum Sum Energy Consumption
Calculate the running total (i.e., cumulative sum) energy consumption of the Meta/Facebook data centers in all 3 continents by the date. Output the date, running total energy consumption, and running total percentage rounded to the nearest whole number.
*/

with fb_energy as (
select * from fb_eu_energy
union all
select * from fb_na_energy
union all 
select * from fb_asia_energy),
-- select * from fb_energy
-- where date='2020-01-01'
cte2 as (
select 
    distinct date,
    sum(consumption) over(order by date range between unbounded preceding and current row) as cumulative_total_energy,
    sum(consumption) over() as total_energy
                FROM fb_energy
                ORDER BY 1)
                
select date,cumulative_total_energy,(cumulative_total_energy*100/total_energy)::int from cte2