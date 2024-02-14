/*

1990. Count the Number of Experiments
Medium

Table: Experiments

+-----------------+------+
| Column Name     | Type |
+-----------------+------+
| experiment_id   | int  |
| platform        | enum |
| experiment_name | enum |
+-----------------+------+
experiment_id is the primary key for this table.
platform is an enum with one of the values ('Android', 'IOS', 'Web').
experiment_name is an enum with one of the values ('Reading', 'Sports', 'Programming').
This table contains information about the ID of an experiment done with a random person, the platform used to do the experiment, and the name of the experiment.
 

Write an SQL query to report the number of experiments done on each of the three platforms for each of the three given experiments. Notice that all the pairs of (platform, experiment) should be included in the output including the pairs with zero experiments.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input:
Experiments table:
+---------------+----------+-----------------+
| experiment_id | platform | experiment_name |
+---------------+----------+-----------------+
| 4             | IOS      | Programming     |
| 13            | IOS      | Sports          |
| 14            | Android  | Reading         |
| 8             | Web      | Reading         |
| 12            | Web      | Reading         |
| 18            | Web      | Programming     |
+---------------+----------+-----------------+
Output: 
+----------+-----------------+-----------------+
| platform | experiment_name | num_experiments |
+----------+-----------------+-----------------+
| Android  | Reading         | 1               |
| Android  | Sports          | 0               |
| Android  | Programming     | 0               |
| IOS      | Reading         | 0               |
| IOS      | Sports          | 1               |
| IOS      | Programming     | 1               |
| Web      | Reading         | 2               |
| Web      | Sports          | 0               |
| Web      | Programming     | 1               |
+----------+-----------------+-----------------+
Explanation: 
On the platform "Android", we had only one "Reading" experiment.
On the platform "IOS", we had one "Sports" experiment and one "Programming" experiment.
On the platform "Web", we had two "Reading" experiments and one "Programming" experiment.


["PLATFORM", "EXPERIMENT_NAME", "NUM_EXPERIMENT"], 
["Android", "Programming", 0],
["Android", "Sports", 0], 
["Android", "Reading", 1], 
["IOS", "Programming", 1], 
["IOS", "Sports", 1], 
["IOS", "Reading", 0], 
["Web", "Programming", 1], 
["Web", "Sports", 0], 
["Web", "Reading", 2]

*/


WITH enum_experiments AS (
    SELECT 'Reading' EXPERIMENT_NAME
    UNION
    SELECT 'Sports' EXPERIMENT_NAME
    UNION
    SELECT 'Programming' EXPERIMENT_NAME
),

enum_platforms AS (
    SELECT 'Android' platform
    UNION
    SELECT 'IOS' platform
    UNION
    SELECT 'Web' platform
)

select 
    a.platform, b.experiment_name , count(experiment_id ) as num_experiments 
from platform a 
cross join experiment_name  b
left join Experiments c
on a.platform = c.platform  and b.experiment_name =c.experiment_name 
group by 1,2
