/*



*/


with cte as (
select 
    pe_description, count(*), dense_rank() over(order by count(*) desc) rnk
from 
    los_angeles_restaurant_health_inspections
where
    facility_name ilike '%cafe%' or facility_name ilike '%tea%' or facility_name ilike '%juice%'
group by
    1)


select
    distinct facility_name
from 
    los_angeles_restaurant_health_inspections
where
    (facility_name ilike '%cafe%' or facility_name ilike '%tea%' or facility_name ilike '%juice%')
    and
    pe_description in (select distinct pe_description from cte where rnk = 3)
    

