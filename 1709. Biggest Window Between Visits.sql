/*
1709. Biggest Window Between Visits
+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| visit_date  | date |
+-------------+------+
This table does not have a primary key.
This table contains logs of the dates that users vistied a certain retailer.
 

Assume today's date is '2021-1-1'.

Write an SQL query that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).

Return the result table ordered by user_id.

The query result format is in the following example:

 

UserVisits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-11-28 |
| 1       | 2020-10-20 |
| 1       | 2020-12-3  |
| 2       | 2020-10-5  |
| 2       | 2020-12-9  |
| 3       | 2020-11-11 |
+---------+------------+
Result table:
+---------+---------------+
| user_id | biggest_window|
+---------+---------------+
| 1       | 39            |
| 2       | 65            |
| 3       | 51            |
+---------+---------------+
For the first user, the windows in question are between dates:
    - 2020-10-20 and 2020-11-28 with a total of 39 days. 
    - 2020-11-28 and 2020-12-3 with a total of 5 days. 
    - 2020-12-3 and 2021-1-1 with a total of 29 days.
Making the biggest window the one with 39 days.
For the second user, the windows in question are between dates:
    - 2020-10-5 and 2020-12-9 with a total of 65 days.
    - 2020-12-9 and 2021-1-1 with a total of 23 days.
Making the biggest window the one with 65 days.
For the third user, the only window in question is between dates 2020-11-11 and 2021-1-1 with a total of 51 days.


*/

with next_day AS(
SELECT *,
 IFNULL(LEAD(visit_date ,1) OVER(PARTITION BY user_id ORDER BY visit_date),'2021-1-1') AS NEXT_DATE 
 FROM UserVisits)

-- You don't have to find rank to find the Max, you can simply group by and use the MAX function. 
-- Import you use Rank where multiple row can have same rank. Remember this
SELECT user_id, MAX(DATEDIFF(NEXT_DATE,visit_date)) AS biggest_window
FROM next_day
GROUP BY user_id;


SELECT USER_ID, MAX(VISIT_WINDOW) AS biggest_window
FROM (SELECT  
    USER_ID,
    DATEDIFF(LEAD(VISIT_DATE,1,'2021-1-1') OVER(PARTITION BY USER_ID ORDER BY VISIT_DATE),VISIT_DATE) AS VISIT_WINDOW
FROM USERVISITS
ORDER BY 1,2) AS A
GROUP BY 1