/*

https://www.windowfunctions.com/questions/over/2

Question:
The cats would like to see the average of the weight of them, the cat just after them and the cat just before them.

The first and last cats are content to have an average weight of consisting of 2 cats not 3.

Return: name, weight, average_weight
Order by: weight



*/

select 
    name,
    weight,
     avg(weight) over (order by weight ROWS between 1 preceding and 1 following) as average_weight
from cats order by weight

select name, weight, cast(cume_dist() over (order by weight) * 100 as integer) as percent from cats order by weight

