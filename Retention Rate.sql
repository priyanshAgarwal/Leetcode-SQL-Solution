/*
Retention Rate


Find the monthly retention rate of users for each account separately for Dec 2020 and Jan 2021. Retention rate is the percentage of active users an account retains over a given period of time. In this case, assume the user is retained if he/she stays with the app in any future months. For example, if a user was active in Dec 2020 and has activity in any future month, consider them retained for Dec. You can assume all accounts are present in Dec 2020 and Jan 2021. Your output should have the account ID and the Jan 2021 retention rate divided by Dec 2020 retention rate.
*/


with cte as(
select 
    account_id,
    user_id,
    DATE_FORMAT(date,'%Y-%m') as current_month,
    lead(DATE_FORMAT(date,'%Y-%m'),1) over(partition by account_id,user_id order by date) as next_month,
    lead(DATE_FORMAT(date,'%Y-%m'),2) over(partition by account_id,user_id order by date) as next_2_month
from sf_events
where date between '2020-11-30' and '2021-02-28'),

cte2 as (
select 
    distinct account_id,
    user_id,
    (case when current_month='2020-12' and next_month='2021-01' then 1 else 0 end) as dec_retention,
    (case when next_month='2021-01' and next_2_month='2021-02' then 1 else 0 end) as jan_retention 
    -- reason we are doing next_month and next_2_month because we are interested in users who were already retained for previous month
from cte)


select account_id, ceil(sum(jan_retention)/coalesce(sum(dec_retention),null)) as retention from cte2
where dec_retention=1 or jan_retention=1
group by 1;