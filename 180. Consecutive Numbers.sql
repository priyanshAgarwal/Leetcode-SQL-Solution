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
WHERE L1.ID=L2.ID-1 -- First two lines are to get consecutive we have to do                    
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

*/
SELECT DISTINCT A.NUM AS ConsecutiveNums FROM
    (SELECT
    NUM,
    LAG(NUM,1) OVER(ORDER BY ID) AS NUM_1, 
    LAG(NUM,2) OVER(ORDER BY ID) AS NUM_2 
    FROM Logs
    ) A
    WHERE A.NUM=A.NUM_1 AND A.NUM_1=A.NUM_2;

