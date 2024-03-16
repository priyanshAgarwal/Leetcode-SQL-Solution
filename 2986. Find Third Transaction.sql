/*

2986. Find Third Transaction
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Transactions

+------------------+----------+
| Column Name      | Type     |
+------------------+----------+
| user_id          | int      |
| spend            | decimal  |
| transaction_date | datetime |
+------------------+----------+
(user_id, transaction_date) is column of unique values for this table.
This table contains user_id, spend, and transaction_date.
Write a solution to find the third transaction (if they have at least three transactions) of every user, where the spending on the preceding two transactions is lower than the spending on the third transaction.

Return the result table by user_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+---------+--------+---------------------+
| user_id | spend  | transaction_date    | 
+---------+--------+---------------------+
| 1       | 65.56  | 2023-11-18 13:49:42 | 
| 1       | 96.0   | 2023-11-30 02:47:26 |     
| 1       | 7.44   | 2023-11-02 12:15:23 | 
| 1       | 49.78  | 2023-11-12 00:13:46 | 
| 2       | 40.89  | 2023-11-21 04:39:15 |  
| 2       | 100.44 | 2023-11-20 07:39:34 | 
| 3       | 37.33  | 2023-11-03 06:22:02 | 
| 3       | 13.89  | 2023-11-11 16:00:14 | 
| 3       | 7.0    | 2023-11-29 22:32:36 | 
+---------+--------+---------------------+
Output
+---------+-------------------------+------------------------+
| user_id | third_transaction_spend | third_transaction_date | 
+---------+-------------------------+------------------------+
| 1       | 65.56                   | 2023-11-18 13:49:42    |  
+---------+-------------------------+------------------------+
Explanation
- For user_id 1, their third transaction occurred on 2023-11-18 at 13:49:42 with an amount of $65.56, surpassing the expenditures of the previous two transactions which were $7.44 on 2023-11-02 at 12:15:23 and $49.78 on 2023-11-12 at 00:13:46. Thus, this third transaction will be included in the output table.
- user_id 2 only has a total of 2 transactions, so there isn't a third transaction to consider.
- For user_id 3, the amount of $7.0 for their third transaction is less than that of the preceding two transactions, so it won't be included.
Output table is ordered by user_id in ascending order.


*/



# Write your MySQL query statement below
/*

1 Option Lead the dates and the spend and check if 

Edge Cases

1. Less than three transactions
2. Lead could give us an isue in the case of last transaction 

Simple Lead would have worked and I over complicated the logic

*/

with cte as (
select *, 
    dense_rank() over(partition by user_id order by transaction_date) as transaction_rank,
    lag(spend,1) over(partition by user_id order by transaction_date) as prev_spend,
    lag(spend,2) over(partition by user_id order by transaction_date) as prev_second_spend 
from Transactions)

select 
    user_id,
    spend as third_transaction_spend,
    transaction_date as third_transaction_date 
from  cte
where spend>prev_spend and spend>prev_second_spend and transaction_rank=3


-- Method 2 

WITH CTE AS (
SELECT *,
    MAX(SPEND) OVER(PARTITION BY USER_ID ORDER BY transaction_date ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS MAX_SPEND, 
DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY transaction_date) AS TRANSACTION_RNK
FROM transactions)

SELECT 
    user_id, 
    spend as third_transaction_spend,
    transaction_date as third_transaction_date 
FROM CTE
WHERE MAX_SPEND<spend  AND TRANSACTION_RNK=3

-- Your modified code ( Method 2)

/*

You forgot the case when 3 transactions is equal to second transaction your code below fails that, so you need to check if two previous transactions are greater than third transactions, Your code will also pull 34 although its not greater

| user_id | spend | transaction_date    | MAX_SPEND | TRANSACTION_RNK |
| ------- | ----- | ------------------- | --------- | --------------- |
| 34      | 63.44 | 2023-11-05 16:10:59 | 63.44     | 1               |
| 34      | 78.33 | 2023-11-07 05:37:51 | 78.33     | 2               |
| 34      | 78.33 | 2023-11-20 22:15:21 | 78.33     | 3               |
| 34      | 43.67 | 2023-11-25 07:25:48 | 78.33     | 4               |
| 34      | 85.67 | 2023-11-29 07:42:01 | 85.67     | 5               |
| 34      | 79.78 | 2023-11-29 15:49:32 | 85.67     | 6               |
| 34      | 44.56 | 2023-11-29 15:57:50 | 85.67     | 7               |
| 34      | 93.56 | 2023-11-29 17:12:11 | 93.56     | 8               |


*/
WITH CTE AS (
SELECT *,
    MAX(SPEND) OVER(PARTITION BY USER_ID ORDER BY transaction_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MAX_SPEND, 
DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY transaction_date) AS TRANSACTION_RNK
FROM transactions)

SELECT 
    user_id, 
    spend as third_transaction_spend,
    transaction_date as third_transaction_date 
FROM CTE
WHERE MAX_SPEND=spend  AND TRANSACTION_RNK=3


-- Another method by a User 

WITH CTE AS (
SELECT *, 
    DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY TRANSACTION_DATE) AS TRAN_RANK
FROM TRANSACTIONS),

-- You need to rank by date before to make sure you have three transactions first, before ranking by spend. Since we are only concerned by first three transactions

CTE2 AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY USER_ID ORDER BY SPEND) AS SPEND_RANK FROM CTE
WHERE TRAN_RANK<=3)


SELECT 
    user_id, 
    spend as third_transaction_spend,
    transaction_date as third_transaction_date 
FROM CTE2
WHERE TRAN_RANK=3 AND SPEND_RANK=3