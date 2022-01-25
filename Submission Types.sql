/*

Submission Types
Write a query that returns the user ID of all users that have created at least one ‘Refinance’ submission and at least one ‘InSchool’ submission.


*/

with cte as (
select user_id, 
    sum(case when type='Refinance' then 1 else 0 end) as Refinance,
    sum(case when type='InSchool' then 1 else 0 end) as InSchool
from loans
where type in ('Refinance','InSchool')
group by user_id
)

select user_id from cte where Refinance>=1 and InSchool>=1


-- method 2  (Intersection)
select distinct user_id from loans
where type='Refinance'
intersect
select distinct user_id from loans
where type='InSchool'