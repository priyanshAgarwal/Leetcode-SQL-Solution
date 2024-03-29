/*

612. Shortest Distance in a Plane

Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 

Write a query to find the shortest distance between these points rounded to 2 decimals.
 

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
 

The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

| shortest |
|----------|
| 1.00     |


*/


-- Remeber when using self join, Important condition to not to join to it self and put 
-- OR if multiple condition self join

SELECT ROUND(SQRT(POW(A.X-B.X,2)+POW(A.Y-B.Y,2)),2) AS SHORTEST 
FROM POINT2D A
INNER JOIN POINT2D B
ON A.X!=B.X OR A.Y!=B.Y
ORDER BY SHORTEST 
LIMIT 1