/*

1384. Total Sales Amount by Year
Hard

116

53

Add to List

Share
SQL Schema
Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key for this table.
product_name is the name of the product.
 

Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.
 

Write an SQL query to report the total sales amount of each item for each year, with corresponding product_name, product_id, product_name, and report_year.

Return the result table ordered by product_id and report_year.

The query result format is in the following example.

 

Example 1:

Input: 
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+
Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+
Output: 
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
Explanation: 
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.

["all_date", "product_id", "period_start", "period_end", "average_daily_sales"], 
["2018-12-01", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-02", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-03", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-04", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-05", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-06", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-07", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-08", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-09", "2", "2018-12-01", "2020-01-01", 10], 
["2018-12-10", "2", "2018-12-01", "2020-01-01", 10]

*/

-- Method 1 (My Method)
# Write your MySQL query statement below
WITH RECURSIVE CTE AS (
    SELECT PRODUCT_ID, PERIOD_START, PERIOD_END,average_daily_sales  FROM SALES
    UNION ALL
    SELECT  PRODUCT_ID, DATE_ADD(PERIOD_START,INTERVAL 1 DAY) AS PERIOD_START,PERIOD_END,average_daily_sales 
    FROM CTE
    WHERE PERIOD_START<PERIOD_END
),

-- ADDITIONAL STEP TO UNDERSTAND NUMBER OF DAYS
CTE2 AS (
SELECT 
    A.product_id,
    B.product_name,
    date_format(period_start, "%Y") AS report_year,
    COUNT(period_start) AS NUMBER_OF_DAYS,
    average_daily_sales
    FROM CTE A
INNER JOIN PRODUCT B
ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY 1,2,3)


SELECT 
    product_id,
    product_name,
    report_year,
    NUMBER_OF_DAYS*average_daily_sales AS total_amount
FROM CTE2
ORDER BY 1,3

-- Method 2
WITH RECURSIVE CTE AS (
    SELECT PRODUCT_ID, PERIOD_START, PERIOD_END,average_daily_sales  FROM SALES
    UNION ALL
    SELECT  PRODUCT_ID, DATE_ADD(PERIOD_START,INTERVAL 1 DAY) AS PERIOD_START,PERIOD_END,average_daily_sales 
    FROM CTE
    WHERE PERIOD_START<PERIOD_END
),

CTE2 AS (
SELECT 
    A.product_id,
    B.product_name,
    date_format(period_start, "%Y") AS report_year,
    COUNT(period_start) AS NUMBER_OF_DAYS,
    average_daily_sales
    FROM CTE A
INNER JOIN PRODUCT B
ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY 1,2,3)


SELECT 
    product_id,
    product_name,
    report_year,
    NUMBER_OF_DAYS*average_daily_sales AS total_amount
FROM CTE2
ORDER BY 1,3

