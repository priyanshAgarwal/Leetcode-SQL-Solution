/*
2701. Consecutive Transactions with Increasing Amounts
Hard
33
3
SQL Schema
Pandas Schema
Table: Transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| customer_id      | int  |
| transaction_date | date |
| amount           | int  |
+------------------+------+
transaction_id is the primary key of this table. 
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.  
Write an SQL query to find the customers who have made consecutive transactions with increasing amount for at least three consecutive days. Include the customer_id, start date of the consecutive transactions period and the end date of the consecutive transactions period. There can be multiple consecutive transactions by a customer.

Return the result table ordered by customer_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+----------------+-------------+------------------+--------+
| transaction_id | customer_id | transaction_date | amount |
+----------------+-------------+------------------+--------+
| 1              | 101         | 2023-05-01       | 100    |
| 2              | 101         | 2023-05-02       | 150    |
| 3              | 101         | 2023-05-03       | 200    |
| 4              | 102         | 2023-05-01       | 50     |
| 5              | 102         | 2023-05-03       | 100    |
| 6              | 102         | 2023-05-04       | 200    |
| 7              | 105         | 2023-05-01       | 100    |
| 8              | 105         | 2023-05-02       | 150    |
| 9              | 105         | 2023-05-03       | 200    |
| 10             | 105         | 2023-05-04       | 300    |
| 11             | 105         | 2023-05-12       | 250    |
| 12             | 105         | 2023-05-13       | 260    |
| 13             | 105         | 2023-05-14       | 270    |
+----------------+-------------+------------------+--------+
Output: 
+-------------+-------------------+-----------------+
| customer_id | consecutive_start | consecutive_end | 
+-------------+-------------------+-----------------+
| 101         |  2023-05-01       | 2023-05-03      | 
| 105         |  2023-05-01       | 2023-05-04      |
| 105         |  2023-05-12       | 2023-05-14      | 
+-------------+-------------------+-----------------+
Explanation: 
- customer_id 101 has made consecutive transactions with increasing amounts from May 1st, 2023, to May 3rd, 2023
- customer_id 102 does not have any consecutive transactions for at least 3 days. 
- customer_id 105 has two sets of consecutive transactions: from May 1st, 2023, to May 4th, 2023, and from May 12th, 2023, to May 14th, 2023. 
customer_id is sorted in ascending order.
 


Important Edge Case

| transaction_id | customer_id | transaction_date | amount | PREV_amount | PREV_transaction_date | date_group |
| -------------- | ----------- | ---------------- | ------ | ----------- | --------------------- | ---------- |
| 7              | 105         | 2023-05-01       | 100    | 100         | 2023-05-01            | 2023-04-30 |
| 8              | 105         | 2023-05-02       | 150    | 100         | 2023-05-01            | 2023-04-30 |
| 9              | 105         | 2023-05-03       | 200    | 150         | 2023-05-02            | 2023-04-30 |
| 10             | 105         | 2023-05-04       | 300    | 200         | 2023-05-03            | 2023-04-30 |

So you also have pre transaction and that is less, so need a way to figure out when transactions started again

| 11             | 105         | 2023-05-12       | 250    | 300         | 2023-05-04            | 2023-05-07 |
| 12             | 105         | 2023-05-13       | 260    | 250         | 2023-05-12            | 2023-05-07 |
| 13             | 105         | 2023-05-14       | 270    | 260         | 2023-05-13            | 2023-05-07 |


*/

-- Was able to think about groupping but wasn't able to figure out consequtive increasing

-- My Method 
WITH CTE1 AS(
    SELECT 
        *
        ,lead(amount,1) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS next_amount
        ,lead(transaction_date,1) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS next_transaction_date
    FROM 
        Transactions
    ORDER BY
        customer_id, transaction_date
),

cte2 as (
select *, date_sub(transaction_date, interval rank() over(partition by customer_id order by transaction_date) day) as date_group
from CTE1
where next_amount > amount),

cte3 as (
select *, count(transaction_id) over(partition by customer_id,date_group) as count_group from cte2)


select 
    customer_id, 
    min(transaction_date) as consecutive_start ,
    DATE_ADD(transaction_date, INTERVAL count_group DAY) AS consecutive_end
from cte3
where count_group>=2
group by customer_id, date_group  




-- Method 1 (Not Mine)
WITH RankedTransactions AS (
    SELECT
        customer_id,
        transaction_date,
        amount,
        LAG(transaction_date, 1) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date 
        ) AS prev_date,
        LAG(amount, 1) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS prev_amount
    FROM
        Transactions
),
ConsecutiveTransactions AS (
    SELECT
        customer_id,
        transaction_date,
        CASE
            WHEN prev_date IS NULL OR
            DATEDIFF(transaction_date, prev_date) > 1 OR    
            amount <= prev_amount
            THEN 1
            ELSE 0
        END AS is_new_start
    FROM
        RankedTransactions
),
CumulativeStartsAsGroups AS (
    SELECT
        customer_id,
        transaction_date,
        SUM(is_new_start) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS start_group
    FROM
        ConsecutiveTransactions
)
SELECT
    customer_id,
    MIN(transaction_date) AS consecutive_start,
    MAX(transaction_date) AS consecutive_end
FROM
    CumulativeStartsAsGroups
GROUP BY
    customer_id,
    start_group
HAVING
    COUNT(*) >= 3
ORDER BY
    customer_id, 
    consecutive_start
;





-- Method 2 (Not Mine)
WITH CTE1 AS(
    SELECT 
        *
        ,LAG(amount) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS prev_amount
        ,LAG(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS pre_transaction_date
    FROM 
        Transactions
    ORDER BY
        customer_id, transaction_date
),

CTE2 AS(
    SELECT 
        *
        ,TO_DAYS(transaction_date) - RANK() OVER(PARTITION BY customer_id ORDER BY transaction_date) AS GRP
    FROM CTE1 
    WHERE amount > prev_amount AND DATEDIFF(transaction_date, pre_transaction_date) = 1
)


SELECT 
    customer_id,
    MIN(pre_transaction_date) AS consecutive_start,
    MAX(transaction_date) AS consecutive_end
FROM 
    CTE2
GROUP BY 
    customer_id, GRP
HAVING COUNT(GRP) >= 2  --We have to take 2 here since this is the edge case where previoud tran at different time greater so you want to start again from 0



