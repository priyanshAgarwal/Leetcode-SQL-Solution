/*

More Grouping
Question:
The cats want to show their weight by breed. The cats agree that they should show the second lightest cat's weight (so as not to make other cats feel bad)

Print a list of breeds, and the second lightest weight of that breed

Return: breed, imagined_weight
Order by: breed
Show Table Schema

Correct
Desired output:
breed	imagined_weight
British Shorthair	4.8
Maine Coon	5.4
Persian	4.5
Siamese	6.1

*/

SELECT
DISTINCT BREED, NTH_VALUE(WEIGHT,2) OVER(PARTITION BY BREED ORDER BY WEIGHT ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SECOND
FROM cats 
ORDER BY BREED
