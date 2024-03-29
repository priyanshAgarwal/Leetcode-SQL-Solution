/*
Print Prime Numbers

Write a query to print all prime numbers less than or equal to . Print your result on a single line, and use the ampersand () character as your separator (instead of a space).

For example, the output for all prime numbers  would be:

2&3&5&7
*/

WITH RECURSIVE NUMBERS AS(
    SELECT 1 AS NUM 
    UNION 
    SELECT NUM+1 AS NUM
    FROM NUMBERS
    WHERE NUM<1000
),

NUM_OF_FACTORS AS (
SELECT A.NUM 
FROM NUMBERS A, NUMBERS B
WHERE A.NUM%B.NUM=0
GROUP BY A.NUM
HAVING COUNT(A.NUM%B.NUM)=2
ORDER BY 1)

SELECT GROUP_CONCAT(NUM SEPARATOR '&') 
FROM NUM_OF_FACTORS;


