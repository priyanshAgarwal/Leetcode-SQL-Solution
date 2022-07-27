/*
Comment Upvotes
11
Have you seen this question before?
Question
We’re given three tables representing a forum of users and their comments on posts.

Write a query to get the top three users that got the most upvotes on their comments written in 2020. 

Note: Do not count deleted comments and upvotes by users on their own comments
*/


with cte as (
select 
    distinct 
    a.user_id as id,
    c.username,
    count(b.id) over(partition by a.user_id) as upvotes
from comments a
inner join comment_votes b
on a.id=b.comment_id
inner join users c
on a.user_id=c.id
where year(a.created_at)='2020'
and is_deleted=0  
and is_upvote=1
)

select * from cte 
order by upvotes desc
limit 3