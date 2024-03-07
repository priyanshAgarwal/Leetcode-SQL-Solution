/*
2474. Customers With Strictly Increasing Purchases
Hard
37
5
company
Amazon
SQL Schema
Pandas Schema
Table: Orders

+--------------+------+
| Column Name  | Type |
+--------------+------+
| order_id     | int  |
| customer_id  | int  |
| order_date   | date |
| price        | int  |
+--------------+------+
order_id is the column with unique values for this table.
Each row contains the id of an order, the id of customer that ordered it, the date of the order, and its price.
 

Write a solution to report the IDs of the customers with the total purchases strictly increasing yearly.

The total purchases of a customer in one year is the sum of the prices of their orders in that year. If for some year the customer did not make any order, we consider the total purchases 0.
The first year to consider for each customer is the year of their first order.
The last year to consider for each customer is the year of their last order.
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Orders table:
+----------+-------------+------------+-------+
| order_id | customer_id | order_date | price |
+----------+-------------+------------+-------+
| 1        | 1           | 2019-07-01 | 1100  |
| 2        | 1           | 2019-11-01 | 1200  |
| 3        | 1           | 2020-05-26 | 3000  |
| 4        | 1           | 2021-08-31 | 3100  |
| 5        | 1           | 2022-12-07 | 4700  |
| 6        | 2           | 2015-01-01 | 700   |
| 7        | 2           | 2017-11-07 | 1000  |
| 8        | 3           | 2017-01-01 | 900   |
| 9        | 3           | 2018-11-07 | 900   |
+----------+-------------+------------+-------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
+-------------+
Explanation: 
Customer 1: The first year is 2019 and the last year is 2022
  - 2019: 1100 + 1200 = 2300
  - 2020: 3000
  - 2021: 3100
  - 2022: 4700
  We can see that the total purchases are strictly increasing yearly, so we include customer 1 in the answer.

Customer 2: The first year is 2015 and the last year is 2017
  - 2015: 700
  - 2016: 0
  - 2017: 1000
  We do not include customer 2 in the answer because the total purchases are not strictly increasing. Note that customer 2 did not make any purchases in 2016.

Customer 3: The first year is 2017, and the last year is 2018
  - 2017: 900
  - 2018: 900
 We do not include customer 3 in the answer because the total purchases are not strictly increasing.
*/


-- Method 1 ( but that's what I have been thinking, Not Mine)
with cte_aggs as (
    select 
        customer_id,
        year(order_date) as year_order,
        sum(price) as total
    from Orders
    group by 1, 2
),

cte_consec as (
    select 
        customer_id,
        year_order,
        total,
        lead(year_order) over (partition by customer_id order by year_order) as next_year,
        lead(total) over (partition by customer_id order by year_order) as next_total
    from cte_aggs
),

-- My thought was to get all the orders as well, but the code below is just getting the customer and times big
-- which is ok..


times_big as (
select customer_id, 
    SUM(case when year_order = next_year - 1 and total < next_total then 1 else 0 end) AS times_big,
    count(distinct year_order) as total_year
from cte_consec
group by 1)

select customer_id from times_big
where times_big+1=total_year
group by 1

-- Method 2 (Smart use of Rank, Not Mine)

WITH cte AS (
    SELECT  customer_id,
            YEAR(order_date)- RANK() OVER (PARTITION BY customer_id ORDER BY SUM(price)) AS rank_diff
    FROM Orders
    GROUP BY customer_id, YEAR(order_date)
)

select customer_id
from cte
group by 1
having count(distinct rank_diff)=1