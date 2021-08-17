/*
574. Winning Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+

*/

Select distinct c.Name As Name
from Candidate c
where c.id = (Select CandidateId 
from Vote
Group by CandidateId  
order by count(CandidateId) desc
limit 1)


SELECT B.NAME FROM (SELECT CandidateId, COUNT(*) AS VOTE_COUNT
FROM VOTE 
GROUP BY CandidateId 
ORDER BY VOTE_COUNT DESC 
LIMIT 1) A
INNER JOIN Candidate B
ON A.CandidateId=B.id