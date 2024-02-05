/*

2984. Find Peak Calling Hours for Each City
Medium
2
3
SQL Schema
Pandas Schema
Table: Calls

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| caller_id    | int      |
| recipient_id | int      |
| call_time    | datetime |
| city         | varchar  |
+--------------+----------+
(caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) for this table.
Each row contains caller id, recipient id, call time, and city.
Write a solution to find the peak calling hour for each city. If multiple hours have the same number of calls, all of those hours will be recognized as peak hours for that specific city.

Return the result table ordered by peak calling hour and city in descending order.

The result format is in the following example.

 

Example 1:

Input: 
Calls table:
+-----------+--------------+---------------------+----------+
| caller_id | recipient_id | call_time           | city     |
+-----------+--------------+---------------------+----------+
| 8         | 4            | 2021-08-24 22:46:07 | Houston  |
| 4         | 8            | 2021-08-24 22:57:13 | Houston  |  
| 5         | 1            | 2021-08-11 21:28:44 | Houston  |  
| 8         | 3            | 2021-08-17 22:04:15 | Houston  |
| 11        | 3            | 2021-08-17 13:07:00 | New York |
| 8         | 11           | 2021-08-17 14:22:22 | New York |
+-----------+--------------+---------------------+----------+
Output: 
+----------+-------------------+-----------------+
| city     | peak_calling_hour | number_of_calls |
+----------+-------------------+-----------------+
| Houston  | 22                | 3               |
| New York | 14                | 1               |
| New York | 13                | 1               |
+----------+-------------------+-----------------+
Explanation: 
For Houston:
  - The peak time is 22:00, with a total of 3 calls recorded. 
For New York:
  - Both 13:00 and 14:00 hours have equal call counts of 1, so both times are considered peak hours.
Output table is ordered by peak_calling_hour and city in descending order.

*/

-- # Write your MySQL query statement below

-- SELECT 
--     LEAST(CALLER_ID,RECIPIENT_ID) as caller,
--     GREATEST(CALLER_ID,RECIPIENT_ID) as receiver,
--     CALL_TIME,
--     CITY
-- FROM CALLS


-- SELECT CITY, DATE_FORMAT(call_time,'%H') AS peak_calling_hour, 
-- COUNT(DISTINCT caller_id,recipient_id) AS number_of_calls
-- -- DENSE_RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS r 
-- FROM Calls
-- GROUP BY 1,2


WITH CTE AS (
SELECT 
    CITY,
    HOUR(CALL_TIME) AS peak_calling_hour,
    COUNT(caller_id) AS NUMBER_OF_CALLS,
    DENSE_RANK() OVER(PARTITION BY CITY ORDER BY COUNT(caller_id) DESC) AS NUMBER_OF_CALLS_RANK
FROM CALLS 
GROUP BY 1,2
)

SELECT 
    CITY AS city,
    peak_calling_hour AS peak_calling_hour,
    NUMBER_OF_CALLS AS number_of_calls
FROM CTE
WHERE NUMBER_OF_CALLS_RANK=1
ORDER BY 2 DESC,1 DESC


