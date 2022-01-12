/*

More Row Comparisons
Question:
Each cat would like to see the next heaviest cat's weight when grouped by breed. If there is no heavier cat print 'fattest cat'

Print a list of cats, their weights and either the next heaviest cat's weight or 'fattest cat'

Return: name, weight, breed, next_heaviest
Order by: weight
Show Table Schema
 correct
Desired output:
name	weight	breed	next_heaviest
Tigger	3.8	British Shorthair	4.8
Molly	4.2	Persian	4.5
Ashes	4.5	Persian	5
Charlie	4.8	British Shorthair	4.9
Smudge	4.9	British Shorthair	fattest cat
Felix	5.0	Persian	fattest cat
Puss	5.1	Maine Coon	5.4
Millie	5.4	Maine Coon	5.7
Alfie	5.5	Siamese	6.1
Misty	5.7	Maine Coon	6.1
Oscar	6.1	Siamese	fattest cat
Smokey	6.1	Maine Coon	fattest cat

coalesce and lead
*/


select 
name, 
weight,
breed,
coalesce(cast(lead(weight, 1) over (partition by breed order by weight) as varchar), 'fattest cat') as next_heaviest
from cats 
order by weight
