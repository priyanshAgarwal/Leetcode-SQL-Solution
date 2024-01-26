/*

197. Rising Temperature

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature in a certain day.
 

Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).

Return the result table in any order.

The query result format is in the following example:

Weather
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+

Result table:
+----+
| id |
+----+
| 2  |
| 4  |
+----+

["ID", "TODAY_TEMP", "TODAY_DATE", "PREV_TEMP", "PREV_DATE"],
[1, 10, "2015-01-01", null, null], 
[2, 25, "2015-01-02", 10, "2015-01-01"], 
[3, 20, "2015-01-03", 25, "2015-01-02"], 
[4, 30, "2015-01-04", 20, "2015-01-03"]]}

In 2015-01-02, temperature was higher than the previous day (10 -> 25).
In 2015-01-04, temperature was higher than the previous day (20 -> 30).
*/

-- Should Know when to use LAG and when to use self join 

SELECT A.id FROM Weather A
INNER JOIN Weather B
ON A.recordDate=date_add(B.recordDate, interval 1 day)
AND A.Temperature > B.Temperature 

--Method 2 (Windows Function)
WITH CTE AS (
SELECT 
    ID,
    RECORDDATE,
    TEMPERATURE,
    LAG(TEMPERATURE,1) OVER(ORDER BY RECORDDATE) AS PREVIOUS_TEMP,
    LAG(RECORDDATE,1) OVER(ORDER BY RECORDDATE) AS PREVIOUS_DATE,
    TEMPERATURE - LAG(TEMPERATURE,1) OVER(ORDER BY RECORDDATE)  AS TEMP_RISE
FROM WEATHER)

SELECT ID FROM CTE 
WHERE TEMP_RISE>0 AND RECORDDATE=DATE_ADD(PREVIOUS_DATE, INTERVAL 1 DAY)
