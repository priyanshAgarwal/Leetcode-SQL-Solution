/*

The Most Popular Client_Id Among Users Using Video and Voice Calls
Select the most popular client_id based on a count of the number of users who have at least 50% of their events from the following list: 'video call received', 'video call sent', 'voice call received', 'voice call sent'.

*/

with cte as (select user_id , SUM(CASE WHEN event_type in ('video call received', 'video call sent','voice call received','voice call sent') THEN 1 ELSE 0 END)::decimal/COUNT(event_id) AS EVENT_PERCENTAGE
from fact_events
GROUP BY 1),

cte_2 as(
select b.client_id,dense_rank() over(order by count(*) desc) as client_rank from cte a
inner join fact_events b
on a.user_id=b.user_id
where a.EVENT_PERCENTAGE>=0.50
group by 1)

select client_id from cte_2
where client_rank=1;


