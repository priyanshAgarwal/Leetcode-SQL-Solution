/*



*/

select 
a.name, 
count(distinct b.user_id)*100.0/(select count(distinct user_id) from feed_comments) as percentage_feed,
count(distinct c.user_id)*100.0/(select count(distinct user_id) from moments_comments) as percentage_moments
from ads a
inner join feed_comments b
on a.id=b.ad_id
inner join moments_comments c
on a.id=c.ad_id
group by 1