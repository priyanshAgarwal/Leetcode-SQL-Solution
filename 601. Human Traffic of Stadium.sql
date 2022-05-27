/*

601. Human Traffic of Stadium
Hard

Table: Stadium

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the primary key for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
No two rows will have the same visit_date, and as the id increases, the dates increase as well.
 

Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The query result format is in the following example.

 

Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

Result table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids.

Explanation -
If we use a row_number window ordered by id where people >= 100 assuming id's are gonna be
unique we will get a unique incremental row_num (think of it as id for a new table which
consist only of ids with people over 100).
Now if we observe the logic below id - row_num increments for every break of consecutive
chain of 100+ days. count of the id - row_num will result more than 3 incase where our 
window size is >=3

# +------+------------+-----------+------------+------------+
# | id   | visit_date | people    | row_num    |id - row_num|
# +------+------------+-----------+------------+------------+
# | 1    | 2017-01-01 | 10        |-           |-           |
# | 2    | 2017-01-02 | 109       |1           |1           |
# | 3    | 2017-01-03 | 150       |2           |1           | window of 1 has size -> (2)
# | 4    | 2017-01-04 | 99        |-           |-           |
# | 5    | 2017-01-05 | 145       |3           |2           |
# | 6    | 2017-01-06 | 1455      |4           |2           |
# | 7    | 2017-01-07 | 199       |5           |2           |
# | 8    | 2017-01-09 | 188       |6           |2           | window of 2 has size -> (4)
# +------+------------+-----------+------------+------------+


*/

--Consecutive 

-- METHOD 1
WITH CTE AS (SELECT *, COUNT(ID) OVER(PARTITION BY GROUP_PEOPLE) AS NUM_PEOPLE
FROM (SELECT *,
		ID-ROW_NUMBER() OVER(ORDER BY id) GROUP_PEOPLE
		FROM stadium WHERE people >= 100) AS A)
        

SELECT ID, VISIT_DATE, PEOPLE FROM CTE
WHERE NUM_PEOPLE>2


-- METHOD 2 (Reason we are using 2 for lag and lead because we want more than 2 rows where
-- number of people are more than 100)
WITH CTE AS (
SELECT *,
    LAG(PEOPLE,1) OVER(ORDER BY ID) AS PREVIOUS_PEOPLE,
    LEAD(PEOPLE,1) OVER(ORDER BY ID) AS NEXT_PEOPLE,
    LAG(PEOPLE,2) OVER(ORDER BY ID) AS PREVIOUS_PEOPLE_2,
    LEAD(PEOPLE,2) OVER(ORDER BY ID) AS NEXT_PEOPLE_2
FROM STADIUM)

SELECT id , visit_date, people FROM CTE 
WHERE (PEOPLE>99 AND NEXT_PEOPLE>99 AND PREVIOUS_PEOPLE>99)
OR (PEOPLE>99 AND NEXT_PEOPLE>99 AND NEXT_PEOPLE_2>99)
OR (PEOPLE>99 AND PREVIOUS_PEOPLE>99 AND PREVIOUS_PEOPLE_2>99)