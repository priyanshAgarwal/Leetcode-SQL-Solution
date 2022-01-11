/*

Correct Running Total
Question:
The cats must be ordered by weight descending and will enter an elevator one by one. We would like to know what the running total weight is.

If two cats have the same weight they must enter separately (Very Important Concept)
Your output:
name	weight
Ashes	4.5
Molly	4.2
Felix	5.0
Smudge	4.9
Tigger	3.8
Alfie	5.5
Oscar	6.1
Millie	5.4
Misty	5.7
Puss	5.1
Smokey	6.1
Charlie	4.8

Return: name, running total weight
Order by: weight desc
Show Table Schema
select 
name, weight from cats 
Desired output:
name	running_total_weight
Smokey	6.1
Oscar	12.2
Misty	17.9
Alfie	23.4
Millie	28.8
Puss	33.9
Felix	38.9
Smudge	43.8
Charlie	48.6
Ashes	53.1
Molly	57.3
Tigger	61.1

*/

select 
name, 
-- This takes weight one by one and does not group weights if two weights are similar.
sum(weight) over(ORDER BY WEIGHT desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
 as running_total_weight
from cats 