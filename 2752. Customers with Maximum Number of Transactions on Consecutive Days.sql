/*
2752. Customers with Maximum Number of Transactions on Consecutive Days
Hard
9
22
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
transaction_id is the column with unique values of this table.
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.   
Write a solution to find all customer_id who made the maximum number of transactions on consecutive days.

Return all customer_id with the maximum number of consecutive transactions. Order the result table by customer_id in ascending order.

The result format is in the following example.

 

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
+----------------+-------------+------------------+--------+
Output: 
+-------------+
| customer_id | 
+-------------+
| 101         | 
| 105         | 
+-------------+
Explanation: 
- customer_id 101 has a total of 3 transactions, and all of them are consecutive.
- customer_id 102 has a total of 3 transactions, but only 2 of them are consecutive. 
- customer_id 105 has a total of 3 transactions, and all of them are consecutive.
In total, the highest number of consecutive transactions is 3, achieved by customer_id 101 and 105. The customer_id are sorted in ascending order.

*/



# Write your MySQL query statement below

WITH CTE AS (
SELECT *, DATE_SUB(TRANSACTION_DATE, INTERVAL DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE) DAY) AS DATE_GROUP
FROM TRANSACTIONS),

CTE_2 AS (
SELECT 
    customer_id,
    DATE_GROUP, 
    COUNT(transaction_id) AS consecutive_TRANSACTIONS,
    DENSE_RANK() OVER(ORDER BY COUNT(transaction_id) DESC) AS TOP_RANK 
FROM CTE
GROUP BY 1,2)


SELECT customer_id FROM CTE_2
WHERE TOP_RANK=1
ORDER BY 1

-- Pandas Code
import pandas as pd

def find_customers(transactions: pd.DataFrame) -> pd.DataFrame:
    df = transactions.sort_values(by=['customer_id', 'transaction_date'])
    df['row_num'] = df.groupby('customer_id')['transaction_date'].rank()
    df['date_group']= df['transaction_date'] - pd.to_timedelta(df['row_num'], unit='d')
    df=df.groupby(['customer_id','date_group'])['transaction_id'].nunique().reset_index().rename(columns=   {'transaction_id':'transaction_cnt'}) 
    max_num = df['transaction_cnt'].max()

    return df[df['transaction_cnt']==max_num][['customer_id']].sort_values(by='customer_id', ascending=True).drop_duplicates()
