/*

1174. Immediate Food Delivery II

Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+

Delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify
a preferred delivery date (on the same order date or after it).
 

If the preferred delivery date of the customer is the same as the order date then the order is 
called immediate otherwise it's called scheduled.

The first order of a customer is the order with the earliest order date that customer made.
It is guaranteed that a customer has exactly one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers,
rounded to 2 decimal places.

The query result format is in the following example:

Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+

Result table:
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.

*/

WITH CTE AS ( 
SELECT *,
    DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS ORDER_RANK,
    CASE WHEN order_date=customer_pref_delivery_date THEN 1 ELSE 0 END AS ORDER_TYPE
FROM DELIVERY)


SELECT ROUND(COUNT(DISTINCT CASE WHEN ORDER_RANK=1 AND ORDER_TYPE=1 THEN customer_id ELSE NULL END)*100.0/COUNT(DISTINCT CUSTOMER_ID),2) AS immediate_percentage 
 FROM CTE


-- Keep in mind you can use group by using * 
SELECT *, MIN(order_date) as recent_order
FROM Delivery
GROUP BY customer_id