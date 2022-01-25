/*

Rank Variance Per Country
Which countries have risen in the rankings based on the number of comments between Dec 2019 vs Jan 2020? Hint: Avoid gaps between ranks when ranking countries.

Not a Difficult Question, But tedious difficult to understand
*/
with a as 
(select u.country, sum(number_of_comments),
dense_rank() over (order by sum(number_of_comments) desc ) as ra
from fb_comments_count c 
join fb_active_users u
on c.user_id = u.user_id
where extract(month from created_at)=12 and extract(year from created_at)=2019
group by 1),

b as 
(select u.country, sum(number_of_comments),
dense_rank() over (order by sum(number_of_comments) desc ) as rb
from fb_comments_count c 
join fb_active_users u
on c.user_id = u.user_id
where extract(month from created_at)=1 and extract(year from created_at)=2020
group by 1)


SELECT b.country
FROM B 
LEFT JOIN A
ON b.country = a.country 
where B.RB<A.RA or A.RA is null 