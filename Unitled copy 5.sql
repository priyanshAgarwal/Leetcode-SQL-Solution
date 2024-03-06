/*

*/



Table: orders
order_id (integer)
customer_id (integer)
order_date (date)
order_amount (decimal)
Table: customers
customer_id (integer)
signup_date (date)
country (string)

Cohort Retention: Calculate the percentage of customers from each signup month who placed a second order within 30 days.


with cte as(
select 
month(signup_date) as sign_up_month,
customer_id
count(distinct order_id) as num_orders
from customers a
inner join orders b
on a.customer_id=b.customer_id
where order_date between signup_date and DATE_ADD(signup_date,interval 30 days)
group by 1,2
having count(distinct order_id)>=2)


select month(a.signup_date), count(distinct b.customer_id)*100.00/count(distinct a.customer_id) from customers
left join cte on a.customer_id=b.customer_id and month(a.signup_date)=sign_up_month
group by 1