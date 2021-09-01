/*
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| order_date    | date    | 
| item_id       | varchar |
| quantity      | int     |
+---------------+---------+
(ordered_id, item_id) is the primary key for this table.
This table contains information of the orders placed.
order_date is the date when item_id was ordered by the customer with id customer_id.
 

Table: Items

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| item_id             | varchar |
| item_name           | varchar |
| item_category       | varchar |
+---------------------+---------+
item_id is the primary key for this table.
item_name is the name of the item.
item_category is the category of the item.
 

You are the business owner and would like to obtain a sales report for category items and day of the week.

Write an SQL query to report how many units in each category have been ordered on each day of the week.

Return the result table ordered by category.

The query result format is in the following example:

 

Orders table:
+------------+--------------+-------------+--------------+-------------+
| order_id   | customer_id  | order_date  | item_id      | quantity    |
+------------+--------------+-------------+--------------+-------------+
| 1          | 1            | 2020-06-01  | 1            | 10          |
| 2          | 1            | 2020-06-08  | 2            | 10          |
| 3          | 2            | 2020-06-02  | 1            | 5           |
| 4          | 3            | 2020-06-03  | 3            | 5           |
| 5          | 4            | 2020-06-04  | 4            | 1           |
| 6          | 4            | 2020-06-05  | 5            | 5           |
| 7          | 5            | 2020-06-05  | 1            | 10          |
| 8          | 5            | 2020-06-14  | 4            | 5           |
| 9          | 5            | 2020-06-21  | 3            | 5           |
+------------+--------------+-------------+--------------+-------------+

Items table:
+------------+----------------+---------------+
| item_id    | item_name      | item_category |
+------------+----------------+---------------+
| 1          | LC Alg. Book   | Book          |
| 2          | LC DB. Book    | Book          |
| 3          | LC SmarthPhone | Phone         |
| 4          | LC Phone 2020  | Phone         |
| 5          | LC SmartGlass  | Glasses       |
| 6          | LC T-Shirt XL  | T-Shirt       |
+------------+----------------+---------------+

Result table:
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
| Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
| Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
| T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
On Tuesday (2020-06-02) were sold a total of 5 units  in the category Book (ids: 1, 2).
On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
On Saturday there are no items sold.
On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
There are no sales of T-Shirt.


Mistakes I Made

Used Left join, there we re no sales for T-Shirt so it wasn't showing, didn't used ISNULL in Quantity

*/



/* Write your T-SQL query statement below */

WITH SALES_DATA AS ( 
SELECT 
    DATENAME(dw,order_date) AS WEEK_DAY,
    item_category AS Category,
    ISNULL(quantity,0) AS quantity
FROM Orders A
RIGHT JOIN Items B
ON A.item_id=B.item_id)


SELECT 
    Category,
    ISNULL(MONDAY,0) AS MONDAY,
    ISNULL(TUESDAY,0) AS TUESDAY,
    ISNULL(WEDNESDAY,0) AS WEDNESDAY,
    ISNULL(THURSDAY,0) AS THURSDAY,
    ISNULL(FRIDAY,0) AS FRIDAY,
    ISNULL(SATURDAY,0) AS SATURDAY,
    ISNULL(SUNDAY,0) AS SUNDAY
    FROM SALES_DATA
    PIVOT(
        SUM (quantity)
        FOR WEEK_DAY
        in (Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday)) as pivot_table


-- METHOD 2

SELECT 
    B.ITEM_CATEGORY AS CATEGORY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(order_date) = 2 THEN QUANTITY END),0) as MONDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(order_date) = 3 THEN QUANTITY END),0) as TUESDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(ORDER_DATE) = 4 THEN QUANTITY END),0) AS WEDNESDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(ORDER_DATE) = 5 THEN QUANTITY END),0) AS THURSDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(ORDER_DATE) = 6 THEN QUANTITY END),0) AS FRIDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(ORDER_DATE) = 7 THEN QUANTITY END),0) AS SATURDAY,
    IFNULL(SUM(CASE WHEN DAYOFWEEK(ORDER_DATE) = 1 THEN QUANTITY END),0) AS SUNDAY
FROM ORDERS A
RIGHT JOIN ITEMS B
ON A.ITEM_ID=B.ITEM_ID
GROUP BY 1
ORDER BY 1;
