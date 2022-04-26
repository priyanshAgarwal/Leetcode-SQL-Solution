/*

1321. Restaurant Growth

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) have visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Write an SQL query to compute moving average of how much customer paid in a 7 days window (current day + 6 days before) .

The query result format is in the following example:

Return result table ordered by visited_on.

average_amount should be rounded to 2 decimal places, all dates are in the format ('YYYY-MM-DD').

 

Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+

Result table:
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+

1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86

***
sum(amount) over (order by visited_on range between interval 6 day preceding and current row) as amount,

What this line does is it counts subsiquent 7 rows 
["VISITED_ON", "CURRENT_AMOUNT", "AMOUNT"], 
["2019-01-01", 100, 100],  
["2019-01-02", 110, 210], 
["2019-01-03", 120, 330], 
["2019-01-04", 130, 460], 
["2019-01-05", 110, 570], 
["2019-01-06", 140, 710], 
["2019-01-07", 150, 860], (100+110+120+130+110+140+150)
["2019-01-08", 80, 840],  (110+120+130+110+140+150+80) leaving '2019-01-01'
["2019-01-09", 110, 840], (120+130+110+140+150+80+110)
["2019-01-10", 130, 1000], (130+110+140+150+80+110+130+150) Both values for 2019-01-10 are added
["2019-01-10", 150, 1000]  will have same amount because amount for same dates are adding up

This will show same result for both the dates.
 
***
sum(amount) over (order by visited_on rows between 6 preceding and current row) as amount,

["visited_on", "current_amount", "amount"],
["2019-01-01", 100, 100], 
["2019-01-02", 110, 210], 
["2019-01-03", 120, 330], 
["2019-01-04", 130, 460], 
["2019-01-05", 110, 570], 
["2019-01-06", 140, 710], 
["2019-01-07", 150, 860], (100+110+120+130+110+140+150)
["2019-01-08", 80, 840],  (110+120+130+110+140+150+80) leaving '2019-01-01'
["2019-01-09", 110, 840], (120+130+110+140+150+80+110)
["2019-01-10", 130, 850], (130+110+140+150+80+110+130) 
["2019-01-10", 150, 870]  (130+110+140+150+80+110+150) 

For above code we hace two rows for same date

*/

# Write your MySQL query statement below
WITH CTE AS(
SELECT VISITED_ON, SUM(AMOUNT) AS AMOUNT FROM CUSTOMER GROUP BY 1),

CTE2 AS (
SELECT 
    VISITED_ON,
    SUM(AMOUNT) OVER(ORDER BY VISITED_ON RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS AMOUNT,
    AVG(AMOUNT) OVER(ORDER BY VISITED_ON RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS AVG_AMOUNT,
    ROW_NUMBER() OVER(ORDER BY VISITED_ON) AS ROW_NUM
FROM CTE)


SELECT VISITED_ON,AMOUNT,ROUND(AVG_AMOUNT,2) AS average_amount  FROM CTE2
WHERE ROW_NUM>6