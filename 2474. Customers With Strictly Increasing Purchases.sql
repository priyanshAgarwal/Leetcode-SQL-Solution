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

-- Method 3 (Couldn't think of this logic as well)

with orders as (
    select
    customer_id,
    year(order_date) as order_year,
    sum(price) as price
    from orders
    group by 1,2
    order by 1,2
),

orders2 as (
    select *,
    -- # Compare current order year to the next order year
    lead(order_year,1,order_year) over(partition by customer_id order by order_year) as next_year, 
    lead(order_year,1,order_year) over(partition by customer_id order by order_year) - order_year as diff_year,
    -- # Compared current year's total price to next year's price; Add 1 to next year's price to account for the last year when there is no more future years to compare to so that the results will not return 0.
    lead(price,1, price+1) over (partition by customer_id order by order_year) as next_price,
    lead(price,1, price+1) over (partition by customer_id order by order_year) - price as diff_price
    from orders
)

select distinct
customer_id
from orders2
# Exclude customers that do not meet the criteria
where customer_id not in (
select customer_id from orders2
where diff_price<=0 or diff_year>1)



/*
Why won't simple self join work with the conditins

select * 
from cte a 
inner join cte b
on a.customer_id=b.customer_id and a.years + 1 = b.years and b.total_price>a.total_price

| customer_id | years | total_price |
| ----------- | ----- | ----------- |
| 6           | 2019  | 15000       |
| 6           | 2020  | 5600        |
| 6           | 2021  | 6700        |
| 6           | 2022  | 2100        |


so first or last row can have price greater or less than previous valu and still that would be considerred, in other cases it might work but in this edge case it won't work
*/

-- Left Join but kinda self join 
WITH CTE AS (
SELECT 
    customer_id,
    YEAR(ORDER_DATE) AS ORDER_YEAR,
    SUM(PRICE) AS PRICE
FROM ORDERS 
GROUP BY 1,2
),

CTE_3 AS (
SELECT 
    A.customer_id, 
        MAX(a.ORDER_YEAR)-MIN(a.ORDER_YEAR) AS num_years,
    COUNT(DISTINCT B.ORDER_YEAR) AS year_shopping  
FROM CTE A
LEFT JOIN CTE B
ON A.CUSTOMER_ID = B.CUSTOMER_ID AND A.ORDER_YEAR+1=B.ORDER_YEAR AND A.PRICE<B.PRICE
GROUP BY 1)

SELECT DISTINCT CUSTOMER_ID 
FROM CTE_3 
WHERE num_years=year_shopping
GROUP BY 1

-- (My Solution - Created my own using understanding from other) 
# Write your MySQL query statement below

WITH RECURSIVE ALL_YEAR AS (
    SELECT customer_id, YEAR(MIN(ORDER_DATE)) AS ORDER_YEAR, YEAR(MAX(ORDER_DATE)) AS MAX_YEAR FROM ORDERS GROUP BY 1
    UNION ALL
    SELECT customer_id, ORDER_YEAR+1 AS ALL_YEAR, MAX_YEAR FROM ALL_YEAR
    WHERE ORDER_YEAR<MAX_YEAR
),

PRICE AS (
    select A.customer_id, A.ORDER_YEAR, COALESCE(sum(B.price),0) as TOTAL
    from ALL_YEAR A LEFT JOIN Orders B ON A.customer_id=B.customer_id AND A.ORDER_YEAR=YEAR(B.order_date)  
    group by 1,2),


RANK_USER AS (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_YEAR) AS ORDER_YEAR_RANK,
    DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY TOTAL) AS PRICE_RANK
    FROM PRICE  

),

GET_USERS AS (
SELECT 
    customer_id,
    COUNT(DISTINCT CASE WHEN ORDER_YEAR_RANK=PRICE_RANK THEN ORDER_YEAR ELSE NULL END) AS TIMES_SAME,
    MAX(ORDER_YEAR)-MIN(ORDER_YEAR)+1 AS NUM_YEAR
FROM RANK_USER
GROUP BY 1
ORDER BY 1,2)

SELECT customer_id 
FROM GET_USERS
WHERE TIMES_SAME=NUM_YEAR
GROUP BY 1


-- My Solution Using Lead

# Write your MySQL query statement below


WITH RECURSIVE ALL_YEAR AS (
    SELECT customer_id, YEAR(MIN(ORDER_DATE)) AS ORDER_YEAR, YEAR(MAX(ORDER_DATE)) AS MAX_YEAR FROM ORDERS GROUP BY 1
    UNION ALL
    SELECT customer_id, ORDER_YEAR+1 AS ALL_YEAR, MAX_YEAR FROM ALL_YEAR
    WHERE ORDER_YEAR<MAX_YEAR
),

PRICE AS (
    select A.customer_id, A.ORDER_YEAR, COALESCE(sum(B.price),0) as TOTAL
    from ALL_YEAR A LEFT JOIN Orders B ON A.customer_id=B.customer_id AND A.ORDER_YEAR=YEAR(B.order_date)  
    group by 1,2),


LEAD_USER AS (
    SELECT *,
    LEAD(TOTAL) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_YEAR) AS NEXT_TOTAL
    FROM PRICE  

),

LEAD_VALUES AS (
SELECT 
    customer_id, 
    COUNT(DISTINCT CASE WHEN NEXT_TOTAL>TOTAL THEN ORDER_YEAR ELSE NULL END) AS TIMES_BIG,
    MAX(ORDER_YEAR)-MIN(ORDER_YEAR) AS YEAR_PRESENT 
FROM LEAD_USER
GROUP BY 1)


SELECT customer_id 
FROM LEAD_VALUES
WHERE TIMES_BIG=YEAR_PRESENT
GROUP BY 1