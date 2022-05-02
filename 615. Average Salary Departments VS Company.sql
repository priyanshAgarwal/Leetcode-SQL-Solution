/*

615. Average Salary: Departments VS Company
Hard

148

48

Add to List

Share
SQL Schema
Table: Salary

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| employee_id | int  |
| amount      | int  |
| pay_date    | date |
+-------------+------+
id is the primary key column for this table.
Each row of this table indicates the salary of an employee in one month.
employee_id is a foreign key from the Employee table.
 

Table: Employee

+---------------+------+
| Column Name   | Type |
+---------------+------+
| employee_id   | int  |
| department_id | int  |
+---------------+------+
employee_id is the primary key column for this table.
Each row of this table indicates the department of an employee.
 

Write an SQL query to report the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Salary table:
+----+-------------+--------+------------+
| id | employee_id | amount | pay_date   |
+----+-------------+--------+------------+
| 1  | 1           | 9000   | 2017/03/31 |
| 2  | 2           | 6000   | 2017/03/31 |
| 3  | 3           | 10000  | 2017/03/31 |
| 4  | 1           | 7000   | 2017/02/28 |
| 5  | 2           | 6000   | 2017/02/28 |
| 6  | 3           | 8000   | 2017/02/28 |
+----+-------------+--------+------------+
Employee table:
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
+-------------+---------------+
Output: 
+-----------+---------------+------------+
| pay_month | department_id | comparison |
+-----------+---------------+------------+
| 2017-02   | 1             | same       |
| 2017-03   | 1             | higher     |
| 2017-02   | 2             | same       |
| 2017-03   | 2             | lower      |
+-----------+---------------+------------+
Explanation: 
In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.

With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.

*/

WITH CTE AS (
SELECT 
    B.*,
    LEFT(PAY_DATE,7) AS PAY_MONTH,
    AVG(AMOUNT) OVER(PARTITION BY LEFT(PAY_DATE,7),B.DEPARTMENT_ID) AS DEPARTMENT_AVG, 
    AVG(AMOUNT) OVER(PARTITION BY LEFT(PAY_DATE,7)) AS COMPANY_AVG_SALARY
FROM SALARY A
LEFT JOIN EMPLOYEE B
ON A.EMPLOYEE_ID=B.EMPLOYEE_ID)

SELECT pay_month, department_id, 
    CASE
        WHEN DEPARTMENT_AVG>COMPANY_AVG_SALARY THEN 'higher'
        WHEN DEPARTMENT_AVG<COMPANY_AVG_SALARY THEN 'lower'
        WHEN DEPARTMENT_AVG=COMPANY_AVG_SALARY THEN 'same'
    END AS comparison 
FROM CTE
GROUP BY PAY_MONTH, DEPARTMENT_ID
ORDER BY department_id 