/*

603. Consecutive Available Seats

Several friends at a cinema ticket office would like to reserve consecutive available seats.
Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
| seat_id | free |
|---------|------|
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
 

Your query should return the following result for the sample case above.
 

| seat_id |
|---------|
| 3       |
| 4       |
| 5       |
Note:
The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
Consecutive available seats are more than 2(inclusive) seats consecutively available.

*/


SELECT seat_id FROM (SELECT
        seat_id,
        free,
        LAG(free,1) OVER (ORDER BY seat_id) as free_PREVIOUS,
        LEAD(free,1) OVER (ORDER BY seat_id) as free_NEXT
FROM CINEMA) A
WHERE (A.FREE=1 AND A.free_NEXT=1)
OR (A.FREE=1 AND A.free_PREVIOUS=1)
ORDER BY seat_id

