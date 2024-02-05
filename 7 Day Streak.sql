/*
7 Day Streak

Given a table with event logs, find the percentage of users that had at least one seven-day streak of visiting the same URL.

Note: Round the results to 2 decimal places. For example, if the result is 35% return 0.35.
*/
with cte as (
select user_id,date(created_at) as created_at,url 
from events 
group by 1,2,3),


cte2 as (
    select 
        *, lead(created_at,6) over(partition by user_id,url order by created_at) as next_seven_day
     from cte
)

select
round(count(distinct case when date_add(created_at, interval 6 day)=next_seven_day then user_id else null end)*1.0/count(distinct user_id),2) as precent_of_users
from cte2

