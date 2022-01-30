/*
Arizona, California, and Hawaii Employees

Arizona, California, and Hawaii Employees
Find employees from Arizona, California, and Hawaii while making sure to output all employees from each city. Output column headers should be Arizona, California, and Hawaii. Data for all cities must be ordered on the first name.
Assume unequal number of employees per city.

Look Again
Very Important Concept
*/

WITH CTE AS (select 
        CASE WHEN CITY = 'California' then first_name end as California,
        CASE WHEN CITY = 'Arizona' then first_name end as Arizona,
        CASE WHEN CITY = 'Hawaii' then first_name end as Hawaii,
        DENSE_RANK() OVER(PARTITION BY CITY ORDER BY FIRST_NAME ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS NAME_RANK
    FROM employee
    WHERE CITY IN ('California', 'Arizona', 'Hawaii'))
    
SELECT 
    MAX(california) AS california,
    MAX(arizona) AS arizona,
    MAX(hawaii) AS hawaii
FROM CTE
GROUP BY
name_rank