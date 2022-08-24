/*
180. Consecutive Numbers

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+

1 is the only number that appears consecutively for at least three times.
*/

SELECT L1.NUM AS ConsecutiveNums  
FROM
Logs L1,
Logs L2,
Logs L3
WHERE L2.ID=L1.ID+1 -- First two lines are to get consecutive we have to do                    
AND L2.ID=L3.ID-1   -- ID and next two lines to get the numbers
AND L1.NUM=L2.NUM
AND L2.NUM=L3.NUM;


/*
Important thing here, a mistake I made. 
Always use Lag function with column you want to see a LAG over a Unique ID.   
My Mistake LAG(NUM,1) OVER(ORDER BY NUM) AS NUM_1

Example - Mujhe Employee ki previous year salary chahiye, so I will put Salary in Lag function and then put 
employee_id in OVER() function. 

SELECT 
	employee_id, 
	fiscal_year, 
	salary,
	LAG(salary) OVER (
		PARTITION BY employee_id 
		ORDER BY fiscal_year) previous_salary
FROM
	basic_pays;


["id", "num", "DENSE_RANK() OVER(PARTITION BY NUM ORDER BY ID)"]
[1, 1, 1],  so hoga kya ki  id-dense_rank same group me aa jayega.
[2, 1, 2], 
[3, 1, 3], 
[5, 1, 4], 
[4, 2, 1], 
[6, 2, 2], 
[7, 2, 3]	

["id", "num", "rw", "rn"], 
[1, 1, 1, 1], 
[2, 1, 2, 2], 
[3, 1, 3, 3], 
[4, 2, 4, 1], 
[5, 1, 5, 4], 
[6, 2, 6, 2], 
[7, 2, 7, 3]]}
*/

SELECT DISTINCT NUM AS ConsecutiveNums FROM (SELECT ID, NUM, 
    LAG(NUM,1) OVER(ORDER BY ID) AS PREVIOUS_NUM,
    LEAD(NUM,1) OVER(ORDER BY ID) AS NEXT_NUM
FROM LOGS) AS A
WHERE A.NUM=A.PREVIOUS_NUM AND A.NUM=A.NEXT_NUM

-- Gap and Island
SELECT DISTINCT NUM AS ConsecutiveNums 
FROM (SELECT *, 
    ROW_NUMBER() OVER(ORDER BY ID) AS ROW_NUM,
    ROW_NUMBER() OVER(PARTITION BY NUM ORDER BY ID) AS ROW_RANK
FROM LOGS) AS A
GROUP BY ROW_NUM-ROW_RANK, NUM
HAVING COUNT(*)>2

/*
["id", "num", "NUM_GROUP"], 
[1, 1, 0], 
[2, 2, 1]
[3, 1, 1], 
[4, 1, 1]

Why have to use NUM also in group by because number 2 and 1 both got same ranks.
*/