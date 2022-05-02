/*

Input: 
Employee table:
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
| 1  | 7     | 90     |
| 1  | 8     | 90     |
+----+-------+--------+


SELECT * FROM EMPLOYEE
ORDER BY 1,2,3

["id", "month", "salary"],
[1, 1, 20], 20
[1, 2, 30], 20+30=50
[1, 3, 40], 20+30+40=90
[1, 4, 60], 30+40+60=130
[1, 5,  0] (Not included in the data)
[1, 6,  0] (Not included in the data)
[1, 7, 90], ROWS Code 40+60+90=190  RANGE Code 90+0+0=90
[1, 8, 90], ROWS Code 90+90+60=240  RANGE Code 90+90+0=180

SELECT  id, 
        month, 
        SUM(salary) OVER(PARTITION BY id ORDER BY month RANGE BETWEEN 2 PRECEDING AND CURRENT ROW) as Salary, 
        DENSE_RANK() OVER(PARTITION BY id ORDER by month DESC) month_no
FROM Employee

SELECT  id, 
        month, 
        SUM(salary) OVER(PARTITION BY id ORDER BY month RANGE 2 PRECEDING) as Salary, 
        DENSE_RANK() OVER(PARTITION BY id ORDER by month DESC) month_no
FROM Employee

["id", "month", "Salary", "month_no"],
[1, 8, 180, 1], 90+90+0=180 (Prior one Month Zero)
[1, 7, 90, 2], 90+0+0=90 (Prior Two Month Zero)
[1, 4, 130, 3], 30+40+60=130
[1, 3, 90, 4], 20+30+40=90
[1, 2, 50, 5], 20+30=50
[1, 1, 20, 6], 


[2, 2, 50, 1], 
[2, 1, 20, 2], 
[3, 4, 170, 1], 
[3, 3, 100, 2], 
[3, 2, 40, 3]


SELECT  id, 
        month, 
        SUM(salary) OVER(PARTITION BY id  ORDER BY month ROWS 2 PRECEDING) as Salary, 
        DENSE_RANK() OVER(PARTITION BY id ORDER by month DESC) month_no
FROM Employee

SELECT  id, 
        month, 
        SUM(salary) OVER(PARTITION BY id  ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Salary, 
        DENSE_RANK() OVER(PARTITION BY id ORDER by month DESC) month_no
FROM Employee

["id", "month", "Salary", "month_no"]
[1, 8, 240, 1], 90+90+60=240
[1, 7, 190, 2], 40+60+90=190
[1, 4, 130, 3], 30+40+60=130
[1, 3, 90, 4], 20+30+40=90
[1, 2, 50, 5], 20+30=50
[1, 1, 20, 6], 

[2, 2, 50, 1], 
[2, 1, 20, 2], 
[3, 4, 170, 1], 
[3, 3, 100, 2], 
[3, 2, 40, 3]
*/
