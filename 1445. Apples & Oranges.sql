/*
1445. Apples & Oranges

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date,fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.
 

Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format ('YYYY-MM-DD').

The query result format is in the following example:

 

Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+

Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).
*/


--Method 1

Select 
    A.sale_date,
    (A.sold_num-B.sold_num) AS DIFF
FROM 
(SELECT sale_date, fruit, sold_num
FROM Sales
WHERE fruit='apples') as A
LEFT JOIN 
(SELECT sale_date, fruit, sold_num
FROM Sales
WHERE fruit='oranges') as B
ON A.sale_date=B.sale_date;


--Method 2
SELECT 
    SALE_DATE,
    SUM(IF(FRUIT='apples',sold_num,-sold_num)) As diff
FROM Sales
GROUP BY SALE_DATE;

--Method 3
WITH SALES_PIVOT AS ( 
SELECT 
    sale_date,  
    sum(CASE WHEN FRUIT='apples' THEN sold_num END) AS APPLES,
    sum(CASE WHEN FRUIT='oranges' THEN sold_num END) AS ORANGE
    FROM sales   
    GROUP BY sale_date)
    
SELECT sale_date, (APPLES-ORANGE) AS diff  FROM SALES_PIVOT;

--Method 4 (Pivot Table)
WITH SALES_PIVOT as(
    select sale_date, apples, oranges
    from Sales
    PIVOT (
        SUM(sold_num)
        for fruit
        in ([apples],[oranges])
    ) AS PIVOT_TABLE        
)

select sale_date, apples-oranges as diff
from SALES_PIVOT

