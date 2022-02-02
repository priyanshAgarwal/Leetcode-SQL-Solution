/*

Fans vs Opposition
Meta/Facebook is quite keen on pushing their new programming language Hack to all their offices. They ran a survey to quantify the popularity of the language and send it to their employees. To promote Hack they have decided to pair developers which love Hack with the ones who hate it so the fans can convert the opposition. Their pair criteria is to match the biggest fan with biggest opposition, second biggest fan with second biggest opposition, and so on. Write a query which returns this pairing. Output employee ids of paired employees. Sort users with the same popularity value by id in ascending order.

Duplicates in pairings can be left in the solution. For example, (2, 3) and (3, 2) should both be in the solution.


*/


-- Remember using employee_id as well

WITH CTE AS (SELECT *,
DENSE_RANK() OVER(ORDER BY POPULARITY DESC,employee_id) AS MORE_POPULAR,
DENSE_RANK() OVER(ORDER BY POPULARITY,employee_id) AS LESS_POPULAR
FROM facebook_hack_survey)


SELECT A.employee_id,B.employee_id
FROM CTE A
INNER JOIN CTE B
ON A.MORE_POPULAR=B.LESS_POPULAR;
