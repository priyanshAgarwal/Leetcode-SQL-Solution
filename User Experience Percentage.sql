/*

User Experience Percentage
2
Have you seen this question before?
Question
Given a table of user_experiences, write a query to determine the percentage of users that held the title of “Data Analyst” immediately before holding the title “Data Scientist”. Immediate is defined as the user holding no other titles between the Data Analyst and Data Scientist roles.

*/

with cte as (select *, dense_rank() over(partition by user_id order by start_date desc) as most_recent_rank
from user_experiences)

select count(distinct case when most_recent='Data Scientist' and second_recent='Data Analyst' then user_id end)*1.0/count(distinct user_id) as percentage
from 
(select user_id,
    max(case when most_recent_rank=1 then position_name end) as most_recent,
    max(case when most_recent_rank=2 then position_name end) as second_recent
from cte
group by 1) as a
