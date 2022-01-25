/*


City With The Highest and Lowest Income Variance
What cities recorded the largest growth and biggest drop in order amount between March 11, 2019, and April 11, 2019. Your output should include the names of the cities and the amount of growth/drop.


Look Again
*/

with cte as (select city_id,date(order_timestamp_utc) as date, SUM(amount)-lag(SUM(amount),1) over(partition by city_id order by date(order_timestamp_utc)) as drop_growth from postmates_orders
group by 1,2),

cte2 as (
select * from cte where drop_growth in (select min(drop_growth)
from cte) or drop_growth in (select max(drop_growth)
from cte))

select a.name,b.drop_growth from postmates_markets a
join cte2 b on b.city_id=a.id


-- Method 2 (Find Min, Max Using Union)
with cte as (
Select 
b.name,
a.order_timestamp_utc::date,
sum(a.amount) - 
lag(sum(a.amount),1) over (partition by b.name order by a.order_timestamp_utc::date) as diff
from postmates_orders a join
postmates_markets b on a.city_id = b.id 
group by 1,2)

Select name, diff from cte where diff = (Select max(diff) from cte)
union
Select name, diff from cte where diff = (Select min(diff) from cte)


-- Method 3
with cte as(
    select
        m.name,
        (sum(case when order_timestamp_utc::date = '2019-04-11' then amount else 0 end) - 
        sum(case when order_timestamp_utc::date = '2019-03-11' then amount else 0 end))
        as amount_difference
    from postmates_orders o 
    join postmates_markets m
    on o.city_id = m.id
    group by 1
)
select * from cte
where 
    amount_difference = (select min(amount_difference) from cte) or
    amount_difference = (select max(amount_difference) from cte)