/*

1777. Product's Price for Each Store

Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store       | enum    |
| price       | int     |
+-------------+---------+
(product_id,store) is the primary key for this table.
store is an ENUM of type ('store1', 'store2', 'store3') where each represents the store this product is available at.
price is the price of the product at this store.
 

Write an SQL query to find the price of each product in each store.

Return the result table in any order.

The query result format is in the following example:

 

Products table:
+-------------+--------+-------+
| product_id  | store  | price |
+-------------+--------+-------+
| 0           | store1 | 95    |
| 0           | store3 | 105   |
| 0           | store2 | 100   |
| 1           | store1 | 70    |
| 1           | store3 | 80    |
+-------------+--------+-------+

Result table:
+-------------+--------+--------+--------+
| product_id  | store1 | store2 | store3 |
+-------------+--------+--------+--------+
| 0           | 95     | 100    | 105    |
| 1           | 70     | null   | 80     |
+-------------+--------+--------+--------+
Product 0 price's are 95 for store1, 100 for store2 and, 105 for store3.
Product 1 price's are 70 for store1, 80 for store3 and, it's not sold in store2.

*/
-- Pivot
-- Method 1  
-- We could also use SUM vs MAX, so remember what to use.
SELECT 
    PRODUCT_ID,
    MAX(CASE WHEN STORE='store1' THEN PRICE END) AS STORE1,
    MAX(CASE WHEN STORE='store2' THEN PRICE END) AS STORE2,
    MAX(CASE WHEN STORE='store3' THEN PRICE END) AS STORE3
FROM PRODUCTS 
GROUP BY 1

-- Method 2
-- Pivot Table
select product_id, store1,store2,store3
from Products
PIVOT 
(
    MAX(price)
    for store
    in (store1,store2,store3)
) AS PI_TAB
