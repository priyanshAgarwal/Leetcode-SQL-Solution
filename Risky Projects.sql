/*

Risky Projects
Identify projects that are at risk for going overbudget. A project is considered to be overbudget if the cost of all employees assigned to the project is greater than the budget of the project. 
You'll need to prorate the cost of the employees to the duration of the project. For example, if the budget for a project that takes half a year to complete is $10K, then the total half-year salary of all employees assigned to the project should not exceed $10K. Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than one year.
Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).

*/

WITH CTE AS (
SELECT 
    DISTINCT A.title,A.budget,
    CEIL(DATEDIFF(END_DATE,START_DATE)*SUM(C.SALARY) OVER(PARTITION BY A.ID)/365) AS PROJECT_SALARY
FROM linkedin_projects A
LEFT JOIN linkedin_emp_projects B
ON A.ID=B.PROJECT_ID
LEFT JOIN linkedin_employees C
ON C.ID=B.EMP_ID)

SELECT title,budget,PROJECT_SALARY FROM CTE
WHERE PROJECT_SALARY>BUDGET;